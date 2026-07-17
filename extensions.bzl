"""Fetches the prebuilt swift-format binary for the host platform.

The binaries are built from source (statically linked stdlib on Linux) by this
repo's release workflow — see .github/workflows/release.yml — and attached to
the matching GitHub release as `swift-format-<version>-<platform>.tar.gz`, each
containing a single `swift-format` executable at the archive root.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# The swift-format release built and packaged. Keep in sync with the tag built
# by .github/workflows/release.yml and the module version in MODULE.bazel.
SWIFT_FORMAT_VERSION = "603.0.0"

_OWNER = "mgeisler"
_REPO = "swift-format-prebuilt"

# repo name -> (release-asset platform slug, sha256 hex of the .tar.gz).
#
# Fill the sha256s after the release workflow publishes the assets: the workflow
# prints them (see README, "Cutting a release"). They are pinned here so the
# tagged module source is fully reproducible for the Bazel Central Registry.
_PLATFORMS = {
    "swift_format_linux_x86_64": ("linux-x86_64", ""),
    "swift_format_linux_aarch64": ("linux-aarch64", ""),
    "swift_format_macos_arm64": ("macos-arm64", ""),
}

_BUILD_FILE = """\
exports_files(["swift-format"], visibility = ["//visibility:public"])
"""

def _swift_format_impl(_module_ctx):
    for repo, (slug, sha256) in _PLATFORMS.items():
        http_archive(
            name = repo,
            url = "https://github.com/{owner}/{repo}/releases/download/{version}/swift-format-{version}-{slug}.tar.gz".format(
                owner = _OWNER,
                repo = _REPO,
                version = SWIFT_FORMAT_VERSION,
                slug = slug,
            ),
            sha256 = sha256,
            build_file_content = _BUILD_FILE,
        )

swift_format = module_extension(implementation = _swift_format_impl)
