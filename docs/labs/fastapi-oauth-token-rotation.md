# FastAPI OAuth and Token Rotation — Local Hands-on Lab

> **Status:** Lessons 01–03 validated locally in the tutorial; Lesson 04 refresh-token rotation is documented but **not yet verified**. Advanced concurrency and authorization-code exercises are planned. This page is a reproducible learning lab, **not a production OAuth server**.

**Learning method:** LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE  
**Environment:** macOS/Linux, Python 3.10+, terminal, curl, FastAPI, PyJWT.  
**Estimated time:** 2–3 sessions of 30–60 minutes.

## Goals and conceptual boundaries

By the end, explain bearer authentication, JWT signatures and claims, access-token expiry, opaque refresh tokens, refresh rotation, race conditions, and the difference between a toy token issuer and OAuth 2.0. **OAuth 2.0 is an authorization framework; a JWT is a token format; OpenID Connect adds an identity layer.** OAuth access tokens need not be JWTs. A real OAuth client normally obtains tokens from an independent authorization server, not from an unauthenticated API endpoint.

### Architecture: learning model

~~~mermaid
flowchart LR
    C[Local client / curl] -->|POST /token| A[FastAPI demo issuer]
    A -->|access JWT + refresh token| C
    C -->|Bearer access JWT| R[GET /api/incidents]
    R -->|verify signature and exp| V[JWT verifier]
    C -->|POST /refresh with refresh token| A
    A -->|rotate refresh token| S[(In-memory token registry)]
~~~

**Security warning:** `POST /token` below is intentionally unauthenticated and issues credentials to anyone. Bind only to loopback, do not deploy this code, do not use real user credentials, and do not commit token files or signing keys.

## Lesson 01 — Baseline FastAPI application

### LEARN

An HTTP 200 proves connectivity and route behavior, **not authentication**. First observe the unprotected baseline, then add a security boundary.

### BUILD

~~~bash
mkdir -p fastapi-oauth-lab && cd fastapi-oauth-lab
python3 -m venv .venv
source .venv/bin/activate
python -m pip install fastapi uvicorn PyJWT
~~~

Create `main.py`:

~~~python
from fastapi import FastAPI

app = FastAPI(title="OAuth Learning Lab")

@app.get("/")
def home():
    return {"message": "OAuth Learning Lab"}

@app.get("/api/incidents")
def get_incidents():
    return {"incidents": [
        {"id": "INC001", "status": "open"},
        {"id": "INC002", "status": "resolved"},
    ]}
~~~

Start in one terminal: `uvicorn main:app --reload --host 127.0.0.1`. In another:

~~~bash
curl -i http://127.0.0.1:8000/api/incidents
~~~

**Expected:** 200 and two incidents. **Observed in tutorial:** 200 and expected JSON. Open `http://127.0.0.1:8000/docs` for Swagger UI.

## Lesson 02 — Bearer authentication and 401

### LEARN

A bearer credential grants access to whoever possesses it. The `Authorization: Bearer <token>` header carries the token; never put it in URLs. A 401 indicates missing or invalid authentication; 403 usually indicates authenticated but insufficient permissions.

### BUILD

Replace `main.py`:

~~~python
from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

app = FastAPI(title="Bearer Token Lab")
security = HTTPBearer(auto_error=False)
ACCESS_TOKEN = "my-secret-access-token"  # learning only

@app.post("/token")
def issue_token():
    return {"access_token": ACCESS_TOKEN, "token_type": "bearer"}

def verify_token(credentials: HTTPAuthorizationCredentials | None = Depends(security)):
    if credentials is None or credentials.credentials != ACCESS_TOKEN:
        raise HTTPException(401, "Invalid or missing access token",
                            headers={"WWW-Authenticate": "Bearer"})
    return credentials.credentials

@app.get("/api/incidents")
def incidents(token: str = Depends(verify_token)):
    return {"incidents": [{"id": "INC001", "status": "open"},
                          {"id": "INC002", "status": "resolved"}]}
~~~

### BREAK / VALIDATE

~~~bash
curl -i http://127.0.0.1:8000/api/incidents
curl -i -H 'Authorization: Bearer invalid-token' http://127.0.0.1:8000/api/incidents
curl -s -X POST http://127.0.0.1:8000/token
curl -i -H 'Authorization: Bearer my-secret-access-token' http://127.0.0.1:8000/api/incidents
~~~

