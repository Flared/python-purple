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

class Conversation:
    def get_name(self) -> bytes: ...
    def get_title(self) -> bytes: ...
    @staticmethod
    def get_ims() -> List["Conversation"]: ...
    @staticmethod
    def get_chats() -> List["Conversation"]: ...
    def get_chat_data(self) -> Chat: ...
    def get_im_data(self) -> IM: ...
    @staticmethod
    def new(
        type: ConversationType, account: Any, name: bytes
    ) -> "Conversation": ...

class IM:
    def send(self, message: bytes): ...

class Chat:
    def send(self, message: bytes): ...

class ConversationType:
    CONVERSATION_TYPE_UNKNOWN: Final["ConversationType"]
    CONVERSATION_TYPE_IM: Final["ConversationType"]
    CONVERSATION_TYPE_CHAT: Final["ConversationType"]
    CONVERSATION_TYPE_MISC: Final["ConversationType"]
    CONVERSATION_TYPE_ANY: Final["ConversationType"]
