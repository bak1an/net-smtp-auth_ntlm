# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "net-smtp-auth_ntlm"
  spec.version = "0.1"
  spec.authors = ["Anton Baklanov"]
  spec.email = ["antonbaklanov@gmail.com"]

  spec.summary = "NTLM auth for Net::SMTP"
  spec.description = "NTLM auth adapter for Net::SMTP using rubyntlm gem."
  spec.homepage = "https://github.com/bak1an/net-smtp-auth_ntlm"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bak1an/net-smtp-auth_ntlm"
  spec.metadata["changelog_uri"] = "https://github.com/bak1an/net-smtp-auth_ntlm/blob/main/CHANGELOG.md"

  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "net-smtp", "~> 0.4"
  spec.add_dependency "rubyntlm", "~> 0.6"
end
