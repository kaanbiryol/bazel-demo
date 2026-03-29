load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcodeproj",
    "xcschemes",
)
load("//build_tools:post_build.bzl", "POST_BUILD_CONFIG")
load("//build_tools:swiftlint/swiftlint.bzl", "swiftlint", "swiftlint_fix")

swiftlint()

swiftlint_fix()

_SCHEMES = [
    xcschemes.scheme(
        name = "App",
        run = xcschemes.run(
            launch_target = xcschemes.launch_target(
                "//App/Sources:App",
            ),
        ),
        test = xcschemes.test(
            test_targets = [
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
    post_build = POST_BUILD_CONFIG,
    project_name = "bazel-demo",
    scheme_autogeneration_mode = "all",
    top_level_targets = [
        top_level_target(
            "//App/Sources:App",
            target_environments = [
                "simulator",
                # "device",
            ],
        ),
        "//App/Tests:AppTests",
        "//Modules/List/Tests:ListTests",
        "//Modules/Details/Tests:DetailsTests",
        "//Modules/Networking/Tests:NetworkingTests",
    ],
    xcschemes = _SCHEMES,
    xcode_configurations = {
        "Debug": {
            "//command_line_option:compilation_mode": "dbg",
        },
        "Release": {
            "//command_line_option:compilation_mode": "opt",
        },
    },
)
