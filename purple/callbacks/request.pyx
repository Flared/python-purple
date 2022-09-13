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

from libpurple cimport conversation as c_libconversation
from libpurple cimport request as c_librequest
from libpurple cimport debug as c_libdebug
from libpurple cimport account as c_libaccount
from purple cimport account as libaccount
from purple cimport conversation as libconversation

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef int size_t
    ctypedef void* va_list
    char* charptr "char *"
    glib.GCallback glibcb "GCallback"
    void* va_arg(void *action, void *type)

request_cbs = {}

cdef str CALLBACK_REQUEST_REQUEST_INPUT = "request-input"
cdef void* request_input(
    const_char* c_title,
    const_char* c_primary,
    const_char* c_secondary,
    const_char* c_default_value,
    glib.gboolean c_multiline,
    glib.gboolean c_masked,
    glib.gchar* c_hint,
    const_char* c_ok_text,
    glib.GCallback ok_cb,
    const_char* c_cancel_text,
    glib.GCallback cancel_cb,
    c_libaccount.PurpleAccount* c_account,
    const_char* c_who,
    c_libconversation.PurpleConversation* c_conv,
    void* user_data
):
    """
    @see purple_request_input().
    """

    cdef bytes title = c_title or None
    cdef bytes primary = c_primary or None
    cdef bytes secondary = c_secondary or None
    cdef bytes default_value = c_default_value or None
    cdef bytes hint = c_hint or None
    cdef bytes ok_text = c_ok_text or None
    cdef bytes cancel_text = c_cancel_text or None
    cdef bytes who = c_who or None
    cdef bint multiline = c_multiline
    cdef bint masked = c_masked

    def ok_callback_python(bytes _input):
        (<c_librequest.PurpleRequestInputCb> ok_cb)(user_data, _input)

    def cancel_callback_python():
        (<c_librequest.PurpleRequestInputCb> cancel_cb)(user_data, NULL)

    c_libdebug.purple_debug_info("request", "%s", "request-input\n")
    if CALLBACK_REQUEST_REQUEST_INPUT in request_cbs:
        request_cbs[CALLBACK_REQUEST_REQUEST_INPUT](
            title=title,
            primary=primary,
            secondary=secondary,
            default_value=default_value,
            multiline=multiline,
            masked=c_masked,
            hint=hint,
            ok_text=ok_text,
            ok_cb=ok_callback_python,
            cancel_text=cancel_text,
            cancel_cb=cancel_callback_python,
            account=None,
            who=who,
            conversation=None,
        )

    return user_data

cdef void *request_choice(
    const_char *title,
    const_char *primary,
    const_char *secondary,
    int default_value,
    const_char *ok_text,
    glib.GCallback ok_cb,
    const_char *cancel_text,
    glib.GCallback cancel_cb,
    c_libaccount.PurpleAccount *account,
    const_char *who,
    c_libconversation.PurpleConversation *conv,
    void *user_data,
    va_list choices
):
    """
    @see purple_request_choice_varg().
    """
    c_libdebug.purple_debug_info("request", "%s", "request-choice\n")
    if "request-choice" in request_cbs:
        (<object> request_cbs["request-choice"])("request-choice: TODO")

cdef str CALLBACK_REQUEST_REQUEST_ACTION = "request-action"
cdef void *request_action(
    const_char *c_title,
    const_char *c_primary,
    const_char *c_secondary,
    int default_action,
    c_libaccount.PurpleAccount *c_account,
    const_char *c_who,
    c_libconversation.PurpleConversation *c_conversation,
    void *user_data,
    size_t action_count, va_list actions
):
    """
    @see purple_request_action_varg().
    """
    cdef c_librequest.PurpleRequestActionCb req_actions_cb[10]
    cdef object req_actions_list = []
    cdef int i = 0
    cdef int action_id = default_action
    cdef char *btn_txt
    cdef void *cb

    cdef bytes title = c_title or None
    cdef bytes primary = c_primary or None
    cdef bytes secondary = c_secondary or None
    cdef libaccount.Account account = libaccount.Account.from_c_account(c_account)
    cdef bytes who = c_who or None
    cdef libconversation.Conversation conversation = libconversation.Conversation.from_c_conversation(c_conversation)

    #FIXME: i < 10 max size to req_actions_cb
    while i < action_count and i < 10:
        btn_txt = <char *> va_arg(actions, charptr)
        req_actions_cb[i] = <c_librequest.PurpleRequestActionCb> va_arg(actions, glibcb)
        req_actions_list.append(btn_txt)
        i = i + 1

    c_libdebug.purple_debug_info("request", "%s", "request-action\n")
    if CALLBACK_REQUEST_REQUEST_ACTION in request_cbs:
        action_id = request_cbs[CALLBACK_REQUEST_REQUEST_ACTION](
            title=title,
            primary=primary,
            secondary=secondary,
            default_action=default_action,
            account=account,
            who=who,
            conversation=conversation,
            actions=req_actions_list)

    if action_id < 0 or action_id >= action_count or action_id >= 10:
        action_id = default_action

    if action_id > -1:
        req_actions_cb[action_id](user_data, action_id)

cdef void *request_fields(
    const_char *title,
    const_char *primary,
    const_char *secondary,
    c_librequest.PurpleRequestFields *fields,
    const_char *ok_text,
    glib.GCallback ok_cb,
    const_char *cancel_text,
    glib.GCallback cancel_cb,
    c_libaccount.PurpleAccount *account,
    const_char *who,
    c_libconversation.PurpleConversation *conv,
    void *user_data
):
    """
    @see purple_request_fields().
    """
    c_libdebug.purple_debug_info("request", "%s", "request-fields\n")
    if "request-fields" in request_cbs:
        (<object> request_cbs["request-fields"])("request-fields: TODO")

cdef void *request_file(
    const_char *title,
    const_char *filename,
    glib.gboolean savedialog,
    glib.GCallback ok_cb,
    glib.GCallback cancel_cb,
    c_libaccount.PurpleAccount *account,
    const_char *who,
    c_libconversation.PurpleConversation *conv,
    void *user_data
):
    """
    @see purple_request_file().
    """
    c_libdebug.purple_debug_info("request", "%s", "request-file\n")
    if "request-file" in request_cbs:
        (<object> request_cbs["request-file"])("request-file: TODO")

cdef void close_request(
    c_librequest.PurpleRequestType type,
    void *ui_handle
):
    """
    TODO
    """
    c_libdebug.purple_debug_info("request", "%s", "close-request\n")
    if "close-request" in request_cbs:
        (<object> request_cbs["close-request"])("close-request: TODO")

cdef void *request_folder(
    const_char *title,
    const_char *dirname,
    glib.GCallback ok_cb,
    glib.GCallback cancel_cb,
    c_libaccount.PurpleAccount *account,
    const_char *who,
    c_libconversation.PurpleConversation *conv,
    void *user_data
):
    """
    @see purple_request_folder().
    """
    c_libdebug.purple_debug_info("request", "%s", "request-folder\n")
    if "request-folder" in request_cbs:
        (<object> request_cbs["request-folder"])("request-folder: TODO")
