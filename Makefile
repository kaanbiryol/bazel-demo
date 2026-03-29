project:
	bazel run //:xcodeproj

test:
	bazel test //App/...:all //Modules/...:all

build:
	bazel build //App/Sources:App

swiftlint:
	bazel run //:swiftlint
