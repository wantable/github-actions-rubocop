#!/bin/sh

set -e

gem install haml_lint -v 0.57.0
gem install rubocop -v 1.22.3
gem install rubocop-minitest -v 0.13.0
gem install rubocop-performance -v 1.11.5
gem install rubocop-rails -v 2.11.3

# HAML_OUTPUT=$(haml-lint app/views/w3/users/ -r github)
# $HAML_OUTPUT >> $GITHUB_OUTPUT
echo "::error file=app/views/w3/users/signup.haml,line=2::`%25div.one-class` can be written as `.one-class` since `%25div` is implicit"  >> $GITHUB_OUTPUT
# ruby /action/lib/index.rb
