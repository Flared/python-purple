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
