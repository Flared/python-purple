import purple


def get_test_account(*, core):
    protocol = purple.Protocol.find_with_id(b"prpl-null")
    account = purple.Account.new(core, protocol, b"user1")
    return account
