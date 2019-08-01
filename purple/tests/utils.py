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


def get_test_account(*, username=b"user1"):
    protocol = purple.Protocol.find_with_id(b"prpl-null")
    account = purple.Account.new(protocol, username)
    return account


def get_test_chat(*, account=None, chat_name=b"chatname"):
    if account is None:
        account = get_test_account()
        account.set_enabled(True)

    chat = purple.Conversation.new(
        type=purple.ConversationType.CONVERSATION_TYPE_CHAT,
        account=account,
        name=chat_name,
    )

    return chat
