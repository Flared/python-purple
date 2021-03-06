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

from libpurple cimport blist as c_libblist
from libpurple cimport account as c_libaccount
from libpurple cimport debug as c_libdebug

cdef extern from *:
    ctypedef char const_char "const char"

blist_cbs = {}

cdef void __group_node_cb(c_libblist.PurpleBlistNode *node, object callback):
    cdef c_libblist.PurpleGroup *group = <c_libblist.PurpleGroup *>node
    cdef char *c_name = NULL

    c_name = <char *> c_libblist.purple_group_get_name(group)
    cdef bytes name = c_name or None

    currentsize = c_libblist.purple_blist_get_group_size(group, False)
    totalsize = c_libblist.purple_blist_get_group_size(group, True)
    online = c_libblist.purple_blist_get_group_online_count(group)

    callback(node.type, name, totalsize, currentsize, online)

cdef void __contact_node_cb(c_libblist.PurpleBlistNode *node, object callback):
    cdef c_libblist.PurpleContact *contact = <c_libblist.PurpleContact *>node
    cdef char *c_alias = NULL

    c_alias = <char *> c_libblist.purple_contact_get_alias(contact)
    cdef bytes alias = c_alias or None

    callback(node.type, alias, contact.totalsize, contact.currentsize, \
             contact.online)

cdef void __buddy_node_cb(c_libblist.PurpleBlistNode *node, object callback):
    cdef c_libblist.PurpleBuddy *buddy = <c_libblist.PurpleBuddy *>node
    cdef char *c_name = NULL
    cdef char *c_alias = NULL

    c_name = <char *> c_libblist.purple_buddy_get_name(buddy)
    cdef bytes name = c_name or None

    c_alias = <char *> c_libblist.purple_buddy_get_alias_only(buddy)
    cdef bytes alias = c_alias or None

    callback(node.type, name, alias)

cdef void __chat_node_cb(c_libblist.PurpleBlistNode *node, object callback):
    cdef c_libblist.PurpleChat *chat = <c_libblist.PurpleChat *>node
    cdef char *c_name = NULL

    c_name = <char *> c_libblist.purple_chat_get_name(chat)
    cdef bytes name = c_name or None

    callback(node.type, name)

cdef void __other_node_cb(c_libblist.PurpleBlistNode *node, object callback):
    callback(node.type)

cdef void new_list(c_libblist.PurpleBuddyList *list):
    """
    Sets UI-specific data on a buddy list.
    """
    c_libdebug.purple_debug_info("blist", "%s", "new-list\n")
    if "new-list" in blist_cbs:
        (<object> blist_cbs["new-list"])("new-list: TODO")

cdef void new_node(c_libblist.PurpleBlistNode *node):
    """
    Sets UI-specific data on a node.
    """
    c_libdebug.purple_debug_info("blist", "%s", "new-node\n")
    if "new-node" in blist_cbs:
        if node.type == c_libblist.PURPLE_BLIST_GROUP_NODE:
            __group_node_cb(node, blist_cbs["new-node"])
        elif node.type == c_libblist.PURPLE_BLIST_CONTACT_NODE:
            __contact_node_cb(node, blist_cbs["new-node"])
        elif node.type == c_libblist.PURPLE_BLIST_BUDDY_NODE:
            __buddy_node_cb(node, blist_cbs["new-node"])
        elif node.type == c_libblist.PURPLE_BLIST_CHAT_NODE:
            __chat_node_cb(node, blist_cbs["new-node"])
        elif node.type == c_libblist.PURPLE_BLIST_OTHER_NODE:
            __other_node_cb(node, blist_cbs["new-node"])

cdef void show(c_libblist.PurpleBuddyList *list):
    """
    The core will call this when it's finished doing its core stuff.
    """
    c_libdebug.purple_debug_info("blist", "%s", "show")
    if "show" in blist_cbs:
        (<object> blist_cbs["show"])("show: TODO")

