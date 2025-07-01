load("//build_tools:feature_macro.bzl", "feature_macro")

feature_macro(
    name = "Summary",
    srcs = glob(["**/*.swift"]),
    data = glob(
        ["Resources/**"],
        exclude = ["**/.DS_Store"],
    ),
    deps = [
        "//Modules/NetworkingInterface/Sources:NetworkingInterface",
        "//Modules/SummaryInterface/Sources:SummaryInterface",
        # "//Modules/RouterService/Sources:RouterService",
    ],
)
