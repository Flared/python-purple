#
#  Copyright (c) 2008 INdT - Instituto Nokia de Tecnologia
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

from libpurple cimport connection as c_libconnection
from libpurple cimport plugin as c_libplugin

from purple cimport account as libaccount
from purple cimport plugin as libplugin

cdef class Connection:
    """
    Protocol class
    """

    def __init__(self):
        raise Exception("Use Connnection.new() instead.")

    @staticmethod
    cdef Connection from_c_connection(c_libconnection.PurpleConnection* c_connection):
        cdef Connection connection = Connection.__new__(Connection)
        connection._c_connection = c_connection
        return connection

    cpdef libaccount.Account get_account(self):
        return libaccount.Account.from_c_account(
            c_libconnection.purple_connection_get_account(self._c_connection)
        )

    cpdef libplugin.Plugin get_prpl(self):
        cdef c_libplugin.PurplePlugin* c_plugin = c_libconnection.purple_connection_get_prpl(
            self._c_connection
        )
        cdef libplugin.Plugin plugin = None

        if c_plugin != NULL:
            plugin = libplugin.Plugin.from_c_plugin(
                c_plugin
            )

        return plugin
