def _feature_impl(ctx):
    compilation_mode = ctx.var["COMPILATION_MODE"]
    if compilation_mode == "dbg":
        print("dbg")
    elif compilation_mode == "opt":
        print("opt")
    else:
        print("fastbuild")

feature = rule(
    implementation = _feature_impl,
)
