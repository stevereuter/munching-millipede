# Switch VIC to Bank 3
poke 56576, peek(56576) and 252

# Set Screen to 52224, Chars at 49152
poke 53272, 48

# Tell BASIC the screen moved
poke 648, 204

print "{clr}the munching millipede v###VERSION### c64"
print "{down}<c>2026 steviesaurus dev"
print "{down}steviesaurus-dev.itch.io"
print "{down}{209}{209}{209}{209}{209}{209}{210}"

# add custom characters
# letters
hx=8
for i=cr+hx to cr+hx+25*8+7
    read h
    poke i, h
    poke 1024+i, 255 - h
next

# empty
hx=32*8
for i=cr+hx to cr+hx+7
    poke i, 0
    poke 1024+i, 255
next

# period
hx=46*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

# exclamation mark
for i=264 to 271
    read h
    poke cr+i, h
next

# asterisk
for i=336 to 343
    read h
    poke cr+i, h
next

# numbers. colon
for i=384 to 471
    read h
    poke cr+i, h
    poke cr+1024+i, 255 - h
next

# reversed circle
hx=81*8
for i=cr+hx to cr+hx+7
    read h
    poke 1024+i, h
next

# heart
hx=83*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

# checkered block
hx=bl*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

# millipede head left, body, head right
hx=80*8
for i=cr+hx to cr+hx+23
    read h
    poke i,h
next

# millipede head up
hx=41*8
for i=cr+hx to cr+hx+7
    read h
    poke i,h
next

# millipede head down
hx=121*8
for i=cr+hx to cr+hx+7
    read h
    poke i,h
next

# slash
hx=47*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

# comma
hx=44*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

# question mark
hx=63*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

# arrow left
hx=60*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

# arrow right
hx=62*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

# dash
hx=45*8
for i=cr+hx to cr+hx+7
    read h
    poke i, h
next

