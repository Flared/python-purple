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

import purple


def test_signals_enum(core):
    signals = purple.Signals

    assert signals.SIGNAL_BLIST_BUDDY_SIGNED_ON == "buddy-signed-on"
    assert signals.SIGNAL_BLIST_BUDDY_SIGNED_OFF == "buddy-signed-off"

    assert signals.SIGNAL_CONNECTION_SIGNING_ON == "signing-on"
    assert signals.SIGNAL_CONNECTION_SIGNED_ON == "signed-on"
    assert signals.SIGNAL_CONNECTION_SIGNING_OFF == "signing-off"
    assert signals.SIGNAL_CONNECTION_SIGNED_OFF == "signed-off"
    assert signals.SIGNAL_CONNECTION_CONNECTION_ERROR == "connection-error"

    assert signals.SIGNAL_CONVERSATION_RECEIVED_IM_MSG == "received-im-msg"
    assert signals.SIGNAL_CONVERSATION_RECEIVING_IM_MSG == "receiving-im-msg"
    assert signals.SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG == "received-chat-msg"
    assert signals.SIGNAL_CONVERSATION_CHAT_JOINED == "chat-joined"
    assert signals.SIGNAL_CONVERSATION_CHAT_LEFT == "chat-left"
    assert signals.SIGNAL_CONVERSATION_CHAT_JOIN_FAILED == "chat-join-failed"

    assert signals.SIGNAL_CORE_QUITTING == "quitting"
