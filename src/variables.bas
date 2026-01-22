
h=0:t=0:pa$="":lp=0:di$="":fd=-1:sn=81:em=32:ps=1024:pc=55296:gr=13:br=9:zr=0
lm=5000:n1=1:rw=40:tr=-1:sc=0:fc=0:gw=0:ov=0:n2=2:n8=8:n3=3:n4=4:n5=5:n6=6
hr=83:bl=102:hs=10:lv=2:n2=2:s=54272
r$="d":l$="a":u$="w":d$="s":i=0:x=0:y=0:pk=53280:rn=0:bg=53281:f=0

rem arrays
dim m(1000):rem map for blocks
rem starting countdown test
dim s$(3)
rem game over text
dim e$(8)
rem intro music array
dim im(16)

rem seed data
gosub initBorderArraySub
gosub initTextArraysSub
gosub seedMusicArraySub

