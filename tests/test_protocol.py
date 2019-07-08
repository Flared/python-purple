import purple


def test_protocol_find_with_id(core):
    protocol = purple.Protocol.find_with_id(b"prpl-irc")
    assert protocol
    assert protocol.get_name() == b"IRC"
    assert protocol.get_id() == b"prpl-irc"


def test_protocol_find_with_id_unknown(core):
    protocol = purple.Protocol.find_with_id(b"unknown-id")
    assert protocol is None
