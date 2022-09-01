from datetime import datetime

from typing_extensions import Final
from typing_extensions import Protocol
from typing_extensions import TypedDict
from typing import Optional
from typing import Any
from typing import Callable
from typing import List

import logging
import click
import tempfile

import purple


from .callbacks import CallbackSignalConversationReceivedImMsg
from .callbacks import CallbackSignalConversationReceivedChatMsg
from .callbacks import CallbackSignalConversationChatJoined
from .callbacks import CallbackSignalConversationChatLeft
from .callbacks import CallbackSignalConversationChatJoinFailed
from .callbacks import CallbackSignalConnectionSigningOn
from .callbacks import CallbackSignalConnectionSigningOff
from .callbacks import CallbackSignalConnectionSignedOn
from .callbacks import CallbackSignalConnectionSignedOff
from .callbacks import CallbackSignalConnectionError
from .callbacks import CallbackRequestRequestInput
from .callbacks import CallbackRequestRequestAction
from .callbacks import CallbackConversationWriteChat
from .callbacks import CallbackConversationWriteIm
from .callbacks import CallbackConversationHasFocus


class _Callbacks(TypedDict):
    SignalConversationReceivedImMsg: Optional[
        CallbackSignalConversationReceivedImMsg
    ]
    SignalConversationReceivedChatMsg: Optional[
        CallbackSignalConversationReceivedChatMsg
    ]
    SignalConversationChatJoined: Optional[CallbackSignalConversationChatJoined]
    SignalConversationChatLeft: Optional[CallbackSignalConversationChatLeft]
    SignalConversationChatJoinFailed: Optional[
        CallbackSignalConversationChatJoinFailed
    ]
    SignalConnectionSigningOn: Optional[CallbackSignalConnectionSigningOn]
    SignalConnectionSigningOff: Optional[CallbackSignalConnectionSigningOff]
    SignalConnectionSignedOn: Optional[CallbackSignalConnectionSignedOn]
    SignalConnectionSignedOff: Optional[CallbackSignalConnectionSignedOff]
    SignalConnectionError: Optional[CallbackSignalConnectionError]
    RequestRequestInput: Optional[CallbackRequestRequestInput]
    RequestRequestAction: Optional[CallbackRequestRequestAction]
    ConversationWriteChat: Optional[CallbackConversationWriteChat]
    ConversationWriteIm: Optional[CallbackConversationWriteIm]
    ConversationHasFocus: Optional[CallbackConversationHasFocus]


