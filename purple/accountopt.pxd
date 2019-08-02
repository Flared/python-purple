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

from libpurple cimport accountopt as c_libaccountopt

cdef class AccountOption:
    cdef c_libaccountopt.PurpleAccountOption* _c_account_option

    @staticmethod
    cdef AccountOption from_c_account_option(c_libaccountopt.PurpleAccountOption* c_account_option)

    cpdef bytes get_text(self)

    cpdef bytes get_setting(self)

    cpdef bint get_default_bool(self)

    cpdef int get_default_int(self)

    cpdef bytes get_default_string(self)

    cpdef bytes get_default_list_value(self)

    cpdef bint get_masked(self)

    cpdef list get_list(self)
