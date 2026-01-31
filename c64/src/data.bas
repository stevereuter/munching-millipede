initBorderArraySub:
    rem top
    for i=0 to 40
        m(i)=-1
    next
    rem sides
    gosub initBorderArraySidesSub
    rem bottom
    for i=960 to 999
        m(i)=-1
    next
return

initBorderArraySidesSub:
    rem sides
    for i=79 to 959 step 40
        m(i)=-1:m(i+1)=-1
    next
return

initTextArraysSub:
    rem starting countdown text
    s$(0)="{blk}ready"
    s$(1)=" set  "
    s$(2)="go!{brn}"
    rem game over text
    tx$="*            *"
    e$(0)="{blk}**************"
    e$(1)=tx$
    e$(2)="* game  over *"
    e$(3)=tx$
    e$(4)=tx$
    e$(5)=tx$
    e$(6)=tx$
    e$(7)="**************"
return

