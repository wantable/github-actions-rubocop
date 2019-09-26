# Github Action: Rubocop

- [Github Action: Rubocop](#github-action-rubocop)
  - [Usage](#usage)
  - [Instructions](#instructions)

Lint your Ruby code in parallel to your builds.
In order to use this action you will need to specify the `$GITHUB_TOKEN`:


## Usage

![](screenshots/annotations.png)


## Instructions

```yaml
# Worflow example
name: CI
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@v1

    - name: Rubocop checks
        uses: gimenete/rubocop-action@1.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

