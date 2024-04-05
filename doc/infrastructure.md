---
title: Infrastructure
description: Infrastructure
---

# Infrastructure

## Git submodule

Sites making use of `site-shared` include it as a [git submodule][] of the same
name at the site repo's root.

To use a specific `site-shared` resource, you'll generally create a symlink to
the desired resource file. In some cases, you'll need to adjust the site
`_config.yml`. Details are given below.

[git submodule]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
