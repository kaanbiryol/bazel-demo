load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcode_schemes",
    "xcodeproj",
)

load("//tools:swiftlint.bzl", "swiftlint", "swiftlint_fix")
load("//tools:post_build.bzl", "POST_BUILD_CONFIG")
# load("//tools:build_configs.bzl", "rules_xcodeproj_build_mode_config")
load("@bazel_skylib//rules:common_settings.bzl", "string_flag")


# load("@bazel_skylib//rules:common_settings.bzl", "string_flag")



swiftlint()
swiftlint_fix()

_TOP_LEVEL_TARGETS = [
    top_level_target(
        "//App/Sources:App",
        target_environments = [
            # "device",
            "simulator",
        ],
    ),
    # "//Sources/AppTests",
    # "//Sources/OtherTests",
]

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
            ]
        ),
    ),
]

xcodeproj(
    name = "xcodeproj",
    project_name = "bazel-demo",
    schemes = _SCHEMES,
    scheme_autogeneration_mode = "all",
    build_mode = select({
        ":bwb": "bazel",
        ":bwx": "xcode",
        "//conditions:default": "bazel",
    }),
    top_level_targets = [
        top_level_target(
            "//App/Sources:App", 
            target_environments = ["simulator"]
        ),
        "//App/Tests:AppTests",
        "//Modules/List/Tests:ListTests",
    ],
    post_build = POST_BUILD_CONFIG
)

string_flag(
    name = "rules_xcodeproj_build_mode",
    values = ["bazel", "xcode"],
    build_setting_default = "bazel",
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