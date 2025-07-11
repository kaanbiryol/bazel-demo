load("@build_bazel_rules_apple//apple:ios.bzl", "ios_framework")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("//build_tools:build_settings.bzl", "minimum_os_version")

def feature_macro(name, srcs = [], data = [], framework_deps = [], deps = []):
    static_lib_name = "__static__" + name
    dynamic_lib_name = "__dynamic__" + name
    bundle_id = "com.example.app." + name + "Framework"
    swift_library(
        name = static_lib_name,
        srcs = srcs,
        data = data,
        module_name = name,
        tags = ["manual"],
        visibility = ["//visibility:private"],
        copts = ["-whole-module-optimization"],
        deps = deps,
        alwayslink = True,
    )
    ios_framework(
        name = dynamic_lib_name,
        bundle_id = bundle_id,
        families = ["iphone"],
        frameworks = framework_deps,
        infoplists = ["Info.plist"],
        minimum_os_version = minimum_os_version,
        visibility = ["//visibility:private"],
        deps = [":" + static_lib_name],
    )

    native.alias(
        name = name,
        actual = select({
            "//build_tools/settings_linking:static": static_lib_name,
            "//build_tools/settings_linking:dynamic": dynamic_lib_name,
            # "//conditions:default": static_lib_name,
        }),
        visibility = ["//visibility:public"],
    )

    # native.genrule(
    #     name = "a",
    #     outs = ["a.txt"],
    #     cmd = "echo 'a World' > $@",
    #     visibility = ["//visibility:public"],
    # )

    # native.genrule(
    #     name = "b",
    #     outs = ["b.txt"],
    #     cmd = "echo 'b World' > $@",
    #     visibility = ["//visibility:public"],
    # )

    # native.alias(
    #     name = "name",
    #     actual = select({
    #         "//build_tools/settings_linking:static": ":a",
    #         "//build_tools/settings_linking:dynamic": ":b",
    #         # "//conditions:default": static_lib_name,
    #     }),
    #     visibility = ["//visibility:public"],
    # )
