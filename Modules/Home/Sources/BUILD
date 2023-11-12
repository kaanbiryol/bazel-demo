load(
  "@build_bazel_rules_apple//apple:ios.bzl",
  "ios_application",
  "ios_unit_test",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Home",
    srcs = glob(["**/*.swift"]),
    # visibility = ["//Modules/Home/Tests:__subpackages__"],
    visibility = ["//visibility:public"],
)