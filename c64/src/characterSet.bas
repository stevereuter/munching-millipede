# Switch VIC to Bank 3
poke 56576, peek(56576) and 252

# Set Screen to 52224, Chars at 49152
poke 53272, 48

# Tell BASIC the screen moved
poke 648, 204

print "{clr}the munching millipede v1.0.5"
print "{down}by steviesaurus dev"
print "{down}{209}{209}{209}{209}{209}{209}{210}"

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

# update custom left, body, right
hx=80*8
for i=cr+hx to cr+hx+23
    read h
    poke i,h
next

# update custom up
hx=41*8
for i=cr+hx to cr+hx+7
    read h
    poke i,h
next

# update custom down
hx=121*8
for i=cr+hx to cr+hx+7
    read h
    poke i,h
next
