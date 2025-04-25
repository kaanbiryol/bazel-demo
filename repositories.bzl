load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def swift_collections():
    http_archive(
        name = "swift_collections",
        sha256 = "d9e4c8a91c60fb9c92a04caccbb10ded42f4cb47b26a212bc6b39cc390a4b096",
        strip_prefix = "swift-collections-1.0.4",
        url = "https://github.com/apple/swift-collections/archive/refs/tags/1.0.4.tar.gz",
        build_file = "//third_party:swift_collections.BUILD"
    )

def factory():
    http_archive(
        name = "factory",
        sha256 = "764409e55836512ec6e8f1eeb8853223082ce9ba7b0819ed883b104bfdf6cff6",
        strip_prefix = "Factory-2.4.5",
        url = "https://github.com/hmlongco/Factory/archive/refs/tags/v2.4.5.tar.gz",
        build_file = "//third_party:factory.BUILD",
    )

def ribs():
    http_archive(
        name = "ribs",
        sha256 = "f733bf399ac574b962c9050650c5dd0de62484e6109f37d16558a64bded04452",
        strip_prefix = "RIBs-iOS-0.16.3",
        url = "https://github.com/uber/RIBs-iOS/archive/refs/tags/v0.16.3.tar.gz",
        build_file = "//third_party:ribs.BUILD",
    )