load("@build_bazel_rules_apple//apple:ios.bzl", "ios_framework")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "List",
    srcs = glob(["**/*.swift"]),
    data = glob(
        ["Resources/**"],
        exclude = ["**/.DS_Store"],
    ),
    module_name = "List",
    tags = ["manual"],
    visibility = ["//visibility:public"],
    deps = [
        "//Modules/Details/Sources:Details",
        "//Modules/NetworkingInterface/Sources:NetworkingInterface",
    ],
    alwayslink = True,
)

ios_framework(
    name = "ListFramework",
    bundle_id = "com.example.app.ListFramework",
    families = ["iphone"],
    frameworks = [
        "//Modules/Details/Sources:DetailsFramework",
    ],
    infoplists = ["Info.plist"],
    minimum_os_version = "17.0",
    visibility = ["//visibility:public"],
    deps = [":List"],
)
