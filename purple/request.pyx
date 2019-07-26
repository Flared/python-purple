#
#  Copyright (c) 2019 Flare Systems
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
import sys

cimport glib
from cpython.ref cimport PyObject

from libpurple cimport request as c_librequest

from purple cimport account as libaccount
from purple cimport conversation as libconversation

cdef class RequestInputCallbackManager:

    # Instances of this class will venture into wild C code
    # where they are not ref counted!
    REFS = []

    cdef object _ok_callback
    cdef object _cancel_callback
    cdef object _python_user_data

    def __init__(
        self,
        object ok_callback,
        object cancel_callback,
        object python_user_data,
    ):
        assert ok_callback
        assert cancel_callback

        RequestInputCallbackManager.REFS.append(self)

        self._ok_callback = ok_callback
        self._cancel_callback = cancel_callback
        self._python_user_data = python_user_data

    cpdef cancel_callback(self):
        self._cancel_callback(self._python_user_data)

    cpdef ok_callback(self, bytes _input):
        self._ok_callback(self._python_user_data, _input)

    @staticmethod
    cdef void c_ok_callback(void *c_user_data, char* _input):
        cdef RequestInputCallbackManager callback_manager = <RequestInputCallbackManager> c_user_data
        RequestInputCallbackManager.REFS.remove(callback_manager)
        callback_manager.ok_callback(_input)

    @staticmethod
    cdef void c_cancel_callback(void *c_user_data):
        cdef RequestInputCallbackManager callback_manager = <RequestInputCallbackManager> c_user_data
        RequestInputCallbackManager.REFS.remove(callback_manager)
        callback_manager.cancel_callback()


cdef class Request:

    @staticmethod
    def request_input(
        *,
        bytes title,
        bytes primary,
        bytes secondary,
        bytes default_value,
        bint multiline,
        bint masked,
        bytes hint,
        bytes ok_text,
        object ok_callback,
        bytes cancel_text,
        object cancel_callback,
        libaccount.Account account,
        bytes who,
        libconversation.Conversation conversation,
        object user_data,
    ):

        cdef int handle

        cdef RequestInputCallbackManager callback_manager = RequestInputCallbackManager(
            ok_callback=ok_callback,
            cancel_callback=cancel_callback,
            python_user_data=user_data
        )

        c_librequest.purple_request_input(
            NULL,
            title,
            primary,
            secondary,
            default_value,
            multiline,
            masked,
            hint,
            ok_text,
            glib.G_CALLBACK(<void*> RequestInputCallbackManager.c_ok_callback),
            cancel_text,
            glib.G_CALLBACK(<void*> RequestInputCallbackManager.c_cancel_callback),
            NULL,
            who,
            NULL,
            <void*> callback_manager
        )
