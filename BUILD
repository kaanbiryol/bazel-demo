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
                # "//Modules/List/Tests:ListTests",
                # "//Modules/Details/Tests:DetailsTests",
                # "//Modules/Networking/Tests:NetworkingTests",
            ],
        ),
    ),
]

xcodeproj(
    name = "xcodeproj",
    build_mode = "xcode",
    # post_build = POST_BUILD_CONFIG,
    project_name = "bazel-playground-mono",
    scheme_autogeneration_mode = "all",
    schemes = _SCHEMES,
    top_level_targets = [
        top_level_target(
            "//App/Sources:App",
            target_environments = ["simulator"],
        ),
        "//App/Tests:AppTests",
        # "//Modules/List/Tests:ListTests",
        # "//Modules/Details/Tests:DetailsTests",
        # "//Modules/Networking/Tests:NetworkingTests",
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


xcodeproj(
    name = "xcodeproj_modular",
    build_mode = "xcode",
    # post_build = POST_BUILD_CONFIG,
    project_name = "bazel-playground",
    scheme_autogeneration_mode = "all",
    schemes = _SCHEMES,
    top_level_targets = [
        top_level_target(
            "//App/Sources:App",
            target_environments = ["simulator"],
        ),
        "//App/Tests:AppTests",
        # "//Modules/List/Tests:ListTests",
        # "//Modules/Details/Tests:DetailsTests",
        # "//Modules/Networking/Tests:NetworkingTests",
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

# Clean (mono/modular) remove the lowest average the two (mono first) add / remove function
#  3.6 2.5 2.4  / 2.5 2.8 2.6
# Critical change (networkinterfface) 
# 2.2 1.1 0.9 / 2.0 0.9 0.9
# Normal change (NetworkImpl)
# 0.8 0.7 0.8 / 0.7 0.8 0.7


# Clean (mono/modular) remove the lowest average the two (modular first)
#  1.2 2.7 3.7 2.7     /  2.4 2.4 2.5
# Critical change (networkinterfface) 
#   /  
# Normal change (NetworkImpl)
#   /  