**Expected and observed in tutorial:** 401 without token, 401 with invalid token, 200 with valid token. The JSON shown in documentation is **response data, not a shell command**: pasting `{"access_token": ...}` into zsh produces command-not-found errors.

## Lesson 03 — Signed JWT and expiration

### LEARN

JWT = `base64url(header).base64url(payload).base64url(signature)`. Payload is readable, **not encrypted**. Signature validation detects tampering; `exp` is checked against current time. `sub` identifies the subject, `iat` is issued-at time. Pin the accepted signing algorithm rather than trusting the token header. A real resource server also validates issuer, audience, scopes, and other applicable claims.

~~~mermaid
flowchart TD
    A[POST /token] --> B[Sign JWT with HS256]
    B --> C[Client stores access JWT]
    C --> D[GET /api/incidents]
    D --> E{Signature and claims valid?}
    E -->|Yes, not expired| F[200 incidents]
    E -->|Missing / invalid / expired| G[401 Bearer challenge]
~~~

### BUILD

Generate a local-only signing key **in the same terminal used to launch Uvicorn**:

~~~bash
export JWT_SECRET="$(python -c 'import secrets; print(secrets.token_urlsafe(32))')"
~~~

Replace `main.py`:

~~~python
import os
from datetime import datetime, timedelta, timezone
import jwt
from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

app = FastAPI(title="JWT Expiration Lab")
security = HTTPBearer(auto_error=False)
SECRET_KEY = os.environ["JWT_SECRET"]
ALGORITHM = "HS256"
TOKEN_EXPIRY_SECONDS = 30

@app.post("/token")
def issue_token():
    now = datetime.now(timezone.utc)
    payload = {"sub": "corebot-user", "iat": now,
               "exp": now + timedelta(seconds=TOKEN_EXPIRY_SECONDS)}
    return {"access_token": jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM),
            "token_type": "bearer", "expires_in": TOKEN_EXPIRY_SECONDS}

def verify_token(credentials: HTTPAuthorizationCredentials | None = Depends(security)):
    if credentials is None:
        raise HTTPException(401, "Missing access token",
                            headers={"WWW-Authenticate": "Bearer"})
    try:
        return jwt.decode(credentials.credentials, SECRET_KEY,
                          algorithms=[ALGORITHM],
                          options={"require": ["sub", "iat", "exp"]})
    except jwt.ExpiredSignatureError:
        raise HTTPException(401, "Access token expired",
                            headers={"WWW-Authenticate": "Bearer"})
    except jwt.InvalidTokenError:
        raise HTTPException(401, "Invalid access token",
                            headers={"WWW-Authenticate": "Bearer"})

@app.get("/api/incidents")
def incidents(payload: dict = Depends(verify_token)):
    return {"authenticated_user": payload["sub"],
            "incidents": [{"id": "INC001", "status": "open"},
                          {"id": "INC002", "status": "resolved"}]}
~~~

### OPERATE / BREAK

