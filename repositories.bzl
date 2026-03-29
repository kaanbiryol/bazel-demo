load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_SWIFT_COLLECTIONS_BUILD_FILE = """\
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "DequeModule",
    srcs = glob(["Sources/DequeModule/**/*.swift"]),
    module_name = "DequeModule",
    visibility = ["//visibility:public"],
)

swift_library(
    name = "OrderedCollections",
    srcs = glob(["Sources/OrderedCollections/**/*.swift"]),
    module_name = "OrderedCollections",
    visibility = ["//visibility:public"],
)

swift_library(
    name = "Collections",
    srcs = glob(["Sources/Collections/**/*.swift"]),
    module_name = "Collections",
    visibility = ["//visibility:public"],
    deps = [
        ":DequeModule",
        ":OrderedCollections",
    ],
)
"""

def swift_collections():
    http_archive(
        name = "swift_collections",
        sha256 = "d9e4c8a91c60fb9c92a04caccbb10ded42f4cb47b26a212bc6b39cc390a4b096",
        strip_prefix = "swift-collections-1.0.4",
        build_file_content = _SWIFT_COLLECTIONS_BUILD_FILE,
        url = "https://github.com/apple/swift-collections/archive/refs/tags/1.0.4.tar.gz",
    )
