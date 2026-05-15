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
for i=cr to cr+(256*8)-1
    read h
    poke i, h
next
