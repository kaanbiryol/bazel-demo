load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_application",
    "ios_unit_test",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

ios_application(
    name = "App",
    bundle_id = "com.example.app",
    bundle_name = "App",
    families = ["iphone"],
    frameworks = [
        "//Modules/List/Sources:ListFramework",
    ],
    infoplists = [":Info.plist"],
    minimum_os_version = "17.0",
    visibility = [
        "//visibility:public",
    ],
    deps = [":AppModule"],
)

swift_library(
    name = "AppModule",
    srcs = glob(["**/*.swift"]),
    module_name = "App",
    tags = ["manual"],
    visibility = ["//visibility:public"],
    deps = [
        "//Modules/List/Sources:List",
        "//Modules/Networking/Sources:Networking",
        "//Modules/NetworkingInterface/Sources:NetworkingInterface",
        "@com_github_apple_swift_collections//:Collections",
    ],
)
