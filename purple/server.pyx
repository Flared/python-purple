from libc.stdlib cimport free
cimport glib

from libpurple cimport server as c_libserver

from purple cimport connection as libconnection
from purple cimport util as libutil

cdef class Server:

    @staticmethod
    def join_chat(libconnection.Connection connection, dict data):

        cdef glib.GHashTable* components = glib.g_hash_table_new_full(
            glib.g_str_hash,
            glib.g_str_equal,
            glib.g_free,
            glib.g_free
        )

        for key, value in data.items():
            if not isinstance(key, bytes) or not isinstance(value, bytes):
                raise Exception("Data must be a Dict[bytes, bytes]")

            glib.g_hash_table_insert(
                components,
                glib.g_strdup(key),
                glib.g_strdup(value),
            )

        c_libserver.serv_join_chat(
            connection._c_connection,
            components,
        )


    @staticmethod
    def chat_leave(libconnection.Connection connection, int _id):
        c_libserver.serv_chat_leave(
            connection._c_connection,
            _id,
        )
