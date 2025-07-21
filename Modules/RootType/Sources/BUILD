load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "RootType",
    srcs = glob(["**/*.swift"]),
    module_name = "RootType",
    visibility = ["//visibility:public"],
    deps = ["@factory//:Factory"],
)