from libpurple cimport blist as c_blist

cdef void signal_blist_buddy_signed_on_cb(c_blist.PurpleBuddy *buddy)

cdef void signal_blist_buddy_signed_off_cb(c_blist.PurpleBuddy *buddy)
