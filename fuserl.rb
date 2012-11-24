require 'formula'

class Fuserl < Formula
  url 'http://fuserl.googlecode.com/files/fuserl-2.0.5.tar.gz'
  homepage 'http://code.google.com/p/fuserl/'
  sha1 'c71a2697248f294941ce3546654624e366a02dab'

  depends_on 'erlang'
  depends_on 'fuse4x'
  depends_on 'fuserldrv'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-erlrc"
    system "make install"
  end
end
