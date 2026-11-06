class Vork < Formula
  desc "Headless 3D and VFX engine for agents"
  homepage "https://voyager.so/vork"
  # Source-available, not open source. The terms are in LICENSE, installed beside the binary:
  # https://github.com/voyager-so/vork/blob/main/LICENSE
  license "LicenseRef-vork-Preview-License"

  livecheck do
    url :stable
    strategy :github_latest
  end

  if OS.mac?
    url "https://github.com/voyager-so/vork/releases/download/v0.1.0/vork-0.1.0-darwin-arm64.tar.gz"
    sha256 "677d1aad60ca86a6e8c480f623c2773658cc30d68a98a42ea11fc3d9c39f1d51"
  else
    url "https://github.com/voyager-so/vork/releases/download/v0.1.0/vork-0.1.0-linux-x64.tar.gz"
    sha256 "126f8aac1d721f621ed51c25e28951511bf4467ee12f4b44d868a11a25507dc1"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  # bin/vork points into libexec, which post_install_steps fills.
  skip_clean "bin"

  # Unpack after install, not during it. Once install returns, Homebrew rewrites Mach-O files in
  # the keg, which replaces the release's Developer ID signature on some dylibs with an ad hoc one,
  # and it moves LICENSE, NOTICE and README.md out of libexec. The whole flat archive has to stay
  # together: Slang, OIDN, shaders, libraries, examples, SDKs and licence texts are runtime
  # companions that vork finds beside its real path.
  def install
    libexec.mkpath
    cp stable.cached_download, libexec/"release.tar.gz"
    bin.install_symlink libexec/"vork"
  end

  post_install_steps do
    if_path_exists "release.tar.gz", base: :libexec do
      run "tar", args: ["-xzf", "{{libexec}}/release.tar.gz", "-C", "{{libexec}}"]
      remove "release.tar.gz", base: :libexec
    end
  end

  def caveats
    linux_requirements = <<~EOS if OS.linux?
      vork on Linux needs glibc 2.35+, a recent NVIDIA GPU with its hardware-ray-tracing Vulkan
      driver, and the system packages libvulkan1, libgomp1 and ffmpeg.

    EOS

    <<~EOS
      #{linux_requirements}Before your first render, prepare shaders for this GPU. It can take a few minutes:
        vork setup

      vork is source-available under the vork Preview License, not open source:
        #{opt_libexec}/LICENSE
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vork --version")
  end
end
