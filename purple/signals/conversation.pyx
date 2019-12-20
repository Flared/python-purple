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
from libpurple cimport debug as c_libdebug

from purple cimport signals as libsignals
from purple cimport conversation as libconversation
from purple cimport connection as libconnection
from purple cimport account as libaccount

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
    c_libdebug.purple_debug_info("conversation", "%s", "receiving-im-msg\n")

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
    c_libconversation.PurpleConversation* c_conversation,
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
    c_libdebug.purple_debug_info("conversation", "%s", "received-im-msg\n")

    cdef bytes sender = c_sender or None
    cdef bytes message = c_message or None
    cdef libaccount.Account account = libaccount.Account.from_c_account(c_account)
    cdef libconversation.Conversation conversation = libconversation.Conversation.from_c_conversation(c_conversation)

    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_RECEIVED_IM_MSG, tuple()):
        callback(
            account=account,
            sender=sender,
            message=message,
            conversation=conversation,
            flags=None,
        )


cdef str SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG = "received-chat-msg"
cdef void signal_conversation_received_chat_msg_cb(
    c_libaccount.PurpleAccount* c_account,
    char* c_sender,
    char* c_message,
    c_libconversation.PurpleConversation* c_conversation,
    c_libconversation.PurpleMessageFlags* c_flags
):
    c_libdebug.purple_debug_info("conversation", "%s", "received-chat-msg\n")

    cdef bytes sender = c_sender or None
    cdef bytes message = c_message or None
    cdef libconversation.Conversation conversation = libconversation.Conversation.from_c_conversation(c_conversation)

    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG, tuple()):
        callback(
            account=None,
            sender=sender,
            message=message,
            conversation=conversation,
            flags=None,
        )

cdef str SIGNAL_CONVERSATION_CHAT_JOINED = "chat-joined"
cdef glib.gboolean signal_conversation_chat_joined_cb(
    c_libconversation.PurpleConversation* c_conversation,
):
    c_libdebug.purple_debug_info("conversation", "%s", "chat-joined\n")

    cdef libconversation.Conversation conversation = libconversation.Conversation.from_c_conversation(
        c_conversation
    )

    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_CHAT_JOINED, tuple()):
        callback(
            conversation=conversation
        )


cdef str SIGNAL_CONVERSATION_CHAT_LEFT = "chat-left"
cdef glib.gboolean signal_conversation_chat_left_cb(
    c_libconversation.PurpleConversation* c_conversation,
):
    c_libdebug.purple_debug_info("conversation", "%s", "chat-left\n")

    cdef libconversation.Conversation conversation = libconversation.Conversation.from_c_conversation(
        c_conversation
    )

    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_CHAT_LEFT, tuple()):
        callback(
            conversation=conversation
        )


cdef str SIGNAL_CONVERSATION_CHAT_JOIN_FAILED = "chat-join-failed"
cdef glib.gboolean signal_conversation_chat_join_failed_cb(
    c_libconnection.PurpleConnection* c_connection,
    glib.GHashTable* c_components,
):
    c_libdebug.purple_debug_info("conversation", "%s", "chat-join-failed\n")

    cdef libconnection.Connection connection = libconnection.Connection.from_c_connection(c_connection)

    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_CHAT_JOIN_FAILED, tuple()):
        callback(
            connection=connection,
            components=None,
        )
