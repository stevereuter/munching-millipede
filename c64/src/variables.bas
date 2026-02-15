# head, tail, pointers, loop, and food
h=0:lh=0:t=0:hx=0:tx=0:lp=0:di=0:fd=-1
# characters, poke registers, colors, level
mi=81:em=32:hr=83:bl=102:ps=52224:pc=55296:s=54272:sy=58732:gr=13:br=9:lv=2
# loop max, row, true, food count, grow, gameover, score, x, y, random number
lm=5000::rw=40:ru=-40:tr=-1:fc=0:gw=0:ov=0:sc=0:x=0:y=0:rn=0
# numbers
zr=0:n1=1:n2=2:n3=3:n4=4:n5=5:n6=6:n8=8
# directions, index, screen, background color, frequency, high score
r$="d":l$="a":u$="w":d$="s":i=0:pk=53280:bg=53281:f=0:hs=10

# set custom characters
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

# arrays
# path array
dim pa(900)
# map for blocks
dim m(1000)
# starting countdown test
dim s$(3)
# game over text
dim e$(8)
# intro music array
dim im(16)

# seed data
gosub initBorderArraySub
gosub initTextArraysSub
gosub seedMusicArraySub

# border grey
poke pk, 11
