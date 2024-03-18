#!/bin/sh

set -e

gem install rubocop -v 1.62.1
gem install rubocop-minitest -v 0.13
gem install rubocop-performance -v 1.11.5
gem install rubocop-rails -v 2.24.0

ruby /action/lib/index.rb
