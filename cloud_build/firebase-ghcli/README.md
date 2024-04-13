## Summary

This directory contains a Dockerfile that provides access to
Node/NPM, Firebase CLI tools, and the GitHub CLI.
This image is used to deploy various Dart/Flutter websites to
Firebase in both production and staging, and is
also used to comment staging links on GitHub PRs.

## Installed tools

* GitHub CLI
* Node/NPM
* Firebase Tools

## Additional information

When the `Dockerfile` file or `cloudbuild.yaml` template in this directory
are changed in a PR, the cloud build template is triggered and
a new version of the image is deployed as the latest version in
Container Registry under the `flutter-dev` project in GCP.
