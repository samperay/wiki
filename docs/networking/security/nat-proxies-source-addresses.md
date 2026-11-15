# NAT, Reverse Proxies and Trustworthy Client Identity

**Goal:** Trace source addresses across NAT and proxies without treating untrusted HTTP headers as identity.

## LEARN — Three different addresses

```mermaid
flowchart LR
    C["Client 10.1.1.10"] --> N["SNAT gateway: 203.0.113.10"]
    N --> P["Reverse proxy"]
    P --> B["Backend"]
```

The backend may see the **proxy's TCP source IP**, not the end user's address. A reverse proxy may add `X-Forwarded-For` or standardized `Forwarded` headers, but a direct client can forge these headers unless the edge proxy removes/normalizes them and the backend trusts only known proxy hops.

| Mechanism | Changes | Key operational issue |
| --- | --- | --- |
| SNAT | Source IP/port in packet | Conntrack/ephemeral-port exhaustion |
| DNAT | Destination IP/port | Mapping and return path |
| Reverse proxy | Terminates client connection; creates upstream connection | Separate TCP/TLS sessions and trusted headers |
| Forward proxy | Makes outbound requests for clients | Proxy policy, DNS and CONNECT behavior |
| Load balancer | Distributes connections/requests | Health checks, session affinity, source preservation |

**Security rule:** Never authorize users based solely on `X-Forwarded-For` or `X-Real-IP`. Configure a strict trusted-proxy list, strip client-supplied forwarding headers at the trusted edge, and use authenticated identities for access decisions.

## DESIGN — Two independent network paths

A laptop VPN may change the laptop's DNS and route, but it does not automatically change the egress route of a cloud workload. Trace both **Slack/client → application** and **application → internal GitHub/API** from the actual execution environments. A connection reset does not alone identify the device that generated it.

## BUILD — Observe proxy-header spoofing safely

Start a disposable local Python HTTP server that echoes request headers:

```bash
mkdir -p ~/networking-phase4
cd ~/networking-phase4
cat > headers.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        body = (f"peer={self.client_address[0]}\n"
                f"x-forwarded-for={self.headers.get('X-Forwarded-For')}\n").encode()
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)
HTTPServer(("127.0.0.1", 18090), H).serve_forever()
PY
python3 headers.py
```

In another terminal:

```bash
curl --noproxy '*' -H 'X-Forwarded-For: 198.51.100.99' http://127.0.0.1:18090/
```

**Expected:** TCP peer is loopback while the header reports the arbitrary documentation IP. This demonstrates that the header is **caller-controlled** when no trusted proxy normalizes it.

## BREAK / FIX — Header trust boundary

**Break (conceptual):** An application treats the unvalidated header as the client's authenticated identity. **Fix:** authenticate requests independently; configure the edge to overwrite forwarding headers; trust forwarding metadata only from configured proxy IPs/hops.

Stop the server with Ctrl-C. Delete only `~/networking-phase4/headers.py` if no longer needed.

## INVESTIGATE — Production evidence

- Client-observed destination IP/port and DNS answer.
- Actual workload's source network, route, NAT/proxy configuration and outbound policy.
- Proxy access logs: peer address, selected upstream, status and timings.
- Backend logs: authenticated principal and **trusted** proxy metadata.
- Conntrack occupancy and NAT idle timeout where applicable.
- Compare source and destination captures at permitted boundaries.

Related: [Nginx reverse proxy](../../nginx/reverse_proxy.md), [connection failure diagnosis](../troubleshooting/connection-failure-diagnosis.md).

## My Architecture Review — Solutions & Doubts

- Why can `X-Forwarded-For` be forged?
- What changes when TLS terminates at a load balancer?
- Why does a successful laptop VPN test not prove cloud egress works?
- **Evidence / doubts:**
