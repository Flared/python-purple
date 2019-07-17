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

from libpurple cimport account as c_libaccount
from libpurple cimport accountopt as c_libaccountopt
from libpurple cimport blist as c_libblist
from libpurple cimport plugin as c_libplugin
from libpurple cimport prefs as c_libprefs
from libpurple cimport prpl as c_libprpl
from libpurple cimport savedstatuses as c_libsavedstatuses
from libpurple cimport server as c_libserver
from libpurple cimport status as c_libstatus

from purple cimport buddy as libbuddy
from purple cimport protocol as libprotocol

cdef class Account:
    """
    Account class
    @param username
    @param protocol Protocol class instance
    @param core Purple class instance
    """

    def __init__(self):
        raise Exception("Use Account.find() or Account.new() instead.")

    @staticmethod
    def new(object core, libprotocol.Protocol protocol, char* username):
        c_libaccount.purple_accounts_add(
            c_libaccount.purple_account_new(
                username,
                protocol.get_id()
            )
        )

        cdef Account account = Account.find(
            core,
            protocol,
            username
        )

        if not account:
            raise Exception("Could not create account!")

        return account

    @staticmethod
    cdef Account _new(object core,
                      c_libaccount.PurpleAccount* _c_account):
        cdef Account account = Account.__new__(Account)
        account._c_account = _c_account
        account.__core = core
        return account

    @staticmethod
    def find(object core, libprotocol.Protocol protocol, char* username):
        cdef object account = None
        cdef c_libaccount.PurpleAccount* _c_account = c_libaccount.purple_accounts_find(
            username,
            protocol.get_id()
        )
        if _c_account != NULL:
            account = Account._new(core, _c_account)
        return account

    cdef c_libaccount.PurpleAccount* _get_structure(self):
        return self._c_account

    def is_connected(self):
        cdef bint _is_connected = False
        _is_connected = c_libaccount.purple_account_is_connected(
            self._get_structure()
        )
        return _is_connected

    def __is_connecting(self):
        if self.__exists:
            return c_libaccount.purple_account_is_connecting(self._get_structure())
        else:
            return None
    is_connecting = property(__is_connecting)

    def __is_disconnected(self):
        if self.__exists:
            return c_libaccount.purple_account_is_disconnected( \
                    self._get_structure())
        else:
            return None
    is_disconnected = property(__is_disconnected)

    def __get_core(self):
        return self.__core
    core = property(__get_core)

    def __get_exists(self):
        return self.__exists
    exists = property(__get_exists)

    def get_username(self):
        cdef char *username = NULL
        username = <char *> c_libaccount.purple_account_get_username(
            self._c_account,
        )
        return username

    def __get_protocol(self):
        return self.__protocol
    protocol = property(__get_protocol)

    def _get_protocol_options(self):
        """
        @return Dictionary {'setting': value, ...}
        """
        cdef glib.GList *iter
        cdef c_libaccount.PurpleAccount *account
        cdef c_libplugin.PurplePlugin *c_plugin
        cdef c_libprpl.PurplePluginProtocolInfo *prpl_info
        cdef c_libaccountopt.PurpleAccountOption *option
        cdef c_libprefs.PurplePrefType type
        cdef char *label_name
        cdef char *str_value
        cdef char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        account = self._get_structure()

        if account == NULL:
            return None

        po = {}

        c_plugin = c_libplugin.purple_plugins_find_with_id(self.__protocol.id)
        prpl_info = c_libplugin.PURPLE_PLUGIN_PROTOCOL_INFO(c_plugin)
        iter = prpl_info.protocol_options

        while iter:

            option = <c_libaccountopt.PurpleAccountOption *> iter.data
            type = c_libaccountopt.purple_account_option_get_type(option)
            label_name = <char *> c_libaccountopt.purple_account_option_get_text(option)
            setting = <char *> c_libaccountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            if type == c_libprefs.PURPLE_PREF_STRING:

                str_value = <char *> c_libaccountopt.purple_account_option_get_default_string(option)

                # Hack to set string "" as default value to Account options when
                # the default value of the protocol is NULL
                if str_value == NULL:
                    str_value = ""
                str_value = <char *> c_libaccount.purple_account_get_string(account, setting, str_value)

                val = str(<char *> str_value)

            elif type == c_libprefs.PURPLE_PREF_INT:

                int_value = c_libaccountopt.purple_account_option_get_default_int(option)
                int_value = c_libaccount.purple_account_get_int(account, setting, int_value)

                val = int(int_value)

            elif type == c_libprefs.PURPLE_PREF_BOOLEAN:

                bool_value = c_libaccountopt.purple_account_option_get_default_bool(option)
                bool_value = c_libaccount.purple_account_get_bool(account, setting, bool_value)

                val = bool(bool_value)

            elif type == c_libprefs.PURPLE_PREF_STRING_LIST:

                str_value = <char *> c_libaccountopt.purple_account_option_get_default_list_value(option)
                str_value = <char *> c_libaccount.purple_account_get_string(account, setting, str_value)

                val = str(<char *> str_value)

            iter = iter.next

            po[sett] = val

        return po
    protocol_options = property(_get_protocol_options)

    def __get_password(self):
        cdef char *password = NULL
        if self.__exists:
            password = <char *> c_libaccount.purple_account_get_password( \
                    self._get_structure())
            if password:
                return password
            else:
                return None
        else:
            return None
    password = property(__get_password)

    def __get_alias(self):
        cdef char *alias = NULL
        if self.__exists:
            alias = <char *> c_libaccount.purple_account_get_alias(self._get_structure())
            if alias:
                return alias
            else:
                return None
        else:
            return None
    alias = property(__get_alias)

    def __get_user_info(self):
        cdef char *user_info = NULL
        if self.__exists:
            user_info = <char *> c_libaccount.purple_account_get_user_info(self._get_structure())
            if user_info:
                return user_info
            else:
                return None
        else:
            return None
    user_info = property(__get_user_info)

    def __get_remember_password(self):
        if self.__exists:
            return c_libaccount.purple_account_get_remember_password( \
                    self._get_structure())
        else:
            return None
    remember_password = property(__get_remember_password)

    def is_enabled(self):
        cdef bint is_enabled = False
        is_enabled = c_libaccount.purple_account_get_enabled(
            self._get_structure(),
            self.__core.ui_name
        )
        return is_enabled

    def __get_status_types(self):
        cdef glib.GList *iter = NULL
        cdef c_libstatus.PurpleStatusType *c_statustype = NULL
        cdef char *id = NULL
        cdef char *name = NULL

        status_types = []
        if self.__exists:
            iter = c_libaccount.purple_account_get_status_types(self._get_structure())
            while iter:
                c_statustype = <c_libstatus.PurpleStatusType *> iter.data
                id = <char *> c_libstatus.purple_status_type_get_id(c_statustype)
                name = <char *> c_libstatus.purple_status_type_get_name(c_statustype)
                status_types.append((id, name))
                iter = iter.next

        return status_types

    status_types = property(__get_status_types)

    def __get_active_status(self):
        cdef c_libstatus.PurpleStatus* c_status = NULL
        cdef char *type = NULL
        cdef char *name = NULL
        cdef char *msg = NULL
        if self.__exists:
            active = {}
            c_status = <c_libstatus.PurpleStatus*> c_libaccount.purple_account_get_active_status(self._get_structure())
            type = <char *> c_libstatus.purple_status_get_id(c_status)
            name = <char *> c_libstatus.purple_status_get_name(c_status)
            msg = <char *> c_libstatus.purple_status_get_attr_string(c_status,
                "message")

            active['type'] = type
            active['name'] = name
            if msg:
                active['message'] = msg

            return active
        else:
            return None
    active_status = property(__get_active_status)

    def set_username(self, username):
        """
        Sets the account's username.

        @param username The username
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            c_libaccount.purple_account_set_username(self._get_structure(), \
                    username)
            return True
        else:
            return False

    def set_protocol(self, protocol):
        """
        Sets the account's protocol.

        @param protocol A Protocol class instance
        @return True if successful, False if account doesn't exists
        """
        if protocol.exists and self.__exists:
            c_libaccount.purple_account_set_protocol_id(self._get_structure(), \
                        protocol.id)
            self.__protocol = protocol
            return True
        else:
            return False

    def set_protocol_options(self, po):
        """
        @param po Dictionary {'setting': value, ...} options to be updated
        @return True to success or False to failure
        """
        cdef glib.GList *iter
        cdef c_libaccount.PurpleAccount *account
        cdef c_libplugin.PurplePlugin *c_plugin
        cdef c_libprpl.PurplePluginProtocolInfo *prpl_info
        cdef c_libaccountopt.PurpleAccountOption *option
        cdef c_libprefs.PurplePrefType type
        cdef char *str_value
        cdef char *setting
        cdef int int_value
        cdef glib.gboolean bool_value

        account = self._get_structure()

        if account == NULL:
            return False

        c_plugin = c_libplugin.purple_plugins_find_with_id(self.__protocol.get_id())
        if c_plugin == NULL:
            raise Exception(
                "Could not find plugin matching protocol id {id}".format(
                    id=self.__protocol.id,
                )
            )
        prpl_info = c_libplugin.PURPLE_PLUGIN_PROTOCOL_INFO(c_plugin)
        iter = prpl_info.protocol_options

        while iter:

            option = <c_libaccountopt.PurpleAccountOption *> iter.data
            type = c_libaccountopt.purple_account_option_get_type(option)
            setting = <char *> c_libaccountopt.purple_account_option_get_setting(option)

            sett = str(<char *> setting)

            if sett not in po:
                iter = iter.next
                continue

            if type == c_libprefs.PURPLE_PREF_STRING:

                str_value = <char *> po[sett]
                c_libaccount.purple_account_set_string(account, setting, str_value)

            elif type == c_libprefs.PURPLE_PREF_INT:

                int_value = int(po[sett])
                c_libaccount.purple_account_set_int(account, setting, int_value)

            elif type == c_libprefs.PURPLE_PREF_BOOLEAN:

                bool_value = bool(po[sett])
                c_libaccount.purple_account_set_bool(account, setting, bool_value)

            elif type == c_libprefs.PURPLE_PREF_STRING_LIST:

                str_value = <char *> po[sett]
                c_libaccount.purple_account_set_string(account, setting, str_value)

            iter = iter.next

        return True

    def set_password(self, password):
        """
        Sets the account's password.

        @param password The password
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            c_libaccount.purple_account_set_password(self._get_structure(), \
                    password)
            return True
        else:
            return False

    def set_alias(self, alias):
        """
        Sets the account's alias

        @param alias The alias
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            c_libaccount.purple_account_set_alias(self._get_structure(), \
                    alias)
            return True
        else:
            return False

    def set_user_info(self, user_info):
        """
        Sets the account's user information

        @param user_info The user information
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            c_libaccount.purple_account_set_user_info(self._get_structure(), \
                    user_info)
            return True
        else:
            return False

    def set_remember_password(self, remember_password):
        """
        Sets whether or not this account should save its password.

        @param remember_password True if should remember the password,
                                 or False otherwise
        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            c_libaccount.purple_account_set_remember_password( \
                self._get_structure(), remember_password)
            return True
        else:
            return False

    def set_enabled(self, bint value):
        """
        Sets wheter or not this account is enabled.

        @param value True if it is enabled, or False otherwise
        @return True if successful, False if account doesn't exists
        """
        c_libaccount.purple_account_set_enabled(
            self._get_structure(),
            self.__core.ui_name,
            value
        )

    def remove(self):
        """
        Removes an existing account.

        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            c_libaccount.purple_accounts_delete(self._get_structure())
            self__exists = False
            return True
        else:
            return False

    def connect(self):
        """
        Connects to an account.

        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            c_libaccount.purple_account_connect(self._get_structure())
            return True
        else:
            return False

    def disconnect(self):
        """
        Disconnects from an account.

        @return True if successful, False if account doesn't exists
        """
        if self.__exists:
            c_libaccount.purple_account_disconnect(self._get_structure())
            return True
        else:
            return False

    def add_buddy(self, name, alias=None, group=None):
        """
        Adds a buddy to account's buddy list.

        @param name  Buddy name
        @param alias Buddy alias (optional)
        @return True if successfull, False otherwise
        """
        cdef c_libblist.PurpleBuddy *c_buddy = NULL
        cdef c_libblist.PurpleGroup *c_group = NULL
        cdef char *c_alias = NULL

        if alias:
            c_alias = alias
        else:
            c_alias = NULL

        if self.__exists and \
                c_libaccount.purple_account_is_connected(self._get_structure()):
            if c_libblist.purple_find_buddy(self._get_structure(), name):
                return False

            if group:
                c_group = c_libblist.purple_find_group(group)
                if c_group == NULL:
                    c_group = c_libblist.purple_group_new(group)

            c_buddy = c_libblist.purple_buddy_new(self._get_structure(), \
                    name, c_alias)
            if c_buddy == NULL:
                return False

            c_libblist.purple_blist_add_buddy(c_buddy, NULL, c_group, NULL)
            c_libaccount.purple_account_add_buddy(self._get_structure(), c_buddy)
            if c_alias:
                c_libblist.purple_blist_alias_buddy(c_buddy, c_alias)
                c_libserver.serv_alias_buddy(c_buddy)

            return True

        else:
            return None

    def remove_buddy(self, name):
        """
        Removes a buddy from account's buddy list.

        @param name Buddy name
        @return True if successful, False otherwise
        """
        cdef c_libblist.PurpleBuddy *c_buddy = NULL
        cdef c_libblist.PurpleGroup *c_group = NULL

        if self.__exists and \
                c_libaccount.purple_account_is_connected(self._get_structure()):
            c_buddy = c_libblist.purple_find_buddy(self._get_structure(), name)
            if c_buddy == NULL:
                return False

            c_group = c_libblist.purple_buddy_get_group(c_buddy)

            c_libaccount.purple_account_remove_buddy(self._get_structure(), \
                    c_buddy, c_group)
            c_libblist.purple_blist_remove_buddy(c_buddy)
            return True
        else:
            return None

    def get_buddies_online(self):
        cdef glib.GSList *iter = NULL
        cdef c_libblist.PurpleBuddy *c_buddy = NULL
        cdef char *c_alias = NULL

        buddies_list = []
        if self.__exists and \
                c_libaccount.purple_account_is_connected(self._get_structure()):
            iter = c_libblist.purple_find_buddies(self._get_structure(), NULL)

            while iter:
                c_alias = NULL
                c_buddy = <c_libblist.PurpleBuddy *> iter.data
                if <bint> (<c_libblist.PurpleBuddy *> c_buddy) and \
                        <bint> c_libstatus.purple_presence_is_online( \
                                c_libblist.purple_buddy_get_presence(c_buddy)):
                    name = <char *> c_libblist.purple_buddy_get_name(c_buddy)

                    new_buddy = libbuddy.Buddy(name, self)

                    c_alias = <char *> c_libblist.purple_buddy_get_alias_only(c_buddy)
                    if c_alias:
                        new_buddy.set_alias(c_alias)

                    buddies_list.append(new_buddy)
                iter = iter.next

        return buddies_list

    def get_buddies(self):
        """
        @return Account's buddies list
        """
        cdef glib.GSList *iter = NULL
        cdef c_libblist.PurpleBuddy *c_buddy = NULL
        cdef char *c_alias = NULL

        buddies_list = []
        if self.__exists:
            iter = c_libblist.purple_find_buddies(self._get_structure(), NULL)

            while iter:
                c_alias = NULL
                c_buddy = <c_libblist.PurpleBuddy *> iter.data

                name = <char *> c_libblist.purple_buddy_get_name(c_buddy)
                new_buddy = libbuddy.Buddy(name, self)

                c_alias = <char *> c_libblist.purple_buddy_get_alias_only(c_buddy)
                if c_alias:
                    new_buddy.set_alias(c_alias)

                buddies_list.append(new_buddy)
                iter = iter.next

        return buddies_list

    def request_add_buddy(self, buddy_username, buddy_alias):
        if buddy_alias:
            c_libblist.purple_blist_request_add_buddy(self._get_structure(), \
                    buddy_username, NULL, buddy_alias)
        else:
            c_libblist.purple_blist_request_add_buddy(self._get_structure(), \
                    buddy_username, NULL, NULL)

    def set_active_status(self, type, msg=None):
        cdef c_libstatus.PurpleStatusType *c_statustype = NULL
        cdef c_libsavedstatuses.PurpleSavedStatus *c_savedstatus = NULL

        if self.__exists:
            if msg:
                c_libaccount.purple_account_set_status(self._get_structure(),
                        <char *> type, True, <char *> "message", <char *> msg, NULL)
            else:
                c_libaccount.purple_account_set_status(self._get_structure(),
                        <char *> type, True, NULL)

            # FIXME: We can create only a savedstatus for each statustype
            c_savedstatus = c_libsavedstatuses.purple_savedstatus_find(type)
            if c_savedstatus == NULL:
                c_statustype = c_libaccount.purple_account_get_status_type( \
                        self._get_structure(), type)
                c_savedstatus = c_libsavedstatuses.purple_savedstatus_new( \
                        NULL, c_libstatus.purple_status_type_get_primitive( \
                                c_statustype))
                c_libsavedstatuses.purple_savedstatus_set_title(c_savedstatus,
                        type)

            c_libsavedstatuses.purple_savedstatus_set_message(c_savedstatus, msg)
            c_libprefs.purple_prefs_set_int("/purple/savedstatus/idleaway",
                    c_libsavedstatuses.purple_savedstatus_get_creation_time(c_savedstatus))

            return True
        else:
            return False

    def set_status_message(self, type, msg):
        cdef c_libstatus.PurpleStatus* c_status = NULL
        cdef c_libstatus.PurpleStatusType *c_statustype = NULL
        cdef c_libsavedstatuses.PurpleSavedStatus *c_savedstatus = NULL

        if self.__exists and msg:
            c_status = c_libaccount.purple_account_get_status(self._get_structure(),
                    type)
            if c_status == NULL:
                return False
            c_libstatus.purple_status_set_attr_string(c_status, "message", msg)

            # FIXME: We can create only a savedstatus for each statustype
            c_savedstatus = c_libsavedstatuses.purple_savedstatus_find(type)
            if c_savedstatus == NULL:
                c_statustype = c_libaccount.purple_account_get_status_type( \
                        self._get_structure(), type)
                c_savedstatus = c_libsavedstatuses.purple_savedstatus_new( \
                        NULL, c_libstatus.purple_status_type_get_primitive( \
                                c_statustype))
                c_libsavedstatuses.purple_savedstatus_set_title(c_savedstatus,
                        type)

            c_libsavedstatuses.purple_savedstatus_set_message(c_savedstatus, msg)
            return True
        else:
            return False
