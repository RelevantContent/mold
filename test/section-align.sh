#!/bin/bash
. $(dirname $0)/common.inc

cat <<EOF | $CC -o $t/a.o -c -xc -fno-PIC -
__attribute__((section(".foo"))) int foo;
int main() {}
EOF

$CC -B. -o $t/exe1 $t/a.o -Wl,--section-align=.foo=0x2000
readelf -WS $t/exe1 | grep '\.foo.* 8192$'

$CC -B. -o $t/exe2 $t/a.o -Wl,--section-align=.foo=256
readelf -WS $t/exe2 | grep '\.foo.* 256$'

not $CC -B. -o $t/exe3 $t/a.o -Wl,--section-align=.foo=3 |&
  grep 'must be a power of 2'
