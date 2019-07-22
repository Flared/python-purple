import purple


def test_signals_enum(core):
    signals = purple.Signals

    assert signals.SIGNAL_BLIST_BUDDY_SIGNED_ON == "buddy-signed-on"
    assert signals.SIGNAL_BLIST_BUDDY_SIGNED_OFF == "buddy-signed-off"

    assert signals.SIGNAL_CONNECTION_SIGNED_ON == "signed-on"
    assert signals.SIGNAL_CONNECTION_SIGNED_OFF == "signed-off"
    assert signals.SIGNAL_CONNECTION_CONNECTION_ERROR == "connection-error"

    assert signals.SIGNAL_CONVERSATION_RECEIVED_IM_MSG == "received-im-msg"
    assert signals.SIGNAL_CONVERSATION_RECEIVING_IM_MSG == "receiving-im-msg"

    assert signals.SIGNAL_CORE_QUITTING == "quitting"
