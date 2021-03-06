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

from libpurple cimport plugin as c_libplugin
from libpurple cimport prpl as c_libprpl

from purple cimport connection as libconnection


cdef class PluginProtocolInfo:
    cdef c_libprpl.PurplePluginProtocolInfo* _c_plugin_protocol_info

    @staticmethod
    cdef PluginProtocolInfo from_c_plugin_protocol_info(c_libprpl.PurplePluginProtocolInfo* c_protocol_info)

    cpdef list get_options(self)

    cpdef list get_chat_info(self, libconnection.Connection connection)

    cpdef bytes get_chat_name(self, dict data)


cdef class ProtoChatEntry:
    cdef c_libprpl.proto_chat_entry* _c_proto_chat_entry

    @staticmethod
    cdef ProtoChatEntry from_c_proto_chat_entry(c_libprpl.proto_chat_entry* c_proto_chat_entry)

    cpdef bytes get_label(self)

    cpdef bytes get_identifier(self)

    cpdef bint get_required(self)

    cpdef bint get_is_int(self)

    cpdef int get_min(self)

    cpdef int get_max(self)

    cpdef bint get_secret(self)
