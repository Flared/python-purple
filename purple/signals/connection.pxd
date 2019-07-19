cimport glib

from libpurple cimport connection as c_libconnection

cdef str SIGNAL_CONNECTION_SIGNED_ON
cdef void signal_connection_signed_on_cb(c_libconnection.PurpleConnection *gc, glib.gpointer null)

cdef str SIGNAL_CONNECTION_SIGNED_OFF
cdef void signal_connection_signed_off_cb(c_libconnection.PurpleConnection *gc, glib.gpointer null)

cdef str SIGNAL_CONNECTION_CONNECTION_ERROR
cdef void signal_connection_connection_error_cb(c_libconnection.PurpleConnection *gc,
                                                c_libconnection.PurpleConnectionError err,
                                                glib.const_gchar *c_desc)
