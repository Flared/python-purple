import purple


def get_test_account(*, username=b"user1"):
    protocol = purple.Protocol.find_with_id(b"prpl-null")
    account = purple.Account.new(protocol, username)
    return account
