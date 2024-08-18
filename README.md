- `brew install bazelisk`
- `bazel run //build_tools:buildifier`
- `bazel run //:xcodeproj`
- `bazel build //App/Sources:App`

`bazel build --explain=output.txt //App/Sources:App && grep "Compiling Swift module" output.txt`

# Queries
`bazel aquery 'mnemonic("SwiftCompile", deps(//App/Sources:App))' > output.txt`
`bazel aquery 'deps(//App/Sources:App)'`
`bazel cquery 'deps(//App/Sources:App)' --//build_tools/settings_linking:linking_mode=static --output=build > output.txt`
