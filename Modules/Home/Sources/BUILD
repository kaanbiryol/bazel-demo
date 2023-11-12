load(
  "@build_bazel_rules_apple//apple:ios.bzl",
  "ios_application",
  "ios_unit_test",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Home",
    srcs = glob(["**/*.swift"]),
    module_name = "Home",
    visibility = ["//visibility:public"],
)