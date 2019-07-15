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

from libpurple cimport notify as c_notify
from libpurple cimport debug as c_debug
from libpurple cimport conversation as c_conversation
from libpurple cimport connection as c_connection

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef int size_t

cdef object notify_cbs

cdef void *notify_message(c_notify.PurpleNotifyMsgType type,
                          const_char *title,
                          const_char *primary,
                          const_char *secondary)

cdef void *notify_email(c_connection.PurpleConnection *gc,
                        const_char *subject,
                        const_char *_from,
                        const_char *to,
                        const_char *url)

cdef void *notify_emails(c_connection.PurpleConnection *gc,
                         size_t count,
                         glib.gboolean detailed,
                         const_char **subjects,
                         const_char **froms,
                         const_char **tos,
                         const_char **urls)

cdef void *notify_formatted(const_char *title,
                            const_char *primary,
                            const_char *secondary,
                            const_char *text)

cdef void *notify_searchresults(c_connection.PurpleConnection *gc,
                                const_char *title,
                                const_char *primary,
                                const_char *secondary,
                                c_notify.PurpleNotifySearchResults *results,
                                glib.gpointer user_data)

cdef void notify_searchresults_new_rows(c_connection.PurpleConnection *gc,
                                        c_notify.PurpleNotifySearchResults *results,
                                        void *data)

cdef void *notify_userinfo(c_connection.PurpleConnection *gc,
                           const_char *who,
                           c_notify.PurpleNotifyUserInfo *user_info)

cdef void *notify_uri(const_char *uri)

cdef void close_notify(c_notify.PurpleNotifyType type, void *ui_handle)
