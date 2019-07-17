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
from libpurple cimport status as c_libstatus

cdef extern from *:
    ctypedef char const_char "const char"

cdef object account_cbs

cdef c_libaccount.PurpleAccountRequestAuthorizationCb c_request_authorize_authorize_cb
cdef c_libaccount.PurpleAccountRequestAuthorizationCb c_request_authorize_deny_cb
cdef void *c_request_authorize_user_data

cdef void notify_added(c_libaccount.PurpleAccount *account,
                       const_char *remote_user,
                       const_char *id,
                       const_char *alias,
                       const_char *c_message)

cdef void status_changed(c_libaccount.PurpleAccount *account,
                         c_libstatus.PurpleStatus *status)

cdef void request_add(c_libaccount.PurpleAccount *account,
                      const_char *remote_user,
                      const_char *id,
                      const_char *alias,
                      const_char *c_message)

cdef void *request_authorize(c_libaccount.PurpleAccount *account,
                             const_char *remote_user,
                             const_char *id,
                             const_char *alias,
                             const_char *c_message,
                             glib.gboolean on_list,
                             c_libaccount.PurpleAccountRequestAuthorizationCb authorize_cb,
                             c_libaccount.PurpleAccountRequestAuthorizationCb deny_cb,
                             void *user_data)

cdef void close_account_request (void *ui_handle)
