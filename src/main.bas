rem the munching millipede by steve reuter 2024

#include "variables.bas"
rem border grey
poke pk, 11
  
startIntroScreen:
gosub introScreenSub

rem load game
print "{brn}{clr}"
poke bg,12
sc=0:fc=0:t=361
pa$="":rem path/history
di$=r$:rem direction
fd=-1:rem food position
for h=t to 364
  rem set path/history
  pa$=pa$+r$
  gosub updateHeadSub
next
h=h-1:rem remove the final next val
gosub createGameLevelSub
gosub addNewFoodSub
gosub writeHighScoreSub
gosub showStartCountdownSub

rem main loop
for lp=zr to lm
  get in$

  gosub updatePositionSub
  gosub checkBlockCollisionSub
  rem collision detected, set loop to max to end game
  if ov then lp=lm:goto gameLoopDone

  gosub checkFoodCollisionSub
  gosub updateHeadSub
  gosub updateTailSub
  gosub updatePathSub

  if fd=tr then gosub addNewFoodSub

  if not gw then gameLoopDone
  gw=zr
  gosub updateScoreSub
  gosub updateLevelSub
  gameLoopDone:
next

rem game over
gosub playGameOverSoundSub
x=13:y=8
for i=0 to 7
  tx$=e$(i):gosub writeTextSub
  y=y+1
next
y=13:tx$="score:"+str$(sc):gosub writeTextSubCenterSub
for i=0 to 999:m(i)=0:next

rem reset for new game
gosub initBorderArraySub
if sc>hs then hs=sc
goto startIntroScreen
end

updatePositionSub:
  if in$=u$ then if di$<>d$ then di$=in$
  if in$=d$ then if di$<>u$ then di$=in$
  if in$=l$ then if di$<>r$ then di$=in$
  if in$=r$ then if di$<>l$ then di$=in$
  if di$=u$ then h=h-rw
  if di$=d$ then h=h+rw
  if di$=l$ then h=h-n1
  if di$=r$ then h=h+n1
return

updateHeadSub:
  poke pc+h,gr
  poke ps+h,sn
  m(h)=-1
return

updateTailSub:
  if gw then goto updateTailEnd
  poke ps+t,em
  m(t)=zr
  la$=mid$(pa$,n2,n1)
  if la$=u$ then t=t-rw
  if la$=d$ then t=t+rw
  if la$=r$ then t=t+n1
  if la$=l$ then t=t-n1
  updateTailEnd:
return

updatePathSub:
  pa$=pa$+di$
  if gw then skipUpdatePath
  pa$=mid$(pa$,n2)
  skipUpdatePath:
return

checkFoodCollisionSub:
  if fd <> h then goto destroyFood
  gw=tr
  fd=tr
  sc=sc+10+lv
  gosub playScoreSoundSub
  fc=fc+n1
  destroyFood:
  if lp<100 then checkFoodCollisionDone
  m(fd)=0:poke ps+fd,em:fd=tr
  checkFoodCollisionDone:
return

checkBlockCollisionSub:
  ov=m(h)
return

addNewFoodSub:
  rn=int(rnd(ti)*1000)
  if m(rn) then goto addNewFoodEnd
  fd=rn
  poke pc+fd,n2
  poke ps+fd,hr
  lp=zr
  addNewFoodEnd:
return

updateLevelSub:
  z=fc/10
  if int(z)-z <> zr then goto updateLevelDone
  rn=int(rnd(ti)*918)+41
  if m(rn) then goto updateLevelDone
  if rn=fd then goto updateLevelDone
  i=rn:gosub addBlockSub
  updateLevelDone:
return

updateScoreSub:
  tx$="{rvon}"+mid$(str$(sc),n2)
  x=n8:y=zr:gosub writeTextSub
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
  poke 211, x:poke 214, y:sys 58732
  print tx$
return

writeTextSubInlineSub:
  poke 211,x:poke 214,y:sys 58732
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

createGameLevelSub: rem create border
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

  rem create blocks
  for i=0 to lv*10
    rn=int(rnd(ti)*918)+41
    if m(rn) then goto createBlockLoopDone
    poke ps+rn, bl
    m(rn)=-1
    createBlockLoopDone:
  next
return

#include "sound.bas"
#include "data.bas"
#include "intro.bas"
