# Lesson 17 — mTLS CA Rotation, Trust-Bundle Drift & Partial Service Outages

**Reading and architecture design: 20–25 minutes. Optional local hands-on: 60–90 minutes, separately. Status: Published; hands-on execution unverified.**

**LEARN → DESIGN → BUILD → BREAK → INVESTIGATE → FIX → VALIDATE**

> **Architect question:** If a certificate authority is replaced while 500 clients are still using old certificates, what rollout ordering guarantees that legitimate requests continue without silently weakening service identity?

This is a **networking/backend revision lesson** extending the canonical [Mutual TLS, Identity and Certificate Rotation](../../networking/security/mtls-certificate-rotation.md) reference into a distributed rollout incident. That page remains the source for handshake basics and certificate checks; this lesson focuses on fleet-wide safety, blast radius, evidence, and architectural decisions. It does not repeat Lessons 06 (DNS), 13 (HTTP pools), 14 (configuration consistency), or 15 (forwarded-header spoofing).

## LEARN — Problem and service contract

An internal deployment-control API accepts privileged deployment approvals from 500 automation clients across three regions. Requests travel through an mTLS gateway to a Python API. The gateway validates client certificates; the application authorizes the verified service identity for the specific operation. A platform security team must replace an old client-issuing CA without stopping deployment automation. Some clients use long-lived HTTP connections; others reconnect per job.

**Functional requirements:** (1) authenticate client certificate chain and validity at the gateway; (2) authorize only explicitly allowed service identities and operations; (3) roll out a new CA and new leaf certificates; (4) expose safe, low-cardinality trust/rotation telemetry; (5) reject unknown or expired credentials; (6) preserve audit correlation without exposing private keys.

**Nonfunctional requirements:** 99.95% successful authorized requests per rolling 30 days, p99 gateway overhead below 25 ms at normal load (design target, not measured), zero unintended acceptance of untrusted clients, CA-rotation completion within 48 hours, and a 10-minute rollback objective while the old CA remains uncompromised and valid. For a *compromised* CA, security revocation takes precedence over availability: do not restore trust to a compromised issuer.

**Failure domains:** client certificate distribution, gateway trust bundle, gateway process reload, upstream service authorization, time synchronization, and regional rollout orchestration. The private CA key never belongs in a container image or Git repository.

### Capacity and error budget

Assume **500 clients × 0.4 requests/s = 200 RPS average**; 8× bursts yield **1,600 RPS peak**. At 30 ms average end-to-end service time, Little's Law estimates **48 concurrent in-flight requests** at peak (1,600 × 0.030). Allow a 4× burst/latency margin: design for roughly 192 concurrent requests per region or across the deployment according to the traffic distribution; do not confuse connections with requests, especially with HTTP/2 multiplexing.

A 99.95% success objective permits **0.05% failures**: at 200 RPS, 17.28 million requests/day and **8,640 failed requests/day** at the threshold. This is an aggregate budget, *not permission* to cause a concentrated outage of one tenant or region. If 20% of clients are broken for 15 minutes at uniform traffic, the expected failure count is 200 × 0.20 × 900 = **36,000**, more than four daily budgets. Also track distinct impacted client identities and deployment jobs, not only global RPS.

### Initial architecture

