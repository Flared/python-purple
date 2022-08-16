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
from purple import PurpleClient

from . import utils


def test_conversation_get_all_empty():
    conversations = purple.Conversation.get_conversations()
    assert isinstance(conversations, list)
    assert len(conversations) == 0


def test_conversation_new_chat(core) -> None:
    account = utils.get_test_account(username=b"chatuser")
    account.set_enabled(True)

    conversation = purple.Conversation.new(
        type=purple.ConversationType.CONVERSATION_TYPE_CHAT,
        account=account,
        name=b"chatname",
    )
    assert isinstance(conversation, purple.Conversation)
    assert (
        conversation.get_type()
        == purple.ConversationType.CONVERSATION_TYPE_CHAT
    )
    assert conversation.get_name() == b"chatname"
    assert conversation.get_title() == b"chatname"
    assert conversation.get_account().get_username() == b"chatuser"
    assert not conversation.get_im_data()

    chat = conversation.get_chat_data()
    assert isinstance(chat, purple.Chat)
    assert chat.get_id() == 0
    assert chat.get_nick() == b"chatuser"
    assert chat.get_topic() == None
    assert chat.has_left() == False
    assert repr(chat) == "<Chat: b'chatname'>"

    chat.add_user(
        b"testuser",
        b"extramsg",
        purple.PurpleConvChatBuddyFlags.PURPLE_CBFLAGS_VOICE,
        False,
    )
    users = chat.get_users()
    assert len(users) == 1
    assert users[0].get_name() == b"testuser"
    assert users[0].get_alias() == b"testuser"
    assert chat.cb_find(b"testuser") is not None
    assert chat.cb_find(b"invaliduser") is None

    conversations = purple.Conversation.get_conversations()
    assert len(conversations) == 1
    assert conversations[0].get_name() == b"chatname"

    chats = purple.Conversation.get_chats()
    assert len(chats) == 1
    assert chats[0].get_name() == b"chatname"
    assert isinstance(chats[0], purple.Conversation)

    ims = purple.Conversation.get_ims()
    assert len(ims) == 0


def test_conversation_new_im(core):
    account = utils.get_test_account(username=b"chatuser")
    account.set_enabled(True)

    conversation = purple.Conversation.new(
        type=purple.ConversationType.CONVERSATION_TYPE_IM,
        account=account,
        name=b"imname",
    )
    assert isinstance(conversation, purple.Conversation)
    assert (
        conversation.get_type() == purple.ConversationType.CONVERSATION_TYPE_IM
    )
    assert conversation.get_name() == b"imname"
    assert conversation.get_title() == b"imname"
    assert not conversation.get_chat_data()

    im = conversation.get_im_data()
    assert isinstance(im, purple.IM)
    assert repr(im) == "<IM: b'imname'>"

    conversations = purple.Conversation.get_conversations()
    assert len(conversations) == 1
    assert conversations[0].get_name() == b"imname"

    chats = purple.Conversation.get_chats()
    assert len(chats) == 0

    ims = purple.Conversation.get_ims()
    assert len(ims) == 1
    assert isinstance(ims[0], purple.Conversation)
    assert ims[0].get_name() == b"imname"


def test_conversation_type():
    conv_types = purple.ConversationType

    assert conv_types.CONVERSATION_TYPE_UNKNOWN == 0
    assert conv_types.CONVERSATION_TYPE_IM == 1
    assert conv_types.CONVERSATION_TYPE_CHAT == 2
    assert conv_types.CONVERSATION_TYPE_MISC == 3
    assert conv_types.CONVERSATION_TYPE_ANY == 4


def test_chat_has_left(core):
    chat = utils.get_test_chat()
    assert chat.has_left() == False
    chat.left()
    assert chat.has_left() == True


def test_received_im_message_signal(client: PurpleClient):

    received_im_message_handler_called = False
    _message = None
    _account_name = None

    def received_im_message_handler(
        *, account, sender, message, conversation, flags
    ):
        nonlocal received_im_message_handler_called
        nonlocal _message
        nonlocal _account_name
        received_im_message_handler_called = True
        _message = message
        _account_name = account.get_username()

    client.set_cb_signal_conversation_received_im_msg(
        callback=received_im_message_handler
    )

    im = utils.get_test_im()

    assert not received_im_message_handler_called
    assert not _message

    im.send(b"Hello!")

    assert received_im_message_handler_called
    assert _message == b"Hello!"
    assert _account_name == b"user1"


def test_write_im_callback(client: PurpleClient):

    write_im_handler_called = False
    _message = None
    _account_name = None

    def write_im_handler(*, conversation, who, message, time, flags):
        nonlocal write_im_handler_called
        nonlocal _message
        nonlocal _account_name
        if not (flags & purple.PurpleMessageFlags.PURPLE_MESSAGE_RECV):
            return

        write_im_handler_called = True
        _message = message
        _account_name = who

    client.set_cb_conversation_write_im(callback=write_im_handler)

    im = utils.get_test_im()

    assert not write_im_handler_called
    assert not _message

    im.send(b"Hello!")

    assert write_im_handler_called
    assert _message == b"Hello!"
    assert _account_name == b"user1"


def test_joined_chat_signal(client: PurpleClient):

    # Prepare handler
    joined_chat_handler_called = False

    def joined_chat_handler(*, conversation):
        nonlocal joined_chat_handler_called
        joined_chat_handler_called = True

    # Connect signal
    client.set_cb_signal_conversation_chat_joined(callback=joined_chat_handler)

    # Prepare
    account = utils.get_test_account()
    account.set_enabled(True)
    assert account

    connection = account.get_connection()
    assert connection

    assert not purple.Conversation.get_chats()
    assert not joined_chat_handler_called

    # Join the chat
    purple.Server.join_chat(connection, {b"room": b"test"})

    assert joined_chat_handler_called

    chat_conversations = purple.Conversation.get_chats()
    assert len(chat_conversations) == 1
