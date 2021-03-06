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

cimport glib

from libpurple cimport conversation as c_libconversation
from libpurple cimport account as c_libaccount
from libpurple cimport connection as c_libconnection

cdef str SIGNAL_CONVERSATION_RECEIVING_IM_MSG
cdef glib.gboolean signal_conversation_receiving_im_msg_cb(
    c_libaccount.PurpleAccount* account,
    char** sender,
    char** message,
    c_libconversation.PurpleConversation* conv,
    c_libconversation.PurpleMessageFlags* flags
)

cdef str SIGNAL_CONVERSATION_RECEIVED_IM_MSG
cdef void signal_conversation_received_im_msg_cb(
    c_libaccount.PurpleAccount* account,
    char* sender,
    char* message,
    c_libconversation.PurpleConversation* conv,
    c_libconversation.PurpleMessageFlags* flags
)

cdef str SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG
cdef void signal_conversation_received_chat_msg_cb(
    c_libaccount.PurpleAccount* account,
    char* sender,
    char* message,
    c_libconversation.PurpleConversation* conv,
    c_libconversation.PurpleMessageFlags* flags
)

cdef str SIGNAL_CONVERSATION_CHAT_JOINED
cdef glib.gboolean signal_conversation_chat_joined_cb(
    c_libconversation.PurpleConversation* conversation,
)

cdef str SIGNAL_CONVERSATION_CHAT_LEFT
cdef glib.gboolean signal_conversation_chat_left_cb(
    c_libconversation.PurpleConversation* conversation,
)

cdef str SIGNAL_CONVERSATION_CHAT_JOIN_FAILED
cdef glib.gboolean signal_conversation_chat_join_failed_cb(
    c_libconnection.PurpleConnection* connection,
    glib.GHashTable* components,
)
