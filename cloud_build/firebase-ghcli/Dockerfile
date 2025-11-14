FROM dart:3.11.0-93.2.beta

# Install prerequisite dependencies.
RUN apt-get update && apt-get install -y curl gpg

# Install the GitHub cli.
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg;
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null;
RUN apt update && apt install -y gh;

# Install the latest version of firebase-tools globally.
RUN curl -sL https://firebase.tools | bash
