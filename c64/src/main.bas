# the munching millipede (c) 2026 steviesaurus dev

# we're going to skip loading the characters here if the first one is set, which means this is the second time this has run
if peek(49152)=60 then skipCharacterLoading
# set custom characters
#include "characterSet.bas"

# load the characters into memory
load "chars", 8, 1
skipCharacterLoading:
#include "variables.bas"
  
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
