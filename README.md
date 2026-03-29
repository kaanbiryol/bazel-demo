# Bazel iOS Playground

A demo iOS SwiftUI project built with [Bazel](https://bazel.build/), showcasing modular architecture, static/dynamic linking configuration, and Xcode integration via [rules_xcodeproj](https://github.com/MobileNativeFoundation/rules_xcodeproj).

## Architecture

```
App/                            Main iOS application (SwiftUI)
Modules/
  List/                         List feature module
  Details/                      Details feature module
  Networking/                   Network implementation
  NetworkingInterface/          Network protocol (dependency inversion)
build_tools/                    Bazel macros and build configuration
```

## Prerequisites

- macOS with Xcode 15+
- [Bazelisk](https://github.com/bazelbuild/bazelisk) (`brew install bazelisk`)

## Quick Start

```bash
# Generate Xcode project
bazel run //:xcodeproj

# Build the app
bazel build //App/Sources:App

# Run tests
bazel test //App/...:all //Modules/...:all

# Run SwiftLint
bazel run //:swiftlint
```

## Key Concepts

- **Bzlmod** - modern Bazel module system (`MODULE.bazel`) alongside legacy `WORKSPACE`
- **Custom macro** - `build_tools/feature_macro.bzl` abstracts static library + dynamic framework with a `select()` toggle
- **Static/Dynamic linking** - switch between linking modes via `--config=static` or `--config=dynamic` in `.bazelrc`
- **rules_xcodeproj** - generate Xcode projects that build with Bazel
- **SwiftLint** - Bazel-managed linting with custom rules
- **External dependencies** - swift-collections integrated via bzlmod extension

## Useful Queries

```bash
# List all Swift compile actions
bazel aquery 'mnemonic("SwiftCompile", deps(//App/Sources:App))'

# Query dependency graph with static linking
bazel cquery 'deps(//App/Sources:App)' --//build_tools/settings_linking:linking_mode=static --output=build

# Format BUILD files
bazel run //build_tools:buildifier
```

## Bazel Version

Pinned to 8.4.1 via `.bazelversion`. Bazelisk will automatically download the correct version.