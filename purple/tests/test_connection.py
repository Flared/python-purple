import time
import pytest

import purple

from .utils import get_test_account


def test_signing_on_signal(core):

    called = False

    def handler(connection):
        nonlocal called
        called = True

    core.signal_connect(
        signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNING_ON,
        callback=handler,
    )
    account = get_test_account(core=core)

    assert not called
    account.set_enabled(True)
    assert called


def test_signed_on_signal(core):

    called = False

    def handler(connection):
        nonlocal called
        called = True

    core.signal_connect(
        signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNED_ON, callback=handler
    )
    account = get_test_account(core=core)

    assert not called
    account.set_enabled(True)
    assert called


def test_signing_off_signal(core):

    called = False

    def handler(connection):
        nonlocal called
        called = True

    core.signal_connect(
        signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNING_OFF,
        callback=handler,
    )

    account = get_test_account(core=core)
    account.set_enabled(True)

    assert not called
    account.set_enabled(False)
    assert called


def test_signed_off_signal(core):

    called = False

    def handler(connection):
        nonlocal called
        called = True

    core.signal_connect(
        signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNED_OFF,
        callback=handler,
    )

    account = get_test_account(core=core)
    account.set_enabled(True)

    assert not called
    account.set_enabled(False)
    assert called
