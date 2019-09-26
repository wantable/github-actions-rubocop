#!/bin/sh

set -e

gem install rubocop rubocop-performance

ruby /action/lib/index.rb
