
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_framework")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

def feature_macro(name, srcs = [], data = [], deps = [], framework_deps = []):
    swift_library(
        name = name,
        srcs = srcs,
        data = data,
        module_name = name,
        tags = ["manual"],
        visibility = ["//visibility:public"],
        deps = deps,
        alwayslink = True
    )
    ios_framework(
        name = name + "Framework",
        bundle_id = "com.example.app" + name + "Framework",
        families = ["iphone"],
        frameworks = framework_deps,
        infoplists = ["Info.plist"],
        minimum_os_version = "17.0",
        visibility = ["//visibility:public"],
        deps = [":" + name],
    )