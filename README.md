# About

This is a custom implementation of a Transit Secret Engine plugin for HashiCorp Vault to manage keys and perform cryptographic operations for Hyperledger Iroha. This plugin will adapt the [Transit secrets engine](https://developer.hashicorp.com/vault/api-docs/secret/transit) implementation of HashiCorp Vault.

## Usage

Following the [Register and enable external plugins](https://developer.hashicorp.com/vault/docs/plugins/register) documentation, you can register this plugin with Vault. Once registered, you can enable it as a Transit secrets engine.

### Before you start

- You must have admin permissions for Vault. Specifically, you must be able to run `plugin register` and the appropriate `enable` command.
- You must have `plugin_directory` set in your Vault configuration file.
- You must have the plugin binary saved to the location set in plugin_directory.
- You must have `api_addr` set in your Vault configuration file.

### Step 1: Update the plugin catalog

You must register your external plugin with the Vault catalog before enabling it. Registering plugins ensures the plugin invoked by Vault is authentic and maintains integrity.

1. Save the SHA for your plugin binary:
    ```bash
    $ PLUGIN_SHA=$(sha256sum <path_to_plugin_binary> | awk '{print $1;}')
    ```
2. Use `vault plugin register` to add your plugin to the catalog:
    ```bash
    vault plugin register                     \
        -command <command_to_run_plugin_binary> \
        -sha256 "${PLUGIN_SHA[0]}"              \
        -version "<semantic_version>"           \
        <plugin_type>                           \
        <plugin_name>                           \
    ```
    For example, to register a secrets plugin called mykv that runs on the command line as mykvplugin:
    ```bash
    $ vault plugin register   \
        -sha256 ${PLUGIN_SHA} \
        -version "v1.0.1"     \
        secret                \
        iroha-transit

    Success! Registered plugin: iroha-transit
    ```

### Step 2: Enable the plugin
Enable the plugin to make it available to clients.

Use the appropriate enable command (vault secrets enable or vault auth enable) and the registered name to mount the external plugin:
```bash
vault secrets enable -path <mount_path> iroha-transit
```

For example, to enable the mykv plugin on the path /custom/kv:
```bash
$ vault secrets enable -path custom/kv iroha-transit

Success! Enabled the iroha-transit secrets engine at: custom/kv/
```
