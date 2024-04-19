## Summary
This directory contains a Dockerfile that provides access to firebase tools and
the Github CLI. This image is used to deploy various Dart/Flutter websites to
firebase in both production and staging, and is also used to comment on Github
PRs.


## Installed tools
* Github CLI
* Node/NPM
* Firebase Tools


## Additional information
When the dockerfile or cloud build template in this directory is changed in a
PR, the cloud build template is triggered and a new version of the image is
deployed as the latest version in Container Registry under the `flutter-dev`
project in GCP.