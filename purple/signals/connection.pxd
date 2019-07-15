cimport glib

from libpurple cimport connection as c_connection

cdef void signal_connection_signed_on_cb(c_connection.PurpleConnection *gc, glib.gpointer null)

cdef void signal_connection_signed_off_cb(c_connection.PurpleConnection *gc, glib.gpointer null)

cdef void signal_connection_connection_error_cb(c_connection.PurpleConnection *gc,
                                                c_connection.PurpleConnectionError err,
                                                glib.const_gchar *c_desc)
