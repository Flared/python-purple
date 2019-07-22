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

    ##################
    ## Core Signals ##
    ##################
    @property
    def SIGNAL_CORE_QUITTING(self):
        return core_signals.SIGNAL_CORE_QUITTING

cdef _Signals get_signals_enum():
    return _Signals()
