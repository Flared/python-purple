from purple.signals cimport signals_enum as libsignals_enum

signal_cbs = {}

Signals = libsignals_enum.get_signals_enum()
