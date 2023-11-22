load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

ios_unit_test(
    name = "ListTests",
    # bundle_id = "com.example.Home.HomeTests",
    minimum_os_version = "17.0",
    test_host = "//App/Sources:App",
    visibility = ["@rules_xcodeproj//xcodeproj:generated"],
    deps = [":ListTestsModule"],
)

swift_library(
    name = "ListTestsModule",
    testonly = True,
    srcs = glob(["**/*.swift"]),
    module_name = "ListTests",
    tags = ["manual"],
    deps = [
        "//Modules/List/Sources:ListFramework",
    ],
)
