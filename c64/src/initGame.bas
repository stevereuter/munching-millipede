print "{brn}{clr}"
poke bg,12
sc=0:fc=0:t=361
pa$="":rem path/history
di$=r$:rem direction
fd=-1:rem food position
for h=t to t+n3
    rem set path/history
    pa$=pa$+r$
    #include "drawHead.bas"
next
h=t+n3
gosub createGameLevelSub
gosub addNewFoodSub
gosub writeHighScoreSub
gosub showStartCountdownSub
