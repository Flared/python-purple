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

from libpurple cimport connection as c_libconnection

cdef extern from *:
    ctypedef char const_char "const char"

cdef object connection_cbs

cdef extern from *:
    ctypedef int size_t

cdef void connect_progress(c_libconnection.PurpleConnection *gc,
                           const_char *text,
                           size_t step,
                           size_t step_count)

cdef void connected(c_libconnection.PurpleConnection *gc)

cdef void disconnected(c_libconnection.PurpleConnection *gc)

cdef void notice(c_libconnection.PurpleConnection *gc, const_char *text)

cdef void report_disconnect(c_libconnection.PurpleConnection *gc, const_char *text)

cdef void network_connected()

cdef void network_disconnected()

cdef void report_disconnect_reason(c_libconnection.PurpleConnection *gc,
                                   c_libconnection.PurpleConnectionError reason,
                                   const_char *c_text)
