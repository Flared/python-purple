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
from libpurple cimport debug as c_libdebug

cimport purple.signals as libsignals
 
cdef extern from *:
    ctypedef char const_gchar "const gchar"

cdef str SIGNAL_CORE_QUITTING = "quitting"
cdef void signal_core_quitting_cb():
    """
    Emitted when libpurple is quitting.
    """
    c_libdebug.purple_debug_info("core", "%s\n", "quitting\n")
    cdef char *c_name = NULL

    for callback in libsignals.signal_cbs.get(SIGNAL_CORE_QUITTING, tuple()):
        callback()
