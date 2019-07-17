cimport glib

from libpurple cimport connection as c_libconnection
from libpurple cimport account as c_libaccount

from purple cimport signals

cdef void signal_connection_signed_on_cb(c_libconnection.PurpleConnection *gc,
                                         glib.gpointer null):
    """
    Emitted when a connection has signed on.
    @params gc  The connection that has signed on.
    """
    cdef c_libaccount.PurpleAccount *acc = c_libconnection.purple_connection_get_account(gc)
    cdef char *c_username = NULL
    cdef char *c_protocol_id = NULL

    c_username = <char *> c_libaccount.purple_account_get_username(acc)
    if c_username == NULL:
        username = None
    else:
        username = c_username

    c_protocol_id = <char *> c_libaccount.purple_account_get_protocol_id(acc)
    if c_protocol_id == NULL:
        protocol_id = None
    else:
        protocol_id = c_protocol_id

    if "signed-on" in signals.signal_cbs:
        (<object> signals.signal_cbs["signed-on"])(username, protocol_id)

cdef void signal_connection_signed_off_cb(c_libconnection.PurpleConnection *gc,
                                          glib.gpointer null):
    """
    Emitted when a connection has signed off.
    @params gc  The connection that has signed off.
    """
    cdef c_libaccount.PurpleAccount *acc = c_libconnection.purple_connection_get_account(gc)
    cdef char *c_username = NULL
    cdef char *c_protocol_id = NULL

    c_username = <char *> c_libaccount.purple_account_get_username(acc)
    if c_username == NULL:
        username = None
    else:
        username = c_username

    c_protocol_id = <char *> c_libaccount.purple_account_get_protocol_id(acc)
    if c_protocol_id == NULL:
        protocol_id = None
    else:
        protocol_id = c_protocol_id

    if "signed-off" in signals.signal_cbs:
        (<object> signals.signal_cbs["signed-off"])(username, protocol_id)

cdef void signal_connection_connection_error_cb(c_libconnection.PurpleConnection *gc,
                                                c_libconnection.PurpleConnectionError err,
                                                glib.const_gchar *c_desc):
    """
    Emitted when a connection error occurs, before signed-off.
    @params gc   The connection on which the error has occured
    @params err  The error that occured
    @params desc A description of the error, giving more information
    """
    cdef c_libaccount.PurpleAccount *acc = c_libconnection.purple_connection_get_account(gc)
    cdef char *c_username = NULL
    cdef char *c_protocol_id = NULL

    c_username = <char *> c_libaccount.purple_account_get_username(acc)
    if c_username:
        username = <char *> c_username
    else:
        username = None

    c_protocol_id = <char *> c_libaccount.purple_account_get_protocol_id(acc)
    if c_protocol_id:
        protocol_id = <char *> c_protocol_id
    else:
        protocol_id = None

    short_desc = {
        0: "Network error",
        1: "Invalid username",
        2: "Authentication failed",
        3: "Authentication impossible",
        4: "No SSL support",
        5: "Encryption error",
        6: "Name in use",
        7: "Invalid settings",
        8: "SSL certificate not provided",
        9: "SSL certificate untrusted",
        10: "SSL certificate expired",
        11: "SSL certificate not activated",
        12: "SSL certificate hostname mismatch",
        13: "SSL certificate fingerprint mismatch",
        14: "SSL certificate self signed",
        15: "SSL certificate other error",
        16: "Other error" }[<int> err]

    if c_desc:
        desc = str(<char *> c_desc)
    else:
        desc = None

    if "connection-error" in signals.signal_cbs:
        (<object> signals.signal_cbs["connection-error"])(username, protocol_id, \
                short_desc, desc)

