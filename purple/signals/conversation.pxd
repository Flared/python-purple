cimport glib

from libpurple cimport conversation as c_libconversation
from libpurple cimport account as c_libaccount

cdef str SIGNAL_CONVERSATION_RECEIVING_IM_MSG
cdef glib.gboolean signal_conversation_receiving_im_msg_cb(
    c_libaccount.PurpleAccount* account,
    char** sender,
    char** message,
    c_libconversation.PurpleConversation* conv,
    c_libconversation.PurpleMessageFlags* flags
)

cdef str SIGNAL_CONVERSATION_RECEIVED_IM_MSG
cdef void signal_conversation_received_im_msg_cb(
    c_libaccount.PurpleAccount* account,
    char* sender,
    char* message,
    c_libconversation.PurpleConversation* conv,
    c_libconversation.PurpleMessageFlags* flags
)
