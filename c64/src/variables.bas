# head, tail, pointers, loop, and food
h=0:lh=0:t=0:hx=0:tx=0:lp=0:di=0:fd=-1
# characters, poke registers, colors, level
mi=81:em=32:hr=83:bl=102:ps=52224:pc=55296:s=54272:sy=58732:gr=13:br=9:lv=2
# loop max, row, true, food count, grow, gameover, score, x, y, random number
lm=5000::rw=40:ru=-40:tr=-1:fc=0:gw=0:ov=0:sc=0:x=0:y=0:rn=0
# numbers
zr=0:n1=1:n2=2:n3=3:n4=4:n5=5:n6=6:n8=8
# directions, index, screen, background color, frequency, high score
r$="d":l$="a":u$="w":d$="s":i=0:pk=53280:bg=53281:f=0:hs=10:cr=49152

# set custom characters
#include "characterSet.bas"

# arrays
# path array
dim pa(900)
# map for blocks
dim m(1000)
# starting countdown test
dim s$(3)
# game over text
dim e$(8)
# intro music array
dim im(16)

# seed data
gosub initBorderArraySub
gosub initTextArraysSub
gosub seedMusicArraySub

# border grey
poke pk, 11
