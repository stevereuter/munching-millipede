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
    rem uses the i from the intro loop to play note
    gosub startSoundSub
    if i>15 then i=-1
    i=i+1
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
    im(1)=5
    im(2)=5
    im(3)=5
    im(4)=40
    im(5)=40
    im(6)=40
    im(7)=40
    im(8)=10
    im(9)=10
    im(10)=10
    im(11)=10
    im(12)=30
    im(13)=30
    im(14)=30
    im(15)=30
return