# intro Screen Sub
introScreenSub:
    # clear keyboard buffer
    poke 198,0
    print "{clr}"
    poke bg,zr
    ln$="{rvon}                                        {rvof}"
    
    x=zr:y=n2:tx$="{red}"+ln$:gosub writeTextSub
    y=n3:tx$="{orng}"+ln$:gosub writeTextSub
    y=n4:tx$="{yel}"+ln$:gosub writeTextSub
    y=n5:tx$="{grn}"+ln$:gosub writeTextSub
    y=n6:tx$="{blu}"+ln$:gosub writeTextSub
    y=n4:tx$="{rvon}{yel}the munching millipede{rvof}":gosub writeTextSubCenterSub
    y=9:tx$="{wht}use wasd keys to move"
    gosub writeTextSubCenterSub
    y=11:tx$="difficulty"+str$(lv):gosub writeTextSubCenterSub
    y=14:tx$="up and down to change difficulty":gosub writeTextSubCenterSub
    y=16:x=16:tx$="w: up":gosub writeTextSub
    y=17:tx$="s: down":gosub writeTextSub
    y=18:tx$="a: left":gosub writeTextSub
    y=19:tx$="d: right":gosub writeTextSub
    y=22:tx$="press space to start":gosub writeTextSubCenterSub
    y=24:tx$="{152}{64}2026 steviesaurus dev v###VERSION###":gosub writeTextSubCenterSub
    tn=0

    introLoopStart:
        get i$
        gosub playIntroMusicPartSub
        introActions:
        if i$="" then introLoopStart
        if i$="w" then setLevelUp
        if i$=" " then introLoopDone
        if i$="s" then setLevelDown
        if i$="t" then tn=-1:goto introLoopDone
        goto introLoopStart
        setLevelUp:
        if lv<9 then lv=lv+1
        goto showLevel
        setLevelDown:
        if lv>0 then lv=lv-1
        showLevel:
        x=24:y=11:tx$=str$(lv):gosub writeTextSub
    goto introLoopStart

    introLoopDone:
    # stop music
    poke s+4,16
    if tn then gosub trainerSub
return
