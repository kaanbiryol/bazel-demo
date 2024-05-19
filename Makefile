project:
	bazel run //:xcodeproj --config=bazel
		
project_bwx:
	bazel run //:xcodeproj --config=xcode

test:
	bazel test //...:all

build:
	bazel build -s //App/Sources:App
