# frozen_string_literal: true

if defined?(Bridgetown)
  raise "The Roda Turbo plugin support for Bridgetown requires v1.1 or newer" if Bridgetown::VERSION.starts_with?("1.0")

  require "roda-turbo/bridgetown_helpers"
end
