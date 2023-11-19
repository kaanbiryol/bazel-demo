load(
  "@build_bazel_rules_apple//apple:ios.bzl",
  "ios_application",
  "ios_unit_test",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_framework")


swift_library(
    name = "Details",
    srcs = glob(["**/*.swift"]),
    copts = ["-application-extension"],
    data = glob(
        ["Resources/**"],
        exclude = ["**/.DS_Store"],
    ),
    module_name = "Details",
    tags = ["manual"],
    visibility = ["//visibility:public"],
    deps = [
        "//Modules/Networking/Sources:Networking"
    ],
    alwayslink = True,
)

ios_framework(
    name = "DetailsFramework",
    bundle_id = "com.example.app.DetailsFramework",
    extension_safe = True,
    families = ["iphone"],
    infoplists = ["Info.plist"],
    minimum_os_version = "17.0",
    visibility = ["//visibility:public"],
    deps = [":Details"],
)