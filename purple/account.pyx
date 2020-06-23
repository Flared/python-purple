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
from libpurple cimport core as c_libcore
from libpurple cimport connection as c_libconnection

from purple cimport plugin as libplugin
from purple cimport connection as libconnection

cdef class Account:
    """
    Account class
    @param username
    @param protocol Protocol class instance
    """

    def __init__(self):
        raise Exception("Use Account.find() or Account.new() instead.")

    @staticmethod
    def new(libplugin.Plugin protocol, char* username):
        c_libaccount.purple_accounts_add(
            c_libaccount.purple_account_new(
                username,
                protocol.get_id()
            )
        )

        cdef Account account = Account.find(
            protocol,
            username
        )

        if not account:
            raise Exception("Could not create account!")

        return account

    @staticmethod
    cdef Account from_c_account(
        c_libaccount.PurpleAccount* c_account
    ):
        cdef Account account = Account.__new__(Account)
        account._c_account = c_account
        return account

    @staticmethod
    def find(libplugin.Plugin protocol, char* username):
        cdef object account = None
        cdef c_libaccount.PurpleAccount* c_account = c_libaccount.purple_accounts_find(
            username,
            protocol.get_id()
        )
        if c_account != NULL:
            account = Account.from_c_account(c_account)
        return account

    def is_connected(self):
        cdef bint _is_connected = False
        _is_connected = c_libaccount.purple_account_is_connected(
            self._c_account,
        )
        return _is_connected

    def get_username(self):
        cdef char* c_username = c_libaccount.purple_account_get_username(
            self._c_account,
        )
        cdef bytes username = c_username or None
        return username

    def get_password(self):
        cdef char* password = NULL
        password = <char *> c_libaccount.purple_account_get_password(
            self._c_account,
        )
        return password or None

    cpdef bytes get_protocol_id(self):
        cdef char* c_protocol_id = c_libaccount.purple_account_get_protocol_id(
            self._c_account,
        )
        cdef bytes protocol_id = c_protocol_id or None
        return protocol_id

    cpdef bytes get_protocol_name(self):
        cdef char* c_protocol_name = c_libaccount.purple_account_get_protocol_name(
            self._c_account,
        )
        cdef bytes protocol_name = c_protocol_name or None
        return protocol_name

    def get_string(self, char* name, char* default_value):
        """
        Gets a protocol-specific string setting for an account.

        @param name The name of the setting.
        @param default_value The default value.
        @return The value.
        """
        cdef char* c_value = c_libaccount.purple_account_get_string(
            self._c_account,
            name,
            default_value,
        )
        cdef bytes value = c_value or None
        return value


    def is_enabled(
        self,
        bytes ui_name = None,
    ):
        if not ui_name:
            ui_name = c_libcore.purple_core_get_ui()

        cdef bint is_enabled = False
        is_enabled = c_libaccount.purple_account_get_enabled(
            self._c_account,
            ui_name
        )
        return is_enabled

    def set_password(self, char* password):
        """
        Sets the account's password.

        @param password The password
        @return True if successful, False if account doesn't exists
        """
        c_libaccount.purple_account_set_password(
            self._c_account,
            password
        )

    def set_string(self, char* name, char* value):
        """
        Sets a protocol-specific string setting for an account.

        @param name The name of the setting.
        @param value The setting's value.
        """
        c_libaccount.purple_account_set_string(
            self._c_account,
            name,
            value
        )

    def set_enabled(
        self,
        bint enabled,
        *,
        bytes ui_name = None
    ):
        """
        Sets wheter or not this account is enabled.

        @param value True if it is enabled, or False otherwise
        @return True if successful, False if account doesn't exists
        """
        if not ui_name:
            ui_name = c_libcore.purple_core_get_ui()

        c_libaccount.purple_account_set_enabled(
            self._c_account,
            ui_name,
            enabled,
        )

    cpdef libconnection.Connection get_connection(self):
        cdef c_libconnection.PurpleConnection* c_connection =  c_libaccount.purple_account_get_connection(
            self._c_account,
        )
        cdef libconnection.Connection connection = None

        if c_connection != NULL:
            connection = libconnection.Connection.from_c_connection(
                c_connection
            )

        return connection
