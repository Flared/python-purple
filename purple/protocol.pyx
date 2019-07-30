#
#  Copyright (c) 2008 INdT - Instituto Nokia de Tecnologia
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

from libpurple cimport accountopt as c_libaccountopt
from libpurple cimport plugin as c_libplugin
from libpurple cimport prefs as c_libprefs
from libpurple cimport prpl as c_libprpl

cdef extern from *:
    ctypedef char const_char "const char"

cdef class Protocol:
    """
    Protocol class
    """

    def __init__(self):
        raise Exception("Use Protocol.find_with_id() instead.")

    @staticmethod
    cdef Protocol from_c_plugin(c_libplugin.PurplePlugin* c_plugin):
        cdef Protocol protocol = Protocol.__new__(Protocol)
        protocol._c_plugin = c_plugin
        return protocol

    @staticmethod
    def find_with_id(char* id):
        cdef object protocol = None
        cdef c_libplugin.PurplePlugin* c_plugin = c_libplugin.purple_plugins_find_with_id(id)
        if c_plugin != NULL:
            protocol = Protocol.from_c_plugin(c_libplugin.purple_plugins_find_with_id(id))
        return protocol

    def get_name(self):
        return self._c_plugin.info.name

    def get_id(self):
        return self._c_plugin.info.id

    def __repr__(self):
        return "<{class_name}: {protocol_id}>".format(
            class_name=self.__class__.__name__,
            protocol_id=self.get_id(),
        )

    def get_options_labels(self):
        cdef c_libprpl.PurplePluginProtocolInfo *prpl_info
        cdef glib.GList *iter
        cdef c_libaccountopt.PurpleAccountOption *option
        cdef c_libprefs.PurplePrefType type
        cdef const_char *label_name
        cdef const_char *setting

        if not self.__exists:
            return None

        prpl_info = c_libplugin.PURPLE_PLUGIN_PROTOCOL_INFO(self._c_plugin)

        po = {}

        iter = prpl_info.protocol_options

        while iter:

            option = <c_libaccountopt.PurpleAccountOption *> iter.data
            type = c_libaccountopt.purple_account_option_get_type(option)
            label_name = c_libaccountopt.purple_account_option_get_text(option)
            setting = c_libaccountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)
            label = str(<char *> label_name)

            iter = iter.next

            po[sett] = label

        return po

    def get_options_values(self):
        cdef c_libprpl.PurplePluginProtocolInfo *prpl_info
        cdef glib.GList *iter
        cdef c_libaccountopt.PurpleAccountOption *option
        cdef c_libprefs.PurplePrefType type
        cdef const_char *str_value
        cdef const_char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        if not self.__exists:
            return None

        prpl_info = c_libplugin.PURPLE_PLUGIN_PROTOCOL_INFO(self._c_plugin)

        po = {}

        iter = prpl_info.protocol_options

        while iter:

            option = <c_libaccountopt.PurpleAccountOption *> iter.data
            type = c_libaccountopt.purple_account_option_get_type(option)
            setting = c_libaccountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            if type == c_libprefs.PURPLE_PREF_STRING:
                str_value = c_libaccountopt.purple_account_option_get_default_string(option)
                # Hack to set string "" as default value when the
                # protocol's option is NULL
                if str_value == NULL:
                    str_value = ""
                val = str(<char *> str_value)

            elif type == c_libprefs.PURPLE_PREF_INT:
                int_value = c_libaccountopt.purple_account_option_get_default_int(option)
                val = int(int_value)

            elif type == c_libprefs.PURPLE_PREF_BOOLEAN:
                bool_value = c_libaccountopt.purple_account_option_get_default_bool(option)

                val = bool(bool_value)

            elif type == c_libprefs.PURPLE_PREF_STRING_LIST:
                str_value = c_libaccountopt.purple_account_option_get_default_list_value(option)

                val = str(<char *> str_value)

            iter = iter.next

            po[sett] = val

        return po