class PurpleClient:
    """This is a high-level version of purple.Purple.

    It takes care of initializing the core and it provides
    type-annotated interfaces.
    """

    def __init__(
        self, *, purple_debug: bool = False, user_dir: Optional[str] = None
    ) -> None:

        self.logger: Final[logging.Logger] = logging.getLogger(
            __name__ + "." + self.__class__.__name__
        )

        self._purple_debug: Final[bool] = purple_debug
        self._user_dir = (user_dir or tempfile.mkdtemp()).encode()
        self._purple_core: Optional[purple.Purple] = None
        self._purple_account: Optional[purple.Account] = None

        self._callbacks: _Callbacks = {
            "SignalConversationReceivedImMsg": None,
            "SignalConversationReceivedChatMsg": None,
            "SignalConversationChatJoined": None,
            "SignalConversationChatLeft": None,
            "SignalConversationChatJoinFailed": None,
            "SignalConnectionSigningOn": None,
            "SignalConnectionSigningOff": None,
            "SignalConnectionSignedOn": None,
            "SignalConnectionSignedOff": None,
            "SignalConnectionError": None,
            "RequestRequestInput": None,
            "RequestRequestAction": None,
            "ConversationWriteChat": None,
            "ConversationWriteIm": None,
            "ConversationHasFocus": None,
        }

    def set_cb_signal_conversation_received_im_msg(
        self, callback: CallbackSignalConversationReceivedImMsg
    ) -> None:
        self._callbacks["SignalConversationReceivedImMsg"] = callback

    def _cb_signal_conversation_received_im_msg(
        self,
        *,
        account: purple.Account,
        sender: bytes,
        message: bytes,
        conversation: purple.Conversation,
        flags: Any,
    ) -> None:
        if self._callbacks["SignalConversationReceivedImMsg"] is not None:
            try:
                self._callbacks["SignalConversationReceivedImMsg"](
                    account=account,
                    sender=sender,
                    message=message,
                    conversation=conversation,
                    flags=flags,
                )
            except Exception:
                self.logger.exception(
                    "Could not execute conversation_received_im_msg callback"
                )
                raise

    def set_cb_signal_conversation_received_chat_msg(
        self, callback: CallbackSignalConversationReceivedChatMsg
    ) -> None:
        self._callbacks["SignalConversationReceivedChatMsg"] = callback

    def _cb_signal_conversation_received_chat_msg(
        self,
        *,
        account: purple.Account,
        sender: bytes,
        message: bytes,
        conversation: purple.Conversation,
        flags: Any,
    ) -> None:
        if self._callbacks["SignalConversationReceivedChatMsg"] is not None:
            try:
                self._callbacks["SignalConversationReceivedChatMsg"](
                    account=account,
                    sender=sender,
                    message=message,
                    conversation=conversation,
                    flags=flags,
                )
            except Exception:
                self.logger.exception(
                    "Could not execute conversation_received_chat_msg callback"
                )
                raise

    def set_cb_signal_conversation_chat_joined(
        self, callback: CallbackSignalConversationChatJoined
    ) -> None:
        self._callbacks["SignalConversationChatJoined"] = callback

    def _cb_signal_conversation_chat_joined(
        self, *, conversation: purple.Conversation
    ) -> None:
        if self._callbacks["SignalConversationChatJoined"] is not None:
            try:
                self._callbacks["SignalConversationChatJoined"](
                    conversation=conversation
                )
            except Exception:
                self.logger.exception(
                    "Could not execute conversation_chat_joined callback"
                )
                raise

    def set_cb_signal_conversation_chat_left(
        self, callback: CallbackSignalConversationChatLeft
    ) -> None:
        self._callbacks["SignalConversationChatLeft"] = callback

    def _cb_signal_conversation_chat_left(
        self, *, conversation: purple.Conversation
    ) -> None:
        if self._callbacks["SignalConversationChatLeft"] is not None:
            try:
                self._callbacks["SignalConversationChatLeft"](
                    conversation=conversation
                )
            except Exception:
                self.logger.exception(
                    "Could not execute conversation_chat_left callback"
                )
                raise

    def set_cb_signal_conversation_chat_join_failed(
        self, callback: CallbackSignalConversationChatJoinFailed
    ) -> None:
        self._callbacks["SignalConversationChatJoinFailed"] = callback

    def _cb_signal_conversation_chat_join_failed(
        self,
        connection: purple.Connection,
        components: Any,
    ) -> None:
        if self._callbacks["SignalConversationChatJoinFailed"] is not None:
            try:
                self._callbacks["SignalConversationChatJoinFailed"](
                    connection=connection,
                    components=components,
                )
            except Exception:
                self.logger.exception(
                    "Could not execute chat_join_failed callback"
                )
                raise

    def set_cb_signal_connection_signing_off(
        self, callback: CallbackSignalConnectionSigningOff
    ) -> None:
        self._callbacks["SignalConnectionSigningOff"] = callback

    def _cb_signal_connection_signing_off(
        self, *, connection: purple.Connection
    ) -> None:
        if self._callbacks["SignalConnectionSigningOff"] is not None:
            try:
                self._callbacks["SignalConnectionSigningOff"](
                    connection=connection
                )
            except Exception:
                self.logger.exception(
                    "Could not execute connection_signing_off callback"
                )
                raise

    def set_cb_signal_connection_signing_on(
        self, callback: CallbackSignalConnectionSigningOn
    ) -> None:
        self._callbacks["SignalConnectionSigningOn"] = callback

    def _cb_signal_connection_signing_on(
        self, *, connection: purple.Connection
    ) -> None:
        if self._callbacks["SignalConnectionSigningOn"] is not None:
            try:
                self._callbacks["SignalConnectionSigningOn"](
                    connection=connection
                )
            except Exception:
                self.logger.exception(
                    "Could not execute connection_signing_on callback"
                )
                raise

    def set_cb_signal_connection_signed_on(
        self, callback: CallbackSignalConnectionSignedOn
    ) -> None:
        self._callbacks["SignalConnectionSignedOn"] = callback

    def _cb_signal_connection_signed_on(
        self, *, connection: purple.Connection
    ) -> None:
        if self._callbacks["SignalConnectionSignedOn"] is not None:
            try:
                self._callbacks["SignalConnectionSignedOn"](
                    connection=connection
                )
            except Exception:
                self.logger.exception(
                    "Could not execute connection_signed_on callback"
                )
                raise

    def set_cb_connection_signed_off(
        self, callback: CallbackSignalConnectionSignedOff
    ) -> None:
        self._callbacks["SignalConnectionSignedOff"] = callback

    def _cb_signal_connection_signed_off(
        self, *, connection: purple.Connection
    ) -> None:
        if self._callbacks["SignalConnectionSignedOff"] is not None:
            try:
                self._callbacks["SignalConnectionSignedOff"](
                    connection=connection
                )
            except Exception:
                self.logger.exception(
                    "Could not execute connection_signed_off callback"
                )
                raise

    def set_cb_signal_connection_error(
        self, callback: CallbackSignalConnectionError
    ) -> None:
        self._callbacks["SignalConnectionError"] = callback

    def _cb_signal_connection_error(
        self,
        *,
        connection: purple.Connection,
        description: bytes,
        short_description: bytes,
    ) -> None:
        if self._callbacks["SignalConnectionError"] is not None:
            try:
                self._callbacks["SignalConnectionError"](
                    connection=connection,
                    description=description,
                    short_description=short_description,
                )
            except Exception:
                self.logger.exception(
                    "Could not excute connection_error callback"
                )
                raise

    def set_cb_request_request_input(
        self, callback: CallbackRequestRequestInput
    ) -> None:
        self._callbacks["RequestRequestInput"] = callback

    def _cb_request_request_input(
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
        if self._callbacks["RequestRequestInput"] is not None:
            self._callbacks["RequestRequestInput"](
                title=title,
                primary=primary,
                secondary=secondary,
                default_value=default_value,
                multiline=multiline,
                masked=masked,
                hint=hint,
                ok_text=ok_text,
                ok_cb=ok_cb,
                cancel_text=cancel_text,
                cancel_cb=cancel_cb,
                account=account,
                who=who,
                conversation=conversation,
            )

    def set_cb_request_request_action(
        self, callback: CallbackRequestRequestAction
    ) -> None:
        self._callbacks["RequestRequestAction"] = callback

    def _cb_request_request_action(
        self,
        *,
        title: bytes,
        primary: bytes,
        secondary: bytes,
        default_action: int,
        account: purple.Account,
        who: bytes,
        conversation: Optional[purple.Conversation],
        actions: List[bytes],
    ) -> int:
        if self._callbacks["RequestRequestAction"] is not None:
            return self._callbacks["RequestRequestAction"](
                title=title,
                primary=primary,
                secondary=secondary,
                default_action=default_action,
                account=account,
                who=who,
                conversation=conversation,
                actions=actions,
            )
        return default_action

    def set_cb_conversation_write_chat(
        self, callback: CallbackConversationWriteChat
    ) -> None:
        self._callbacks["ConversationWriteChat"] = callback

    def _cb_conversation_write_chat(
        self,
        *,
        conversation: purple.Conversation,
        who: bytes,
        message: bytes,
        time: datetime,
        flags: int,
    ) -> None:
        if self._callbacks["ConversationWriteChat"] is not None:
            self._callbacks["ConversationWriteChat"](
                conversation=conversation,
                who=who,
                message=message,
                time=time,
                flags=flags,
            )

    def set_cb_conversation_write_im(
        self, callback: CallbackConversationWriteChat
    ) -> None:
        self._callbacks["ConversationWriteIm"] = callback

    def _cb_conversation_write_im(
        self,
        *,
        conversation: purple.Conversation,
        who: bytes,
        message: bytes,
        time: datetime,
        flags: int,
    ) -> None:
        if self._callbacks["ConversationWriteIm"] is not None:
            self._callbacks["ConversationWriteIm"](
                conversation=conversation,
                who=who,
                message=message,
                time=time,
                flags=flags,
            )

    def set_cb_conversation_has_focus(
        self, callback: CallbackConversationHasFocus
    ) -> None:
        self._callbacks["ConversationHasFocus"] = callback

    def _cb_conversation_has_focus(
        self,
        *,
        conversation: purple.Conversation,
    ) -> bool:
        if self._callbacks["ConversationHasFocus"] is not None:
            return self._callbacks["ConversationHasFocus"](
                conversation=conversation,
            )
        return False

    def do_loop(self) -> None:
        if not self._purple_core:
            self._purple_core_init()

        if self._purple_core:
            self._purple_core.iterate_main_loop()

    def _purple_core_init(self) -> None:
        self._purple_core = purple.Purple(
            b"python-purple",
            b"0.1",
            b"https://github.com/flared/python-purple",
            b"https://github.com/flared/python-purple",
            debug_enabled=self._purple_debug,
            default_path=self._user_dir,
        )
        self._purple_core.purple_init()

        ######################
        ## Register signals ##
        ######################

        ## Conversation
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_RECEIVED_IM_MSG,
            callback=self._cb_signal_conversation_received_im_msg,
        )
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG,
            callback=self._cb_signal_conversation_received_chat_msg,
        )
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_CHAT_JOINED,
            callback=self._cb_signal_conversation_chat_joined,
        )
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_CHAT_LEFT,
            callback=self._cb_signal_conversation_chat_left,
        )
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_CHAT_JOIN_FAILED,
            callback=self._cb_signal_conversation_chat_join_failed,
        )

        ## Connection
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNING_ON,
            callback=self._cb_signal_connection_signing_on,
        )
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNING_OFF,
            callback=self._cb_signal_connection_signing_off,
        )
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNED_ON,
            callback=self._cb_signal_connection_signed_on,
        )
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNED_OFF,
            callback=self._cb_signal_connection_signed_off,
        )
        self._purple_core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONNECTION_CONNECTION_ERROR,
            callback=self._cb_signal_connection_error,
        )

        ########################
        ## Register callbacks ##
        ########################
        self._purple_core.add_callback(
            callback_name=purple.Callbacks.CALLBACK_REQUEST_REQUEST_INPUT,
            callback=self._cb_request_request_input,
        )
        self._purple_core.add_callback(
            callback_name=purple.Callbacks.CALLBACK_REQUEST_REQUEST_ACTION,
            callback=self._cb_request_request_action,
        )
        self._purple_core.add_callback(
            callback_name=purple.Callbacks.CALLBACK_CONVERSATION_WRITE_CHAT,
            callback=self._cb_conversation_write_chat,
        )

        self._purple_core.add_callback(
            callback_name=purple.Callbacks.CALLBACK_CONVERSATION_WRITE_IM,
            callback=self._cb_conversation_write_im,
        )

        self._purple_core.add_callback(
            callback_name=purple.Callbacks.CALLBACK_CONVERSATION_HAS_FOCUS,
            callback=self._cb_conversation_has_focus,
        )

    def close(self) -> None:
        if self._purple_core:
            self._purple_core.destroy()
