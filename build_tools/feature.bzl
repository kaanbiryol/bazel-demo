
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_framework")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

def _feature_impl(ctx):
    compilation_mode = ctx.var["COMPILATION_MODE"]
    if compilation_mode == "dbg":
        print("dbg")
    elif compilation_mode == "opt":
        print("opt")
    else:
        print("fastbuild")

feature = rule(
    implementation = _feature_impl
)