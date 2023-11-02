load(
  "@build_bazel_rules_apple//apple:ios.bzl",
  "ios_application",
  "ios_unit_test",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcode_schemes",
    "xcodeproj",
)

_SCHEMES = [
    xcode_schemes.scheme(
        name = "App",
        build_action = xcode_schemes.build_action(
            targets = ["//App"],
        ),
        launch_action = xcode_schemes.launch_action(
            "//App",
        )
    ),
]

xcodeproj(
    name = "xcodeproj",
    project_name = "App",
    schemes = _SCHEMES,
    top_level_targets = [
        top_level_target(
            "//App", 
            target_environments = ["simulator"]
        ),
    ],
)