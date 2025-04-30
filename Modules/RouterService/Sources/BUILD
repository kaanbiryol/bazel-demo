load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "RouterService",
    srcs = glob(["**/*.swift"]),
    module_name = "RouterService",
    deps = ["//Modules/RIBs:RIBs", "@factory//:Factory",],
    visibility = ["//visibility:public"],
)