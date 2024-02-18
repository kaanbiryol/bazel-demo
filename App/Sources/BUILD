load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_application",
    "ios_unit_test",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("//build_tools:build_settings.bzl", "minimum_os_version")

ios_application(
    name = "App",
    bundle_id = "com.example.app",
    bundle_name = "App",
    families = ["iphone"],
    # frameworks = select({
    #         "//build_tools/settings_linking:static": [],
    #         "//build_tools/settings_linking:dynamic": ["//Modules/List/Sources:List"],
    #         "//conditions:default": [],
    # }),
    infoplists = [":Info.plist"],
    minimum_os_version = minimum_os_version,
    visibility = [
        "//visibility:public",
    ],
    deps = [":AppModule"],
)

_MONOLITH_APP_DEPS = [
     "//Modules/Monolith/Sources:Monolith",
     "@com_github_apple_swift_collections//:Collections",
]

_MODULAR_APP_DEPS = [
    "//Modules/List/Sources:List",
    "//Modules/Networking/Sources:Networking",
    "//Modules/NetworkingInterface/Sources:NetworkingInterface",
    "@com_github_apple_swift_collections//:Collections",
]

swift_library(
    name = "AppModule",
    srcs = [
         "App.swift",
         "SwiftLint.swift",
    ] + select({
            "//build_tools/settings_module:modular": ["ContentView.swift"],
            "//build_tools/settings_module:monolith": ["ContentView_Monolith.swift"],
            "//conditions:default": [],
    }),
    module_name = "App",
    tags = ["manual"],
    visibility = ["//visibility:public"],
    deps =  select({
            "//build_tools/settings_module:modular": _MODULAR_APP_DEPS,
            "//build_tools/settings_module:monolith": _MONOLITH_APP_DEPS,
            "//conditions:default": [],
    })
)