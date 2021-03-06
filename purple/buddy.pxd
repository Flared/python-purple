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

from libpurple cimport blist as c_libblist

cdef class Buddy:

    cdef c_libblist.PurpleBuddy* _c_buddy

    @staticmethod
    cdef Buddy from_c_buddy(c_libblist.PurpleBuddy* c_buddy)

    cpdef bytes get_alias(self)

    cpdef bytes get_name(self)
