## Unit tests

The core work of this action is done by the `publish-to-subrepo` script. That script is tested by a bunch of shell scripts in the `tests` folder. You can run them all like this:

		./test

Or you can run an individual one like this:

		./test tests/copy-a-single-commit.sh

If you add new behaviour, you can test-drive it by adding another test script in this folder, together with some `.expected` files to specify your expecations for the shell output, exit status, git log or git commits found in the target subrepo. See the existing tests for examples.

## Acceptance tests

Running acceptance tests for this action is a little mind-bending, so maybe make sure you're sitting comfortably, then we'll begin.

Because the job of this action is to publish stuff from one repo to another, we need two github repos to test it. We use these:

* https://github.com/cucumber/action-publish-subrepo-test-monorepo
* https://github.com/cucumber/action-publish-subrepo-test-monorepo-a-subfolder

We use [this workflow](./.github/workflows/test.yaml), running [in the `action-publish-subrepo-test-monorepo` repo](https://github.com/cucumber/action-publish-subrepo-test-monorepo/blob/main/.github/workflows/test.yml) as the test. The test makes a commit to the monorepo, runs our action, and then looks in the subrepo to check that the commit is there.

In order to get nice commit statuses in this repo as we make changes to the action, we use a [workflow_dispatch](https://github.com/cucumber/action-publish-subrepo/blob/main/.github/workflows/trigger_tests.yml#L10) event to trigger and watch the workflow running in the monorepo.

See? Simple!