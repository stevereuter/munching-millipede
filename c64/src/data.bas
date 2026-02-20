initBorderArraySub:
    # top
    for i=0 to 40
        m(i)=-1
    next
    # sides
    gosub initBorderArraySidesSub
    # bottom
    for i=960 to 999
        m(i)=-1
    next
return

initBorderArraySidesSub:
    # sides
    for i=79 to 959 step 40
        m(i)=-1:m(i+1)=-1
    next
return

initTextArraysSub:
    # starting countdown text
    s$(0)="{blk}ready"
    s$(1)=" set  "
    s$(2)="go!{brn}"
    # game over text
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

# custom characters
# head left
data 142, 95, 63, 63, 63, 63, 95, 142
# body
data 60, 126, 255, 255, 255, 255 ,126, 60
# head right
data 113, 250, 252, 252, 252, 252, 250, 113
# head up
data 129, 66, 60, 126, 255, 255, 255, 126
# head down
data 126, 255, 255, 255, 126, 60, 66, 129
