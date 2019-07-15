cimport glib

from libpurple cimport conversation as c_conversation
from libpurple cimport account as c_account

cdef glib.gboolean signal_conversation_receiving_im_msg_cb(c_account.PurpleAccount *account,
                                                           char **sender,
                                                           char **message,
                                                           c_conversation.PurpleConversation *conv,
                                                           c_conversation.PurpleMessageFlags *flags)
