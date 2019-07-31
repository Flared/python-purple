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

from purple.callbacks cimport request as libcallbacks_request

cdef class _Callbacks:

    #############
    ## Request ##
    #############
    @property
    def CALLBACK_REQUEST_REQUEST_INPUT(self):
        return libcallbacks_request.CALLBACK_REQUEST_REQUEST_INPUT


cdef _Callbacks get_callbacks_enum():
    return _Callbacks()