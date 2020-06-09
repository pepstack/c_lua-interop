noinst_LIBRARIES = libluacontext.a

libluacontext_a_SOURCES = luacontext.c

libluacontext_a_LIBADD = $(top_srcdir)/libs/lib/liblua.a

DEFS += -D_GNU_SOURCE

AM_CPPFLAGS = -I$(top_srcdir)/src \
    -I$(top_srcdir)/libs/include
