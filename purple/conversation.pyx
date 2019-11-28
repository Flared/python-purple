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

        cdef Conversation conversation = Conversation.from_c_conversation(c_conversation)

        return conversation

    cpdef libaccount.Account get_account(self):
        return libaccount.Account.from_c_account(
            c_libconversation.purple_conversation_get_account(self._c_conversation)
        )

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

    cpdef list get_message_history(self):
        cdef glib.GList* c_iter = c_libconversation.purple_conversation_get_message_history(
            self._c_conversation
        )
        cdef list messages = list()

        while c_iter:
            conv_message = ConversationMessage.from_c_conv_message(
                <c_libconversation.PurpleConvMessage*> iter.data
            )
            messages.append(conv_message)
            c_iter = c_iter.next

        return messages

    cpdef Chat get_chat_data(self):
        cdef c_libconversation.PurpleConvChat* c_conv_chat = c_libconversation.purple_conversation_get_chat_data(
            self._c_conversation,
        )
        cdef Chat chat = None

        if c_conv_chat != NULL:
            chat = Chat.from_c_conv_chat(c_conv_chat)

        return chat

    cpdef IM get_im_data(self):
        cdef c_libconversation.PurpleConvIm* c_conv_im = c_libconversation.purple_conversation_get_im_data(
            self._c_conversation,
        )
        cdef IM im = None

        if c_conv_im != NULL:
            im = IM.from_c_conv_im(c_conv_im)

        return im

    @staticmethod
    def get_conversations():
        cdef glib.GList* c_iter = c_libconversation.purple_get_conversations()
        cdef list conversations = list()

        while c_iter:
            conversation = Conversation.from_c_conversation(
                <c_libconversation.PurpleConversation*> c_iter.data
            )
            conversations.append(conversation)
            c_iter = c_iter.next

        return conversations

    @staticmethod
    def get_ims():
        cdef glib.GList* c_iter = c_libconversation.purple_get_ims()
        cdef list ims = list()

        while c_iter:
            conversation = Conversation.from_c_conversation(
                <c_libconversation.PurpleConversation*> c_iter.data
            )
            ims.append(conversation)
            c_iter = c_iter.next

        return ims

    @staticmethod
    def get_chats():
        cdef glib.GList* c_iter = c_libconversation.purple_get_chats()
        cdef list chats = list()

        while c_iter:
            conversation = Conversation.from_c_conversation(
                <c_libconversation.PurpleConversation*> c_iter.data
            )
            chats.append(conversation)
            c_iter = c_iter.next

        return chats

    def __repr__(self):
        return "<{class_name}: {conversation_name}>".format(
            class_name=self.__class__.__name__,
            conversation_name=self.get_name(),
        )


cdef class IM:

    @staticmethod
    cdef IM from_c_conv_im(c_libconversation.PurpleConvIm* c_conv_im):
        cdef IM im = IM.__new__(IM)
        im._c_conv_im = c_conv_im
        return im

    cpdef void send(self, bytes message):
        c_libconversation.purple_conv_im_send(
            self._c_conv_im,
            message,
        )

    cpdef Conversation get_conversation(self):
        cdef Conversation conversation = Conversation.from_c_conversation(
            c_libconversation.purple_conv_im_get_conversation(
            self._c_conv_im,
            )
        )
        return conversation

    def __repr__(self):
        return "<{class_name}: {im_name}>".format(
            class_name=self.__class__.__name__,
            im_name=self.get_conversation().get_name(),
        )

cdef class Chat:

    @staticmethod
    cdef Chat from_c_conv_chat(c_libconversation.PurpleConvChat* c_conv_chat):
        cdef Chat chat = Chat.__new__(Chat)
        chat._c_conv_chat = c_conv_chat
        return chat

    cpdef Conversation get_conversation(self):
        cdef Conversation conversation = Conversation.from_c_conversation(
            c_libconversation.purple_conv_chat_get_conversation(
                self._c_conv_chat,
            )
        )
        return conversation

    cpdef void send(self, bytes message):
        c_libconversation.purple_conv_chat_send(
            self._c_conv_chat,
            message,
        )

    cpdef int get_id(self):
        cdef int _id = c_libconversation.purple_conv_chat_get_id(
            self._c_conv_chat,
        )
        return _id

    cpdef bytes get_nick(self):
        cdef char* c_nick = c_libconversation.purple_conv_chat_get_nick(
            self._c_conv_chat,
        )
        cdef bytes nick = c_nick or None
        return nick

    cpdef bytes get_topic(self):
        cdef char* c_topic = c_libconversation.purple_conv_chat_get_topic(
            self._c_conv_chat,
        )
        cdef bytes topic = c_topic or None
        return topic

    cpdef bint has_left(self):
        cdef bint _has_left = c_libconversation.purple_conv_chat_has_left(
            self._c_conv_chat,
        )
        return _has_left

    cpdef void left(self):
       c_libconversation.purple_conv_chat_left(
           self._c_conv_chat,
       )

    cpdef void invite_user(self, bytes user, bytes message, bint confirm):
        c_libconversation.purple_conv_chat_invite_user(
            self._c_conv_chat,
            user,
            message,
            confirm,
        )

    cpdef list get_users(self):
        cdef glib.GList* c_iter = c_libconversation.purple_conv_chat_get_users(
            self._c_conv_chat,
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

    def __repr__(self):
        return "<{class_name}: {chat_name}>".format(
            class_name=self.__class__.__name__,
            chat_name=self.get_conversation().get_name(),
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


cdef class ConversationMessage:

    @staticmethod
    cdef ConversationMessage from_c_conv_message(c_libconversation.PurpleConvMessage* c_conv_message):
        cdef ConversationMessage conversation_message = ConversationMessage.__new__(ConversationMessage)
        conversation_message._c_conv_message = c_conv_message
        return conversation_message

    cpdef bytes get_message(self):
        cdef char* c_message = c_libconversation.purple_conversation_message_get_message(
            self._c_conv_message
        )
        cdef bytes message = c_message or None
        return message