\`\`\`mermaid
flowchart LR
    C["Automation clients (500)"] -->|mTLS| G["Regional NGINX gateways"]
    G -->|Verified identity| A["FastAPI deployment control"]
    A --> DB[("Audit database")]
    PKI["Certificate issuer / distribution"] -.-> C
    PKI -.-> G
\`\`\`

**Trust boundaries:** TLS client authentication terminates at the gateway. The gateway must overwrite any incoming identity header, not forward a user-supplied value. In production, secure the gateway-to-app hop with network policy and ideally a second authenticated transport; the lab uses a private Compose network only to illustrate the mechanism. A valid CA chain proves an issuer relationship, **not** that a client may approve any deployment.

## DESIGN — Safe rotation protocol

### Stage 1: Distribute trust before new identity

\`\`\`mermaid
flowchart LR
    A["Old CA trusted; old leaves"] --> B["Trust old + new CA"]
    B --> C["Verify all gateways loaded bundle"]
    C --> D["Issue / deploy new client leaves"]
    D --> E["Measure adoption + authorization"]
    E --> F["Retire old leaves"]
    F --> G["Remove old CA after safety gate"]
\`\`\`

The ordering is an invariant: **every serving gateway must trust the new CA before any client is required to present a new-CA certificate**. If the old CA is compromised, this overlap may be prohibited; choose controlled denial and explicit recovery rather than insecure rollback.

### Stage 2: Add a rollout controller and guardrails

\`\`\`mermaid
flowchart TB
    O["Rotation orchestrator"] --> P{"Preflight: inventory + expiry + ownership?"}
    P -->|No| H["Block rollout and escalate"]
    P -->|Yes| T["Distribute dual trust"]
    T --> Q{"All gateways verified?"}
    Q -->|No| H
    Q -->|Yes| L["Canary new client certificates"]
    L --> M{"Handshake, identity and SLO pass?"}
    M -->|No| R["Pause; restore safe trust state"]
    M -->|Yes| W["Expand waves; verify adoption"]
    W --> X["Remove old CA only after zero dependent clients"]
\`\`\`

### Alternatives and tradeoffs

| Approach | Benefit | Risk / operational cost | Decision |
| --- | --- | --- | --- |
| Coordinated dual-CA trust overlap | Safe mixed-client migration; reversible while old CA is trusted | Temporarily wider trust; requires inventory and gates | **Preferred** for planned, uncompromised CA replacement |
| All-at-once CA switch | Simple single operation | Guaranteed breakage for lagging clients; unsafe rollback | Reject for multi-region fleets |
| Per-client leaf renewal under unchanged CA | Smaller trust change | Does not solve issuer replacement or compromise | Use for ordinary leaf renewal |
| Service mesh identity/SPIFFE | Automated workload identity and rotation | New control plane, policy ownership, mesh outage modes | Evaluate if service count and operations justify it |
| Terminate mTLS at application | End-to-end peer identity visible in app | More application key/reload responsibility | Consider for especially sensitive paths |

**Security controls:** short-lived leaf certs, distinct client identities, SAN-based identity mapping where supported, least-privilege authorization, protected CA signing keys, no certificate private keys in metrics/logs, and a documented emergency issuer-revocation process. Avoid treating common-name matching alone as a production authorization scheme; the lab uses CN solely for clarity.

## BREAK — Hypothetical production incident

**The following incident and evidence are fictional teaching data, not an actual IBM or customer outage.**

At 09:00 UTC a release controller deploys **new-CA-only** trust to 40% of gateways before the clients have rotated. Old-CA clients still account for 72% of requests. A subset of gateway workers did not reload, so behavior differs even within a region. The application remains healthy, and CPU is normal. Automation jobs fail intermittently with TLS alerts and gateway-side verification errors. The application receives **no HTTP request** for rejected handshakes.

| UTC | Observation | Hypothesis / next test |
| --- | --- | --- |
| 09:00 | Trust-bundle rollout begins; desired version 203 | Confirm actual loaded version by gateway |
| 09:02 | Client-side TLS handshake failures rise in region B | Separate TLS verification from TCP reachability |
| 09:04 | Gateway logs show client certificate verification failures | Inspect presented issuer and gateway trusted issuers |
| 09:07 | 403/401 application metrics unchanged while successful RPS falls | Rejected TLS sessions never reached FastAPI |
| 09:10 | Old-client failures correlate with new-only gateways | Test old/new client certificates against each gateway |
| 09:13 | On-call pauses rollout; restores dual trust on affected gateways | Confirm safe rollback and reload |
| 09:20 | Client success returns; fleet inventory shows old-CA dependence | Delay old-CA removal until adoption verified |

### INVESTIGATE — Evidence-led elimination

**1. Establish scope and timeline.** Compare regional successful request rate, handshake failures, affected identities and rollout timestamps. Ask whether the failure correlates with *gateway instance* or *client certificate*. Preserve UTC timestamps, request/job IDs, gateway instance ID and certificate issuer fingerprints (not private keys).

\`\`\`bash
date -u
journalctl -u nginx --since "2026-11-23 09:00:00 UTC" --no-pager | tail -100
# On Kubernetes/OpenShift:
kubectl -n gateway get pods -o wide
kubectl -n gateway logs deploy/mtls-gateway --since=30m --all-containers=true
\`\`\`

Expected illustrative gateway error: \`client SSL certificate verify error: (20:unable to get local issuer certificate)\`. The actual OpenSSL error may differ by chain, expiration or configuration.

**2. Eliminate DNS, routing and TCP.** From a failing client, inspect resolution, route and socket establishment before interpreting TLS. Use the *actual* hostname and port.

\`\`\`bash
getent ahosts gateway.internal.example  # Linux; on macOS use dig or dscacheutil
ip route get 192.0.2.20                 # Linux; example documentation IP
ss -tan '( dport = :443 )'             # Linux; check SYN-SENT / ESTAB
nc -vz gateway.internal.example 443
\`\`\`

If TCP succeeds but mTLS fails, DNS/routing is not the immediate cause. On macOS, use \`route -n get 192.0.2.20\` and \`netstat -an -p tcp\` instead of Linux-specific \`ip\` and \`ss\`. Replace example IP/host with real environment values.

**3. Inspect both sides of the handshake without disabling verification.**

\`\`\`bash
openssl x509 -in client.crt -noout -subject -issuer -dates -ext subjectAltName
openssl verify -CAfile trusted-client-ca.pem client.crt
openssl s_client -connect gateway.internal.example:443 \
  -servername gateway.internal.example \
  -cert client.crt -key client.key \
  -CAfile server-ca.pem -verify_return_error </dev/null
\`\`\`

A successful TCP connect followed by a TLS alert or HTTP 400 from NGINX can indicate certificate rejection. \`openssl s_client\` output requires care: server-certificate verification and server acceptance of the *client* certificate are separate checks. Check gateway logs for the latter. Never use \`curl -k\` as a production repair.

**4. Check loaded configuration, not just the desired file.**

\`\`\`bash
nginx -T 2>&1 | grep -E 'ssl_client_certificate|ssl_verify_client'
openssl crl -in issuer.crl -noout -text  # only if CRL is configured
stat /etc/nginx/certs/trust.pem
ps -ef | grep '[n]ginx'
\`\`\`

File modification time does not prove workers loaded it. Use a controlled probe of each gateway instance and an explicit reload/rollout acknowledgment. In Kubernetes, compare Secret checksum annotation and running Pod revision. An old worker and a new worker may temporarily coexist during reload.

**5. Compare application and database evidence.** Query application logs for the request ID: if the TLS handshake failed, the request will be absent. Inspect database audit rows only for requests that reached the application; missing rows do not prove DB outage.

\`\`\`bash
grep 'deployment_id=demo-42' /var/log/deploy-api/app.log
# Example PostgreSQL query, if audit storage exists:
psql "$DATABASE_URL" -c "SELECT created_at, identity, decision FROM approval_audit WHERE deployment_id='demo-42' ORDER BY created_at DESC LIMIT 20;"
\`\`\`

The database query is **illustrative production investigation**, not a prerequisite of the minimal lab. The lab intentionally does not include PostgreSQL because its failure mode is gateway trust, not persistence.

**6. Trace and metric interpretation.** Expected metrics: \`tls_client_verify_failures_total{gateway,reason}\`, \`mtls_handshake_attempts_total{gateway,result}\`, \`gateway_loaded_trust_version{gateway}\`, \`client_ca_adoption_ratio{region}\`, \`api_requests_total{result}\`, and \`job_completion_latency_seconds\`. A trace is often absent for rejected TLS sessions; correlate connection-level gateway logs with job IDs rather than assuming application traces cover handshake failures. Avoid certificate serial numbers as high-cardinality metric labels.

### Root cause, immediate mitigation and systemic weakness

**Immediate cause:** new-CA-only trust was applied to serving gateways while old-CA clients still connected. **Contributing factor:** some workers did not reload consistently. **Systemic weakness:** no enforced dependency ordering, no per-gateway loaded-trust attestation, no old-CA client inventory gate, and global API availability monitoring missed handshake failures.

**Immediate mitigation:** freeze rollout, restore the **dual-CA** bundle on affected gateways (only if old CA is still trusted and uncompromised), reload safely, probe old and new clients against each gateway, and check success rate by region and identity. Do not restart all gateways simultaneously.

**Long-term redesign:** orchestrated waves with preflight validation, signed and versioned trust bundles, canary probes, explicit rollout acknowledgments, adoption telemetry, expiration windows, abort conditions, and an emergency compromised-CA procedure. Separate authentication from application authorization and secure the gateway-to-application identity channel.

### Observability, alerting and validation

| Signal | Alert / acceptance example | Why |
| --- | --- | --- |
| Client TLS verify failures | >0.5% for 5 min per gateway (tune from baseline) | Detect broken trust even without HTTP |
| Trust-version skew | Any serving gateway below required version during new-leaf wave | Enforce ordering |
| Old-CA dependence | Nonzero old-client usage before old-CA retirement | Prevent premature removal |
| Job success and latency | SLO burn and p99 by region/client cohort | Catch masked partial outage |
| Certificate expiry | 30/14/7-day warnings plus ownership | Give renewal runway |
| Negative probe | Untrusted client must never succeed | Detect accidental overtrust |

Validate four cases in each region: old client + dual trust succeeds; new client + dual trust succeeds; unknown CA fails; after **all** old clients have migrated, new-only trust accepts new and rejects old. Check both live connections and fresh handshakes; pooled connections may mask trust changes until reconnect.

### Optional architect challenges — answer independently

1. **Ordering and rollback:** You operate 300 gateways and 500 clients. Design a rollout state machine with explicit admission gates, failure thresholds, and a rollback strategy when 2% of gateways fail to reload. What is the invariant?
2. **Compromised CA:** Security declares the old CA compromised during overlap. How do you choose between availability and revocation, and how do you recover clients without silently trusting a compromised issuer?
3. **Observability:** A dashboard shows HTTP 200 success >99.9%, yet 18% of deployment jobs fail. Which *non-HTTP* signals and cohort dimensions would reveal the problem? How would you avoid high-cardinality metrics?

## Practical Labs

**Optional hands-on: 60–90 minutes, separate from the 20–25-minute reading/design session.** Use **Mac Docker Desktop** (recommended, 2 CPUs and ~2 GB available) or **Ubuntu VM** (at least 2 vCPU and 2 GB RAM). This small lab uses FastAPI + NGINX + OpenSSL only; no DB or Redis is needed for the certificate trust failure. Use a disposable directory. **Never use real certificates, production private keys, or public ingress for this exercise.**

### BUILD — Prerequisites and project tree

On macOS: Docker Desktop, \`docker compose\`, \`openssl\` and \`curl\`. On Ubuntu: Docker Engine with Compose plugin, \`openssl\`, \`curl\`; add your account to Docker permissions only if appropriate for your security model (or prefix Docker commands with \`sudo\`). Docker Desktop's Compose networking is identical for this lab. Check host port 8443 is free.

\`\`\`bash
docker version
docker compose version
openssl version
mkdir -p "$HOME/architecture-lab17"/{app,nginx,certs}
cd "$HOME/architecture-lab17"
\`\`\`

\`\`\`text
architecture-lab17/
├── app/
│   └── main.py
├── nginx/
│   └── default.conf
├── certs/                    # generated locally; NEVER commit
├── requirements.txt
├── Dockerfile
├── compose.yaml
├── generate-certs.sh
└── validate.sh
\`\`\`

Create each file using \`cat > filename <<'EOF'\`, paste the corresponding complete code block, then enter \`EOF\`. Keep all files inside this directory. **Fences below are normal Markdown, not escaped backticks.**

**File: \`requirements.txt\`**

\`\`\`text
fastapi==0.115.12
uvicorn==0.34.2
\`\`\`

**File: \`Dockerfile\`**

\`\`\`dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ /app/
USER 65534
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
\`\`\`

**File: \`app/main.py\`**

\`\`\`python
import logging
from fastapi import FastAPI, Header, HTTPException

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger("approval-api")
app = FastAPI()

@app.get("/healthz")
def healthz():
    return {"status": "ok"}

@app.post("/approve")
def approve(x_verified_client: str | None = Header(default=None)):
    # This header is trustworthy ONLY because NGINX overwrites it and
    # the API has no published host port. Production requires authenticated
    # gateway-to-app transport and a robust SAN-based identity policy.
    if x_verified_client != "CN=service-client":
        log.warning("authorization_denied identity=%r", x_verified_client)
        raise HTTPException(status_code=403, detail="identity not authorized")
    log.info("approval_granted identity=%s", x_verified_client)
    return {"approved": True, "identity": x_verified_client}
\`\`\`

**File: \`nginx/default.conf\`**

\`\`\`nginx
server {
    listen 8443 ssl;
    server_name localhost;
    ssl_certificate /certs/server.crt;
    ssl_certificate_key /certs/server.key;
    ssl_client_certificate /certs/trust.pem;
    ssl_verify_client on;
    ssl_verify_depth 2;
    ssl_protocols TLSv1.2 TLSv1.3;

    access_log /dev/stdout;
    error_log /dev/stderr info;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Verified-Client $ssl_client_s_dn;
        proxy_set_header X-Forwarded-Proto https;
        proxy_pass http://api:8000;
    }
}
\`\`\`

**File: \`compose.yaml\`**

\`\`\`yaml
name: architecture-lab17
services:
  api:
    build: .
    networks: [internal]
    read_only: true
    security_opt: [no-new-privileges:true]
  gateway:
    image: nginx:1.27-alpine
    depends_on: [api]
    ports:
      - "127.0.0.1:8443:8443"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
      - ./certs:/certs:ro
    networks: [internal]
networks:
  internal:
    driver: bridge
\`\`\`

**File: \`generate-certs.sh\`**

\`\`\`bash
#!/usr/bin/env bash
set -euo pipefail
mkdir -p certs
cd certs
# Entirely disposable local keys; do not commit or reuse.
for ca in old new; do
  openssl req -x509 -newkey rsa:2048 -nodes -days 3 \
    -keyout "$ca-ca.key" -out "$ca-ca.crt" \
    -subj "/CN=lab-$ca-ca" >/dev/null 2>&1
  openssl req -newkey rsa:2048 -nodes -keyout "$ca-client.key" \
    -out "$ca-client.csr" -subj "/CN=service-client" >/dev/null 2>&1
  printf 'extendedKeyUsage=clientAuth\n' > "$ca-client.ext"
  openssl x509 -req -in "$ca-client.csr" -CA "$ca-ca.crt" \
    -CAkey "$ca-ca.key" -CAcreateserial -days 2 \
    -extfile "$ca-client.ext" -out "$ca-client.crt" >/dev/null 2>&1
done
openssl req -newkey rsa:2048 -nodes -keyout server.key -out server.csr \
  -subj "/CN=localhost" >/dev/null 2>&1
printf 'subjectAltName=DNS:localhost,IP:127.0.0.1\nextendedKeyUsage=serverAuth\n' > server.ext
openssl x509 -req -in server.csr -CA old-ca.crt -CAkey old-ca.key \
  -CAcreateserial -days 2 -extfile server.ext -out server.crt >/dev/null 2>&1
cp old-ca.crt trust.pem
chmod 600 *.key
echo "Generated disposable old/new client CAs and localhost server certificate."
\`\`\`

**File: \`validate.sh\`**

\`\`\`bash
#!/usr/bin/env bash
set -euo pipefail
expected="\${1:-200}"
client="\${2:-old}"
status=$(curl -sS -o /tmp/lab17-response-$$ -w '%{http_code}' \
  --cacert certs/old-ca.crt \
  --cert "certs/\${client}-client.crt" --key "certs/\${client}-client.key" \
  -X POST https://localhost:8443/approve)
cat /tmp/lab17-response-$$
rm -f /tmp/lab17-response-$$
printf '\nclient=%s expected=%s actual=%s\n' "$client" "$expected" "$status"
test "$status" = "$expected"
\`\`\`

Run:

\`\`\`bash
chmod +x generate-certs.sh validate.sh
./generate-certs.sh
docker compose up -d --build
docker compose ps
docker compose logs --tail=30 gateway api
# A fresh startup may need a few seconds for the API to be ready.
./validate.sh 200 old
\`\`\`

**Expected baseline:** old client gets HTTP 200 with \`{"approved":true,"identity":"CN=service-client"}\`. Server certificate verification remains enabled via \`--cacert\`. If the gateway reports 502, check \`docker compose logs api gateway\` and retry only after API startup; if TLS fails, inspect certificate issuer, SAN, and NGINX config.

### BREAK — One controlled failure: premature CA removal

**Do not change the client certificate yet.** Simulate a gateway that switches to new-only trust while the old client is still active:

\`\`\`bash
cp certs/new-ca.crt certs/trust.pem
docker compose exec gateway nginx -t
docker compose exec gateway nginx -s reload
./validate.sh 400 old
\`\`\`

**Expected:** NGINX rejects the old client certificate during TLS verification and returns HTTP **400** with an SSL certificate error page (NGINX's default 495 client-certificate verification handling). Some TLS stacks can instead surface an alert before a response; in that case capture the curl error and gateway log rather than assuming a precise status. \`validate.sh\` expects an HTTP response; if curl exits before HTTP, the script exits nonzero, which is also valid evidence of rejection.

### INVESTIGATE — Capture evidence before changing anything else

\`\`\`bash
docker compose logs --tail=60 gateway
docker compose logs --tail=30 api
openssl x509 -in certs/old-client.crt -noout -issuer -subject -dates
openssl verify -CAfile certs/trust.pem certs/old-client.crt || true
openssl verify -CAfile certs/trust.pem certs/new-client.crt
docker compose exec gateway nginx -T 2>&1 | grep -E 'ssl_client_certificate|ssl_verify_client'
\`\`\`

**Interpretation:** the old client certificate chains to old CA; the gateway now trusts only new CA. The FastAPI log has no new \`approval_granted\` for the rejected request, proving the request did not reach application authorization. A healthy API and open TCP port do not imply a successful mTLS handshake. If testing packet-level symptoms, capture on the host using Wireshark or \`tcpdump\` (Linux) with permission; TLS payloads are encrypted, so packet captures alone cannot prove which issuer failed verification.

### FIX — Restore safe overlap, then migrate client

\`\`\`bash
cat certs/old-ca.crt certs/new-ca.crt > certs/trust.pem
docker compose exec gateway nginx -t
docker compose exec gateway nginx -s reload
./validate.sh 200 old
./validate.sh 200 new
\`\`\`

**Expected:** both clients succeed. This is an intentional overlap only for **uncompromised** old CA. A real rollout must inventory and authorize each identity, verify gateway trust deployment, and monitor new-issuer adoption before removing the old CA.

### VALIDATE — Complete the migration, then negative-test

\`\`\`bash
# Simulate that all real clients have migrated to new CA.
cp certs/new-ca.crt certs/trust.pem
docker compose exec gateway nginx -t
docker compose exec gateway nginx -s reload
./validate.sh 200 new
./validate.sh 400 old
\`\`\`

For the final negative test, \`400\` is the expected NGINX HTTP response; if your TLS stack ends the connection first, record the nonzero curl result and matching gateway verification log. The application should never log a new approval for a rejected old client.

**Automated local check (after restoring dual trust):**

\`\`\`bash
cat certs/old-ca.crt certs/new-ca.crt > certs/trust.pem
docker compose exec gateway nginx -t
docker compose exec gateway nginx -s reload
./validate.sh 200 old
./validate.sh 200 new
docker compose exec gateway nginx -t
\`\`\`

This validates positive paths and configuration syntax; negative behavior must also be observed during the controlled fault. Do not infer production readiness from a local Compose test.

### Cleanup — Preserve unrelated volumes and files

\`\`\`bash
docker compose down
# Optional: remove ONLY this disposable lab's locally generated certs,
# after confirming you are in $HOME/architecture-lab17:
pwd
# rm -rf certs  # uncomment only when you intentionally discard lab keys
\`\`\`

This Compose project declares **no named volumes**. Do **not** run \`docker compose down -v\`, \`docker volume prune\`, or \`docker system prune\`; unrelated data must remain untouched. Keep the source directory for repeat practice and add \`certs/\` to any future Git ignore rules.

**Mentor cadence:** Execute **one step**, share the actual output (redact keys, hostnames, tokens), explain what it proves, and only then move to the next fault. This document remains a complete self-contained reference.

## My Architecture Review — Solutions & Doubts

### 1. My Understanding

- **My explanation of the authentication versus authorization boundary:**
- **The invariant that prevents premature CA retirement:**

### 2. My Solutions to the Architect Challenges

- **Challenge 1 — Rollout ordering and rollback (decision + evidence):**
- **Challenge 2 — Compromised CA response (security/availability tradeoff):**
- **Challenge 3 — Non-HTTP observability (signals and labels):**

### 3. My Troubleshooting Approach

- **First three hypotheses and the commands I would use to falsify each:**
- **Evidence distinguishing TCP, TLS, and application failures:**

### 4. My Proposed Architecture Improvements

- **Near-term controls:**
- **Long-term orchestration, security, and failure-domain improvements:**

### 5. My Doubts / Questions

- **Unresolved questions:**

### 6. Lessons Learned

- **One principle I can apply to a real platform rollout:**
- **Actual lab output and evidence link (leave blank until executed):**

### 7. Mentor Review

- **Status:** Pending — assess reasoning and evidence only after I submit solutions.
- **What was correct / what needs correction:**
- **Next practice step:**
