The way this GitHub action is tested is a little mind-bending, so maybe make sure you're sitting comfortably, then we'll begin.

Because the job of this action is to publish stuff from one repo to another, we need two github repos to test it. We use these:

* https://github.com/cucumber/action-publish-subrepo-test-monorepo
* https://github.com/cucumber/action-publish-subrepo-test-monorepo-a-subfolder

We use [this workflow](./.github/workflows/test.yaml), running [in the `action-publish-subrepo-test-monorepo` repo](https://github.com/cucumber/action-publish-subrepo-test-monorepo/blob/main/.github/workflows/test.yml) as the test. The test makes a commit to the monorepo, runs our action, and then looks in the subrepo to check that the commit is there.

In order to get nice commit statuses in this repo as we make changes to the action, we use a [workflow_dispatch](https://github.com/cucumber/action-publish-subrepo/blob/main/.github/workflows/trigger_tests.yml#L10) event to trigger and watch the workflow running in the monorepo.

See? Simple!
