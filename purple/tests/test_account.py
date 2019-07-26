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

import pytest

import purple

from .utils import get_test_account


def test_account_init_raises():
    with pytest.raises(Exception):
        account = account.Account()


def test_find_account(core):
    # Prepare
    protocol = purple.Protocol.find_with_id(b"prpl-irc")

    # Not found
    found_account = purple.Account.find(protocol, b"user1")
    assert found_account is None

    # Create
    account = purple.Account.new(protocol, b"user1")
    assert account

    # Find
    found_account = purple.Account.find(protocol, b"user1")
    assert found_account
    assert account.get_username() == b"user1"


def test_enable_account(core):
    account = get_test_account()
    assert account.is_enabled() is False
    account.set_enabled(True)
    assert account.is_enabled() is True


def test_is_connected(core):
    account = get_test_account()
    assert account.is_connected() is False


def test_set_password(core):
    account = get_test_account()
    assert account.get_password() is None

    account.set_password(b"pass123")
    assert account.get_password() == b"pass123"
