# Rubocop Action

Lint your Ruby code in parallel to your builds.
In order to use this action you will need to specify the `$GITHUB_TOKEN`:


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


![](screenshots/annotations.png)
