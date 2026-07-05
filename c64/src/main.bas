# the munching millipede (c) 2026 steviesaurus dev

#include "fileLoader.bas"
#include "variables.bas"

# switch to game characters now
# Switch VIC to Bank 3
poke 56576, peek(56576) and 252
# Set chars block 0 (49152) and screen block 3 (52224)
poke 53272, 48
# Tell BASIC the screen moved to 52224
poke 648, 204
# switch to standard character mode
poke 53270, peek(53270) and 239
  
startIntroScreen:
gosub introScreenSub

# load game
#include "initGame.bas"

# main loop
#include "gameLoop.bas"

# game over
#include "gameOver.bas"

# utility subs
#include "utilitySubs.bas"
#include "trainer.bas"

#include "sound.bas"
#include "intro.bas"
#include "data.bas"
