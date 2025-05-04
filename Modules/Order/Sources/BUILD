load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Order",
    srcs = glob(["**/*.swift"]),
    module_name = "Order",
    visibility = ["//visibility:public"],
    deps = [
        "//Modules/OrderInterface/Sources:OrderInterface",
        "//Modules/RouterService/Sources:RouterService",
        "@factory//:Factory",
    ],
) 