# trainer screen
trainerSub:
    print "{clr}welcome to the steviesaurus dev trainer"
    print "{down}{down}here you can set the additional length"
    print "of the millipede at the start of the"
    print "game. the millipede will still look"
    print "normal to begin with, but will continue"
    print "to grow until it reaches the length you set"
    print "{down}{down}"
    tryAgain:
    input "enter length";tn
    if tn>400 then tryAgain
return

setTrainerLengthSub:
    for i=899 to 899-tn step -1
        pa(i)=t
        tx=i
    next
return
