# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "roda"
require "roda/plugins/turbo"

require "minitest/autorun"
require "rack/test"

Minitest::Test.include Rack::Test::Methods
