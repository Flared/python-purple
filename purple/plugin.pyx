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

from purple cimport prpl as libprpl

cdef extern from *:
    ctypedef char const_char "const char"

cdef class Plugin:

    def __init__(self):
        raise Exception("Use Plugin.find_with_id() instead.")

    @staticmethod
    cdef Plugin from_c_plugin(c_libplugin.PurplePlugin* c_plugin):
        cdef Plugin _plugin = Plugin.__new__(Plugin)
        _plugin._c_plugin = c_plugin
        return _plugin

    @staticmethod
    def find_with_id(char* id):
        cdef object _plugin = None
        cdef c_libplugin.PurplePlugin* c_plugin = c_libplugin.purple_plugins_find_with_id(id)
        if c_plugin != NULL:
            _plugin = Plugin.from_c_plugin(c_plugin)
        return _plugin

    def get_name(self):
        return self._c_plugin.info.name

    def get_id(self):
        return self._c_plugin.info.id

    def __repr__(self):
        return "<{class_name}: {protocol_id}>".format(
            class_name=self.__class__.__name__,
            protocol_id=self.get_id(),
        )

    cpdef libprpl.PluginProtocolInfo get_protocol_info(self):
        cdef c_libprpl.PurplePluginProtocolInfo* c_plugin_protocol_info = c_libprpl.PURPLE_PLUGIN_PROTOCOL_INFO(
            self._c_plugin
        )
        cdef libprpl.PluginProtocolInfo plugin_protocol_info = None

        if c_plugin_protocol_info != NULL:
            plugin_protocol_info = libprpl.PluginProtocolInfo.from_c_plugin_protocol_info(
                c_plugin_protocol_info
            )

        return plugin_protocol_info

    @staticmethod
    def plugins_enabled():
        return bool(c_libplugin.purple_plugins_enabled())

    @staticmethod
    def get_search_paths():
        search_paths = []
        cdef glib.GList* iter
        iter = c_libplugin.purple_plugins_get_search_paths()
        while iter:
            search_paths.append(<char*> iter.data)
            iter = iter.next
        return search_paths

    @staticmethod
    def add_search_path(path):
        c_libplugin.purple_plugins_add_search_path(path)

    @staticmethod
    def probe(ext):
        c_libplugin.purple_plugins_probe(ext)

    @staticmethod
    def get_plugins():
        cdef glib.GList* iter
        cdef c_libplugin.PurplePlugin *pp
        plugins = []
        iter = c_libplugin.purple_plugins_get_all()
        while iter:
            pp = <c_libplugin.PurplePlugin*> iter.data
            if pp.info and pp.info.name:
                p = Plugin.from_c_plugin(pp)
                if p:
                    plugins += [p]
            else:
                raise Exception("Plugin without info or name")
            iter = iter.next
        glib.g_list_free(iter)
        return plugins

    @staticmethod
    def get_protocols():
        cdef glib.GList *iter
        cdef c_libplugin.PurplePlugin *pp
        protocols = []
        iter = c_libplugin.purple_plugins_get_protocols()
        while iter:
            pp = <c_libplugin.PurplePlugin*> iter.data
            if pp.info and pp.info.name:
                p = Plugin.from_c_plugin(pp)
                if p:
                    protocols += [p]
            iter = iter.next
        glib.g_list_free(iter)
        return protocols
