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

from libpurple cimport notify as c_libnotify
from libpurple cimport debug as c_libdebug
from libpurple cimport connection as c_libconnection

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef int size_t

notify_cbs = {}

cdef void *notify_message(c_libnotify.PurpleNotifyMsgType type,
                          const_char *title,
                          const_char *primary,
                          const_char *secondary):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "notify-message\n")
    if "notify-message" in notify_cbs:
        (<object> notify_cbs["notify-message"])("notify-message: TODO")

cdef void *notify_email(c_libconnection.PurpleConnection *gc,
                        const_char *subject,
                        const_char *_from,
                        const_char *to,
                        const_char *url):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "notify-email\n")
    if "notify-email" in notify_cbs:
        (<object> notify_cbs["notify-email"])("notify-email: TODO")

cdef void *notify_emails(c_libconnection.PurpleConnection *gc,
                         size_t count,
                         glib.gboolean detailed,
                         const_char **subjects,
                         const_char **froms,
                         const_char **tos,
                         const_char **urls):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "notify-emails\n")
    if "notify-emails" in notify_cbs:
        (<object> notify_cbs["notify-emails"])("notify-emails: TODO")

cdef void *notify_formatted(const_char *title,
                            const_char *primary,
                            const_char *secondary,
                            const_char *text):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "notify-formatted\n")
    if "notify-formatted" in notify_cbs:
        (<object> notify_cbs["notify-formatted"])("notify-formatted: TODO")

cdef void *notify_searchresults(c_libconnection.PurpleConnection *gc,
                                const_char *title,
                                const_char *primary,
                                const_char *secondary,
                                c_libnotify.PurpleNotifySearchResults *results,
                                glib.gpointer user_data):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "notify-searchresults\n")
    if "notify-searchresults" in notify_cbs:
        (<object> notify_cbs["notify-searchresults"]) \
            ("notify-searchresults: TODO")

cdef void notify_searchresults_new_rows(c_libconnection.PurpleConnection *gc,
                                        c_libnotify.PurpleNotifySearchResults *results,
                                        void *data):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "notify-searchresults-new-rows\n")
    if "notify-searchresults-new-rows" in notify_cbs:
        (<object> notify_cbs["notify-searchresults-new-rows"]) \
            ("notify-searchresults-new-rows: TODO")

cdef void *notify_userinfo(c_libconnection.PurpleConnection *gc,
                           const_char *who,
                           c_libnotify.PurpleNotifyUserInfo *user_info):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "notify-userinfo\n")
    if "notify-userinfo" in notify_cbs:
        (<object> notify_cbs["notify-userinfo"])("notify-userinfo: TODO")

cdef void *notify_uri(const_char *uri):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "notify-uri\n")
    if "notify-uri" in notify_cbs:
        (<object> notify_cbs["notify-uri"])("notify-uri: TODO")

cdef void close_notify(c_libnotify.PurpleNotifyType type, void *ui_handle):
    """
    TODO
    """
    c_libdebug.purple_debug_info("notify", "%s", "close-notify\n")
    if "close-notify" in notify_cbs:
        (<object> notify_cbs["close-notify"])("close-notify: TODO")
