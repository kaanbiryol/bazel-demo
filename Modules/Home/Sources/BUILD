load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Home",
    srcs = glob(["**/*.swift"]),
    module_name = "Home",
    visibility = ["//visibility:public"],
    deps = [
        "//Modules/HomeInterface/Sources:HomeInterface",
        "//Modules/RouterService/Sources:RouterService",
        "@factory//:Factory",
    ],
) 