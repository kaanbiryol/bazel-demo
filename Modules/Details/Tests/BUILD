load("@build_bazel_rules_apple//apple:ios.bzl", "ios_unit_test")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("//build_tools:build_settings.bzl", "minimum_os_version")

ios_unit_test(
    name = "DetailsTests",
    # bundle_id = "com.example.Home.HomeTests",
    minimum_os_version = minimum_os_version,
    test_host = "//App/Sources:App",
    visibility = ["@rules_xcodeproj//xcodeproj:generated"],
    deps = [":DetailsTestsModule"],
)

swift_library(
    name = "DetailsTestsModule",
    testonly = True,
    srcs = glob(["**/*.swift"]),
    module_name = "DetailsTests",
    tags = ["manual"],
    deps = [
        "//Modules/Details/Sources:Details",
    ],
)
