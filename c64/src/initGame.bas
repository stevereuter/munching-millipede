print "{brn}{clr}"
poke bg,12
sc=0:fc=0:t=361

# direction
di=n1
# food position
fd=-1

tx=zr
hx=zr
lh=t

for h=t to t+n3
    # set path/history
    pa(hx)=h
    hx=hx+n1
    #include "drawHead.bas"
    lh=h
next
hx=n3
h=pa(hx)
gosub createGameLevelSub
gosub addNewFoodSub
gosub writeHighScoreSub
gosub showStartCountdownSub
