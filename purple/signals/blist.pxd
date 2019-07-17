from libpurple cimport blist as c_libblist

cdef void signal_blist_buddy_signed_on_cb(c_libblist.PurpleBuddy *buddy)

cdef void signal_blist_buddy_signed_off_cb(c_libblist.PurpleBuddy *buddy)
