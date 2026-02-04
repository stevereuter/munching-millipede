print "{brn}{clr}"
poke bg,12
sc=0:fc=0:t=361
# path/history
pa$=""
# direction
di$=r$
# food position
fd=-1

for h=t to t+n3
    # set path/history
    pa$=pa$+r$
    #include "drawHead.bas"
next
h=t+n3
gosub createGameLevelSub
gosub addNewFoodSub
gosub writeHighScoreSub
gosub showStartCountdownSub
