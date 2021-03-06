class CacheDownloadStrategy < CurlDownloadStrategy
  def fetch
    archive = @url.sub(%r[^file://], "")
    unless File.exists?(archive)
      odie <<~EOS
        Formula expects to locate the following archive:
          #{Pathname.new(archive).basename}

        in the HOMEBREW_CACHE directory:
          #{HOMEBREW_CACHE}

        Copy the archive to the cache or create a symlink in the cache to the archive:
          ln -sf /path/to/archive $(brew --cache)/
      EOS
    end
    super
  end
end

class Sqlcl < Formula
  desc "Free, Java-based command-line interface for Oracle databases"
  homepage "https://www.oracle.com/database/technologies/appdev/sqlcl.html"
  url "file://#{HOMEBREW_CACHE}/sqlcl-19.2.1.246.1707.zip",
    using: CacheDownloadStrategy
  sha256 "80ebfbdec7652762c29813ca864b7504e1a6ff21cdd62adc25f03bf57a2067a8"

  bottle :unneeded

  depends_on java: "11"

  def install
    # Remove Windows files
    rm_f "bin/sql.exe"

    prefix.install "bin/README.md"
    rm_f "bin/README.md"

    bin.install "bin/sql" => "sqlcl"
    libexec.install "lib"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11"))
  end

  test do
    system bin/"sqlcl", "-V"
  end
end
