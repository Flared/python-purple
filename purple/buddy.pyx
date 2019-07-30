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

    @staticmethod
    cdef Buddy from_c_buddy(c_libblist.PurpleBuddy* c_buddy):
        cdef Buddy buddy = Buddy.__new__(Buddy)
        buddy._c_buddy = c_buddy
        return buddy

    cpdef bytes get_alias(self):
        cdef char* c_alias = c_libblist.purple_buddy_get_alias(
            self._c_buddy
        )
        cdef bytes alias = c_alias or None
        return alias

    cpdef bytes get_name(self):
        cdef char* c_name = c_libblist.purple_buddy_get_name(
            self._c_buddy
        )
        cdef bytes name = c_name or None
        return name
