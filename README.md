[![Test](https://github.com/cucumber/action-publish-cpan/actions/workflows/test.yaml/badge.svg)](https://github.com/cucumber/action-publish-cpan/actions/workflows/test.yaml)

# action-publish-subrepo
GitHub Action to publish a subdirectory of a repo to a read-only mirror.

The name of the target repo to mirror into is inferred from the repo where the action is running and the given `working-directory`.

e.g. https://github.com/cucumber/messages => https://github.com/cucumber/messages-php

## Inputs

* `working-directory` - subfolder path within your repo that you want to mirror 

## Example

```yaml
name: Publish `php` folder to subrepo

on:
  push:
    branches:
      - "release/*"

jobs:
  publish-ui:
    name: Publish php folder to subrepo
    runs-on: ubuntu-latest
    environment: Release
    steps:
      - uses: actions/checkout@v2
      - uses: cucumber/action-publish-subrepo@v1.0.0
        with:
          working-directory: "php"
          github-token: ${{ secrets.GITHUB_TOKEN }}
```
