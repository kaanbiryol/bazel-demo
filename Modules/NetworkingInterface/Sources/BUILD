load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "NetworkingInterface",
    srcs = glob(["**/*.swift"]),
    module_name = "NetworkingInterface",
    visibility = ["//visibility:public"],
    deps = ["@factory//:Factory"],
)
