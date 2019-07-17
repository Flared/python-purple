from libpurple cimport conversation as c_libconversation
from libpurple cimport account as c_libaccount
from libpurple cimport blist as c_libblist
from libpurple cimport util as c_libutil

from purple cimport signals

cdef glib.gboolean signal_conversation_receiving_im_msg_cb(c_libaccount.PurpleAccount *account,
                                                           char **sender,
                                                           char **message,
                                                           c_libconversation.PurpleConversation *conv,
                                                           c_libconversation.PurpleMessageFlags *flags):
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
    cdef c_libblist.PurpleBuddy *buddy = c_libblist.purple_find_buddy(account, sender[0])
    cdef char *c_alias = NULL

    c_alias = <char *> c_libblist.purple_buddy_get_alias_only(buddy)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    stripped = c_libutil.purple_markup_strip_html(message[0])

    if "receiving-im-msg" in signals.signal_cbs:
        return (<object> signals.signal_cbs["receiving-im-msg"])(sender[0], alias, stripped)
