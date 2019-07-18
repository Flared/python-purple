from libpurple cimport debug as c_libdebug

cimport purple.signals as libsignals
 
cdef extern from *:
    ctypedef char const_gchar "const gchar"

cdef void signal_core_quitting_cb():
    """
    Emitted when libpurple is quitting.
    """
    c_libdebug.purple_debug_info("core", "%s", "quitting\n")
    cdef char *c_name = NULL

    for callback in libsignals.signal_cbs.get("quitting", tuple()):
        callback()
