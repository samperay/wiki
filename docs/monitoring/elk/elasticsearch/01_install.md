## TL;DR

Elasticsearch is the distributed search and analytics engine at the heart of the ELK stack (Elasticsearch, Logstash, Kibana). It stores data as JSON documents, indexes them using Apache Lucene under the hood, and exposes a REST API for full-text search, aggregations, and analytics — all at scale. This document walks through local installation on macOS, the cluster concepts you need to understand before running anything in production (sharding, replication, snapshots, multi-node), and the essential API commands every SRE should know. Kibana is the browser-based UI layer that sits on top; you configure and query Elasticsearch through it.

See also: [Managing Documents](./02_managing_docs.md) | [Mapping & Analysis](./03_mapping_analysis.md) | [Kibana Overview](../kibana/overview.md) | [Logstash Overview](../logstash/overview.md)

---

## Getting Started

Please download the elasticsearch and kibana from below official websites for your OS.

[Elasticsearch](https://www.elastic.co/downloads/elasticsearch)

[Kibana](https://www.elastic.co/downloads/kibana)

The examples in this guide use macOS (Intel). The setup steps are identical on Linux; only the download URL and the `xattr` quarantine workaround are macOS-specific.

[Elasticsearch for Mac (Intel)](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.8.0-darwin-x86_64.tar.gz)

[Kibana for Mac (Intel)](https://artifacts.elastic.co/downloads/kibana/kibana-8.8.0-darwin-x86_64.tar.gz)

**Why the tarball instead of Homebrew?** The tarball gives you full control over the config directory (`config/elasticsearch.yml`) and the certificate store (`config/certs/`), which you'll need when adding nodes or tuning JVM heap. Homebrew hides these paths.

---

## Local Installation Setup

Create a working directory, extract both archives, and rename them for convenience. Keeping Elasticsearch and Kibana under the same parent directory makes it easy to find config files and run both services side by side.

```bash
# Create a parent directory for the whole stack
mkdir elastic-stack
cd elastic-stack

# Extract both archives (downloaded to ~/Downloads in this example)
tar -zxvf ~/Downloads/elasticsearch-8.8.0-darwin-x86_64.tar.gz
tar -zxvf ~/Downloads/kibana-8.8.0-darwin-x86_64.tar.gz

# Rename for shorter paths
mv elasticsearch-8.8.0 elasticsearch
mv kibana-8.8.0 kibana
```

Open two terminal tabs or windows — one for each service. Both must be running simultaneously since Kibana proxies API calls to Elasticsearch.

## Elasticsearch

Start Elasticsearch from its installation directory. On first startup, the security auto-configuration runs and prints the auto-generated `elastic` superuser password, the HTTP CA certificate fingerprint (needed for TLS verification), and a Kibana enrollment token (valid for 30 minutes). **Copy these to a safe place immediately** — you will need the password for every subsequent API call and the token for Kibana setup.

```bash
# Start Elasticsearch (first run generates security credentials)
cd elastic-stack/elasticsearch
bin/elasticsearch

✅ Elasticsearch security features have been automatically configured!
✅ Authentication is enabled and cluster connections are encrypted.

ℹ️  Password for the elastic user (reset with `bin/elasticsearch-reset-password -u elastic`):
  Xl4mktLmPkO=22=_DwEl

ℹ️  HTTP CA certificate SHA-256 fingerprint:
  5c47f6c2bd182fc83cd9487af5dc400c3fa75013995fa8c5cf5b63c930803cb1

ℹ️  Configure Kibana to use this cluster:
• Run Kibana and click the configuration link in the terminal when Kibana starts.
• Copy the following enrollment token and paste it into Kibana in your browser (valid for the next 30 minutes):
  eyJ2ZXIiOiI4LjguMCIsImFkciI6WyIxOTIuMTY4LjAuMTA2OjkyMDAiXSwiZmdyIjoiNWM0N2Y2YzJiZDE4MmZjODNjZDk0ODdhZjVkYzQwMGMzZmE3NTAxMzk5NWZhOGM1Y2Y1YjYzYzkzMDgwM2NiMSIsImtleSI6ImlTd1BjSWdCRmJwS05TRUtLSmwyOm9sVlc2aEd1VG9tYVJVUThCZ2Y1c3cifQ==

ℹ️  Configure other nodes to join this cluster:
• On this node:
  ⁃ Create an enrollment token with `bin/elasticsearch-create-enrollment-token -s node`.
  ⁃ Uncomment the transport.host setting at the end of config/elasticsearch.yml.
  ⁃ Restart Elasticsearch.
• On other nodes:
  ⁃ Start Elasticsearch with `bin/elasticsearch --enrollment-token <token>`, using the enrollment token that you generated.
```

## Kibana

Before starting Kibana, remove the macOS quarantine flag that Gatekeeper sets on downloaded binaries (Linux users can skip this step). Then start Kibana, navigate to the printed URL, and paste the 30-minute enrollment token from the Elasticsearch startup output to connect the two services.

```bash
# macOS only: remove quarantine flag so Kibana can execute its bundled Node.js
xattr -d -r com.apple.quarantine kibana

# Start Kibana
cd elastic-stack/kibana
bin/kibana

# Kibana will print a URL like:
# http://localhost:5601/?code=XXXXXX
# Open it in your browser to complete enrollment
```

When prompted, enter the `elastic` username and the auto-generated password from the Elasticsearch startup output. After login, Kibana opens its home dashboard. To run queries interactively, navigate to **Menu → Management → Dev Tools → Console**.

**Security note:** The auto-generated password is only shown once. If you lose it, reset it with:

```bash
# Reset the elastic superuser password (run from the Elasticsearch install dir)
bin/elasticsearch-reset-password -u elastic
```

### Search Query Using the Kibana Console

All Elasticsearch operations are REST API calls that return JSON. The Kibana Dev Tools console lets you write and run these queries without worrying about authentication headers or TLS certificates — Kibana handles both automatically. Each line starting with a verb (`GET`, `PUT`, `POST`, `DELETE`) is an independent request; press **Ctrl+Enter** (or click the play button) to run the selected query.

```json
// Check overall cluster health — look for status: "green" in production
GET /_cluster/health

// List all indices with document counts, sizes, and health status
GET /_cat/indices?v

// List all nodes in the cluster with their roles and resource usage
GET /_cat/nodes?v
```

**What the cluster health colours mean:**
- `green` — All primary and replica shards are assigned and active. Fully healthy.
- `yellow` — All primary shards are active but some replicas are unassigned. A single-node cluster is always yellow (nowhere to place replicas). Not a problem for local dev, but investigate in production.
- `red` — One or more primary shards are unassigned. The cluster cannot serve some data. Requires immediate attention.

### Search Query Using curl

Since every Elasticsearch operation is a REST call, you can use `curl`, Postman, or any HTTP client directly against the API. This is useful for scripting, automation, and troubleshooting when Kibana is unavailable. The `--cacert` flag points to the auto-generated TLS certificate so curl can verify the HTTPS connection.

```bash
# Search all documents in the 'products' index via curl
# Replace the password with the one generated during first startup
curl \
  -H "Content-Type: application/json" \
  --cacert config/certs/http_ca.crt \
  -u elastic:Xl4mktLmPkO=22=_DwEl \
  -X GET "https://localhost:9200/products/_search" \
  -d '{"query": {"match_all": {}}}'
```

## Sharding

Data in Elasticsearch is organized into indices. Each index is made up of one or more shards. Each shard is an instance of a Lucene index, which you can think of as a self-contained search engine that indexes and handles queries for a subset of the data in an Elasticsearch cluster.

Sharding solves two problems: **scale-out** (data that does not fit on a single node is split across multiple shards on multiple nodes) and **parallelism** (search queries run on all relevant shards simultaneously and results are merged, making large-scale searches faster than a single-server approach).

**How many shards should you use?** The Elasticsearch team recommends keeping shard size between 10 GB and 50 GB. Too many small shards ("over-sharding") wastes memory and increases coordination overhead; too few large shards makes recovery slow after a node failure. For a new index, start with the default (1 primary shard since ES 7.x) and increase only when data growth requires it. Shards cannot be split after index creation — you must reindex into a new index with more shards.

```
# Sharding diagram: 2 primary shards, 1 replica each, across 2 nodes
#
#  Node 1                  Node 2
#  +--------------------+  +--------------------+
#  | P0 (primary shard) |  | R0 (replica of P0) |
#  | R1 (replica of P1) |  | P1 (primary shard) |
#  +--------------------+  +--------------------+
#
# Elasticsearch guarantees P0 and R0 are NEVER on the same node.
# If Node 1 fails, R0 on Node 2 is promoted to primary automatically.
```

[Official guide: How many shards should I have?](https://www.elastic.co/blog/how-many-shards-should-i-have-in-my-elasticsearch-cluster)

## Replication

Each index is divided into shards and each shard can have multiple copies. These copies form a **replication group** and must always be kept in sync when documents are added or deleted. The copied shards are called **replica shards** and are placed on secondary nodes for fault tolerance — Elasticsearch guarantees that a primary shard and its replica are never placed on the same node.

Replication serves two purposes: **high availability** (if a node fails, a replica is promoted to primary with no data loss or manual intervention) and **read throughput** (search requests can be served from any copy of a shard, spreading read load across all replicas).

**Production recommendation:** Minimum 3 nodes with at least 1 replica shard per index. This tolerates a single node failure without data loss or search degradation. Two nodes with 1 replica works but leaves zero redundancy during rolling upgrades (one node is always down during the process).

```bash
# Check replication status — all shards should show STARTED, zero UNASSIGNED
GET /_cat/shards?v

# Healthy output for a 2-node cluster:
# index    shard prirep state   node
# products 0     p      STARTED node-1
# products 0     r      STARTED node-2
# products 1     p      STARTED node-2
# products 1     r      STARTED node-1
```

## Snapshots

A snapshot is a point-in-time backup of a running Elasticsearch cluster. Unlike stopping the cluster and copying data files, snapshots are incremental: the first snapshot copies all segments; subsequent snapshots copy only segments changed since the last one, making them fast and storage-efficient.

A snapshot copies segments from an index's primary shards. 

A snapshot copies segments from an index’s primary shards. When you start a snapshot, Elasticsearch immediately starts copying the segments of any available primary shards. If a shard is starting or relocating, Elasticsearch will wait for these processes to complete before copying the shard’s segments. If one or more primary shards aren’t available, the snapshot attempt fails

To back up an index, a snapshot makes a copy of the index’s segments and stores them in the snapshot repository.


## Adding additional nodes to the Elasticsearch

copy the tar file of the `elasticsearch` and place in a new directory and extract. 

```
mkdir elastic-stack/node2
cp elasticsearch-8.8.0-darwin-x86_64.tar.gz elastic-stack/second-node
tar -zxvf elasticsearch-8.8.0-darwin-x86_64.tar.gz 
mv elasticsearch-8.8.0 second-node
vim elastic-stack/second-node/node2/config/elasticsearch.yml

# modify the hostname, save & quit
node.name: second-node
```

Now, you need to get the active token from already running(master) elasticsearch. 

```
cd elastic-stack/elasticsearch/bin/
./elasticsearch-create-enrollment-token --scope node
```

copy the token and go to second node. 

```
cd elastic-stack/second-node/node2/
./bin/elasticsearch --enrollement-token <token>
```

Once they are joined, you would need to go to kibana dashboard console and query for the `GET /_cluster/health`
you would be seeing two nodes. 

## Starting services

Open two terminals side by side and execute below

```
cd elastic-stack/elasticsearch/bin/
bin/elasticsearch  [ Enter ]

cd elastic-stack/kibana
bin/kibana [ Enter ]
```

Copy paste kibana URL into browser http://localhost:5601/app/home#/

## Console login

Login to the url kibana console login for elastic search http://localhost:5601/app/home#/. 
Click on, Hover button -> Dev tools to open console. 

## Cluster health check

```
GET /_cluster/health
GET /_cat/indices?v
GET /_cat/shards?v
GET /_cat/nodes?v
```