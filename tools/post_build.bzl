POST_BUILD_CONFIG = """set -euo pipefail
if [[ "$ACTION" == "build" ]]; then
    if [[ "$(uname -m)" == arm64 ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi

    if which swiftlint > /dev/null; then
    swiftlint
    else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    fi
fi"""