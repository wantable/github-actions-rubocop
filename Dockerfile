FROM ruby:2.6.3-alpine

LABEL com.github.actions.name="Rubocop checks"
LABEL com.github.actions.description="Lint your Ruby code in parallel to your builds"
LABEL com.github.actions.icon="code"
LABEL com.github.actions.color="red"

LABEL maintainer="Luiz Fonseca <luiz@lytt.co>"

COPY lib /action/lib
ENTRYPOINT ["/action/lib/entrypoint.sh"]
