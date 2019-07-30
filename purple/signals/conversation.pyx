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

from libpurple cimport conversation as c_libconversation
from libpurple cimport account as c_libaccount
from libpurple cimport blist as c_libblist
from libpurple cimport util as c_libutil

from purple cimport signals as libsignals

cdef str SIGNAL_CONVERSATION_RECEIVING_IM_MSG = "receiving-im-msg"
cdef glib.gboolean signal_conversation_receiving_im_msg_cb(
    c_libaccount.PurpleAccount* c_account,
    char** c_sender,
    char** c_message,
    c_libconversation.PurpleConversation* c_conv,
    c_libconversation.PurpleMessageFlags* c_flags
):
    """
    Emitted when an IM is received. The callback can replace the name of the
    sender, the message, or the flags by modifying the pointer to the strings
    and integer. This can also be used to cancel a message by returning TRUE.
    @note Make sure to free *sender and *message before you replace them!
    @returns TRUE if the message should be canceled, or FALSE otherwise.
    @params account  The account the message was received on.
    @params sender   A pointer to the username of the sender.
    @params message  A pointer to the message that was sent.
    @params conv     The IM conversation.
    @params flags    A pointer to the IM message flags.
    """
    cdef bytes sender = c_sender[0] or None
    cdef bytes message = c_message[0] or None

    cdef glib.gboolean ret = False
    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_RECEIVING_IM_MSG, tuple()):
        ret = ret or callback(
            account=None,
            sender=sender[0],
            message=message[0],
            conversation=None,
            flags=None,
        )

    return ret

cdef str SIGNAL_CONVERSATION_RECEIVED_IM_MSG = "received-im-msg"
cdef void signal_conversation_received_im_msg_cb(
    c_libaccount.PurpleAccount* c_account,
    char* c_sender,
    char* c_message,
    c_libconversation.PurpleConversation* c_conv,
    c_libconversation.PurpleMessageFlags* c_flags
):
    """
    Emitted when after IM is received.
    @params account  The account the message was received on.
    @params sender   A pointer to the username of the sender.
    @params message  A pointer to the message that was sent.
    @params conv     The IM conversation.
    @params flags    A pointer to the IM message flags.
    """
    cdef bytes sender = c_sender or None
    cdef bytes message = c_message or None

    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_RECEIVED_IM_MSG, tuple()):
        callback(
            account=None,
            sender=sender,
            message=message,
            conversation=None,
            flags=None,
        )
