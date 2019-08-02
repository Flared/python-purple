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

from purple cimport protocol as libprotocol

cdef class Account:
    """
    Account class
    @param username
    @param protocol Protocol class instance
    """

    def __init__(self):
        raise Exception("Use Account.find() or Account.new() instead.")

    @staticmethod
    def new(libprotocol.Protocol protocol, char* username):
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
    def find(libprotocol.Protocol protocol, char* username):
        cdef object account = None
        cdef c_libaccount.PurpleAccount* c_account = c_libaccount.purple_accounts_find(
            username,
            protocol.get_id()
        )
        if c_account != NULL:
            account = Account.from_c_account(c_account)
        return account

    cdef c_libaccount.PurpleAccount* _get_structure(self):
        return self._c_account

    def is_connected(self):
        cdef bint _is_connected = False
        _is_connected = c_libaccount.purple_account_is_connected(
            self._get_structure()
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
            self._get_structure()
        )
        return password or None

    def is_enabled(
        self,
        bytes ui_name = None,
    ):
        if not ui_name:
            ui_name = c_libcore.purple_core_get_ui()

        cdef bint is_enabled = False
        is_enabled = c_libaccount.purple_account_get_enabled(
            self._get_structure(),
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
            self._get_structure(),
            password
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
            self._get_structure(),
            ui_name,
            enabled,
        )
