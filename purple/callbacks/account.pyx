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
from libpurple cimport connection as c_libconnection
from libpurple cimport request as c_librequest
from libpurple cimport status as c_libstatus
from libpurple cimport debug as c_libdebug

cdef extern from *:
    ctypedef char const_char "const char"

account_cbs = {}

cdef c_libaccount.PurpleAccountRequestAuthorizationCb c_request_authorize_authorize_cb = NULL
cdef c_libaccount.PurpleAccountRequestAuthorizationCb c_request_authorize_deny_cb = NULL
cdef void *c_request_authorize_user_data = NULL

def call_authorize_cb():
    global c_request_authorize_authorize_cb
    global c_request_authorize_deny_cb
    global c_request_authorize_user_data

    if c_request_authorize_authorize_cb:
        c_request_authorize_authorize_cb(c_request_authorize_user_data)
    c_request_authorize_authorize_cb = NULL
    c_request_authorize_deny_cb = NULL
    c_request_authorize_user_data = NULL

def call_deny_cb():
    global c_request_authorize_authorize_cb
    global c_request_authorize_deny_cb
    global c_request_authorize_user_data

    if c_request_authorize_deny_cb:
        c_request_authorize_deny_cb(c_request_authorize_user_data)
    c_request_authorize_authorize_cb = NULL
    c_request_authorize_deny_cb = NULL
    c_request_authorize_user_data = NULL

cdef void notify_added(c_libaccount.PurpleAccount *account,
                       const_char *c_remote_user,
                       const_char *c_id,
                       const_char *c_alias,
                       const_char *c_message):
    """
    A buddy who is already on this account's buddy list added this account to
    their buddy list.
    """
    cdef c_libconnection.PurpleConnection *gc = c_libaccount.purple_account_get_connection(account)

    c_libdebug.purple_debug_info("account", "%s", "notify-added\n")

    cdef bytes remote_user = c_remote_user or None
    cdef bytes alias = c_alias or None
    cdef bytes message = c_message or None

    if id:
        username = <char *> id
    elif c_libconnection.purple_connection_get_display_name(gc) != NULL:
        username = c_libconnection.purple_connection_get_display_name(gc)
    else:
        username = c_libaccount.purple_account_get_username(account)

    protocol_id = c_libaccount.purple_account_get_protocol_id(account)

    if "notify-added" in account_cbs:
        (<object> account_cbs["notify-added"])(
            (remote_user, alias),
            (username, protocol_id),
            message
        )

cdef void status_changed(c_libaccount.PurpleAccount *account,
                         c_libstatus.PurpleStatus *status):
    """
    This account's status changed.
    """
    c_libdebug.purple_debug_info("account", "%s", "status-changed\n")

    username = c_libaccount.purple_account_get_username(account)
    protocol_id = c_libaccount.purple_account_get_protocol_id(account)

    status_id = c_libstatus.purple_status_get_id(status)
    status_name = c_libstatus.purple_status_get_name(status)

    if "status-changed" in account_cbs:
        (<object> account_cbs["status-changed"])( \
            (username, protocol_id), status_id, status_name)

cdef void request_add(c_libaccount.PurpleAccount *account,
                      const_char *remote_user,
                      const_char *id,
                      const_char *alias,
                      const_char *c_message):
    """
    Someone we don't have on our list added us; prompt to add them.
    """
    cdef c_libconnection.PurpleConnection *gc = c_libaccount.purple_account_get_connection(account)

    c_libdebug.purple_debug_info("account", "%s", "request-add\n")

    if alias:
        remote_alias = <char *> alias
    else:
        remote_alias = None

    if id:
        username = <char *> id
    elif c_libconnection.purple_connection_get_display_name(gc) != NULL:
        username = c_libconnection.purple_connection_get_display_name(gc)
    else:
        username = c_libaccount.purple_account_get_username(account)

    protocol_id = c_libaccount.purple_account_get_protocol_id(account)

    if c_message:
        message = <char *> c_message
    else:
        message = None

    if "request-add" in account_cbs:
        (<object> account_cbs["request-add"])( \
            (<char *> remote_user, remote_alias), \
            (username, protocol_id), message)

cdef void *request_authorize(c_libaccount.PurpleAccount *account,
                             const_char *remote_user,
                             const_char *id,
                             const_char *alias,
                             const_char *c_message,
                             glib.gboolean on_list,
                             c_libaccount.PurpleAccountRequestAuthorizationCb authorize_cb,
                             c_libaccount.PurpleAccountRequestAuthorizationCb deny_cb,
                             void *user_data):
    """
    Prompt for authorization when someone adds this account to their buddy
    list. To authorize them to see this account's presence, call
    authorize_cb(user_data) otherwise call deny_cb(user_data).
    @return a UI-specific handle, as passed to #close_account_request.
    """
    cdef c_libconnection.PurpleConnection *gc = c_libaccount.purple_account_get_connection(account)

    c_libdebug.purple_debug_info("account", "%s", "request-authorize\n")

    global c_request_authorize_authorize_cb
    global c_request_authorize_deny_cb
    global c_request_authorize_user_data

    c_request_authorize_authorize_cb = authorize_cb
    c_request_authorize_deny_cb = deny_cb
    c_request_authorize_user_data = user_data

    if alias:
        remote_alias = <char *> alias
    else:
        remote_alias = None

    if id:
        username = <char *> id
    elif c_libconnection.purple_connection_get_display_name(gc) != NULL:
        username = c_libconnection.purple_connection_get_display_name(gc)
    else:
        username = c_libaccount.purple_account_get_username(account)

    protocol_id = c_libaccount.purple_account_get_protocol_id(account)

    if c_message:
        message = <char *> c_message
    else:
        message = None

    if "request-authorize" in account_cbs:
        (<object> account_cbs["request-authorize"])( \
            (<char *> remote_user, remote_alias), \
            (username, protocol_id), \
            message, on_list, \
            call_authorize_cb, call_deny_cb)

cdef void close_account_request (void *ui_handle):
    """
    Close a pending request for authorization. ui_handle is a handle as
    returned by request_authorize.
    """
    c_libdebug.purple_debug_info("account", "%s", "close-account-request\n")

    c_librequest.purple_request_close(c_librequest.PURPLE_REQUEST_ACTION, ui_handle)

    if "close-account-request" in account_cbs:
        (<object> account_cbs["close-account-request"])()
