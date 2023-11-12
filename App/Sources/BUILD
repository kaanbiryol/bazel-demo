load(
  "@build_bazel_rules_apple//apple:ios.bzl",
  "ios_application",
  "ios_unit_test",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

ios_application(
    name = "App",
    bundle_id = "com.example.app",
    families = ["iphone", "ipad"],
    infoplists = [":Info.plist"],
    minimum_os_version = "17.0",
    visibility = [
        "//App/Tests:__subpackages__",
        "@rules_xcodeproj//xcodeproj:generated"
    ],
    deps = [":AppModule"],
)

swift_library(
    name = "AppModule",
    srcs = glob(["**/*.swift"]),
    module_name = "App",
    tags = ["manual"],
    visibility = ["//App/Tests:__subpackages__"],
    deps = [
        "//Modules/Home/Sources:Home"
    ]
)