~~~bash
# Restart uvicorn in the terminal that exported JWT_SECRET.
TOKEN=$(curl -s -X POST http://127.0.0.1:8000/token | python -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')
curl -i -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8000/api/incidents
sleep 35
curl -i -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8000/api/incidents
~~~

**Expected and observed in tutorial:** first 200, later 401 with `{"detail":"Access token expired"}`. To inspect a JWT locally without verifying it (inspection **only**, never authorization), split at dots and Base64URL-decode the payload; remember decoded claims are untrusted until signature and claims validation succeed.

## Lesson 04 — Opaque refresh token rotation

### DESIGN

Access JWT expires after 30 seconds. An opaque refresh token expires after 600 seconds and is used only at `POST /refresh`, never at `GET /api/incidents`. Every successful refresh consumes R1 and returns A2/R2. A second use of R1 must fail.

~~~mermaid
sequenceDiagram
    participant C as Client
    participant S as FastAPI demo issuer
    participant T as Token registry
    C->>S: POST /token
    S->>T: Store R1 expiry
    S-->>C: A1 + R1
    Note over C: A1 expires
    C->>S: POST /refresh (R1)
    S->>T: Check and consume R1
    S->>T: Store R2 expiry
    S-->>C: A2 + R2
    C->>S: POST /refresh (old R1)
    S-->>C: 401 Invalid refresh token
~~~

### BUILD

Replace `main.py` with the **complete** implementation:

~~~python
import os
import secrets
import threading
from datetime import datetime, timedelta, timezone

import jwt
from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from pydantic import BaseModel

app = FastAPI(title="Refresh Rotation Lab")
security = HTTPBearer(auto_error=False)
SECRET_KEY = os.environ["JWT_SECRET"]
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRY = 30
REFRESH_TOKEN_EXPIRY = 600

# Only safe as a single-process, local teaching example.
refresh_tokens: dict[str, datetime] = {}
token_lock = threading.Lock()

class RefreshRequest(BaseModel):
    refresh_token: str

def create_access_token():
    now = datetime.now(timezone.utc)
    return jwt.encode(
        {"sub": "corebot-user", "iat": now,
         "exp": now + timedelta(seconds=ACCESS_TOKEN_EXPIRY)},
        SECRET_KEY, algorithm=ALGORITHM,
    )

@app.post("/token")
def issue_token():
    access_token = create_access_token()
    refresh_token = secrets.token_urlsafe(32)
    with token_lock:
        refresh_tokens[refresh_token] = (
            datetime.now(timezone.utc) + timedelta(seconds=REFRESH_TOKEN_EXPIRY)
        )
    return {"access_token": access_token, "refresh_token": refresh_token,
            "token_type": "bearer", "expires_in": ACCESS_TOKEN_EXPIRY}

@app.post("/refresh")
def refresh(request: RefreshRequest):
    with token_lock:
        expiry = refresh_tokens.get(request.refresh_token)
        if expiry is None:
            raise HTTPException(401, "Invalid refresh token")
        if datetime.now(timezone.utc) >= expiry:
            del refresh_tokens[request.refresh_token]
            raise HTTPException(401, "Refresh token expired")
        # Consume old token and create replacement under one local lock.
        del refresh_tokens[request.refresh_token]
        new_refresh_token = secrets.token_urlsafe(32)
        refresh_tokens[new_refresh_token] = (
            datetime.now(timezone.utc) + timedelta(seconds=REFRESH_TOKEN_EXPIRY)
        )
    return {"access_token": create_access_token(),
            "refresh_token": new_refresh_token,
            "token_type": "bearer", "expires_in": ACCESS_TOKEN_EXPIRY}

def verify_token(credentials: HTTPAuthorizationCredentials | None = Depends(security)):
    if credentials is None:
        raise HTTPException(401, "Missing access token",
                            headers={"WWW-Authenticate": "Bearer"})
    try:
        return jwt.decode(credentials.credentials, SECRET_KEY,
                          algorithms=[ALGORITHM],
                          options={"require": ["sub", "iat", "exp"]})
    except jwt.ExpiredSignatureError:
        raise HTTPException(401, "Access token expired",
                            headers={"WWW-Authenticate": "Bearer"})
    except jwt.InvalidTokenError:
        raise HTTPException(401, "Invalid access token",
                            headers={"WWW-Authenticate": "Bearer"})

@app.get("/api/incidents")
def incidents(payload: dict = Depends(verify_token)):
    return {"authenticated_user": payload["sub"],
            "incidents": [{"id": "INC001", "status": "open"},
                          {"id": "INC002", "status": "resolved"}]}
~~~

### OPERATE / VALIDATE

Restart Uvicorn with the same environment variable. From another terminal:

~~~bash
curl -s -X POST http://127.0.0.1:8000/token > tokens.json
python -m json.tool tokens.json
REFRESH_TOKEN=$(python -c 'import json; print(json.load(open("tokens.json"))["refresh_token"])')
curl -s -X POST http://127.0.0.1:8000/refresh -H 'Content-Type: application/json' \
  -d "{\"refresh_token\":\"$REFRESH_TOKEN\"}" > new_tokens.json
python -m json.tool new_tokens.json
# Old token replay must return 401:
curl -i -X POST http://127.0.0.1:8000/refresh -H 'Content-Type: application/json' \
  -d "{\"refresh_token\":\"$REFRESH_TOKEN\"}"
NEW_ACCESS_TOKEN=$(python -c 'import json; print(json.load(open("new_tokens.json"))["access_token"])')
curl -i -H "Authorization: Bearer $NEW_ACCESS_TOKEN" http://127.0.0.1:8000/api/incidents
~~~

**Expected (not yet verified by learner):** refresh token changes; old R1 returns 401; new access token returns 200 if called before 30 seconds. `new_tokens.json` contains credentials; delete local token files after the lab. Add `tokens.json`, `new_tokens.json`, `.env`, and `.venv/` to `.gitignore`.

### BREAK / INVESTIGATE — concurrency and crash recovery

Try two simultaneous refresh calls using the same R1 (capture separate response codes). **Prediction:** exactly one succeeds and one fails 401 in this single-process example. The lock protects the server's dictionary, **not** the client-side coordination. Run `uvicorn --workers 2` only as a deliberate failure experiment: each worker has its own token registry, so requests may hit different workers and fail unpredictably.

~~~mermaid
flowchart TD
    Q[10 API requests find expired A1] --> L{Acquire shared refresh lock}
    L -->|One winner| R[Reload stored token version]
    R --> N{Already refreshed?}
    N -->|Yes| U[Use new access token]
    N -->|No| X[Exchange R1 for A2 and R2]
    X --> P[Atomically persist new token pair and version]
    P --> U
    L -->|Other requests| W[Wait with timeout, then reload]
    W --> U
~~~

**Production design exercise:** single-flight per authorization/install, not one global refresh token; use a shared durable encrypted store and distributed coordination (e.g. PostgreSQL advisory lock plus transaction/version checks). Refresh before expiry with a safety margin, recheck state after acquiring the lock, retry API calls only when safe and bounded, and instrument refresh attempts/failures without logging credentials. Refresh-token reuse may trigger provider replay detection and revocation. If the provider rotates R1→R2 but the client crashes before storing R2, recovery may require reauthorization: **a lock alone cannot make the provider operation and local database commit atomic**. Explore provider-specific recovery guarantees, failure alerts, and operator runbooks.

## Lesson 05 — Real OAuth 2.0 (future hands-on)

The earlier endpoints are *teaching scaffolding*, not OAuth compliance. Next build an Authorization Code + PKCE flow using an actual authorization server (e.g. a local OIDC provider), with a redirect URI, `state`, PKCE verifier/challenge, code exchange, and provider-issued tokens. Validate issuer, audience, expiry, and permissions; distinguish identity tokens from API access tokens. Use HTTPS and secret management in deployed systems. For Slack specifically, consult its current OAuth and token-rotation documentation: token response shape, rotation rules, installation-scoped credentials, and refresh behavior are provider-specific.

## Troubleshooting reference

| Symptom | Likely cause | Check |
| --- | --- | --- |
| 401 Missing access token | Header absent | curl `-H "Authorization: Bearer ..."` |
| 401 Invalid access token | Wrong token, signature or key | Same JWT_SECRET across issuer/verifier |
| 401 Access token expired | `exp` passed | Obtain a new access token |
| 401 Invalid refresh token | R1 reused or process restarted | Check rotation and in-memory state |
| 401 Refresh token expired | 600-second deadline | Reauthenticate in the demo |
| Random failures with multiple workers | Separate memory stores | Use single worker for lab; shared store in production |
| `zsh: command not found: access_token:` | JSON pasted as shell input | Execute curl instead |
| 200 even without token | Still running Lesson 01 code | Check `main.py`, restart server |

## Evidence checklist

- [x] Lesson 01 public endpoint returned 200 (observed)
- [x] Lesson 02 missing and invalid token returned 401; valid token returned 200 (observed)
- [x] Lesson 03 JWT returned 200 before expiry and 401 after expiry (observed)
- [ ] Lesson 04 token rotation and old-token replay observed
- [ ] Two simultaneous refreshes tested and outcomes recorded
- [ ] Crash-after-provider-refresh scenario discussed and recovery documented
- [ ] Authorization Code + PKCE with real provider implemented

Record date, commands, redacted HTTP statuses, hypothesis, observed evidence, and lessons learned. **Never paste actual tokens into wiki commits.**

## Further reading

- [RFC 6749 — OAuth 2.0](https://www.rfc-editor.org/rfc/rfc6749)
- [RFC 7636 — PKCE](https://www.rfc-editor.org/rfc/rfc7636)
- [RFC 9700 — OAuth 2.0 Security Best Current Practice](https://www.rfc-editor.org/rfc/rfc9700)
- [RFC 7519 — JSON Web Token](https://www.rfc-editor.org/rfc/rfc7519)
- [FastAPI security tutorial](https://fastapi.tiangolo.com/tutorial/security/)
- [Slack token rotation](https://docs.slack.dev/authentication/using-token-rotation/)
