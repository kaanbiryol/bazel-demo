load("//:repositories.bzl", "swift_collections", "factory", "ribs")

def _non_module_dependencies_impl(_ctx):
    swift_collections()
    factory()
    ribs()

non_module_dependencies = module_extension(
    implementation = _non_module_dependencies_impl,
)
