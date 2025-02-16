require File.expand_path('../lib/version', __dir__)

class SecureKeys < Formula
  desc Keys::DESCRIPTION
  homepage Keys::HOMEPAGE_URI
  url "#{Keys::HOMEPAGE_URI}/archive/refs/tags/v#{Keys::VERSION}.tar.gz"
  sha256 '99e6c3898553fe7ca01e0dc817175b967ec4e881808e015c07c5a34e2bf42cee'
  license 'MIT'

  depends_on 'ruby@3.3'

  def install
    ENV['GEM_HOME'] = libexec
    ENV['GEM_PATH'] = libexec

    system 'gem', 'install', 'secure-keys'

    (bin / 'secure-keys').write_env_script libexec / 'bin/secure-keys',
                                           PATH: "#{Formula['ruby@3.3'].opt_bin}:#{libexec}/bin:$PATH",
                                           GEM_HOME: libexec.to_s,
                                           GEM_PATH: libexec.to_s
  end

  test do
    system 'false'
  end
end
