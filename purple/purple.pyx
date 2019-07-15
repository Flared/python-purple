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

from libpurple cimport eventloop as c_eventloop
from libpurple cimport account as c_account
from libpurple cimport blist as c_blist
from libpurple cimport connection as c_connection
from libpurple cimport signals as c_signals
from libpurple cimport pounce as c_pounce
from libpurple cimport core as c_core
from libpurple cimport util as c_util
from libpurple cimport status as c_status
from libpurple cimport notify as c_notify
from libpurple cimport conversation as c_conversation
from libpurple cimport request as c_request
from libpurple cimport debug as c_debug

from purple.signals cimport core as signals_core
from purple.signals cimport blist as signals_blist
from purple.signals cimport connection as signals_connection
from purple.signals cimport conversation as signals_conversation

from purple cimport signals as p_signals

cdef extern from "c_purple.h":
    glib.guint glib_input_add(glib.gint fd,
                              c_eventloop.PurpleInputCondition condition,
                              c_eventloop.PurpleInputFunction function,
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

cdef c_account.PurpleAccountUiOps c_account_ui_ops
cdef c_blist.PurpleBlistUiOps c_blist_ui_ops
cdef c_connection.PurpleConnectionUiOps c_conn_ui_ops
cdef c_conversation.PurpleConversationUiOps c_conv_ui_ops
cdef c_core.PurpleCoreUiOps c_core_ui_ops
cdef c_eventloop.PurpleEventLoopUiOps c_eventloop_ui_ops
cdef c_notify.PurpleNotifyUiOps c_notify_ui_ops
cdef c_request.PurpleRequestUiOps c_request_ui_ops

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
            c_debug.purple_debug_set_enabled(debug_enabled)

        if default_path != b"":
            c_util.purple_util_set_user_dir(default_path)

        # libpurple's built-in DNS resolution forks processes to perform
        # blocking lookups without blocking the main process.  It does not
        # handle SIGCHLD itself, so if the UI does not you quickly get an army
        # of zombie subprocesses marching around.
        signal.signal(signal.SIGCHLD, signal.SIG_IGN)

    def destroy(self):
        c_core.purple_core_quit()

    def get_version(self):
        return c_core.purple_core_get_version()

    def __get_ui_name(self):
        '''Returns the UI name.

        @return UI name.
        '''

        global c_ui_name
        return c_ui_name
    ui_name = property(__get_ui_name)

    cdef void __core_ui_ops_ui_prefs_init(self):
        c_debug.purple_debug_info("core_ui_ops", "%s", "ui_prefs_init")
        prefs.purple_prefs_load()

        prefs.purple_prefs_add_none("/carman")

    cdef void __core_ui_ops_debug_init(self):
        c_debug.purple_debug_info("core_ui_ops", "%s", "debug_ui_init")
        pass

    cdef void __core_ui_ops_ui_init(self):
        c_debug.purple_debug_info("core_ui_ops", "%s", "ui_init")

        c_account.purple_accounts_set_ui_ops(&c_account_ui_ops)
        c_connection.purple_connections_set_ui_ops(&c_conn_ui_ops)
        c_blist.purple_blist_set_ui_ops(&c_blist_ui_ops)
        c_conversation.purple_conversations_set_ui_ops(&c_conv_ui_ops)
        c_notify.purple_notify_set_ui_ops(&c_notify_ui_ops)
        #privacy.purple_privacy_set_ui_ops(&c_privacy_ui_ops)
        c_request.purple_request_set_ui_ops(&c_request_ui_ops)
        #ft.purple_xfers_set_ui_ops(&c_ft_ui_ops)
        #roomlist.purple_roomlist_set_ui_ops(&c_rlist_ui_ops)

    cdef void __core_ui_ops_quit(self):
        c_debug.purple_debug_info("core_ui_ops", "%s", "quit")

        c_account.purple_accounts_set_ui_ops(NULL)
        c_connection.purple_connections_set_ui_ops(NULL)
        c_blist.purple_blist_set_ui_ops(NULL)
        c_conversation.purple_conversations_set_ui_ops(NULL)
        c_notify.purple_notify_set_ui_ops(NULL)
        #privacy.purple_privacy_set_ui_ops(NULL)
        c_request.purple_request_set_ui_ops(NULL)
        #ft.purple_xfers_set_ui_ops(NULL)
        #roomlist.purple_roomlist_set_ui_ops(NULL)

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
        c_conv_ui_ops.write_conv = callbacks_conversation.write_conv
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

        c_core.purple_core_set_ui_ops(&c_core_ui_ops)
        c_eventloop.purple_eventloop_set_ui_ops(&c_eventloop_ui_ops)

        # initialize purple core
        ret = c_core.purple_core_init(c_ui_name)
        if ret is False:
            c_debug.purple_debug_fatal("main", "%s", "libpurple " \
                                       "initialization failed.\n")
            return False

        # check if there is another instance of libpurple running
        if c_core.purple_core_ensure_single_instance() == False:
            c_debug.purple_debug_fatal("main", "%s", "Another instance of " \
                                      "libpurple is already running.\n")
            c_core.purple_core_quit()
            return False

        # create and load the buddy list
        c_blist.purple_set_blist(blist.purple_blist_new())
        c_blist.purple_blist_load()

        # load pounces
        c_pounce.purple_pounces_load()

        return ret

    def add_callback(self, str type, str name, object callback):
        '''Adds a callback with given name inside callback's type.

        @param type     Callback type (e.g. "account")
        @param name     Callback name (e.g. "notify-added")
        @param callback Callback to be called
        '''

        global connection_cbs
        global conversation_cbs
        global notify_cbs
        global request_cbs

        {
            "account": callbacks_account.account_cbs,
            "blist": callbacks_blist.blist_cbs,
            "connection": connection_cbs,
            "conversation": conversation_cbs,
            "notify": notify_cbs,
            "request": request_cbs,
        }[type][name] = callback

    def signal_connect(self, str name=None, object cb=None):
        '''Connects a signal handler to a callback for a particular object.
        Take care not to register a handler function twice. Purple will
        not correct any mistakes for you in this area.

        @param name Name of the signal to connect.
        @param cb Callback function.
        '''

        cdef int handle

        p_signals.signal_cbs[name] = cb

        ##################
        ## Core Signals ##
        ##################
        if name == "quitting":
            c_signals.purple_signal_connect(
                c_core.purple_get_core(),
                "quitting", &handle,
                <c_signals.PurpleCallback> signals_core.signal_core_quitting_cb, NULL)

        #######################
        ## Connection Sinals ##
        #######################
        elif name == "signed-on":
            c_signals.purple_signal_connect(
                    c_connection.purple_connections_get_handle(),
                    "signed-on", &handle,
                    <c_signals.PurpleCallback> signals_connection.signal_connection_signed_on_cb, NULL)
        elif name == "signed-off":
            c_signals.purple_signal_connect(
                    c_connection.purple_connections_get_handle(),
                    "signed-off", &handle,
                    <c_signals.PurpleCallback> signals_connection.signal_connection_signed_off_cb, NULL)
        elif name == "connection-error":
            c_signals.purple_signal_connect(
                    c_connection.purple_connections_get_handle(),
                    "connection-error", &handle,
                    <c_signals.PurpleCallback> signals_connection.signal_connection_connection_error_cb, NULL)

        ########################
        ## Buddy List Signals ##
        ########################
        elif name == "buddy-signed-on":
            c_signals.purple_signal_connect(
                    c_blist.purple_blist_get_handle(),
                    "buddy-signed-on", &handle,
                    <c_signals.PurpleCallback> signals_blist.signal_blist_buddy_signed_on_cb, NULL)
        elif name == "buddy-signed-off":
            c_signals.purple_signal_connect(
                    c_blist.purple_blist_get_handle(),
                    "buddy-signed-off", &handle,
                    <c_signals.PurpleCallback> signals_blist.signal_blist_buddy_signed_off_cb, NULL)

        ##########################
        ## Conversation Signals ##
        ##########################
        elif name == "receiving-im-msg":
            c_signals.purple_signal_connect(
                    c_conversation.purple_conversations_get_handle(),
                    "receiving-im-msg", &handle,
                    <c_signals.PurpleCallback> signals_conversation.signal_conversation_receiving_im_msg_cb, NULL)

        ####################
        ## Unknown Signal ##
        ####################
        else:
            raise Exception("Unknown signal")

    def accounts_get_all(self):
        '''Returns a list of all accounts.

        @return A list of all accounts.
        '''

        cdef glib.GList *iter
        cdef c_account.PurpleAccount *acc
        cdef char *username
        cdef char *protocol_id

        iter = c_account.purple_accounts_get_all()
        account_list = []

        while iter:
            acc = <c_account.PurpleAccount *> iter.data

            if <c_account.PurpleAccount *>acc:
                username = <char *> c_account.purple_account_get_username(acc)
                protocol_id = <char *> c_account.purple_account_get_protocol_id(acc)

                if username != NULL and protocol_id != NULL:
                    account_list.append(Account(username, \
                            Protocol(protocol_id), self))
            iter = iter.next

        return account_list

    def accounts_get_all_active(self):
        '''Returns a list of all enabled accounts.

        @return A list of all enabled accounts.
        '''

        cdef glib.GList *iter
        cdef c_account.PurpleAccount *acc
        cdef char *username
        cdef char *protocol_id

        #FIXME: The list is owned by the caller, and must be g_list_free()d
        #       to avoid leaking the nodes.

        iter = c_account.purple_accounts_get_all_active()
        account_list = []

        while iter:
            acc = <c_account.PurpleAccount *> iter.data

            if <c_account.PurpleAccount *>acc:
                username = <char *> c_account.purple_account_get_username(acc)
                protocol_id = <char *> c_account.purple_account_get_protocol_id(acc)

                if username != NULL and protocol_id != NULL:
                    account_list.append(Account(username, \
                            Protocol(protocol_id), self))
            iter = iter.next

        return account_list

    def iterate_main_loop(self):
        glib.g_main_context_iteration(NULL, False)
        return True

    def protocols_get_all(self):
        '''Returns a list of all protocols.

        @return A list of all protocols.
        '''

        cdef glib.GList *iter
        cdef plugin.PurplePlugin *pp

        iter = plugin.purple_plugins_get_protocols()
        protocol_list = []
        while iter:
            pp = <plugin.PurplePlugin*> iter.data
            if <bint> pp.info and <bint> pp.info.name:
                protocol_list.append(Protocol(pp.info.id))
            iter = iter.next
        return protocol_list

    def call_action(self, i):
        callbacks_request.__call_action(i)

include "protocol.pyx"
include "account.pyx"
