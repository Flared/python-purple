#
#  Copyright (c) 2008 INdT - Instituto Nokia de Tecnologia
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

cimport glib

from libpurple cimport eventloop as c_libeventloop
from libpurple cimport account as c_libaccount
from libpurple cimport blist as c_libblist
from libpurple cimport connection as c_libconnection
from libpurple cimport signals as c_libsignals
from libpurple cimport pounce as c_libpounce
from libpurple cimport core as c_libcore
from libpurple cimport util as c_libutil
from libpurple cimport notify as c_libnotify
from libpurple cimport conversation as c_libconversation
from libpurple cimport request as c_librequest
from libpurple cimport debug as c_libdebug
from libpurple cimport plugin as c_libplugin
from libpurple cimport prefs as c_libprefs

from purple cimport account as libaccount
from purple cimport signals as libsignals

from purple.signals cimport core as libsignals_core
from purple.signals cimport blist as libsignals_blist
from purple.signals cimport connection as libsignals_connection
from purple.signals cimport conversation as libsignals_conversation


cdef extern from "c_purple.h":
    glib.guint glib_input_add(glib.gint fd,
                              c_libeventloop.PurpleInputCondition condition,
                              c_libeventloop.PurpleInputFunction function,
                              glib.gpointer data)

import signal
import sys
import os

cdef glib.GHashTable *c_ui_info

c_ui_info = NULL

cdef char *c_ui_name
cdef char *c_ui_version
cdef char *c_ui_website
cdef char *c_ui_dev_website

cdef c_libaccount.PurpleAccountUiOps c_account_ui_ops
cdef c_libblist.PurpleBlistUiOps c_blist_ui_ops
cdef c_libconnection.PurpleConnectionUiOps c_conn_ui_ops
cdef c_libconversation.PurpleConversationUiOps c_conv_ui_ops
cdef c_libcore.PurpleCoreUiOps c_core_ui_ops
cdef c_libeventloop.PurpleEventLoopUiOps c_eventloop_ui_ops
cdef c_libnotify.PurpleNotifyUiOps c_notify_ui_ops
cdef c_librequest.PurpleRequestUiOps c_request_ui_ops

from purple.callbacks cimport account as callbacks_account
from purple.callbacks cimport blist as callbacks_blist
from purple.callbacks cimport connection as callbacks_connection
from purple.callbacks cimport conversation as callbacks_conversation
from purple.callbacks cimport notify as callbacks_notify
from purple.callbacks cimport request as callbacks_request

