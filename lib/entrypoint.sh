#!/bin/sh

set -e

gem install rubocop -v 1.22.3
gem install rubocop-minitest -v 0.13
gem install rubocop-performance -v 1.11.5
gem install rubocop-rails -v 2.11.3

ruby /action/lib/index.rb
