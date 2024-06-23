load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcode_schemes",
    "xcodeproj",
)
load("//build_tools:post_build.bzl", "POST_BUILD_CONFIG")
load("//build_tools:swiftlint/swiftlint.bzl", "swiftlint", "swiftlint_fix")

swiftlint()
swiftlint_fix()

_SCHEMES = [
    xcode_schemes.scheme(
        name = "App",
        build_action = xcode_schemes.build_action(
            targets = ["//App/Sources:App"],
        ),
        launch_action = xcode_schemes.launch_action(
            "//App/Sources:App",
        ),
        test_action = xcode_schemes.test_action(
            [
                "//App/Tests:AppTests",
                "//Modules/List/Tests:ListTests",
                "//Modules/Details/Tests:DetailsTests",
                "//Modules/Networking/Tests:NetworkingTests",
            ],
        ),
    ),
]

xcodeproj(
    name = "xcodeproj",
    build_mode = select({
        "//build_tools/settings_rules_xcodeproj:bwb": "bazel",
        "//build_tools/settings_rules_xcodeproj:bwx": "xcode",
        "//conditions:default": "bazel",
    }),
    generation_mode = select({
        "//build_tools/settings_rules_xcodeproj:bwb": "incremental",
        "//build_tools/settings_rules_xcodeproj:bwx": "legacy",
        "//conditions:default": "legacy",
    }),
    post_build = POST_BUILD_CONFIG,
    project_name = "bazel-demo",
    scheme_autogeneration_mode = "all",
    schemes = _SCHEMES,
    top_level_targets = [
        top_level_target(
            "//App/Sources:App",
            target_environments = ["simulator", "device"],
        ),
        "//App/Tests:AppTests",
        "//Modules/List/Tests:ListTests",
        "//Modules/Details/Tests:DetailsTests",
        "//Modules/Networking/Tests:NetworkingTests",
    ],
    xcode_configurations = {
        "Debug": {
            "//command_line_option:compilation_mode": "dbg",
        },
        "Release": {
            "//command_line_option:compilation_mode": "opt",
        },
    },
)
