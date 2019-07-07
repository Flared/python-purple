import purple
import tempfile


def test_core_init():
    core = purple.Purple(
        b"name",
        b"version",
        b"website",
        b"dev-website",
        debug_enabled=True,
        default_path=tempfile.mkdtemp().encode(),
    )
    core.purple_init()
    core.destroy()


def test_core_version(core):
    version = core.get_version()
    assert version.startswith(b"2")
