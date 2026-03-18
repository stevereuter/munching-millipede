playScoreSoundSub:
    gosub startSoundSub
    for f=10 to 60 step 10
        poke s+1,f
        poke s+4,17
    next
    poke s+4,16
return

playGameOverSoundSub:
    gosub startSoundSub
    poke s+4,33
    for f=25 to 0 step -1
        poke s+1,f
    next
    poke s+4,32
    poke s+24,0
return

playIntroMusicPartSub:
    # play not based on time passed
    ts=(ti-t)
    i=0
    if ts>80 then t=ti:goto startSound
    if ts>60 then i=3:goto startSound
    if ts>40 then i=2:goto startSound
    if ts>20 then i=1:goto startSound
    startSound:
    gosub startSoundSub
    poke s+1,im(i)
    poke s+4,17
return

startSoundSub:
    poke s+24,15
    poke s+5,0
    poke s+6,240
return

seedMusicArraySub:
    im(0)=5
    im(1)=40
    im(2)=10
    im(3)=30
return
