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

from libpurple cimport accountopt as c_libaccountopt

cdef class AccountOption:

    @staticmethod
    cdef AccountOption from_c_account_option(c_libaccountopt.PurpleAccountOption* c_account_option):
        cdef AccountOption account_option = AccountOption.__new__(AccountOption)
        account_option._c_account_option = c_account_option
        return account_option


    cpdef bytes get_text(self):
        cdef char* c_text = c_libaccountopt.purple_account_option_get_text(
            self._c_account_option,
        )
        cdef bytes text = c_text or None
        return text

    cpdef bytes get_setting(self):
        cdef char* c_setting = c_libaccountopt.purple_account_option_get_setting(
            self._c_account_option,
        )
        cdef bytes setting = c_setting or None
        return setting

    cpdef bint get_default_bool(self):
        cdef bint c_bool = c_libaccountopt.purple_account_option_get_default_bool(
            self._c_account_option,
        )
        return c_bool

    cpdef int get_default_int(self):
        cdef int c_int = c_libaccountopt.purple_account_option_get_default_int(
            self._c_account_option,
        )
        return c_int

    cpdef bytes get_default_string(self):
        cdef char* c_string = c_libaccountopt.purple_account_option_get_default_string(
            self._c_account_option,
        )
        cdef bytes _string = c_string or None
        return _string

    cpdef bytes get_default_list_value(self):
        cdef char* c_default_list_value = c_libaccountopt.purple_account_option_get_text(
            self._c_account_option,
        )
        cdef bytes default_list_value = c_default_list_value or None
        return default_list_value

    cpdef bint get_masked(self):
        cdef bint c_masked = c_libaccountopt.purple_account_option_get_masked(
            self._c_account_option,
        )
        return c_masked

    cpdef list get_list(self):
        cdef glib.GList* c_iter = c_libaccountopt.purple_account_option_get_list(
            self._c_account_option,
        )
        cdef c_libaccountopt.PurpleAccountOption* c_account_option

        cdef list options = list()

        while c_iter:
            c_account_option = <c_libaccountopt.PurpleAccountOption*> c_iter.data
            account_option = AccountOption.from_c_account_option(c_account_option)
            options.append(account_option)
            c_iter = c_iter.next

        return options
