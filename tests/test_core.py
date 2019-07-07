import sys
import os
import tempfile
import purple


def test_core_init():
    c = purple.Purple(
        b"name",
        b"version",
        b"website",
        b"dev-website",
        debug_enabled=True,
        default_path=tempfile.mkdtemp().encode(),
    )
    c.purple_init()
    c.destroy()


def test_core_version(core):
    version = core.get_version()
    assert version.startswith(b"2")
