load("@build_bazel_rules_apple//apple:apple.bzl", "local_provisioning_profile")
load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_application",
)
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@rules_xcodeproj//xcodeproj:defs.bzl", "xcode_provisioning_profile")
load("//build_tools:build_settings.bzl", "minimum_os_version")

BUNDLE_ID = "com.kaan.bazel"

xcode_provisioning_profile(
    name = "xcode_profile",
    managed_by_xcode = True,
    provisioning_profile = ":xcode_managed_profile",
    tags = ["manual"],
)

local_provisioning_profile(
    name = "xcode_managed_profile",
    profile_name = "iOS Team Provisioning Profile: {}".format(BUNDLE_ID),
    tags = ["manual"],
    team_id = "PERSONAL",
)

ios_application(
    name = "App",
    bundle_id = BUNDLE_ID,
    bundle_name = "App",
    families = ["iphone"],
    frameworks = select({
        "//build_tools/settings_linking:static": [],
        "//build_tools/settings_linking:dynamic": ["//Modules/List/Sources:List"],
        "//conditions:default": [],
    }),
    infoplists = [":Info.plist"],
    minimum_os_version = minimum_os_version,
    provisioning_profile = None,
    visibility = [
        "//visibility:public",
    ],
    deps = [":AppModule"],
)

swift_library(
    name = "AppModule",
    srcs = glob(["**/*.swift"]),
    module_name = "App",
    tags = ["manual"],
    visibility = ["//visibility:public"],
    copts = ["-whole-module-optimization"],
    deps = [
        # "//Modules/RouterService/Sources:RouterService",
        "//Modules/RootRIB/Sources:RootRIB",
        "//Modules/List/Sources:List",
        "//Modules/Summary/Sources:Summary",
        "//Modules/Selection/Sources:Selection",
        "//Modules/ListInterface/Sources:ListInterface",
        "//Modules/SummaryInterface/Sources:SummaryInterface",
        "//Modules/SelectionInterface/Sources:SelectionInterface",
        "//Modules/Networking/Sources:Networking",
        "//Modules/NetworkingInterface/Sources:NetworkingInterface",
        "//Modules/Home/Sources:Home",
        "//Modules/HomeInterface/Sources:HomeInterface",
        "//Modules/Order/Sources:Order",
        "//Modules/OrderInterface/Sources:OrderInterface",
        "@swift_collections//:Collections",
        "@factory//:Factory",
        "//Modules/RIBs:RIBs",
    ],
)
