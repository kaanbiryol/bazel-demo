load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("//build_tools:build_settings.bzl", "minimum_os_version")

ios_unit_test(
    name = "NetworkingTests",
    # bundle_id = "com.example.Home.HomeTests",
    minimum_os_version = minimum_os_version,
    test_host = "//App/Sources:App",
    visibility = ["@rules_xcodeproj//xcodeproj:generated"],
    deps = [":NetworkingTestsModule"],
)

swift_library(
    name = "NetworkingTestsModule",
    testonly = True,
    srcs = glob(["**/*.swift"]),
    module_name = "NetworkingTests",
    tags = ["manual"],
    deps = [
        "//Modules/Networking/Sources:Networking",
    ],
)