cdef void update(c_libblist.PurpleBuddyList *list, c_libblist.PurpleBlistNode *node):
    """
    This will update a node in the buddy list.
    """
    c_libdebug.purple_debug_info("blist", "%s", "update")
    if "update" in blist_cbs:
        if node.type == c_libblist.PURPLE_BLIST_GROUP_NODE:
            __group_node_cb(node, blist_cbs["update"])
        elif node.type == c_libblist.PURPLE_BLIST_CONTACT_NODE:
            __contact_node_cb(node, blist_cbs["update"])
        elif node.type == c_libblist.PURPLE_BLIST_BUDDY_NODE:
            __buddy_node_cb(node, blist_cbs["update"])
        elif node.type == c_libblist.PURPLE_BLIST_CHAT_NODE:
            __chat_node_cb(node, blist_cbs["update"])
        elif node.type == c_libblist.PURPLE_BLIST_OTHER_NODE:
            __other_node_cb(node, blist_cbs["update"])

cdef void remove(c_libblist.PurpleBuddyList *list, c_libblist.PurpleBlistNode *node):
    """
    This removes a node from the list.
    """
    c_libdebug.purple_debug_info("blist", "%s", "remove")
    if "remove" in blist_cbs:
        if node.type == c_libblist.PURPLE_BLIST_GROUP_NODE:
            __group_node_cb(node, blist_cbs["remove"])
        elif node.type == c_libblist.PURPLE_BLIST_CONTACT_NODE:
            __contact_node_cb(node, blist_cbs["remove"])
        elif node.type == c_libblist.PURPLE_BLIST_BUDDY_NODE:
            __buddy_node_cb(node, blist_cbs["remove"])
        elif node.type == c_libblist.PURPLE_BLIST_CHAT_NODE:
            __chat_node_cb(node, blist_cbs["remove"])
        elif node.type == c_libblist.PURPLE_BLIST_OTHER_NODE:
            __other_node_cb(node, blist_cbs["remove"])

cdef void destroy(c_libblist.PurpleBuddyList *list):
    """
    When the list gets destroyed, this gets called to destroy the UI.
    """
    c_libdebug.purple_debug_info("blist", "%s", "destroy")
    if "destroy" in blist_cbs:
        (<object> blist_cbs["destroy"])("destroy: TODO")

cdef void set_visible(c_libblist.PurpleBuddyList *list, glib.gboolean show):
    """
    Hides or unhides the buddy list.
    """
    c_libdebug.purple_debug_info("blist", "%s", "set-visible\n")
    if "set-visible" in blist_cbs:
        (<object> blist_cbs["set-visible"])("set-visible: TODO")

cdef void request_add_buddy(c_libaccount.PurpleAccount *account,
                            const_char *c_buddy_username,
                            const_char *c_buddy_group,
                            const_char *c_buddy_alias):
    """
    Requests from the user information needed to add a buddy to the buddy
    list.
    """
    c_libdebug.purple_debug_info("blist", "%s", "request-add-buddy\n")

    username = c_libaccount.purple_account_get_username(account)
    protocol_id = c_libaccount.purple_account_get_protocol_id(account)

    cdef bytes buddy_username = c_buddy_username or None
    cdef bytes buddy_group = c_buddy_group or None
    cdef bytes buddy_alias = c_buddy_alias or None

    if "request-add-buddy" in blist_cbs:
        (<object> blist_cbs["request-add-buddy"])( \
            (username, protocol_id), buddy_username, buddy_group, buddy_alias)

cdef void request_add_chat(c_libaccount.PurpleAccount *acc,
                           c_libblist.PurpleGroup *group,
                           const_char *alias,
                           const_char *name):
    """
    TODO
    """
    c_libdebug.purple_debug_info("blist", "%s", "request-add-chat\n")
    if "request-add-chat" in blist_cbs:
        (<object> blist_cbs["request-add-chat"])("request-add-chat: TODO")

cdef void request_add_group():
    """
    TODO
    """
    c_libdebug.purple_debug_info("blist", "%s", "request-add-group\n")
    if "request-add-group" in blist_cbs:
        (<object>blist_cbs["request-add-group"])("request-add-group: TODO")
