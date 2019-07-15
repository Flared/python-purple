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

from libpurple cimport conversation as c_conversation
from libpurple cimport debug as c_debug

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef glib.guchar const_guchar "const guchar"
    ctypedef long int time_t

cdef object conversation_cbs

cdef void create_conversation(c_conversation.PurpleConversation *conv)

cdef void destroy_conversation(c_conversation.PurpleConversation *conv)

cdef void write_chat(c_conversation.PurpleConversation *conv,
                     const_char *who,
                     const_char *message,
                     c_conversation.PurpleMessageFlags flags,
                     time_t mtime)

cdef void write_im(c_conversation.PurpleConversation *conv,
                   const_char *who,
                   const_char *c_message,
                   c_conversation.PurpleMessageFlags flags,
                   time_t mtime)

cdef void write_conv(c_conversation.PurpleConversation *conv,
                     const_char *name,
                     const_char *alias,
                     const_char *message,
                     c_conversation.PurpleMessageFlags flags,
                     time_t mtime)

cdef void chat_add_users(c_conversation.PurpleConversation *conv,
                         glib.GList *cbuddies,
                         glib.gboolean new_arrivals)

cdef void chat_rename_user(c_conversation.PurpleConversation *conv,
                           const_char *old_name,
                           const_char *new_name,
                           const_char *new_alias)

cdef void chat_remove_users(c_conversation.PurpleConversation *conv,
                            glib.GList *users)

cdef void chat_update_user(c_conversation.PurpleConversation *conv,
                           const_char *user)

cdef void present(c_conversation.PurpleConversation *conv)

cdef glib.gboolean has_focus(c_conversation.PurpleConversation *conv)

cdef glib.gboolean custom_smiley_add(c_conversation.PurpleConversation *conv,
                                     const_char *smile,
                                     glib.gboolean remote)

cdef void custom_smiley_write(c_conversation.PurpleConversation *conv,
                              const_char *smile,
                              const_guchar *data,
                              glib.gsize size)

cdef void custom_smiley_close(c_conversation.PurpleConversation *conv,
                              const_char *smile)

cdef void send_confirm(c_conversation.PurpleConversation *conv,
                       const_char *message)
