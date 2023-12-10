load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

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