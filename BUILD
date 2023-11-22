load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcode_schemes",
    "xcodeproj",
)
load("//tools:post_build.bzl", "POST_BUILD_CONFIG")
load("@bazel_skylib//rules:common_settings.bzl", "string_flag")
load("//tools:swiftlint.bzl", "swiftlint", "swiftlint_fix")

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
        ":bwb": "bazel",
        ":bwx": "xcode",
        "//conditions:default": "bazel",
    }),
    post_build = POST_BUILD_CONFIG,
    project_name = "bazel-demo",
    scheme_autogeneration_mode = "all",
    schemes = _SCHEMES,
    top_level_targets = [
        top_level_target(
            "//App/Sources:App",
            target_environments = ["simulator"],
        ),
        "//App/Tests:AppTests",
        "//Modules/List/Tests:ListTests",
        "//Modules/Details/Tests:DetailsTests",
        "//Modules/Networking/Tests:NetworkingTests",
    ],
)

string_flag(
    name = "rules_xcodeproj_build_mode",
    build_setting_default = "bazel",
    values = [
        "bazel",
        "xcode",
    ],
)

config_setting(
    name = "bwb",
    flag_values = {
        ":rules_xcodeproj_build_mode": "bazel",
    },
)

config_setting(
    name = "bwx",
    flag_values = {
        ":rules_xcodeproj_build_mode": "xcode",
    },
)
