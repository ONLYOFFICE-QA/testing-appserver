# ONLYOFFICE AppServer testing suit

Contains RSpec based tests for Appserver Portals and Personal.

## Rake Tasks

Before usage initialize with wrata api key from [https://wrata-url/clients/api_keys](https://wrata-url/clients/api_keys)

### Task for run all appserver portal tests

* `rake wrata:run_appserver_tests` - run all portal test on default region (`info`)
* `rake wrata:run_appserver_tests['com us']` - run all portal test
 on production `onlyoffice.com`

### Task for run all appserver personal tests

* `rake wrata:run_personal_tests` - run all personal test on default region (`info`)
* `rake wrata:run_personal_tests['com us']` - run all personal test
 on production `onlyoffice.com`

## How to update secret config

1. `rake decrypt_secret_config`
2. Edit `framework/data/private_data/data.yml`
   via any text editor  
   For example add new line `foo: bar` in end of file
3. `rake update_secret_config`
4. Add `framework/data/private_data/data.yml.gpg` to VCS
5. Call encrypted file value via `SecretData.data['foo']`

**Important** Never add decrypted
`framework/data/private_data/data.yml` to VCS.
This file is in `.gitignore` and should never be committed
