introScreenSub:
    # clear keyboard buffer
    poke 198,0
    print "{clr}"
    poke bg,zr
    ln$="{rvon}                                        "
    
    x=zr:y=n2:tx$="{red}"+ln$:gosub writeTextSub
    y=n3:tx$="{orng}"+ln$:gosub writeTextSub
    y=n4:tx$="{yel}"+ln$:gosub writeTextSub
    y=n5:tx$="{grn}"+ln$:gosub writeTextSub
    y=n6:tx$="{blu}"+ln$:gosub writeTextSub
    y=n4:tx$="{rvon}{yel}the munching millipede":gosub writeTextSubCenterSub
    y=9:tx$="{wht}use wasd keys to move"
    gosub writeTextSubCenterSub
    y=11:tx$="level"+str$(lv):gosub writeTextSubCenterSub
    y=14:tx$="up and down to change level":gosub writeTextSubCenterSub
    x=16:y=17:tx$="w: up":gosub writeTextSub
    y=18:tx$="s: down":gosub writeTextSub
    y=19:tx$="a: left":gosub writeTextSub
    y=20:tx$="d: right":gosub writeTextSub
    y=23:tx$="press space to start":gosub writeTextSubCenterSub

    introLoopStart:
        get i$
        gosub playIntroMusicPartSub
        introActions:
        if i$="" then introLoopStart
        if i$="w" then setLevelUp
        if i$=" " then introLoopDone
        if i$="s" then setLevelDown
        goto introLoopStart
        setLevelUp:
        if lv<9 then lv=lv+1
        goto showLevel
        setLevelDown:
        if lv>0 then lv=lv-1
        showLevel:
        x=21:y=11:tx$=str$(lv):gosub writeTextSub
    goto introLoopStart

    introLoopDone:
    # stop music
    poke s+4,16
return
