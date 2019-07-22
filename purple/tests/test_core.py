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


def test_two_signals(core):

    signal_1_count = 0

    def signal_1_callback():
        nonlocal signal_1_count
        signal_1_count = signal_1_count + 1

    signal_2_count = 0

    def signal_2_callback():
        nonlocal signal_2_count
        signal_2_count = signal_2_count + 1

    core.signal_connect(
        signal_name=purple.Signals.SIGNAL_CORE_QUITTING,
        callback=signal_1_callback,
    )
    core.signal_connect(
        signal_name=purple.Signals.SIGNAL_CORE_QUITTING,
        callback=signal_2_callback,
    )
    core.signal_connect(
        signal_name=purple.Signals.SIGNAL_CORE_QUITTING,
        callback=signal_2_callback,
    )

    core.destroy()

    assert signal_1_count == 1
    assert signal_2_count == 2


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

    c.signal_connect(
        signal_name=purple.Signals.SIGNAL_CORE_QUITTING, callback=handler
    )

    c.destroy()

    assert called is True
