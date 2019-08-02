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

from libpurple cimport plugin as c_libplugin
from libpurple cimport accountopt as c_libaccountopt
from libpurple cimport prefs as c_libprefs
from libpurple cimport prpl as c_libprpl
from libpurple cimport account as c_libaccount

cdef class Plugin:
    cdef c_libplugin.PurplePlugin* _c_plugin
    cdef c_libprpl.PurplePluginProtocolInfo* _c_protocol_info
    cdef c_libplugin.PurplePluginInfo* _c_plugin_info

    @staticmethod
    cdef Plugin from_c_plugin(c_libplugin.PurplePlugin* c_plugin)
