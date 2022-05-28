# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "roda-turbo"
  spec.version = "0.1.0"
  spec.authors = ["Jared White"]
  spec.email = ["jared@jaredwhite.com"]

  spec.summary = "Turbo Frames & Streams support for Roda"
  spec.homepage = "https://github.com/bridgetownrb/roda-turbo"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "roda", "~> 3.50"
end
