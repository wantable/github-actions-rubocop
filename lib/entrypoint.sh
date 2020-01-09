#!/bin/sh

set -e

gem install rubocop -v 0.79.0
gem install rubocop-performance -v 1.5.2
gem install rubocop-rails -v 2.4.1

ruby /action/lib/index.rb
