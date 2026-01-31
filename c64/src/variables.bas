rem head, tail, path, loop, and food
h=0:t=0:pa$="":lp=0:di$="":fd=-1
rem characters, poke registers, colors, level
sn=81:em=32:hr=83:bl=102:ps=1024:pc=55296:s=54272:sy=58732:gr=13:br=9:lv=2
rem loop max, row, true, food count, grow, gameover, score, x, y, random number
lm=5000::rw=40:tr=-1:fc=0:gw=0:ov=0:sc=0:x=0:y=0:rn=0
rem numbers
zr=0:n1=1:n2=2:n3=3:n4=4:n5=5:n6=6:n8=8
rem directions, index, screen, background color, frequency, high score
r$="d":l$="a":u$="w":d$="s":i=0:pk=53280:bg=53281:f=0:hs=10

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

rem border grey
poke pk, 11
