require File.expand_path('../lib/version', __dir__)

class SecureKeys < Formula
  desc SecureKeys::DESCRIPTION
  homepage SecureKeys::HOMEPAGE_URI
  url "#{SecureKeys::HOMEPAGE_URI}/archive/refs/tags/v#{SecureKeys::VERSION}.tar.gz"
  sha256 'de64e9146fd96cfa42a3dcfac1303e90f26a2a0fd8bf379ab9c783333eac6f4c'
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
