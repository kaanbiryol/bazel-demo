load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcode_schemes",
    "xcodeproj",
)

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
    build_mode ="bazel",
    top_level_targets = [
        top_level_target(
            "//App/Sources:App", 
            target_environments = ["simulator"]
        ),
        "//App/Tests:AppTests",
        "//Modules/List/Tests:ListTests",
    ],
    
)

genrule(
    name = "swiftlint",
    srcs = [],
    outs = ["swiftlint.sh"],
    cmd = """
echo "set -e" > "$@"
echo "./$(location @SwiftLint//:swiftlint) --fix \\$$BUILD_WORKSPACE_DIRECTORY" >> "$@"
""",
    executable = True,
    tools = [
        "@SwiftLint//:swiftlint",
    ],
)