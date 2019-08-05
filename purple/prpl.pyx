#
#  Copyright (c) 2019 Flare Systems Inc.
#
#  This file is part of python-purple.
#
#  python-purple is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  python-purple is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

cimport glib

from libpurple cimport prpl as c_libprpl
from libpurple cimport accountopt as c_libaccountopt
from libpurple cimport prefs as c_libprefs

from purple cimport accountopt as libaccountopt
from purple cimport connection as libconnection
from purple cimport util as libutil

cdef class PluginProtocolInfo:

    @staticmethod
    cdef PluginProtocolInfo from_c_plugin_protocol_info(c_libprpl.PurplePluginProtocolInfo* c_plugin_protocol_info):
        cdef PluginProtocolInfo plugin_protocol_info = PluginProtocolInfo.__new__(PluginProtocolInfo)
        plugin_protocol_info._c_plugin_protocol_info = c_plugin_protocol_info
        return plugin_protocol_info


    cpdef list get_options(self):
        cdef glib.GList* c_iter = self._c_plugin_protocol_info.protocol_options
        cdef c_libaccountopt.PurpleAccountOption* c_account_option

        cdef list options = list()

        while c_iter:
            c_account_option = <c_libaccountopt.PurpleAccountOption*> c_iter.data
            account_option = libaccountopt.AccountOption.from_c_account_option(c_account_option)
            options.append(account_option)
            c_iter = c_iter.next

        return options


    cpdef list get_chat_info(self, libconnection.Connection connection):
        cdef glib.GList* c_iter = self._c_plugin_protocol_info.chat_info(
            connection._c_connection
        )
        cdef c_libprpl.proto_chat_entry* c_proto_chat_entry

        cdef list options = list()

        while c_iter:
            c_proto_chat_entry = <c_libprpl.proto_chat_entry*> c_iter.data
            proto_chat_entry = ProtoChatEntry.from_c_proto_chat_entry(c_proto_chat_entry)
            options.append(proto_chat_entry)
            c_iter = c_iter.next

        return options

    cpdef bytes get_chat_name(self, dict data):
        if self._c_plugin_protocol_info.get_chat_name == NULL:
            return None

        cdef glib.GHashTable* components = glib.g_hash_table_new_full(
            glib.g_str_hash,
            glib.g_str_equal,
            glib.g_free,
            glib.g_free
        )

        cdef char* c_key
        cdef char* c_value

        for key, value in data.items():
            if not isinstance(key, bytes) or not isinstance(value, bytes):
                raise Exception("data must be a Dict[bytes, bytes]")

            c_key = key
            c_value = value

            glib.g_hash_table_insert(
                components,
                c_key,
                c_value,
            )

        cdef char* c_name = self._c_plugin_protocol_info.get_chat_name(components)
        cdef bytes name = c_name or None

        return name


cdef class ProtoChatEntry:

    @staticmethod
    cdef ProtoChatEntry from_c_proto_chat_entry(c_libprpl.proto_chat_entry* c_proto_chat_entry):
        cdef ProtoChatEntry proto_chat_entry = ProtoChatEntry.__new__(ProtoChatEntry)
        proto_chat_entry._c_proto_chat_entry = c_proto_chat_entry
        return proto_chat_entry

    cpdef bytes get_label(self):
        cdef bytes label = self._c_proto_chat_entry.label or None
        return label


    cpdef bytes get_identifier(self):
        cdef bytes identifier = self._c_proto_chat_entry.identifier or None
        return identifier

    cpdef bint get_required(self):
        return self._c_proto_chat_entry.required

    cpdef bint get_is_int(self):
        return self._c_proto_chat_entry.is_int

    cpdef int get_min(self):
        return self._c_proto_chat_entry.min

    cpdef int get_max(self):
        return self._c_proto_chat_entry.max

    cpdef bint get_secret(self):
        return self._c_proto_chat_entry.secret
