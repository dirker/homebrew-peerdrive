require 'formula'

class Fuserldrv < Formula
  url 'http://fuserl.googlecode.com/files/fuserldrv-2.0.3.tar.gz'
  homepage 'http://code.google.com/p/fuserl/'
  sha1 'f65fdb09139a7535540d995c3e7b1bf2f4435305'

  # patch to make fuserldrv work with fuse4x
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/driver2pipe.c b/src/driver2pipe.c
index 750d5d7..05427e2 100644
--- a/src/driver2pipe.c
+++ b/src/driver2pipe.c
@@ -207,7 +207,7 @@ driver_select (ErlDrvPort       port,
 int 
 driver_output (ErlDrvPort       port,
                char*            buf,
-               int              len)
+               ErlDrvSizeT      len)
 {
   (void) port;
 
diff --git a/src/fuserl.c b/src/fuserl.c
index 78d7ef8..0f6fc02 100644
--- a/src/fuserl.c
+++ b/src/fuserl.c
@@ -989,7 +989,7 @@ FUSE_OPERATION_IMPL_2 (unlink, UNLINK,
                        const char*, name)
 
 #if HAVE_SETXATTR
-#if (__FreeBSD__ >= 10)
+#if (__FreeBSD__ >= 10) || defined(__APPLE__)
 FUSE_OPERATION_IMPL_4 (getxattr, GETXATTR,
                        fuse_ino_t, ino,
                        const char*, name,
@@ -1010,7 +1010,7 @@ FUSE_OPERATION_IMPL_2 (removexattr, REMOVEXATTR,
                        fuse_ino_t, ino,
                        const char*, name)
 
-#if (__FreeBSD__ >= 10)
+#if (__FreeBSD__ >= 10) || defined(__APPLE__)
 FUSE_OPERATION_IMPL_6 (setxattr, SETXATTR,
                        fuse_ino_t, ino,
                        const char*, name,
@@ -1451,7 +1451,7 @@ from_emulator_destruct (FromEmulatorLL from_emulator)
 static void
 fuserl_output           (ErlDrvData     handle,
                          char*          buf,
-                         int            buflen)
+                         ErlDrvSizeT    buflen)
 {
   DriverDataLL* d = (DriverDataLL*) handle;
   FromEmulatorLL from_emulator = decode_from (buf, buflen);
@@ -1563,7 +1563,10 @@ static ErlDrvEntry fuserl_driver_entry =
   .stop = fuserl_stop,
   .output = fuserl_output,
   .ready_input = fuserl_ready_input,
-  .driver_name = (char*) "libfuserl"
+  .driver_name = (char*) "libfuserl",
+  .extended_marker = ERL_DRV_EXTENDED_MARKER,
+  .major_version = ERL_DRV_EXTENDED_MAJOR_VERSION,
+  .minor_version = ERL_DRV_EXTENDED_MINOR_VERSION,
 };
 
 DRIVER_INIT (libfuserl) /* must match name in driver_entry */
diff --git a/src/fuserltypes.h b/src/fuserltypes.h
index 41d5a4c..574c5a5 100644
--- a/src/fuserltypes.h
+++ b/src/fuserltypes.h
@@ -231,7 +231,7 @@ struct _FusErlRequestLL
           fuse_ino_t                    ino;
           const char*                   name;
           size_t                        size;
-#if (__FreeBSD__ >= 10)
+#if (__FreeBSD__ >= 10) || defined(__APPLE__)
           uint32_t                      position;       // NB: unused (!)
 #endif
         }                                       getxattr;
@@ -327,7 +327,7 @@ struct _FusErlRequestLL
           const char*                   value;
           size_t                        size;
           int                           flags;
-#if (__FreeBSD__ >= 10)
+#if (__FreeBSD__ >= 10) || defined(__APPLE__)
           uint32_t                      position;       // NB: unused (!)
 #endif
         }                                       setxattr;
