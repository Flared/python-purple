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
from typing_extensions import Final
from typing import List
from typing import Any
from typing import Optional

import purple

class Conversation:
    @staticmethod
    def get_conversations() -> List["Conversation"]: ...
    def get_name(self) -> bytes: ...
    def get_title(self) -> bytes: ...
    def get_type(self) -> ConversationType: ...
    def get_account(self) -> purple.Account: ...
    @staticmethod
    def get_ims() -> List["Conversation"]: ...
    @staticmethod
    def get_chats() -> List["Conversation"]: ...
    def get_chat_data(self) -> Optional[Chat]: ...
    def get_im_data(self) -> Optional[IM]: ...
    @staticmethod
    def new(
        type: ConversationType, account: Any, name: bytes
    ) -> "Conversation": ...

class IM:
    def send(self, message: bytes): ...

class Chat:
    def send(self, message: bytes): ...
    def get_id(self) -> int: ...
    def get_nick(self) -> bytes: ...
    def get_topic(self) -> bytes: ...
    def get_users(self) -> List[ChatBuddy]: ...
    def cb_find(self, name: bytes) -> Optional[ChatBuddy]: ...
    def add_user(
        self,
        user: bytes,
        extra_msg: bytes,
        flags: purple.PurpleConvChatBuddyFlags,
        new_arrival: bool,
    ): ...
    def has_left(self) -> bool: ...

class ChatBuddy:
    def get_name(self) -> bytes: ...
    def get_alias(self) -> bytes: ...

class ConversationType:
    CONVERSATION_TYPE_UNKNOWN: Final["ConversationType"]
    CONVERSATION_TYPE_IM: Final["ConversationType"]
    CONVERSATION_TYPE_CHAT: Final["ConversationType"]
    CONVERSATION_TYPE_MISC: Final["ConversationType"]
    CONVERSATION_TYPE_ANY: Final["ConversationType"]

class PurpleConvChatBuddyFlags:
    PURPLE_CBFLAGS_NONE = Final["PurpleConvChatBuddyFlags"]
    PURPLE_CBFLAGS_VOICE = Final["PurpleConvChatBuddyFlags"]
    PURPLE_CBFLAGS_HALFOP = Final["PurpleConvChatBuddyFlags"]
    PURPLE_CBFLAGS_OP = Final["PurpleConvChatBuddyFlags"]
    PURPLE_CBFLAGS_FOUNDER = Final["PurpleConvChatBuddyFlags"]
    PURPLE_CBFLAGS_TYPING = Final["PurpleConvChatBuddyFlags"]
    PURPLE_CBFLAGS_AWAY = Final["PurpleConvChatBuddyFlags"]
