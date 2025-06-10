## Starting Vault

Start a Vault server in development mode using Docker. This will run Vault in a single process with an in-memory storage backend, suitable for testing and development purposes.
```bash
docker run --rm -it -p 8200:8200 harbor.sorakh.io/soramitsukhmer-lab/vault:dev server -dev -dev-root-token-id=toor
```

Setup the Vault environment variables to point to the running Vault server:
```bash
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=toor
```

Source for the container image can be found at [soramitsukhmer-lab/docker-vault](https://github.com/soramitsukhmer-lab/docker-vault).

## Register `iroha-transit` plugin


```bash
HASH=$(sha256sum plugins/iroha-transit | cut -d" " -f1)
vault plugin register \
        --sha256=$HASH \
        --command=iroha-transit \
        secret iroha-transit
```


## How to use the `transit` secrets engine

Enable the `transit` secrets engine and create a key named `iroha` with the `ed25519-sha3-512` type. The key will be exportable, allowing you to retrieve the public key for use in signing and verification operations.

```bash
# Enable the transit secrets engine and create a key
vault secrets enable -path iroha iroha-transit
vault write iroha/keys/iroha type=ed25519-sha3-512

# Export the public key
vault read -format=json iroha/export/public-key/iroha
# or
vault read -format=json iroha/export/public-key/iroha  | jq -r '.data.keys["1"]'
```

Signing and verification can be done using the following commands:
```bash
# Sign a message
payload='{
    "input": "KvJOYGLq+NU3U7ZLU2Yu0EJob9sa8otlZrFTfo8etNk="
}'
curl \
    --header "X-Vault-Token: toor" \
    --request POST \
    --data "${payload}" \
    http://127.0.0.1:8200/v1/transit/sign/iroha
```

```bash
# Verify a signature
payload='{
    "input": "KvJOYGLq+NU3U7ZLU2Yu0EJob9sa8otlZrFTfo8etNk=",
    "signature": "vault:v1:xzBH891iWVXe8YvfVN5ZHvDYCFHDAXAIq5O9vEuJjsn2BJ/D4nvHfhqcvjJiNwhPPKUObFT7t9G6FmA3kMFgDw=="
}'
curl \
    --header "X-Vault-Token: toor" \
    --request POST \
    --data "${payload}" \
    http://127.0.0.1:8200/v1/transit/verify/iroha
```
