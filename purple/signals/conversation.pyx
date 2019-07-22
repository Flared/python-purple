from libpurple cimport conversation as c_libconversation
from libpurple cimport account as c_libaccount
from libpurple cimport blist as c_libblist
from libpurple cimport util as c_libutil

from purple cimport signals as libsignals

cdef str SIGNAL_CONVERSATION_RECEIVING_IM_MSG = "receiving-im-msg"
cdef glib.gboolean signal_conversation_receiving_im_msg_cb(
    c_libaccount.PurpleAccount* c_account,
    char** c_sender,
    char** c_message,
    c_libconversation.PurpleConversation* c_conv,
    c_libconversation.PurpleMessageFlags* c_flags
):
    """
    Emitted when an IM is received. The callback can replace the name of the
    sender, the message, or the flags by modifying the pointer to the strings
    and integer. This can also be used to cancel a message by returning TRUE.
    @note Make sure to free *sender and *message before you replace them!
    @returns TRUE if the message should be canceled, or FALSE otherwise.
    @params account  The account the message was received on.
    @params sender   A pointer to the username of the sender.
    @params message  A pointer to the message that was sent.
    @params conv     The IM conversation.
    @params flags    A pointer to the IM message flags.
    """
    cdef bytes sender = c_sender[0]
    cdef bytes message = c_message[0]

    cdef glib.gboolean ret = False
    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_RECEIVING_IM_MSG, tuple()):
        ret = ret or callback(
            account=None,
            sender=sender[0],
            message=message[0],
            conversation=None,
            flags=None,
        )

    return ret

cdef str SIGNAL_CONVERSATION_RECEIVED_IM_MSG = "received-im-msg"
cdef void signal_conversation_received_im_msg_cb(
    c_libaccount.PurpleAccount* c_account,
    char* c_sender,
    char* c_message,
    c_libconversation.PurpleConversation* c_conv,
    c_libconversation.PurpleMessageFlags* c_flags
):
    """
    Emitted when after IM is received.
    @params account  The account the message was received on.
    @params sender   A pointer to the username of the sender.
    @params message  A pointer to the message that was sent.
    @params conv     The IM conversation.
    @params flags    A pointer to the IM message flags.
    """
    cdef bytes sender = c_sender
    cdef bytes message = c_message

    for callback in libsignals.signal_cbs.get(SIGNAL_CONVERSATION_RECEIVED_IM_MSG, tuple()):
        callback(
            account=None,
            sender=sender,
            message=message,
            conversation=None,
            flags=None,
        )
