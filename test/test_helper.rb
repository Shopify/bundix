# typed: strict
# frozen_string_literal: true
require('minitest/autorun')

lib = File.expand_path('../lib/bundix', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

$BUNDIX_QUIET = true

require('bundix')
