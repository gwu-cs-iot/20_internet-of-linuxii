#!/bin/sh

./cos_loader \
"c0.o, ;*fprr.o, ;mpd.o,a4;l.o,a8;mm.o, ;print.o, ;te.o,a3;lock_t.o,a6;e.o,a3;schedconf.o, ;stat.o,a25;st.o, ;bc.o, ;plock.o, :\
\
c0.o-fprr.o;\
fprr.o-print.o|mm.o|st.o|schedconf.o|[parent_]bc.o;\
mpd.o-fprr.o|print.o|te.o|mm.o;\
l.o-fprr.o|mm.o|print.o|te.o;\
te.o-print.o|fprr.o|mm.o;\
mm.o-print.o;\
lock_t.o-print.o|te.o|fprr.o|mm.o|plock.o;\
plock.o-fprr.o|mm.o|print.o|te.o;\
e.o-fprr.o|print.o|mm.o|l.o|st.o;\
stat.o-te.o|fprr.o|l.o|print.o|e.o;\
st.o-print.o;\
schedconf.o-print.o;\
bc.o-print.o\
" ./gen_client_stub
