#
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

from purple.signals cimport core as core_signals
from purple.signals cimport conversation as conversation_signals
from purple.signals cimport connection as connection_signals
from purple.signals cimport blist as blist_signals


cdef class _Signals:

    ###########
    ## Blist ##
    ###########
    @property
    def SIGNAL_BLIST_BUDDY_SIGNED_ON(self):
        return blist_signals.SIGNAL_BLIST_BUDDY_SIGNED_ON

    @property
    def SIGNAL_BLIST_BUDDY_SIGNED_OFF(self):
        return blist_signals.SIGNAL_BLIST_BUDDY_SIGNED_OFF

    ################
    ## Connection ##
    ################
    @property
    def SIGNAL_CONNECTION_SIGNING_ON(self):
        return connection_signals.SIGNAL_CONNECTION_SIGNING_ON

    @property
    def SIGNAL_CONNECTION_SIGNED_ON(self):
        return connection_signals.SIGNAL_CONNECTION_SIGNED_ON

    @property
    def SIGNAL_CONNECTION_SIGNING_OFF(self):
        return connection_signals.SIGNAL_CONNECTION_SIGNING_OFF

    @property
    def SIGNAL_CONNECTION_SIGNED_OFF(self):
        return connection_signals.SIGNAL_CONNECTION_SIGNED_OFF

    @property
    def SIGNAL_CONNECTION_CONNECTION_ERROR(self):
        return connection_signals.SIGNAL_CONNECTION_CONNECTION_ERROR

    ##################
    ## Conversation ##
    ##################
    @property
    def SIGNAL_CONVERSATION_RECEIVING_IM_MSG(self):
        return conversation_signals.SIGNAL_CONVERSATION_RECEIVING_IM_MSG

    @property
    def SIGNAL_CONVERSATION_RECEIVED_IM_MSG(self):
        return conversation_signals.SIGNAL_CONVERSATION_RECEIVED_IM_MSG

    @property
    def SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG(self):
        return conversation_signals.SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG

    @property
    def SIGNAL_CONVERSATION_CHAT_JOINED(self):
        return conversation_signals.SIGNAL_CONVERSATION_CHAT_JOINED

    @property
    def SIGNAL_CONVERSATION_CHAT_LEFT(self):
        return conversation_signals.SIGNAL_CONVERSATION_CHAT_LEFT

    @property
    def SIGNAL_CONVERSATION_CHAT_JOIN_FAILED(self):
        return conversation_signals.SIGNAL_CONVERSATION_CHAT_JOIN_FAILED

    ##################
    ## Core Signals ##
    ##################
    @property
    def SIGNAL_CORE_QUITTING(self):
        return core_signals.SIGNAL_CORE_QUITTING

cdef _Signals get_signals_enum():
    return _Signals()
