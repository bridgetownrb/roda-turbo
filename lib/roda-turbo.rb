# frozen_string_literal: true

if defined?(Bridgetown)
  # Check compatibility
  raise "The Roda Turbo plugin support for Bridgetown requires v1.2 or newer" if Bridgetown::VERSION.to_f < 1.2

  require "roda-turbo/bridgetown_helpers"
end
