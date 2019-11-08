#
#  Copyright (c) 2019 Flare Systems Inc.
#
#  This file is part of python-purple.
#
#  python-purple is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  python-purple is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import time
import pytest

import purple
from purple import PurpleClient

from .utils import get_test_account
from .utils import get_test_connection


def test_connection_get_prpl(core):
    connection = get_test_connection()
    prpl = connection.get_prpl()
    assert isinstance(prpl, purple.Plugin)


def test_signing_on_signal(client: PurpleClient) -> None:

    called = False
    _connection = None

    def handler(*, connection):
        nonlocal called
        called = True

        nonlocal _connection
        _connection = connection

    client.set_cb_signal_connection_signing_on(callback=handler)
    account = get_test_account(username=b"signing_on_user")

    assert not called
    assert not _connection

    account.set_enabled(True)

    assert called
    assert _connection
    assert _connection.get_account().get_username() == b"signing_on_user"


def test_signed_on_signal(client: PurpleClient) -> None:

    called = False
    _connection = None

    def handler(*, connection):
        nonlocal called
        called = True

        nonlocal _connection
        _connection = connection

    client.set_cb_signal_connection_signed_on(callback=handler)
    account = get_test_account(username=b"signed_on_user")

    assert not called
    assert not _connection

    account.set_enabled(True)

    assert called
    assert _connection
    assert _connection.get_account().get_username() == b"signed_on_user"


def test_signing_off_signal(client: PurpleClient) -> None:

    called = False
    _connection = None

    def handler(*, connection):
        nonlocal called
        called = True

        nonlocal _connection
        _connection = connection

    client.set_cb_signal_connection_signing_off(callback=handler)

    account = get_test_account(username=b"signing_off_user")
    account.set_enabled(True)

    assert not called
    assert not _connection

    account.set_enabled(False)

    assert called
    assert _connection
    assert _connection.get_account().get_username() == b"signing_off_user"


def test_signed_off_signal(client: PurpleClient) -> None:

    called = False
    _connection = None

    def handler(*, connection):
        nonlocal called
        called = True

        nonlocal _connection
        _connection = connection

    client.set_cb_connection_signed_off(callback=handler)

    account = get_test_account(username=b"signed_off_user")
    account.set_enabled(True)

    assert not called
    assert not _connection

    account.set_enabled(False)

    assert called
    assert _connection
    assert _connection.get_account().get_username() == b"signed_off_user"
