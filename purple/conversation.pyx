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
from libpurple cimport blist as c_libblist

from purple cimport account as libaccount

cdef class Conversation:

    @staticmethod
    cdef Conversation from_c_conversation(c_libconversation.PurpleConversation* c_conversation):
        cdef Conversation conversation = Conversation.__new__(Conversation)
        conversation._c_conversation = c_conversation
        return conversation

    @staticmethod
    def new(
        *,
        ConversationType type,
        libaccount.Account account,
        bytes name,
    ):

        cdef c_libconversation.PurpleConversation* c_conversation = c_libconversation.purple_conversation_new(
            type,
            account._c_account,
            name,
        )

        if c_conversation == NULL:
            raise Exception("Could not create conversation")

        cdef Conversation conversation = None

        if type == ConversationType.CONVERSATION_TYPE_CHAT:
            conversation = Chat.from_c_conversation(c_conversation)
        elif type == ConversationType.CONVERSATION_TYPE_IM:
            conversation = IM.from_c_conversation(c_conversation)
        else:
            conversation = Conversation.from_c_conversation(c_conversation)

        return conversation

    cpdef bytes get_name(self):
        cdef char* c_name = c_libconversation.purple_conversation_get_name(
            self._c_conversation
        )
        cdef bytes name = c_name or None
        return name

    cpdef bytes get_title(self):
        cdef char* c_name = c_libconversation.purple_conversation_get_title(
            self._c_conversation
        )
        cdef bytes title = c_name or None
        return title

    cpdef ConversationType get_type(self):
        cdef ConversationType _type = <ConversationType> c_libconversation.purple_conversation_get_type(
            self._c_conversation
        )
        return _type

    @staticmethod
    def get_conversations():
        cdef glib.GList* c_iter = c_libconversation.purple_get_conversations()
        cdef list conversations = list()

        while c_iter:
            conversation = Conversation.from_c_conversation(<c_libconversation.PurpleConversation*> c_iter.data)
            conversations.append(conversation)
            c_iter = c_iter.next

        return conversations


cdef class IM(Conversation):

    @staticmethod
    cdef IM from_c_conversation(c_libconversation.PurpleConversation* c_conversation):
        cdef Conversation conversation = IM.__new__(IM)
        conversation._c_conversation = c_conversation
        return conversation

    @staticmethod
    def get_ims():
        cdef glib.GList* c_iter = c_libconversation.purple_get_ims()
        cdef list ims = list()

        while c_iter:
            im = IM.from_c_conversation(<c_libconversation.PurpleConversation*> c_iter.data)
            ims.append(im)
            c_iter = c_iter.next

        return ims

    def __repr__(self):
        return "<{class_name}: {im_name}>".format(
            class_name=self.__class__.__name__,
            im_name=self.get_name(),
        )

cdef class Chat(Conversation):

    @staticmethod
    cdef Chat from_c_conversation(c_libconversation.PurpleConversation* c_conversation):
        cdef Conversation conversation = Chat.__new__(Chat)
        conversation._c_conversation = c_conversation
        return conversation

    cdef c_libconversation.PurpleConvChat* get_c_chat(self):
        cdef c_libconversation.PurpleConvChat* c_chat = c_libconversation.purple_conversation_get_chat_data(
            self._c_conversation
        )
        return c_chat

    cpdef int get_id(self):
        cdef int _id = c_libconversation.purple_conv_chat_get_id(
            self.get_c_chat()
        )
        return _id

    cpdef bytes get_nick(self):
        cdef char* c_nick = c_libconversation.purple_conv_chat_get_nick(
            self.get_c_chat()
        )
        cdef bytes nick = c_nick or None
        return nick

    cpdef bytes get_topic(self):
        cdef char* c_topic = c_libconversation.purple_conv_chat_get_topic(
            self.get_c_chat()
        )
        cdef bytes topic = c_topic or None
        return topic

    cpdef void invite_user(self, bytes user, bytes message, bint confirm):
        c_libconversation.purple_conv_chat_invite_user(
            self.get_c_chat(),
            user,
            message,
            confirm,
        )

    cpdef list get_users(self):
        cdef glib.GList* c_iter = c_libconversation.purple_conv_chat_get_users(
            self.get_c_chat()
        )
        cdef list users = list()

        cdef c_libconversation.PurpleConvChatBuddy* c_conv_chat_buddy
        cdef ChatBuddy chat_buddy
        while c_iter:
            c_conv_chat_buddy = <c_libconversation.PurpleConvChatBuddy*> c_iter.data
            chat_buddy = ChatBuddy.from_c_conv_chat_buddy(c_conv_chat_buddy)
            users.append(chat_buddy)
            c_iter = c_iter.next

        return users

    @staticmethod
    def get_chats():
        cdef glib.GList* c_iter = c_libconversation.purple_get_chats()
        cdef list chats = list()

        while c_iter:
            chat = Chat.from_c_conversation(<c_libconversation.PurpleConversation*> c_iter.data)
            chats.append(chat)
            c_iter = c_iter.next

        return chats

    def __repr__(self):
        return "<{class_name}: {chat_name}>".format(
            class_name=self.__class__.__name__,
            chat_name=self.get_name(),
        )


cdef class ChatBuddy:

    @staticmethod
    cdef ChatBuddy from_c_conv_chat_buddy(c_libconversation.PurpleConvChatBuddy* c_conv_chat_buddy):
        cdef ChatBuddy chat_buddy = ChatBuddy.__new__(ChatBuddy)
        chat_buddy._c_conv_chat_buddy = c_conv_chat_buddy
        return chat_buddy

    cpdef bytes get_name(self):
        cdef char* c_name = c_libconversation.purple_conv_chat_cb_get_name(
            self._c_conv_chat_buddy
        )
        cdef bytes name = c_name or None
        return name
