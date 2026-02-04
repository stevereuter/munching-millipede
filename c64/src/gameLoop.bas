for lp=zr to lm
    get in$

    # update position
    if in$=u$ then if di$<>d$ then di$=in$
    if in$=d$ then if di$<>u$ then di$=in$
    if in$=l$ then if di$<>r$ then di$=in$
    if in$=r$ then if di$<>l$ then di$=in$
    if di$=u$ then h=h-rw
    if di$=d$ then h=h+rw
    if di$=l$ then h=h-n1
    if di$=r$ then h=h+n1

    # check collision
    ov=m(h)
    # collision detected, set loop to max to end game
    if ov then lp=lm:goto gameLoopDone

    # check food collision
    if fd <> h then goto destroyFood
    gw=tr
    fd=tr
    sc=sc+10+lv
    gosub playScoreSoundSub
    fc=fc+n1

    destroyFood:
    if lp<100 then removeFoodDone
    m(fd)=0
    poke ps+fd,em
    fd=tr
    removeFoodDone:

    # update head
    #include "drawHead.bas"

    # update tail
    if gw then goto updateTailEnd
    poke ps+t,em
    m(t)=zr
    la$=mid$(pa$,n2,n1)
    if la$=u$ then t=t-rw
    if la$=d$ then t=t+rw
    if la$=r$ then t=t+n1
    if la$=l$ then t=t-n1
    updateTailEnd:

    # update path
    pa$=pa$+di$
    if gw then skipRemoveTail
    pa$=mid$(pa$,n2)
    skipRemoveTail:

    if fd=tr then gosub addNewFoodSub

    if not gw then gameLoopDone
    gw=zr
    # update score
    tx$="{rvon}"+mid$(str$(sc),n2)
    x=n8:y=zr:gosub writeTextSub

    # update level
    z=fc/10
    if int(z)-z <> zr then goto gameLoopDone
    rn=int(rnd(ti)*918)+41
    if m(rn) then goto gameLoopDone
    if rn=fd then goto gameLoopDone
    i=rn:gosub addBlockSub

    gameLoopDone:
next
