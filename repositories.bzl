load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def swift_collections():
    http_archive(
        name = "swift-collections",
        sha256 = "d0f584b197860db26fd939175c9d1a7badfe7b89949b4bd52d4f626089776e0a",
        # strip_prefix = "swift-collections-4cab1c1c417855b90e9cfde40349a43aff99c536",
        url = "https://github.com/apple/swift-collections/archive/refs/tags/1.0.4.tar.gz",
    )
