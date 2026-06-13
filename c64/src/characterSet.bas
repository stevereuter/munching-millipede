# Switch VIC to Bank 3
poke 56576, peek(56576) and 252

# Set Screen to 52224, Chars at 49152
poke 53272, 48

# Tell BASIC the screen moved
poke 648, 204

print "{clr}the munching millipede v###VERSION### c64"
print "{down}@2026 steviesaurus dev"
print "{down}steviesaurus-dev.itch.io"
print "{down}{209}{209}{209}{209}{209}{209}{210}"
