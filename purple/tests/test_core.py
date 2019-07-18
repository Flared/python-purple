import sys
import os
import tempfile

import pytest

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


def test_create_two_cores():
    c = purple.Purple(
        b"name",
        b"version",
        b"website",
        b"dev-website",
        debug_enabled=True,
        default_path=tempfile.mkdtemp().encode(),
    )
    assert c.purple_init() == True

    c2 = purple.Purple(
        b"name",
        b"version",
        b"website",
        b"dev-website",
        debug_enabled=True,
        default_path=tempfile.mkdtemp().encode(),
    )
    with pytest.raises(Exception, match="Initialization failed"):
        c2.purple_init()


def test_core_version(core):
    version = core.get_version()
    assert version.startswith(b"2")


def test_bad_signal_name(core):
    def handler():
        pass

    with pytest.raises(Exception, match="Unknown signal"):
        core.signal_connect(signal_name="unknown", callback=handler)


def test_core_signal_quitting():
    c = purple.Purple(
        b"name",
        b"version",
        b"website",
        b"dev-website",
        debug_enabled=True,
        default_path=tempfile.mkdtemp().encode(),
    )
    c.purple_init()

    called = False

    def handler():
        nonlocal called
        called = True

    c.signal_connect(signal_name="quitting", callback=handler)

    c.destroy()

    assert called is True
