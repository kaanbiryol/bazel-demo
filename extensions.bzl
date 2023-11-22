load("//:repositories.bzl", "swift_collections")

def _non_module_dependencies_impl(_ctx):
    swift_collections()

non_module_dependencies = module_extension(
    implementation = _non_module_dependencies_impl,
)
