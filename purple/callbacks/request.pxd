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
from libpurple cimport account as c_libaccount

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef int size_t
    ctypedef void* va_list
    char* charptr "char *"
    glib.GCallback glibcb "GCallback"
    void* va_arg(void *action, void *type)

cdef dict request_cbs

cdef str CALLBACK_REQUEST_REQUEST_INPUT
cdef void *request_input(
    const_char *title,
    const_char *primary,
    const_char *secondary,
    const_char *default_value,
    glib.gboolean multiline,
    glib.gboolean masked,
    glib.gchar *hint,
    const_char *ok_text,
    glib.GCallback ok_cb,
    const_char *cancel_text,
    glib.GCallback cancel_cb,
    c_libaccount.PurpleAccount *account,
    const_char *who,
    c_libconversation.PurpleConversation *conv,
    void *user_data
)

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
)

cdef str CALLBACK_REQUEST_REQUEST_ACTION
cdef void *request_action(
    const_char *title,
    const_char *primary,
    const_char *secondary,
    int default_action,
    c_libaccount.PurpleAccount *account,
    const_char *who,
    c_libconversation.PurpleConversation *conv,
    void *user_data,
    size_t action_count,
    va_list actions
)

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
)

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
)

cdef void close_request(
    c_librequest.PurpleRequestType type,
    void *ui_handle
)

cdef void *request_folder(
    const_char *title,
    const_char *dirname,
    glib.GCallback ok_cb,
    glib.GCallback cancel_cb,
    c_libaccount.PurpleAccount *account,
    const_char *who,
    c_libconversation.PurpleConversation *conv,
    void *user_data
)
