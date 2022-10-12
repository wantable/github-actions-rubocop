#!/bin/sh

set -e

gem install rubocop -v 1.31
gem install rubocop-minitest -v 0.13
gem install rubocop-performance -v 1.11
gem install rubocop-rails -v 2.11

ruby /action/lib/index.rb
