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

from libpurple cimport blist as c_blist
from libpurple cimport account as c_account

cdef extern from *:
    ctypedef char const_char "const char"

cdef object blist_cbs

cdef void new_list(c_blist.PurpleBuddyList *list)

cdef void new_node(c_blist.PurpleBlistNode *node)

cdef void show(c_blist.PurpleBuddyList *list)

cdef void update(c_blist.PurpleBuddyList *list, c_blist.PurpleBlistNode *node)

cdef void remove(c_blist.PurpleBuddyList *list, c_blist.PurpleBlistNode *node)

cdef void destroy(c_blist.PurpleBuddyList *list)

cdef void set_visible(c_blist.PurpleBuddyList *list, glib.gboolean show)

cdef void request_add_buddy(c_account.PurpleAccount *account,
                            const_char *c_buddy_username,
                            const_char *c_buddy_group,
                            const_char *c_buddy_alias)

cdef void request_add_chat(c_account.PurpleAccount *acc,
                           c_blist.PurpleGroup *group,
                           const_char *alias,
                           const_char *name)

cdef void request_add_group()
