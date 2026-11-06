# Homebrew tap for vork

This tap installs [vork](https://github.com/voyager-so/vork), a headless 3D and VFX engine for agents, on Apple Silicon Macs and x64 Linux from the binaries in its GitHub releases. Run `brew install voyager-so/tap/vork`, then `vork setup`, which can take a few minutes. vork is source-available under the [vork Preview License](https://github.com/voyager-so/vork/blob/main/LICENSE), not open source; the source, docs and issues are in the [main repository](https://github.com/voyager-so/vork).

## Updating for a new release

In `Formula/vork.rb`, change the version in both `url` lines and copy both `sha256` values from the release's `SHA256SUMS`. Then run `brew install voyager-so/tap/vork`, `vork --version`, `vork setup` and a small render on a Mac, and check `codesign -dv "$(brew --prefix vork)/libexec/vork"` still shows the Nullframe team. Keep the unpack step in `post_install_steps`: it is what keeps the release's signatures intact and the archive together. `brew audit --strict` reports the `LicenseRef-vork-Preview-License` licence as non-standard; that is expected, because the licence has no SPDX identifier.
