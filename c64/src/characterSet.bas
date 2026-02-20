# 1. Stop Interrupts
poke 56334, peek(56334) and 254

# 2. Reveal Character ROM (CPU sees ROM at $D000)
poke 1, 51

# 3. Copy main characters from ROM to RAM
# letters
for i=8 to 208
    c=peek(53248+i)
    poke 49152+i, c
    poke 49152+1024+i, 255 - c
next
# empty
for i=256 to 263
    poke 49152+i, 0
    poke 49152+1024+i, 255
next
# exclamation mark
for i=264 to 271
    c=peek(53248+i)
    poke 49152+i, c
next
# asterisk
for i=336 to 343
    c=peek(53248+i)
    poke 49152+i, c
next
# numbers. colon
for i=348 to 472
    c=peek(53248+i)
    poke 49152+i, c
    poke 49152+1024+i, 255 - c
next
# reversed circle
for i=648 to 655
    c=peek(53248+i)
    poke 49152+1024+i, 255 - c
next
# heart
for i=664 to 671
    c=peek(53248+i)
    poke 49152+i, c
next
# checkered block
for i=816 to 823
    c=peek(53248+i)
    poke 49152+i, c
next

# 4. Restore I/O and BASIC
poke 1, 55
poke 56334, peek(56334) or 1

# 5. Switch VIC to Bank 3
poke 56576, peek(56576) and 252

# 6. Set Screen to $CC00 (204) and Chars to $C000 (0)
# The 48 = Screen at $CC00 (3*1K), Chars at $C000 (0*2K)
poke 53272, 48

# 7. Tell BASIC the screen moved
poke 648, 204

# update custom left, body, right
hx=80*8
for i=49152+hx to 49152+hx+23
    read h
    poke i,h
next
# update custom up
hx=41*8
for i=49152+hx to 49152+hx+7
    read h
    poke i,h
next
# update custom down
hx=121*8
for i=49152+hx to 49152+hx+7
    read h
    poke i,h
next
