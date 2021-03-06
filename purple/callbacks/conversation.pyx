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

from libpurple cimport conversation as c_libconversation
from libpurple cimport debug as c_libdebug
from libpurple cimport account as c_libaccount
from libpurple cimport blist as c_libblist

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef glib.guchar const_guchar "const guchar"
    ctypedef long int time_t

conversation_cbs = {}

cdef void create_conversation(c_libconversation.PurpleConversation *conv):
    """
    Called when a conv is created (but before the conversation-created
    signal is emitted).
    """
    c_libdebug.purple_debug_info("conversation", "%s", "create-conversation\n")
    cdef char *c_name = NULL

    c_name = <char *> c_libconversation.purple_conversation_get_name(conv)
    cdef name = c_name or None

    type = c_libconversation.purple_conversation_get_type(conv)

    if "create-conversation" in conversation_cbs:
        (<object> conversation_cbs["create-conversation"])(name, type)

cdef void destroy_conversation(c_libconversation.PurpleConversation *conv):
    """
    Called just before a conv is freed.
    """
    c_libdebug.purple_debug_info("conversation", "%s", "destroy-conversation\n")
    if "destroy-conversation" in conversation_cbs:
        (<object> conversation_cbs["destroy-conversation"]) \
            ("destroy-conversation: TODO")

cdef void write_chat(c_libconversation.PurpleConversation *conv,
                     const_char *who,
                     const_char *message,
                     c_libconversation.PurpleMessageFlags flags,
                     time_t mtime):
    """
    Write a message to a chat. If this field is NULL, libpurple will fall
    back to using write_conv.
    @see purple_conv_chat_write()
    """
    c_libdebug.purple_debug_info("conversation", "%s", "write-chat\n")
    if "write-chat" in conversation_cbs:
        (<object> conversation_cbs["write-chat"])("write-chat: TODO")

cdef void write_im(c_libconversation.PurpleConversation *conv,
                   const_char *who,
                   const_char *c_message,
                   c_libconversation.PurpleMessageFlags flags,
                   time_t mtime):
    """
    Write a message to an IM conversation. If this field is NULL, libpurple
    will fall back to using write_conv.
    @see purple_conv_im_write()
    """
    c_libdebug.purple_debug_info("conversation", "%s", "write-im\n")
    cdef c_libaccount.PurpleAccount *acc = \
        c_libconversation.purple_conversation_get_account(conv)
    cdef c_libblist.PurpleBuddy *buddy = NULL
    cdef char *c_username = NULL
    cdef char *c_sender_alias = NULL

    c_username = <char *> c_libaccount.purple_account_get_username(acc)
    cdef username = c_username or None

    if who == NULL:
        who = c_libconversation.purple_conversation_get_name(conv)

    sender = <char *> who
    buddy = c_libblist.purple_find_buddy(acc, <char *> who)
    if buddy:
        c_sender_alias = <char *> c_libblist.purple_buddy_get_alias_only(buddy)

    if c_sender_alias:
        sender_alias = unicode(c_sender_alias, 'utf-8')
    else:
        sender_alias = None

    cdef message = c_message or None

    # FIXME: Maybe we need add more purple flags in the future
    if (<int>flags & c_libconversation.PURPLE_MESSAGE_SEND):
        flag = "SEND"
    else:
        flag = "RECV"

    if "write-im" in conversation_cbs:
        (<object> conversation_cbs["write-im"])(
            username,
            sender,
            sender_alias,
            message,
            flag
        )

cdef void write_conv(c_libconversation.PurpleConversation *conv,
                     const_char *name,
                     const_char *alias,
                     const_char *message,
                     c_libconversation.PurpleMessageFlags flags,
                     time_t mtime):
    """
    Write a message to a conversation. This is used rather than the chat- or
    im-specific ops for errors, system messages (such as "x is now known as
    y"), and as the fallback if write_im and write_chat are not implemented.
    It should be implemented, or the UI will miss conversation error messages
    and your users will hate you.
    @see purple_conversation_write()
    """
    c_libdebug.purple_debug_info("conversation", "%s", "write-conv\n")
    if "write-conv" in conversation_cbs:
        (<object> conversation_cbs["write-conv"])("write-conv: TODO")

