#
#  Copyright (c) 2019 Flare Systems
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

cdef class Chat(Conversation):

    @staticmethod
    cdef Chat from_c_conversation(c_libconversation.PurpleConversation* c_conversation):
        cdef Conversation conversation = Chat.__new__(Chat)
        conversation._c_conversation = c_conversation
        return conversation

    @staticmethod
    def get_chats():
        cdef glib.GList* c_iter = c_libconversation.purple_get_chats()
        cdef list chats = list()

        while c_iter:
            chat = Chat.from_c_conversation(<c_libconversation.PurpleConversation*> c_iter.data)
            chats.append(chat)
            c_iter = c_iter.next

        return chats
