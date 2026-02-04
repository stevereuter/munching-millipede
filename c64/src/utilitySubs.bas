
addNewFoodSub:
    rn=int(rnd(ti)*1000)
    if m(rn) then goto addNewFoodEnd
    fd=rn
    poke pc+fd,n2
    poke ps+fd,hr
    lp=zr
    addNewFoodEnd:
return

writeTextSubCenterSub:
    x=20-len(tx$)/2
    gosub writeTextSub
return

writeHighScoreSub:
    tx$="{rvon}hi:"+mid$(str$(hs),2)
    x=39-len(tx$):y=0:gosub writeTextSub
return

writeTextSub:
    poke 211, x:poke 214, y:sys sy
    print tx$
return

writeTextSubInlineSub:
    poke 211,x:poke 214,y:sys sy
    print tx$;
return

addBlockSub:
    m(rn)=tr
    poke ps+rn,bl
    poke pc+rn,br
return

showStartCountdownSub:
    y=9
    for i=0 to 2
        for x=0 to 250:next x
        tx$=s$(i):gosub writeTextSubCenterSub
    next i
    for i=376 to 382
        b=em
        if m(i) then b=bl
        poke 1024+i,b
        poke 55296+i, 9
    next
return

# create border
createGameLevelSub:
  tx$="{brn}{rvon}{$D1} score:0                              {$D1} "
  x=0:y=0
  gosub writeTextSubInlineSub
  x=39:tx$="{rvon}  "
  for y=1 to 23
    gosub writeTextSubInlineSub
  next
  x=0:y=24:tx$="{rvon}{$D1}        the munching millipede        "
  gosub writeTextSubInlineSub
  poke 2023,209

  # create blocks
  for i=0 to lv*10
    rn=int(rnd(ti)*918)+41
    if m(rn) then goto createBlockLoopDone
    poke ps+rn, bl
    m(rn)=-1
    createBlockLoopDone:
  next
return
