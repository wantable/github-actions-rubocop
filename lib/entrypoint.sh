#!/bin/sh

set -e

gem install rubocop -v 0.68.1
gem install rubocop-performance -v 1.3.0

ruby /action/lib/index.rb