cdef class Purple:
    '''Purple class.

    @param ui_name ID of the UI using the purple.
        This should be a unique ID, registered with the purple team.
    @param ui_version UI version.
    @param ui_website UI website.
    @param ui_dev_website UI development website.
    @param debug_enabled True to enable debug messages.
    @param default_path Custom settings directory
    '''


    def __init__(
        self,
        char* ui_name,
        char* ui_version,
        char* ui_website,
        char* ui_dev_website,
        bint debug_enabled=False,
        char* default_path="",
    ):

        global c_ui_name
        global c_ui_version
        global c_ui_website
        global c_ui_dev_website

        c_ui_name = ui_name
        c_ui_version = ui_version
        c_ui_website = ui_website
        c_ui_dev_website = ui_dev_website

        if debug_enabled:
            c_libdebug.purple_debug_set_enabled(debug_enabled)

        if default_path != b"":
            c_libutil.purple_util_set_user_dir(default_path)

        # libpurple's built-in DNS resolution forks processes to perform
        # blocking lookups without blocking the main process.  It does not
        # handle SIGCHLD itself, so if the UI does not you quickly get an army
        # of zombie subprocesses marching around.
        signal.signal(signal.SIGCHLD, signal.SIG_IGN)

    def destroy(self):
        c_libcore.purple_core_quit()

    def get_version(self):
        return c_libcore.purple_core_get_version()

    def __get_ui_name(self):
        '''Returns the UI name.

        @return UI name.
        '''

        global c_ui_name
        return c_ui_name
    ui_name = property(__get_ui_name)

    cdef void __core_ui_ops_ui_prefs_init(self):
        c_libdebug.purple_debug_info("core_ui_ops", "%s", "ui_prefs_init")
        c_libprefs.purple_prefs_load()

        c_libprefs.purple_prefs_add_none("/carman")

    cdef void __core_ui_ops_debug_init(self):
        c_libdebug.purple_debug_info("core_ui_ops", "%s", "debug_ui_init")
        pass

    cdef void __core_ui_ops_ui_init(self):
        c_libdebug.purple_debug_info("core_ui_ops", "%s", "ui_init")

        c_libaccount.purple_accounts_set_ui_ops(&c_account_ui_ops)
        c_libconnection.purple_connections_set_ui_ops(&c_conn_ui_ops)
        c_libblist.purple_blist_set_ui_ops(&c_blist_ui_ops)
        c_libconversation.purple_conversations_set_ui_ops(&c_conv_ui_ops)
        c_libnotify.purple_notify_set_ui_ops(&c_notify_ui_ops)
        c_librequest.purple_request_set_ui_ops(&c_request_ui_ops)

    cdef void __core_ui_ops_quit(self):
        c_libdebug.purple_debug_info("core_ui_ops", "%s", "quit")

        c_libaccount.purple_accounts_set_ui_ops(NULL)
        c_libconnection.purple_connections_set_ui_ops(NULL)
        c_libblist.purple_blist_set_ui_ops(NULL)
        c_libconversation.purple_conversations_set_ui_ops(NULL)
        c_libnotify.purple_notify_set_ui_ops(NULL)
        c_librequest.purple_request_set_ui_ops(NULL)

        global c_ui_info
        if c_ui_info:
            glib.g_hash_table_destroy(<glib.GHashTable *> c_ui_info)

    cdef glib.GHashTable *__core_ui_ops_get_ui_info(self):
        global c_ui_info
        global c_ui_name
        global c_ui_version
        global c_ui_website
        global c_ui_dev_website

        if c_ui_info == NULL:
            c_ui_info = glib.g_hash_table_new(glib.g_str_hash, \
                    glib.g_str_equal)

            glib.g_hash_table_insert(c_ui_info, b"name", c_ui_name)
            glib.g_hash_table_insert(c_ui_info, b"version", c_ui_version)
            glib.g_hash_table_insert(c_ui_info, b"website", c_ui_website)
            glib.g_hash_table_insert(c_ui_info, b"dev_website", c_ui_dev_website)
        return c_ui_info

    def purple_init(self):
        '''Initializes the purple.

        This will setup preferences for all the core subsystems.
        '''

        global c_ui_name

        c_account_ui_ops.notify_added = callbacks_account.notify_added
        c_account_ui_ops.status_changed = callbacks_account.status_changed
        c_account_ui_ops.request_add = callbacks_account.request_add
        c_account_ui_ops.request_authorize = callbacks_account.request_authorize
        c_account_ui_ops.close_account_request = callbacks_account.close_account_request

        c_blist_ui_ops.new_list = callbacks_blist.new_list
        c_blist_ui_ops.new_node = callbacks_blist.new_node
        c_blist_ui_ops.show = callbacks_blist.show
        c_blist_ui_ops.update = callbacks_blist.update
        c_blist_ui_ops.remove = callbacks_blist.remove
        c_blist_ui_ops.destroy = callbacks_blist.destroy
        c_blist_ui_ops.set_visible = callbacks_blist.set_visible
        c_blist_ui_ops.request_add_buddy = callbacks_blist.request_add_buddy
        c_blist_ui_ops.request_add_chat = callbacks_blist.request_add_chat
        c_blist_ui_ops.request_add_group = callbacks_blist.request_add_group

        c_conn_ui_ops.connect_progress = callbacks_connection.connect_progress
        c_conn_ui_ops.connected = callbacks_connection.connected
        c_conn_ui_ops.disconnected = callbacks_connection.disconnected
        c_conn_ui_ops.notice = callbacks_connection.notice
        c_conn_ui_ops.report_disconnect = callbacks_connection.report_disconnect
        c_conn_ui_ops.network_connected = callbacks_connection.network_connected
        c_conn_ui_ops.network_disconnected = callbacks_connection.network_disconnected
        c_conn_ui_ops.report_disconnect_reason = callbacks_connection.report_disconnect_reason

        c_conv_ui_ops.create_conversation = callbacks_conversation.create_conversation
        c_conv_ui_ops.destroy_conversation = callbacks_conversation.destroy_conversation
        c_conv_ui_ops.write_chat = callbacks_conversation.write_chat
        c_conv_ui_ops.write_im = callbacks_conversation.write_im
        c_conv_ui_ops.chat_add_users = callbacks_conversation.chat_add_users
        c_conv_ui_ops.chat_rename_user = callbacks_conversation.chat_rename_user
        c_conv_ui_ops.chat_remove_users = callbacks_conversation.chat_remove_users
        c_conv_ui_ops.chat_update_user = callbacks_conversation.chat_update_user
        c_conv_ui_ops.present = callbacks_conversation.present
        c_conv_ui_ops.has_focus = callbacks_conversation.has_focus
        c_conv_ui_ops.custom_smiley_add = callbacks_conversation.custom_smiley_add
        c_conv_ui_ops.custom_smiley_write = callbacks_conversation.custom_smiley_write
        c_conv_ui_ops.custom_smiley_close = callbacks_conversation.custom_smiley_close
        c_conv_ui_ops.send_confirm = callbacks_conversation.send_confirm

        c_notify_ui_ops.notify_message = callbacks_notify.notify_message
        c_notify_ui_ops.notify_email = callbacks_notify.notify_email
        c_notify_ui_ops.notify_emails = callbacks_notify.notify_emails
        c_notify_ui_ops.notify_formatted = callbacks_notify.notify_formatted
        c_notify_ui_ops.notify_searchresults = callbacks_notify.notify_searchresults
        c_notify_ui_ops.notify_searchresults_new_rows = callbacks_notify.notify_searchresults_new_rows
        c_notify_ui_ops.notify_userinfo = callbacks_notify.notify_userinfo
        c_notify_ui_ops.notify_uri = callbacks_notify.notify_uri
        c_notify_ui_ops.close_notify = callbacks_notify.close_notify

        c_request_ui_ops.request_input = callbacks_request.request_input
        c_request_ui_ops.request_choice = callbacks_request.request_choice
        c_request_ui_ops.request_action = callbacks_request.request_action
        c_request_ui_ops.request_fields = callbacks_request.request_fields
        c_request_ui_ops.request_file = callbacks_request.request_file
        c_request_ui_ops.close_request = callbacks_request.close_request
        c_request_ui_ops.request_folder = callbacks_request.request_folder

        c_core_ui_ops.ui_prefs_init = <void (*)()> self.__core_ui_ops_ui_prefs_init
        c_core_ui_ops.debug_ui_init = <void (*)()> self.__core_ui_ops_debug_init
        c_core_ui_ops.ui_init = <void (*)()> self.__core_ui_ops_ui_init
        c_core_ui_ops.quit = <void (*)()> self.__core_ui_ops_quit
        c_core_ui_ops.get_ui_info = <glib.GHashTable* (*)()> self.__core_ui_ops_get_ui_info

        c_eventloop_ui_ops.timeout_add = glib.g_timeout_add
        c_eventloop_ui_ops.timeout_remove = glib.g_source_remove
        c_eventloop_ui_ops.input_add = glib_input_add
        c_eventloop_ui_ops.input_remove = glib.g_source_remove
        c_eventloop_ui_ops.input_get_error = NULL
        c_eventloop_ui_ops.timeout_add_seconds = NULL

        c_libcore.purple_core_set_ui_ops(&c_core_ui_ops)
        c_libeventloop.purple_eventloop_set_ui_ops(&c_eventloop_ui_ops)

        # initialize purple core
        ret = c_libcore.purple_core_init(c_ui_name)
        if ret is False:
            c_libdebug.purple_debug_fatal("main", "%s", "libpurple " \
                                       "initialization failed.\n")
            raise Exception("Initialization failed")

        # check if there is another instance of libpurple running
        if c_libcore.purple_core_ensure_single_instance() == False:
            c_libdebug.purple_debug_fatal("main", "%s", "Another instance of " \
                                      "libpurple is already running.\n")
            c_libcore.purple_core_quit()
            raise Exception("Another instance of libpurple is already running.")

        # create and load the buddy list
        c_libblist.purple_set_blist(c_libblist.purple_blist_new())
        c_libblist.purple_blist_load()

        # load pounces
        c_libpounce.purple_pounces_load()

        return ret

    def add_callback(self, *, str callback_name, object callback):
        '''Adds a callback with given name inside callback's type.

        @param type     Callback type (e.g. "account")
        @param name     Callback name (e.g. "notify-added")
        @param callback Callback to be called
        '''

        if callback_name == callbacks_request.CALLBACK_REQUEST_REQUEST_INPUT:
            callbacks_request.request_cbs[callback_name] = callback
        elif callback_name == callbacks_conversation.CALLBACK_CONVERSATION_WRITE_CHAT:
            callbacks_conversation.conversation_cbs[callback_name] = callback
        elif callback_name == callbacks_conversation.CALLBACK_CONVERSATION_WRITE_IM:
            callbacks_conversation.conversation_cbs[callback_name] = callback
        else:
            raise Exception(
                "Unknown callback '{callback_name}'".format(
                    callback_name=callback_name
                )
            )

    def signal_connect(self, *, str signal_name, object callback):
        '''Connects a signal handler to a callback for a particular object.
        Take care not to register a handler function twice. Purple will
        not correct any mistakes for you in this area.

        @param name Name of the signal to connect.
        @param cb Callback function.
        '''

        cdef int handle

        cdef list callbacks = libsignals.signal_cbs.get(signal_name, None)

        if callbacks is None:
            callbacks = []
            libsignals.signal_cbs[signal_name] = callbacks

            ##################
            ## Core Signals ##
            ##################
            if signal_name == libsignals_core.SIGNAL_CORE_QUITTING:
                c_libsignals.purple_signal_connect(
                    c_libcore.purple_get_core(),
                    libsignals_core.SIGNAL_CORE_QUITTING.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_core.signal_core_quitting_cb,
                    NULL,
                )

            #######################
            ## Connection Sinals ##
            #######################
            elif signal_name == libsignals_connection.SIGNAL_CONNECTION_SIGNING_ON:
                c_libsignals.purple_signal_connect(
                    c_libconnection.purple_connections_get_handle(),
                    libsignals_connection.SIGNAL_CONNECTION_SIGNING_ON.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_connection.signal_connection_signing_on_cb,
                    NULL,
                )
            elif signal_name == libsignals_connection.SIGNAL_CONNECTION_SIGNED_ON:
                c_libsignals.purple_signal_connect(
                    c_libconnection.purple_connections_get_handle(),
                    libsignals_connection.SIGNAL_CONNECTION_SIGNED_ON.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_connection.signal_connection_signed_on_cb,
                    NULL,
                )
            elif signal_name == libsignals_connection.SIGNAL_CONNECTION_SIGNING_OFF:
                c_libsignals.purple_signal_connect(
                    c_libconnection.purple_connections_get_handle(),
                    libsignals_connection.SIGNAL_CONNECTION_SIGNING_OFF.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_connection.signal_connection_signing_off_cb,
                    NULL,
                )
            elif signal_name == libsignals_connection.SIGNAL_CONNECTION_SIGNED_OFF:
                c_libsignals.purple_signal_connect(
                    c_libconnection.purple_connections_get_handle(),
                    libsignals_connection.SIGNAL_CONNECTION_SIGNED_OFF.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_connection.signal_connection_signed_off_cb,
                    NULL,
                )
            elif signal_name == libsignals_connection.SIGNAL_CONNECTION_CONNECTION_ERROR:
                c_libsignals.purple_signal_connect(
                    c_libconnection.purple_connections_get_handle(),
                    libsignals_connection.SIGNAL_CONNECTION_CONNECTION_ERROR.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_connection.signal_connection_connection_error_cb,
                    NULL,
                )

            ########################
            ## Buddy List Signals ##
            ########################
            elif signal_name == libsignals_blist.SIGNAL_BLIST_BUDDY_SIGNED_ON:
                c_libsignals.purple_signal_connect(
                    c_libblist.purple_blist_get_handle(),
                    libsignals_blist.SIGNAL_BLIST_BUDDY_SIGNED_ON.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_blist.signal_blist_buddy_signed_on_cb,
                    NULL,
                )
            elif signal_name == libsignals_blist.SIGNAL_BLIST_BUDDY_SIGNED_OFF:
                c_libsignals.purple_signal_connect(
                    c_libblist.purple_blist_get_handle(),
                    libsignals_blist.SIGNAL_BLIST_BUDDY_SIGNED_OFF.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_blist.signal_blist_buddy_signed_off_cb,
                    NULL
                )

            ##########################
            ## Conversation Signals ##
            ##########################
            elif signal_name == libsignals_conversation.SIGNAL_CONVERSATION_RECEIVING_IM_MSG:
                c_libsignals.purple_signal_connect(
                    c_libconversation.purple_conversations_get_handle(),
                    libsignals_conversation.SIGNAL_CONVERSATION_RECEIVING_IM_MSG.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_conversation.signal_conversation_receiving_im_msg_cb,
                    NULL,
                )
            elif signal_name == libsignals_conversation.SIGNAL_CONVERSATION_RECEIVED_IM_MSG:
                c_libsignals.purple_signal_connect(
                    c_libconversation.purple_conversations_get_handle(),
                    libsignals_conversation.SIGNAL_CONVERSATION_RECEIVED_IM_MSG.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_conversation.signal_conversation_received_im_msg_cb,
                    NULL,
                )
            elif signal_name == libsignals_conversation.SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG:
                c_libsignals.purple_signal_connect(
                    c_libconversation.purple_conversations_get_handle(),
                    libsignals_conversation.SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_conversation.signal_conversation_received_chat_msg_cb,
                    NULL,
                )
            elif signal_name == libsignals_conversation.SIGNAL_CONVERSATION_CHAT_JOINED:
                c_libsignals.purple_signal_connect(
                    c_libconversation.purple_conversations_get_handle(),
                    libsignals_conversation.SIGNAL_CONVERSATION_CHAT_JOINED.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_conversation.signal_conversation_chat_joined_cb,
                    NULL,
                )
            elif signal_name == libsignals_conversation.SIGNAL_CONVERSATION_CHAT_JOIN_FAILED:
                c_libsignals.purple_signal_connect(
                    c_libconversation.purple_conversations_get_handle(),
                    libsignals_conversation.SIGNAL_CONVERSATION_CHAT_JOIN_FAILED.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_conversation.signal_conversation_chat_join_failed_cb,
                    NULL,
                )
            elif signal_name == libsignals_conversation.SIGNAL_CONVERSATION_CHAT_LEFT:
                c_libsignals.purple_signal_connect(
                    c_libconversation.purple_conversations_get_handle(),
                    libsignals_conversation.SIGNAL_CONVERSATION_CHAT_LEFT.encode(),
                    &handle,
                    <c_libsignals.PurpleCallback> libsignals_conversation.signal_conversation_chat_left_cb,
                    NULL,
                )

            ####################
            ## Unknown Signal ##
            ####################
            else:
                raise Exception(
                    "Unknown signal '{signal_name}'".format(
                        signal_name=signal_name
                    )
                )

        callbacks.append(callback)


    def iterate_main_loop(self):
        glib.g_main_context_iteration(NULL, False)
        return True


    def call_action(self, i):
        callbacks_request.__call_action(i)
