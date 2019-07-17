cimport glib

from libpurple cimport connection as c_libconnection

cdef void signal_connection_signed_on_cb(c_libconnection.PurpleConnection *gc, glib.gpointer null)

cdef void signal_connection_signed_off_cb(c_libconnection.PurpleConnection *gc, glib.gpointer null)

cdef void signal_connection_connection_error_cb(c_libconnection.PurpleConnection *gc,
                                                c_libconnection.PurpleConnectionError err,
                                                glib.const_gchar *c_desc)
