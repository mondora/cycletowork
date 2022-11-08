# Contributing to the Cycle2Work

Thank you for your interest in contributing to the **_Cycle2Work_**! We love receiving contributions, and your work helps quality of this app. This doc will walk you through the easiest way to make a change and have it submitted to the **_Cycle2Work_** app.

## Developer workflow

The easiest workflow for adding a feature/fixing/docs/refactor a bug is to test it out on the traget app.

### Environment

1. Fork the **_Cycle2Work_** repo on github.
2. Clone your fork of the **_Cycle2Work_** repo.
3. Build and run app on your target app.

### Development

1. Make the changes to your local copy of the **_Cycle2Work_** app, testing the changes in target app for example client app.
2. Write a unit test for your change, if is possible. In client app one of the files in client_app/test/.
3. Write a integration test for your change just if your target is client app and also if is possible. In client app one of the files in client_app/integration_test/.
4. Update the CHANGELOG.md with a new version number, and a description of the change you're making for your target app.
5. Update the version:
    1. Client app in the pubspec.yaml file to your new version.
    2. Server app in the package.json file to your new version.

### Review

1. Make sure all the existing tests.
    1. Client app using the following command (from the root of the project): \$ flutter test test/ and \$ flutter test integration_test/.
    2. Server app used this [doc](https://firebase.google.com/docs/functions/unit-testing) for unit test
2. Make sure the repo is formatted.
3. Create a PR to merge the branch on your fork into **_Cycle2Work/main_**.
4. Add owner as reviewers on the PR. I will take a look and add any comments. When the PR is ready to be merged, Thanks!
