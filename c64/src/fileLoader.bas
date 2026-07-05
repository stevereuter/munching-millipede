# handles loading multiple files from disc
# loading switch
h=h+1
on h goto loadSplashScreen, loadSplashScreenChars, loadSplashScreenColors, loadGameChars, loadComplete

# load splash screen memory
loadSplashScreen:
# set background to light blue
poke 53281, 14
load "screen", 8, 1

# load splash screen characters
loadSplashScreenChars:
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
load "color", 8, 1

# load game characters
loadGameChars:
load "chars", 8, 1

loadComplete:
