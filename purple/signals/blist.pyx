from libpurple cimport blist as c_libblist

from purple cimport signals as libsignals

cdef void signal_blist_buddy_signed_on_cb(c_libblist.PurpleBuddy *buddy):
    """
    Emitted when a buddy on your buddy list signs on.
    @params buddy  The buddy that signed on.
    """
    cdef char *c_name = NULL
    cdef char *c_alias = NULL

    c_name = <char *> c_libblist.purple_buddy_get_name(buddy)
    if c_name == NULL:
        name = None
    else:
        name = c_name

    c_alias = <char *> c_libblist.purple_buddy_get_alias_only(buddy)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    for callback in libsignals.signal_cbs.get("buddy-signed-on", tuple()):
        callback(name, alias)

cdef void signal_blist_buddy_signed_off_cb(c_libblist.PurpleBuddy *buddy):
    """
    Emitted when a buddy on your buddy list signs off.
    @params buddy  The buddy that signed off.
    """
    cdef char *c_name = NULL
    cdef char *c_alias = NULL

    c_name = <char *> c_libblist.purple_buddy_get_name(buddy)
    if c_name == NULL:
        name = None
    else:
        name = c_name

    c_alias = <char *> c_libblist.purple_buddy_get_alias_only(buddy)
    if c_alias == NULL:
        alias = None
    else:
        alias = c_alias

    for callback in libsignals.signal_cbs.get("buddy-signed-off", tuple()):
        callback(name, alias)
