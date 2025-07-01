load("//build_tools:feature_macro.bzl", "feature_macro")

# swift_library(
#     name = "List",
#     srcs = glob(["**/*.swift"]),
#     data = glob(
#         ["Resources/**"],
#         exclude = ["**/.DS_Store"],
#     ),
#     module_name = "List",
#     tags = ["manual"],
#     visibility = ["//visibility:public"],
#     deps = [
#         "//Modules/Details/Sources:Details",
#         "//Modules/NetworkingInterface/Sources:NetworkingInterface",
#     ],
#     alwayslink = True,
# )

# ios_framework(
#     name = "ListFramework",
#     bundle_id = "com.example.app.ListFramework",
#     families = ["iphone"],
#     frameworks = [
#         "//Modules/Details/Sources:DetailsFramework",
#     ],
#     infoplists = ["Info.plist"],
#     minimum_os_version = "17.0",
#     visibility = ["//visibility:public"],
#     deps = [":List"],
# )

feature_macro(
    name = "List",
    srcs = glob(["**/*.swift"]),
    data = glob(
        ["Resources/**"],
        exclude = ["**/.DS_Store"],
    ),
    # framework_deps = [
    #     "//Modules/Details/Sources:Details",
    # ],
    deps = [
        "//Modules/RouterService/Sources:RouterService",
        "//Modules/NetworkingInterface/Sources:NetworkingInterface",
        "//Modules/ListInterface/Sources:ListInterface",
        "//Modules/DetailsInterface/Sources:DetailsInterface",
        "//Modules/HomeInterface/Sources:HomeInterface",
        "//Modules/OrderInterface/Sources:OrderInterface",
        "//Modules/SelectionRIB/Sources:SelectionRIB",
    ],
)
