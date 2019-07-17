cimport purple.signals as c_libsignals

from libpurple cimport debug
 
cdef extern from *:
    ctypedef char const_gchar "const gchar"

cdef void signal_core_quitting_cb():
    """
    Emitted when libpurple is quitting.
    """
    debug.purple_debug_info("core", "%s", "quitting\n")
    cdef char *c_name = NULL

    if "quitting" in c_libsignals.signal_cbs:
        (<object> c_libsignals.signal_cbs["quitting"])()
