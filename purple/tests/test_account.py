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
    found_account = purple.Account.find(core, protocol, b"user1")
    assert found_account is None

    # Create
    account = purple.Account.new(core, protocol, b"user1")
    assert account

    # Find
    found_account = purple.Account.find(core, protocol, b"user1")
    assert found_account
    assert account.get_username() == b"user1"


def test_enable_account(core):
    account = get_test_account(core=core)
    assert account.is_enabled() is False
    account.set_enabled(True)
    assert account.is_enabled() is True


def test_is_connected(core):
    account = get_test_account(core=core)
    assert account.is_connected() is False


def test_set_password(core):
    account = get_test_account(core=core)
    assert account.get_password() is None

    account.set_password(b"pass123")
    assert account.get_password() == b"pass123"
