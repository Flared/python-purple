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

from purple cimport account as libaccount


cpdef enum ConversationType:
    CONVERSATION_TYPE_UNKNOWN = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_UNKNOWN
    CONVERSATION_TYPE_IM = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_IM
    CONVERSATION_TYPE_CHAT = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_CHAT
    CONVERSATION_TYPE_MISC = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_MISC
    CONVERSATION_TYPE_ANY = c_libconversation.PurpleConversationType.PURPLE_CONV_TYPE_ANY

cpdef enum PurpleConvChatBuddyFlags:
    PURPLE_CBFLAGS_NONE = c_libconversation.PurpleConvChatBuddyFlags.PURPLE_CBFLAGS_NONE
    PURPLE_CBFLAGS_VOICE = c_libconversation.PurpleConvChatBuddyFlags.PURPLE_CBFLAGS_VOICE
    PURPLE_CBFLAGS_HALFOP = c_libconversation.PurpleConvChatBuddyFlags.PURPLE_CBFLAGS_HALFOP
    PURPLE_CBFLAGS_OP = c_libconversation.PurpleConvChatBuddyFlags.PURPLE_CBFLAGS_OP
    PURPLE_CBFLAGS_FOUNDER = c_libconversation.PurpleConvChatBuddyFlags.PURPLE_CBFLAGS_FOUNDER
    PURPLE_CBFLAGS_TYPING = c_libconversation.PurpleConvChatBuddyFlags.PURPLE_CBFLAGS_TYPING
    PURPLE_CBFLAGS_AWAY = c_libconversation.PurpleConvChatBuddyFlags.PURPLE_CBFLAGS_AWAY



cdef class Conversation:

    cdef c_libconversation.PurpleConversation* _c_conversation

    @staticmethod
    cdef Conversation from_c_conversation(c_libconversation.PurpleConversation* c_conversation)

    cpdef libaccount.Account get_account(self)

    cpdef bytes get_name(self)

    cpdef ConversationType get_type(self)

    cpdef bytes get_title(self)

    cpdef list get_message_history(self)

    cpdef Chat get_chat_data(self)

    cpdef IM get_im_data(self)


cdef class IM:

    cdef c_libconversation.PurpleConvIm* _c_conv_im

    @staticmethod
    cdef IM from_c_conv_im(c_libconversation.PurpleConvIm* c_conv_im)

    cpdef Conversation get_conversation(self)

    cpdef void send(self, bytes message)


cdef class Chat:

    cdef c_libconversation.PurpleConvChat* _c_conv_chat

    @staticmethod
    cdef Chat from_c_conv_chat(c_libconversation.PurpleConvChat* c_conv_chat)

    cpdef Conversation get_conversation(self)

    cpdef void send(self, bytes message)

    cpdef list get_users(self)

    cpdef void add_user(self, bytes user, bytes extra_msg, PurpleConvChatBuddyFlags flags, glib.gboolean new_arrival)

    cpdef ChatBuddy cb_find(self, bytes name)

    cpdef int get_id(self)

    cpdef bytes get_nick(self)

    cpdef bytes get_topic(self)

    cpdef bint has_left(self)

    cpdef void left(self)

    cpdef void invite_user(self, bytes user, bytes message, bint confirm)


cdef class ChatBuddy:

    cdef c_libconversation.PurpleConvChatBuddy* _c_conv_chat_buddy

    @staticmethod
    cdef ChatBuddy from_c_conv_chat_buddy(c_libconversation.PurpleConvChatBuddy* c_chat_buddy)

    cpdef bytes get_name(self)

    cpdef bytes get_alias(self)


cdef class ConversationMessage:

    cdef c_libconversation.PurpleConvMessage* _c_conv_message

    @staticmethod
    cdef ConversationMessage from_c_conv_message(c_libconversation.PurpleConvMessage* c_conv_message)

    cpdef bytes get_message(self)
