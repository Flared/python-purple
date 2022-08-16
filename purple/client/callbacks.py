from datetime import datetime

from typing_extensions import Protocol
from typing import Callable
from typing import Any

import purple


class CallbackSignalConversationReceivedImMsg(Protocol):
    def __call__(
        self,
        *,
        account: purple.Account,
        sender: bytes,
        message: bytes,
        conversation: purple.Conversation,
        flags: Any,
    ) -> None:
        ...


class CallbackSignalConversationReceivedChatMsg(Protocol):
    def __call__(
        self,
        *,
        account: purple.Account,
        sender: bytes,
        message: bytes,
        conversation: purple.Conversation,
        flags: Any,
    ) -> None:
        ...


class CallbackSignalConversationChatJoined(Protocol):
    def __call__(self, *, conversation: purple.Conversation) -> None:
        ...


class CallbackSignalConversationChatLeft(Protocol):
    def __call__(self, *, conversation: purple.Conversation) -> None:
        ...


class CallbackSignalConversationChatJoinFailed(Protocol):
    def __call__(
        self, *, connection: purple.Connection, components: Any
    ) -> None:
        ...


class CallbackSignalConnectionSigningOn(Protocol):
    def __call__(self, *, connection: purple.Connection) -> None:
        ...


class CallbackSignalConnectionSigningOff(Protocol):
    def __call__(self, *, connection: purple.Connection) -> None:
        ...


class CallbackSignalConnectionSignedOn(Protocol):
    def __call__(self, *, connection: purple.Connection) -> None:
        ...


class CallbackSignalConnectionSignedOff(Protocol):
    def __call__(self, *, connection: purple.Connection) -> None:
        ...


class CallbackSignalConnectionError(Protocol):
    def __call__(
        self,
        *,
        connection: purple.Connection,
        description: bytes,
        short_description: bytes,
    ) -> None:
        ...


class CallbackRequestRequestInput(Protocol):
    def __call__(
        self,
        *,
        title: bytes,
        primary: bytes,
        secondary: bytes,
        default_value: bytes,
        multiline: bool,
        masked: bool,
        hint: bytes,
        ok_text: bytes,
        ok_cb: Callable,
        cancel_text: bytes,
        cancel_cb: Callable,
        account: purple.Account,
        who: bytes,
        conversation: purple.Conversation,
    ) -> None:
        ...


class CallbackConversationWriteChat(Protocol):
    def __call__(
        self,
        *,
        conversation: purple.Conversation,
        who: bytes,
        message: bytes,
        time: datetime,
        flags: int,
    ) -> None:
        ...


class CallbackConversationWriteIm(Protocol):
    def __call__(
        self,
        *,
        conversation: purple.Conversation,
        who: bytes,
        message: bytes,
        time: datetime,
        flags: int,
    ) -> None:
        ...
