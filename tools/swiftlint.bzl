def swiftlint():
    _swiftlint("swiftlint",False)

def swiftlint_fix():
    _swiftlint("swiftlint_fix", True)

def _swiftlint(name, enable_fix = False):
    native.genrule(
        name = name,
        srcs = [],
        outs = [name + ".sh"],
        cmd = 'echo "set -e" > "$@"\necho "./$(location @SwiftLint//:swiftlint) {} \\$$BUILD_WORKSPACE_DIRECTORY" >> "$@"'.format(
            '--fix' if enable_fix else ''
        ),
        executable = True,
        tools = ["@SwiftLint//:swiftlint"],
)