load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "OrderInterface",
    srcs = glob(["**/*.swift"]),
    module_name = "OrderInterface",
    visibility = ["//visibility:public"],
    deps = [
        "//Modules/RouterService/Sources:RouterService",
        "@factory//:Factory",
    ],
) 