class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://cisofy.com/files/lynis-2.4.3.tar.gz"
  sha256 "1358a0de753ab5359e04ec7e53b62294d1a11ffe2be493dddb0d143881681290"

  bottle do
    cellar :any_skip_relocation
    sha256 "f81ec2512dba779215fa850106838ec30b823b7cea031103f904a582463c1cc9" => :sierra
    sha256 "f81ec2512dba779215fa850106838ec30b823b7cea031103f904a582463c1cc9" => :el_capitan
    sha256 "f81ec2512dba779215fa850106838ec30b823b7cea031103f904a582463c1cc9" => :yosemite
  end

  def install
    inreplace "lynis" do |s|
      s.gsub! 'tINCLUDE_TARGETS="/usr/local/include/lynis /usr/local/lynis/include /usr/share/lynis/include ./include"',
        %Q(tINCLUDE_TARGETS="#{include}")
      s.gsub! 'tPLUGIN_TARGETS="/usr/local/lynis/plugins /usr/local/share/lynis/plugins /usr/share/lynis/plugins /etc/lynis/plugins ./plugins"',
        %Q(tPLUGIN_TARGETS="#{prefix}/plugins")
      s.gsub! 'tDB_TARGETS="/usr/local/share/lynis/db /usr/local/lynis/db /usr/share/lynis/db ./db"',
        %Q(tDB_TARGETS="#{prefix}/db")
    end
    inreplace "include/functions" do |s|
      s.gsub! 'tPROFILE_TARGETS="/usr/local/etc/lynis /etc/lynis /usr/local/lynis ."',
        %Q(tPROFILE_TARGETS="#{prefix}")
    end

    prefix.install "db", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end

  test do
    assert_match "lynis", shell_output("#{bin}/lynis --invalid 2>&1", 64)
  end
end
