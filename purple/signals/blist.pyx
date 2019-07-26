from libpurple cimport blist as c_libblist

from purple cimport signals as libsignals

cdef str SIGNAL_BLIST_BUDDY_SIGNED_ON = "buddy-signed-on"
cdef void signal_blist_buddy_signed_on_cb(c_libblist.PurpleBuddy *buddy):
    """
    Emitted when a buddy on your buddy list signs on.
    @params buddy  The buddy that signed on.
    """
    cdef char *c_name = NULL
    cdef char *c_alias = NULL

    c_name = <char *> c_libblist.purple_buddy_get_name(buddy)
    cdef bytes name = c_name or None

    c_alias = <char *> c_libblist.purple_buddy_get_alias_only(buddy)
    cdef bytes alias = c_alias or None

    for callback in libsignals.signal_cbs.get(SIGNAL_BLIST_BUDDY_SIGNED_ON, tuple()):
        callback(name, alias)

cdef str SIGNAL_BLIST_BUDDY_SIGNED_OFF = "buddy-signed-off"
cdef void signal_blist_buddy_signed_off_cb(c_libblist.PurpleBuddy *buddy):
    """
    Emitted when a buddy on your buddy list signs off.
    @params buddy  The buddy that signed off.
    """
    cdef char *c_name = NULL
    cdef char *c_alias = NULL

    c_name = <char *> c_libblist.purple_buddy_get_name(buddy)
    cdef bytes name = c_name or None

    c_alias = <char *> c_libblist.purple_buddy_get_alias_only(buddy)
    cdef bytes alias = c_alias or None

    for callback in libsignals.signal_cbs.get(SIGNAL_BLIST_BUDDY_SIGNED_OFF, tuple()):
        callback(name, alias)
