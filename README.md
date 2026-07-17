# swift-format-prebuilt

A Bazel module that provides the
[`swift-format`](https://github.com/swiftlang/swift-format) binary as a
prebuilt, hermetic tool — no full Swift toolchain download, and no reliance on a
host-installed `swift-format`.

`swift-format` publishes source only, so this module builds it from source once
per release (statically linking the Swift stdlib on Linux) and ships the ~50 MB
binary per platform, instead of consumers pulling the ~1 GB Swift toolchain to
extract a single executable.

## Usage

```starlark
# MODULE.bazel
bazel_dep(name = "swift_format_prebuilt", version = "603.0.0")
```

Reference the binary as `@swift_format_prebuilt//:swift-format`; it resolves to
the right platform automatically.

## Supported platforms

- `linux-x86_64`, `linux-aarch64`
- `macos-arm64`

## Versioning

The module version tracks the upstream `swift-format` release it packages (e.g.
`603.0.0`, which matches Swift 6.3). Bumping is deliberate and reviewed: open a
PR, build a new release, merge — consumers move only when they bump the
`bazel_dep` version.

## Cutting a release

1. Run the **Release** workflow (`.github/workflows/release.yml`) with the
   `swift-format` tag to build (e.g. `603.0.0`). It builds every platform,
   attaches the binaries to a _draft_ GitHub release, and prints the sha256s.
2. Set `SWIFT_FORMAT_VERSION` and the per-platform `sha256`s in
   `extensions.bzl`; bump `version` in `MODULE.bazel`. Commit.
3. Publish the draft release for tag `<version>`.
4. The [Publish to BCR](https://github.com/bazel-contrib/publish-to-bcr) app
   opens the Bazel Central Registry PR from the `.bcr/` templates.

## License

This packaging is Apache-2.0 (`LICENSE`). The bundled `swift-format` binaries
are Apache-2.0, © the Swift project authors.
