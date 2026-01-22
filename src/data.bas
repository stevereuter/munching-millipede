initBorderArraySub:
    for i=0 to 40
        m(i)=-1
    next
    for i=79 to 959 step 40
        m(i)=-1:m(i+1)=-1
    next
    for i=960 to 999
        m(i)=-1
    next
return

initTextArraysSub:
    rem starting countdown text
    s$(0)="{blk}ready"
    s$(1)=" set  "
    s$(2)="go!{brn}"
    rem game over text
    e$(0)="{blk}**************"
    e$(1)="*            *"
    e$(2)="* game  over *"
    e$(3)="*            *"
    e$(4)="*            *"
    e$(5)="*            *"
    e$(6)="*            *"
    e$(7)="**************"
return

