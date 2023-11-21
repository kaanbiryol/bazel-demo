load("@build_bazel_rules_apple//apple:ios.bzl", "ios_framework")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Details",
    srcs = glob(["**/*.swift"]),
    data = glob(
        ["Resources/**"],
        exclude = ["**/.DS_Store"],
    ),
    module_name = "Details",
    tags = ["manual"],
    visibility = ["//visibility:public"],
    alwayslink = True,
        deps = [
        "//Modules/NetworkingInterface/Sources:NetworkingInterface",
    ],
)

ios_framework(
    name = "DetailsFramework",
    bundle_id = "com.example.app.DetailsFramework",
    families = ["iphone"],
    infoplists = ["Info.plist"],
    minimum_os_version = "17.0",
    visibility = ["//visibility:public"],
    deps = [":Details"],
)
