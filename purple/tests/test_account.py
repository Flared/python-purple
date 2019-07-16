import pytest

import purple


def test_create_account(core):
    protocol = purple.Protocol.find_with_id(b"prpl-irc")
    account = purple.Account.new(core, protocol, b"user1")
    assert account
    assert account.get_username() == b"user1"


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
