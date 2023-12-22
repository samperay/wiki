## vault interfaces

when user is authenticated to vault in any form, vault would generate the token based on the policies that's being set and would return back the token for usage. We could use that token for any future authenticate again. 

tokens are the core method of authetication, most of the operations in vault require an existing token. 

- The token auth method is responsible for creating and storing tokens
- The token auth method cannot be disabled
- Tokens can be used directly, or they can be used with another auth method
- Authenticating with an external identity (e.g. LDAP) dynamically generate tokens
- Tokens have one or more policies attached to control what the token is allowed to perform

## types of tokens

**service tokens** are the default token type in Vault

- They are persisted to storage (heavy storage reads/writes)
- Can be renewed, revoked, and create child tokens

**batch tokens** are encrypted binary large objects (blobs)

- Designed to be lightweight & scalable
- They are NOT persisted to storage but they are not fully-featured
- Ideal for high-volume operations, such as encryption
- Can be used for DR Replication cluster promotion as well

![compare_token_types](../images/compare_token_types.png)

Tokens carry information and metadata that determines how the token can be used, what type of token, when it expires, etc.

- Accessor
- Policies
- TTL
- Max TTL
- Number of Uses Left
- Orphaned Token
- Renewal Status

```
vault token lookup s.d1BCdhug8buTgAnSZhtPm8Hp
```

## token heirarchy

Each token has a time-to-live (TTL), except root token.

Tokens are revoked once reached its TTL unless renewed

- Once a token reaches its max TTL, it gets revoked
- May be revoked early by manually revoking the token
- When a parent token is revoked, all of its children are revoked as well.


