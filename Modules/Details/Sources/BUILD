load("//build_tools:feature_macro.bzl", "feature_macro")

# swift_library(
#     name = "Details",
#     srcs = glob(["**/*.swift"]),
#     data = glob(
#         ["Resources/**"],
#         exclude = ["**/.DS_Store"],
#     ),
#     module_name = "Details",
#     tags = ["manual"],
#     visibility = ["//visibility:public"],
#     deps = [
#         "//Modules/NetworkingInterface/Sources:NetworkingInterface",
#     ],
#     alwayslink = True,
# )

# ios_framework(
#     name = "DetailsFramework",
#     bundle_id = "com.example.app.DetailsFramework",
#     families = ["iphone"],
#     infoplists = ["Info.plist"],
#     minimum_os_version = "17.0",
#     visibility = ["//visibility:public"],
#     deps = [":Details"],
# )

feature_macro(
    name = "Details",
    srcs = glob(["**/*.swift"]),
    data = glob(
        ["Resources/**"],
        exclude = ["**/.DS_Store"],
    ),
    deps = [
        "//Modules/NetworkingInterface/Sources:NetworkingInterface",
    ],
)
