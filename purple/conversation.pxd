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

from purple cimport account as libaccount

cpdef enum ConversationType:
    CONVERSATION_TYPE_UNKNOWN = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_UNKNOWN
    CONVERSATION_TYPE_IM = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_IM
    CONVERSATION_TYPE_CHAT = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_CHAT
    CONVERSATION_TYPE_MISC = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_MISC
    CONVERSATION_TYPE_ANY = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_ANY

cdef class Conversation:

    cdef c_libconversation.PurpleConversation* _c_conversation

    @staticmethod
    cdef Conversation _from_c_conversation(c_libconversation.PurpleConversation* c_conversation)

    cpdef bytes get_name(self)

    cpdef ConversationType get_type(self)

cdef class IM(Conversation):
    pass

cdef class Chat(Conversation):
    pass
