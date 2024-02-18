load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

string_flag(
    name = "module_configuration",
    build_setting_default = "modular",
    values = [
        "modular",
        "monolith",
    ],
)

config_setting(
    name = "modular",
    flag_values = {
        ":module_configuration": "modular",
    },
)

config_setting(
    name = "monolith",
    flag_values = {
        ":module_configuration": "monolith",
    },
)
