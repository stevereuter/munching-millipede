for lp=zr to lm
    get in$

    # save last head position
    lh=h
    # update position
    if in$=u$ then if di<>rw then di=ru
    if in$=d$ then if di<>ru then di=rw
    if in$=l$ then if di<>n1 then di=tr
    if in$=r$ then if di<>tr then di=n1
    if di=ru then h=h-rw
    if di=rw then h=h+rw
    if di=tr then h=h-n1
    if di=n1 then h=h+n1
    hx=hx+n1
    if hx>899 then hx=0
    pa(hx)=h

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
    # update tail pointer
    tx=tx+n1
    if tx>899 then tx=0
    t=pa(tx)
    updateTailEnd:

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
