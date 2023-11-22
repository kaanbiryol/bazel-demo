load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

rules_xcodeproj_build_mode_config = string_flag(
    name = "rules_xcodeproj_build_mode_config",
    values = ["bazel", "xcode"],
    build_setting_default = "bazel",
)
