from libpurple cimport conversation as c_libconversation
from libpurple cimport account as c_libaccount
from libpurple cimport blist as c_libblist
from libpurple cimport util as c_libutil

from purple cimport signals as libsignals

cdef glib.gboolean signal_conversation_receiving_im_msg_cb(
        c_libaccount.PurpleAccount* account,
        char** sender,
        char** message,
        c_libconversation.PurpleConversation* conv,
        c_libconversation.PurpleMessageFlags* flags
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
    stripped = c_libutil.purple_markup_strip_html(message[0])

    cdef glib.gboolean ret = False
    for callback in libsignals.signal_cbs.get("receiving-im-msg", tuple()):
        ret = ret or callback(
            account=None,
            sender=sender[0],
            message=stripped,
            conversation=None,
            flags=None,
        )

    return ret

cdef void signal_conversation_received_im_msg_cb(
        c_libaccount.PurpleAccount* account,
        char* sender,
        char* message,
        c_libconversation.PurpleConversation* conv,
        c_libconversation.PurpleMessageFlags* flags
    ):
    """
    Emitted when after IM is received.
    @params account  The account the message was received on.
    @params sender   A pointer to the username of the sender.
    @params message  A pointer to the message that was sent.
    @params conv     The IM conversation.
    @params flags    A pointer to the IM message flags.
    """
    cdef char* stripped = c_libutil.purple_markup_strip_html(message)

    for callback in libsignals.signal_cbs.get("received-im-msg", tuple()):
        callback(
            account=None,
            sender=sender,
            message=stripped,
            conversation=None,
            flags=None,
        )
