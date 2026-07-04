# handles loading multiple files from disc
# loading switch
if l=0 then l=1
on l goto loadSplashScreen, loadSplashScreenChars, loadSplashScreenColors, loadGameChars, loadComplete

# load splash screen memory
loadSplashScreen:
l=2
# set background to light blue
poke 53281, 14
load "screen", 8, 1

# load splash screen characters
loadSplashScreenChars:
l=3
# Switch VIC to Bank 2
poke 56576, (peek(56576) and 252) or 1
# switch to multi color mode
poke 53272, 222
# set shared 1 color
poke 53282, 5
# set shared 2 color
poke 53283, 11
# Set screen block 13 and char block 7
poke 53270, peek(53270) or 16
load "splash", 8, 1

# load splash screen colors
loadSplashScreenColors:
l=4
load "color", 8, 1

# load game characters
loadGameChars:
l=5
load "chars", 8, 1

loadComplete:
# switch to game characters now
# Switch VIC to Bank 3
poke 56576, peek(56576) and 252
# Set chars block 0 (49152) and screen block 3 (52224)
poke 53272, 48
# Tell BASIC the screen moved to 52224
poke 648, 204
# switch to standard character mode
poke 53270, peek(53270) and 239
