gosub playGameOverSoundSub
x=13:y=8
for i=0 to 7
    tx$=e$(i):gosub writeTextSub
    y=y+1
next
y=13:tx$="score:"+str$(sc):gosub writeTextSubCenterSub
for i=41 to 959:m(i)=0:next

# reset for new game, creates natural pause on game over screen
gosub initBorderArraySidesSub
if sc>hs then hs=sc
goto startIntroScreen

end
