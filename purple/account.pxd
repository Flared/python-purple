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

from libpurple cimport account as c_libaccount

from purple cimport connection as libconnection

cdef class Account:

    cdef object __username
    cdef object __protocol
    cdef c_libaccount.PurpleAccount* _c_account

    @staticmethod
    cdef Account from_c_account(
        c_libaccount.PurpleAccount* c_account
    )

    cpdef libconnection.Connection get_connection(self)
