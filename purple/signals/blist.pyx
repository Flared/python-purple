from libpurple cimport blist as c_libblist

from purple cimport signals

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

    if "buddy-signed-on" in signals.signal_cbs:
        (<object> signals.signal_cbs["buddy-signed-on"])(name, alias)

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

    if "buddy-signed-off" in signals.signal_cbs:
        (<object> signals.signal_cbs["buddy-signed-off"])(name, alias)

