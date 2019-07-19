from libpurple cimport blist as c_libblist

cdef str SIGNAL_BLIST_BUDDY_SIGNED_ON
cdef void signal_blist_buddy_signed_on_cb(c_libblist.PurpleBuddy *buddy)

cdef str SIGNAL_BLIST_BUDDY_SIGNED_OFF
cdef void signal_blist_buddy_signed_off_cb(c_libblist.PurpleBuddy *buddy)
