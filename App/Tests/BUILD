load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

ios_unit_test(
    name = "AppTests",
    bundle_id = "com.example.app.AppTests",
    minimum_os_version = "17.0",
    test_host = "//App/Sources:App",
    visibility = ["@rules_xcodeproj//xcodeproj:generated"],
    deps = [":AppTestsModule"],
)

swift_library(
    name = "AppTestsModule",
    testonly = True,
    srcs = glob(["**/*.swift"]),
    module_name = "AppTests",
    tags = ["manual"],
    deps = [
        "//App/Sources:AppModule",
    ],
)
