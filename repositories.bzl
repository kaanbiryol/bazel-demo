load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def swift_collections():
    http_archive(
        name = "swift_collections",
        sha256 = "d9e4c8a91c60fb9c92a04caccbb10ded42f4cb47b26a212bc6b39cc390a4b096",
        strip_prefix = "swift-collections-1.0.4",
        url = "https://github.com/apple/swift-collections/archive/refs/tags/1.0.4.tar.gz",
        build_file = Label("//third_party:swift_collections.BUILD"),
    )
