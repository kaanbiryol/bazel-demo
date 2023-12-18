load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

string_flag(
    name = "linking_mode",
    build_setting_default = "static",
    values = [
        "static",
        "dynamic",
    ],
)

config_setting(
    name = "static",
    flag_values = {
        ":linking_mode": "static",
    },
)

config_setting(
    name = "dynamic",
    flag_values = {
        ":linking_mode": "dynamic",
    },
)
