[![Test](https://github.com/cucumber/action-publish-cpan/actions/workflows/test.yaml/badge.svg)](https://github.com/cucumber/action-publish-cpan/actions/workflows/test.yaml)

# action-publish-subrepo
GitHub Action to publish a subdirectory of a repo to a read-only mirror.

No matter what branch the action runs on, the `main` branch will be published to the mirror repo. Tags will be pushed too.

The name of the target repo to mirror into is inferred from the repo where the action is running and the given `working-directory`.

e.g. 

    working_directory: "go"
    github.repositoryUrl: "https://github.com/cucumber/messages"
    => https://github.com/cucumber/messages-go

If the mirror repo does not already exist, it will be created.

## Inputs

* `working-directory` - subfolder path within your repo that you want to mirror
* `github-token` - a [PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with sufficient privileges to create and push to the subrepo

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
          github-token: ${{ secrets.PUSH_TOKEN }}
```
