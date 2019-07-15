cimport purple.signals as p_signals

from libpurple cimport debug
 
cdef extern from *:
    ctypedef char const_gchar "const gchar"

cdef void signal_core_quitting_cb():
    """
    Emitted when libpurple is quitting.
    """
    debug.purple_debug_info("core", "%s", "quitting\n")
    cdef char *c_name = NULL

    if "quitting" in p_signals.signal_cbs:
        (<object> p_signals.signal_cbs["quitting"])()
