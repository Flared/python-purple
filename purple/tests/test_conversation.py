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

from . import utils


def test_conversation_get_all_empty():
    conversations = purple.Conversation.get_conversations()
    assert isinstance(conversations, list)
    assert len(conversations) == 0


def test_conversation_new_chat(core):
    account = utils.get_test_account(username=b"chatuser")
    account.set_enabled(True)

    chat = purple.Conversation.new(
        type=purple.ConversationType.CONVERSATION_TYPE_CHAT,
        account=account,
        name=b"chatname",
    )

    assert isinstance(chat, purple.Conversation)
    assert isinstance(chat, purple.Chat)
    assert chat.get_name() == b"chatname"
    assert chat.get_type() == purple.ConversationType.CONVERSATION_TYPE_CHAT
    assert chat.get_id() == 0
    assert chat.get_nick() == b"chatuser"
    assert chat.get_topic() == None
    assert chat.get_title() == b"chatname"
    assert repr(chat) == "<Chat: b'chatname'>"

    users = chat.get_users()
    assert len(users) == 0

    conversations = purple.Conversation.get_conversations()
    assert len(conversations) == 1
    assert conversations[0].get_name() == b"chatname"

    chats = purple.Chat.get_chats()
    assert len(chats) == 1
    assert chats[0].get_name() == b"chatname"

    ims = purple.IM.get_ims()
    assert len(ims) == 0


def test_conversation_new_im(core):
    account = utils.get_test_account(username=b"chatuser")
    account.set_enabled(True)

    im = purple.Conversation.new(
        type=purple.ConversationType.CONVERSATION_TYPE_IM,
        account=account,
        name=b"imname",
    )

    assert isinstance(im, purple.Conversation)
    assert isinstance(im, purple.IM)
    assert im.get_name() == b"imname"
    assert im.get_type() == purple.ConversationType.CONVERSATION_TYPE_IM
    assert im.get_title() == b"imname"
    assert repr(im) == "<IM: b'imname'>"

    conversations = purple.Conversation.get_conversations()
    assert len(conversations) == 1
    assert conversations[0].get_name() == b"imname"

    chats = purple.Chat.get_chats()
    assert len(chats) == 0

    ims = purple.IM.get_ims()
    assert len(ims) == 1
    assert ims[0].get_name() == b"imname"


def test_conversation_type():
    conv_types = purple.ConversationType

    assert conv_types.CONVERSATION_TYPE_UNKNOWN == 0
    assert conv_types.CONVERSATION_TYPE_IM == 1
    assert conv_types.CONVERSATION_TYPE_CHAT == 2
    assert conv_types.CONVERSATION_TYPE_MISC == 3
    assert conv_types.CONVERSATION_TYPE_ANY == 4
