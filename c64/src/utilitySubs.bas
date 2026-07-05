# draw Head Sub
drawHeadSub:
    poke pc+h,gr
    poke ps+h,mi+di
    poke ps+lh,mi
    m(h)=-1
return

# add New Food Sub
addNewFoodSub:
    rn=int(rnd(.)*1000)
    if m(rn) then goto addNewFoodEnd
    fd=rn
    poke pc+fd,n2
    poke ps+fd,hr
    lp=zr
    addNewFoodEnd:
return

# write High Score Sub
writeHighScoreSub:
    tx$="{rvon}hi:"+mid$(str$(hs),2)+"{rvof}"
    x=39-len(tx$):y=0:gosub writeTextSub
return

# add Block Sub
addBlockSub:

    m(rn)=tr
    poke ps+rn,bl
    poke pc+rn,br
return

# show Start Countdown Sub
showStartCountdownSub:
    # print the ready set go text
    y=9
    for i=0 to 2
        for x=0 to 250:next x
        tx$=s$(i)
        gosub writeTextSubCenterSub
    next i
    for i=376 to 382
        b=em
        if m(i) then b=bl
        poke ps+i,b
        poke pc+i, 9
    next
return

# write Text Sub Center Sub
writeTextSubCenterSub:
    x=20-len(tx$)/2
    gosub writeTextSub
return

# create border
createGameLevelSub:
  tx$="{brn}{rvon}{$D1} score:0                              {$D1} {rvof}"
  x=0:y=0
  gosub writeTextSub
  x=39:tx$="{rvon}  {rvof}"
  for y=1 to 23
    gosub writeTextSub
  next
  x=0:y=24:tx$="{rvon}{$D1}        the munching millipede        {rvof}"
  gosub writeTextSub
  poke ps+999,209

  # create blocks
  for i=0 to lv*10
    rn=int(rnd(.)*918)+41
    if m(rn) then goto createBlockLoopDone
    poke ps+rn, bl
    m(rn)=-1
    createBlockLoopDone:
  next
return

# write Text Sub
writeTextSub:
    poke 211, x:poke 214, y:sys sy
    print tx$;
return
