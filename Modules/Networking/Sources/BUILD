load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Networking",
    srcs = glob(["**/*.swift"]),
    module_name = "Networking",
    visibility = [":NetworkingPackageGroup"],
    deps = [
        "//Modules/NetworkingInterface/Sources:NetworkingInterface",
    ],
)

package_group(
    name = "NetworkingPackageGroup",
    packages = [
        "//App/Sources",
        "//Modules/NetworkingInterface/Sources",
        "//Modules/Networking/Tests"
    ],
)
