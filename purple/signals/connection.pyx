cimport glib

from libpurple cimport connection as c_libconnection
from libpurple cimport account as c_libaccount
from libpurple cimport debug as c_libdebug

from purple cimport signals as libsignals
from purple cimport connection as libconnection

cdef str SIGNAL_CONNECTION_SIGNING_ON = "signing-on"
cdef void signal_connection_signing_on_cb(
    c_libconnection.PurpleConnection* c_connection,
):
    """
    Emitted when a connection is about to sign on.
    @params gc The connection that is about to sign on.
    """
    c_libdebug.purple_debug_info("connection", "%s", "signing on\n")

    cdef libconnection.Connection connection = libconnection.Connection.new(c_connection)

    for callback in libsignals.signal_cbs.get(SIGNAL_CONNECTION_SIGNING_ON, tuple()):
        callback(
            connection=connection,
        )

cdef str SIGNAL_CONNECTION_SIGNED_ON = "signed-on"
cdef void signal_connection_signed_on_cb(
    c_libconnection.PurpleConnection* c_connection,
):
    """
    Emitted when a connection has signed on.
    @params gc  The connection that has signed on.
    """
    c_libdebug.purple_debug_info("connection", "%s", "signed on\n")

    cdef libconnection.Connection connection = libconnection.Connection.new(c_connection)

    for callback in libsignals.signal_cbs.get(SIGNAL_CONNECTION_SIGNED_ON, tuple()):
        callback(
            connection=connection,
        )

cdef str SIGNAL_CONNECTION_SIGNING_OFF = "signing-off"
cdef void signal_connection_signing_off_cb(
    c_libconnection.PurpleConnection* c_connection,
):
    """
    Emitted when a connection is about to sign off.
    @params gc The connection that is about to sign off.
    """
    c_libdebug.purple_debug_info("connection", "%s", "signing off\n")

    cdef libconnection.Connection connection = libconnection.Connection.new(c_connection)

    for callback in libsignals.signal_cbs.get(SIGNAL_CONNECTION_SIGNING_OFF, tuple()):
        callback(
            connection=connection,
        )

SIGNAL_CONNECTION_SIGNED_OFF = "signed-off"
cdef void signal_connection_signed_off_cb(
    c_libconnection.PurpleConnection *c_connection,
):
    """
    Emitted when a connection has signed off.
    @params gc  The connection that has signed off.
    """
    c_libdebug.purple_debug_info("connection", "%s", "signed off\n")

    cdef libconnection.Connection connection = libconnection.Connection.new(c_connection)

    for callback in libsignals.signal_cbs.get(SIGNAL_CONNECTION_SIGNED_OFF, tuple()):
        callback(
            connection=connection,
        )

cdef str SIGNAL_CONNECTION_CONNECTION_ERROR = "connection-error"
cdef void signal_connection_connection_error_cb(
    c_libconnection.PurpleConnection *c_connection,
    c_libconnection.PurpleConnectionError c_connection_error,
    glib.const_gchar *c_description
):
    """
    Emitted when a connection error occurs, before signed-off.
    @params gc   The connection on which the error has occured
    @params err  The error that occured
    @params desc A description of the error, giving more information
    """
    c_libdebug.purple_debug_info("connection", "%s", "error\n")

    cdef libconnection.Connection connection = libconnection.Connection.new(c_connection)

    cdef bytes description = c_description

    cdef bytes short_description = {
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
        16: "Other error" }[<int> c_connection_error]


    for callback in libsignals.signal_cbs.get(SIGNAL_CONNECTION_CONNECTION_ERROR, tuple()):
        callback(
            connection=connection,
            description=description,
            short_description=short_description,
        )
