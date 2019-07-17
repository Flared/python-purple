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
from libpurple cimport blist as c_libblist
from libpurple cimport connection as c_libconnection
from libpurple cimport conversation as c_libconversation
from libpurple cimport prpl as c_libprpl

cdef extern from *:
    ctypedef char const_char "const char"
    ctypedef long int time_t

cdef extern from "libpurple/server.h":
    unsigned int serv_send_typing(c_libconnection.PurpleConnection *gc,
                                  const_char *name,
                                  c_libconversation.PurpleTypingState state)

    void serv_move_buddy(c_libblist.PurpleBuddy*,
                         c_libblist.PurpleGroup*,
                         c_libblist.PurpleGroup*)

    int serv_send_im(c_libconnection.PurpleConnection *,
                     const_char *,
                     const_char *,
                     c_libconversation.PurpleMessageFlags flags)

    c_libprpl.PurpleAttentionType *purple_get_attention_type_from_code(c_libaccount.PurpleAccount *account,
                                                                       glib.guint type_code)

    void serv_send_attention(c_libconnection.PurpleConnection *gc,
                             const_char *who,
                             glib.guint type_code)

    void serv_got_attention(c_libconnection.PurpleConnection *gc,
                            const_char *who,
                            glib.guint type_code)

    void serv_get_info(c_libconnection.PurpleConnection *, const_char *)

    void serv_set_info(c_libconnection.PurpleConnection *, const_char *)

    void serv_add_permit(c_libconnection.PurpleConnection *, const_char *)

    void serv_add_deny(c_libconnection.PurpleConnection *, const_char *)

    void serv_rem_permit(c_libconnection.PurpleConnection *, const_char *)

    void serv_rem_deny(c_libconnection.PurpleConnection *, const_char *)

    void serv_set_permit_deny(c_libconnection.PurpleConnection*)

    void serv_chat_invite(c_libconnection.PurpleConnection*,
                          int,
                          const_char *,
                          const_char *)

    void serv_chat_leave(c_libconnection.PurpleConnection *, int)

    void serv_chat_whisper(c_libconnection.PurpleConnection *,
                           int,
                           const_char *,
                           const_char *)

    int serv_chat_send(c_libconnection.PurpleConnection*,
                       int,
                       const_char *,
                       c_libconversation.PurpleMessageFlags flags)

    void serv_alias_buddy(c_libblist.PurpleBuddy*)

    void serv_got_alias(c_libconnection.PurpleConnection *gc,
                        const_char *who,
                        const_char *alias)

    void purple_serv_got_private_alias(c_libconnection.PurpleConnection *gc,
                                       const_char *who,
                                       const_char *alias)

    void serv_got_typing(c_libconnection.PurpleConnection *gc,
                         const_char *name,
                         int timeout,
                         c_libconversation.PurpleTypingState state)

    void serv_got_typing_stopped(c_libconnection.PurpleConnection *gc,
                                 const_char *name)

    void serv_got_im(c_libconnection.PurpleConnection *gc,
                     const_char *who,
                     const_char *msg,
                     c_libconversation.PurpleMessageFlags flags,
                     time_t mtime)

    void serv_join_chat(c_libconnection.PurpleConnection*,
                        glib.GHashTable *data)

    void serv_reject_chat(c_libconnection.PurpleConnection*,
                          glib.GHashTable *data)

    void serv_got_chat_invite(c_libconnection.PurpleConnection *gc,
                              const_char *name,
                              const_char *who,
                              const_char *message,
                              glib.GHashTable *data)

    c_libconversation.PurpleConversation *serv_got_joined_chat(c_libconnection.PurpleConnection *gc,
                                                               int id,
                                                               const_char *name)

    void purple_serv_got_join_chat_failed(c_libconnection.PurpleConnection *gc,
                                          glib.GHashTable *data)

    void serv_got_chat_left(c_libconnection.PurpleConnection *g, int id)

    void serv_got_chat_in(c_libconnection.PurpleConnection *g,
                          int id,
                          const_char *who,
                          c_libconversation.PurpleMessageFlags flags,
                          const_char *message,
                          time_t mtime)

    void serv_send_file(c_libconnection.PurpleConnection *gc,
                        const_char *who,
                        const_char *file)
