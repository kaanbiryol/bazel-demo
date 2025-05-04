load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "HomeInterface",
    srcs = glob(["**/*.swift"]),
    module_name = "HomeInterface",
    visibility = ["//visibility:public"],
    deps = [
        "//Modules/RouterService/Sources:RouterService",
        "@factory//:Factory",
    ],
) 