cdef void chat_add_users(c_libconversation.PurpleConversation *conv,
                         glib.GList *cbuddies,
                         glib.gboolean new_arrivals):
    """
    Add cbuddies to a chat.
    @param cbuddies  A GList of PurpleConvChatBuddy structs.
    @param new_arrivals  Wheter join notices should be shown.
                         (Join notices are actually written to the
                         conversation by purple_conv_chat_add_users().)
    @see purple_conv_chat_add_users()
    """
    c_libdebug.purple_debug_info("conversation", "%s", "chat-add-users\n")
    if "chat-add-users" in conversation_cbs:
        (<object> conversation_cbs["chat-add-users"])("chat-add-users: TODO")

cdef void chat_rename_user(c_libconversation.PurpleConversation *conv,
                           const_char *old_name,
                           const_char *new_name,
                           const_char *new_alias):
    """
    Rename the user in this chat name old_name to new_name. (The rename
    message is written to the conversation by libpurple.)
    @param new_alias  new_name's new_alias, if they have one.
    @see purple_conv_chat_rename_user()
    """
    c_libdebug.purple_debug_info("conversation", "%s", "chat-rename-user\n")
    if "chat-rename-user" in conversation_cbs:
        (<object> conversation_cbs["chat-rename-user"]) \
            ("chat-rename-user: TODO")

cdef void chat_remove_users(c_libconversation.PurpleConversation *conv,
                            glib.GList *users):
    """
    Remove users from a chat.
    @param  users  A GList of const char *s.
    """
    c_libdebug.purple_debug_info("conversation", "%s", "chat-remove-users\n")
    if "chat-remove-users" in conversation_cbs:
        (<object> conversation_cbs["chat-remove-users"]) \
            ("chat-remove-users: TODO")

cdef void chat_update_user(c_libconversation.PurpleConversation *conv,
                           const_char *user):
    """
    Called when a user's flags are changed.
    @see purple_conv_chat_user_set_flags()
    """
    c_libdebug.purple_debug_info("conversation", "%s", "chat-update-user\n")
    if "chat-update-user" in conversation_cbs:
        (<object> conversation_cbs["chat-update-user"]) \
            ("chat-update-user: TODO")

cdef void present(c_libconversation.PurpleConversation *conv):
    """
    Present this conversation to the user; for example, by displaying the IM
    dialog.
    """
    c_libdebug.purple_debug_info("conversation", "%s", "present")
    if "present" in conversation_cbs:
        (<object> conversation_cbs["present"])("present: TODO")

cdef glib.gboolean has_focus(c_libconversation.PurpleConversation *conv):
    """
    If this UI has a concept of focus (as in a windowing system) and this
    conversation has the focus, return TRUE; otherwise, return FALSE.
    """
    c_libdebug.purple_debug_info("conversation", "%s", "has-focus\n")
    if "has-focus" in conversation_cbs:
        (<object> conversation_cbs["has-focus"])("has-focus: TODO")
    return False

cdef glib.gboolean custom_smiley_add(c_libconversation.PurpleConversation *conv,
                                     const_char *smile,
                                     glib.gboolean remote):
    """
    Custom smileys (add).
    """
    c_libdebug.purple_debug_info("conversation", "%s", "custom-smiley-add\n")
    if "custom-smiley-add" in conversation_cbs:
        (<object> conversation_cbs["custom-smiley-add"]) \
            ("custom-smiley-add: TODO")
    return False

cdef void custom_smiley_write(c_libconversation.PurpleConversation *conv,
                              const_char *smile,
                              const_guchar *data,
                              glib.gsize size):
    """
    Custom smileys (write).
    """
    c_libdebug.purple_debug_info("conversation", "%s", "custom-smiley-write\n")
    if "custom-smiley-write" in conversation_cbs:
        (<object> conversation_cbs["custom-smiley-write"]) \
            ("custom-smiley-write: TODO")

cdef void custom_smiley_close(c_libconversation.PurpleConversation *conv,
                              const_char *smile):
    """
    Custom smileys (close).
    """
    c_libdebug.purple_debug_info("conversation", "%s", "custom-smiley-close\n")
    if "custom-smiley-close" in conversation_cbs:
        (<object> conversation_cbs["custom-smiley-close"]) \
            ("custom-smiley-close: TODO")

cdef void send_confirm(c_libconversation.PurpleConversation *conv,
                       const_char *message):
    """
    Prompt the user for confirmation to send mesage. This function should
    arrange for the message to be sent if the user accepts. If this field
    is NULL, libpurple will fall back to using purple_request_action().
    """
    c_libdebug.purple_debug_info("conversation", "%s", "send-confirm\n")
    if "send-confirm" in conversation_cbs:
        (<object> conversation_cbs["send-confirm"])("send-confirm: TODO")
