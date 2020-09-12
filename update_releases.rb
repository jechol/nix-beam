# frozen_string_literal: true

require 'octokit'

def get_tarball_url(r)
  "https://github.com/erlang/otp/archive/OTP-#{get_version(r)}.tar.gz"
end

def get_version(r)
  r[:tag_name].gsub('OTP-', '')
end

def dir(version)
  major_ver = version.match(/(\d+)/)[1]
  "pkgs/development/interpreters/erlang/R#{major_ver}"
end

def nix_path(version)
  "#{dir(version)}/R#{version}.nix"
end

def new_version?(version)
  !File.exist?(nix_path(version))
end

def nix_prefetch_sha256(url)
  output = `nix-prefetch-url --unpack #{url}`
  output.strip
end

def template_path(version)
  "#{dir(version)}/template.nix"
end

def get_template(version)
  if File.exist?(template_path(version))
    File.read(template_path(version))
  else
    <<~EOF
      { mkDerivation }:

      mkDerivation {
        version = "<<VERSION>>";
        sha256 = "<<SHA256>>";
      }
    EOF
  end
end

def write_nix(version, sha256)
  template = get_template(version)
  content = template.gsub('<<VERSION>>', version).gsub('<<SHA256>>', sha256)
  path = nix_path(version)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, content)
end

def fetch_releases
  client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  client.auto_paginate = true
  client.releases 'erlang/otp'
end

def fetch_new_releases
  fetch_releases.filter { |r| new_version?(get_version(r)) }.take(2)
end

def write_release(r)
  version = get_version(r)
  url = get_tarball_url(r)
  sha256 = nix_prefetch_sha256(url)

  write_nix(version, sha256)
end

def write_new_releases
  fetch_new_releases.map { |r| write_release(r) }
end

write_new_releases if ENV['GITHUB_ACTIONS']
