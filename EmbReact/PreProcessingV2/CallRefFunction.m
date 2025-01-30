if ExpeInfo.nmouse==507
    RefSubtraction_multi('amplifier.dat',64,1,'M507',[0:31],27,[32:63]);
    RefSubtraction_multi('amplifier_M507.dat',64,1,'M507',[32:63],53,[0:31]);
    delete('amplifier_M507_original.dat')
    movefile('amplifier_M507_M507.dat','amplifier_M507.dat')
    
elseif ExpeInfo.nmouse==508
    RefSubtraction_multi('amplifier.dat',64,1,'M508',[0:31],11,[32:63]);
    RefSubtraction_multi('amplifier_M508.dat',64,1,'M508',[32:63],52,[0:31]);
    delete('amplifier_M508_original.dat')
    movefile('amplifier_M508_M508.dat','amplifier_M508.dat')
    
elseif ExpeInfo.nmouse==509
    RefSubtraction_multi('amplifier.dat',64,1,'M509',[32:63],52,[0:31]);
    
elseif ExpeInfo.nmouse==510
    RefSubtraction_multi('amplifier.dat',32,1,'M510',[0:31],27,[]);
    
elseif ExpeInfo.nmouse==512
    RefSubtraction_multi('amplifier.dat',32,1,'M512',[0:31],27,[]);
    
elseif ExpeInfo.nmouse==484
    RefSubtraction_multi('amplifier.dat',16,1,'M484',[0:15],4,[]);
    
elseif ExpeInfo.nmouse==485
    RefSubtraction_multi('amplifier.dat',16,1,'M485',[0:15],12,[]);
elseif ExpeInfo.nmouse==490
    RefSubtraction_multi('amplifier.dat',64,1,'M490',[32:63],43,[0:31]);
elseif ExpeInfo.nmouse==514
    RefSubtraction_multi('amplifier.dat',48,1,'M514',[0:31],8,[32:47]);
elseif ExpeInfo.nmouse==560
    RefSubtraction_multi('amplifier.dat',16,1,'M560',[0:15],9,[]);
elseif ExpeInfo.nmouse==564
    RefSubtraction_multi('amplifier.dat',16,1,'M564',[0:15],0,[]);
elseif ExpeInfo.nmouse==565
    RefSubtraction_multi('amplifier.dat',16,1,'M565',[0:15],0,[]);
elseif ExpeInfo.nmouse==566
    RefSubtraction_multi('amplifier.dat',16,1,'M566',[0:15],8,[]);
elseif ExpeInfo.nmouse==561
    RefSubtraction_multi('amplifier.dat',16,1,'M561',[0:15],15,[]);
elseif ExpeInfo.nmouse==568
    RefSubtraction_multi('amplifier.dat',16,1,'M568',[0:15],7,[]);
elseif ExpeInfo.nmouse==567
    RefSubtraction_multi('amplifier.dat',32,1,'M567',[0:31],24,[]);
elseif ExpeInfo.nmouse==569
    RefSubtraction_multi('amplifier.dat',32,1,'M569',[0:31],12,[]);
elseif ExpeInfo.nmouse==666
    RefSubtraction_multi('amplifier.dat',32,1,'M666',[0:31],1,[]);
elseif ExpeInfo.nmouse==669
    RefSubtraction_multi('amplifier.dat',32,1,'M669',[0:31],25,[]);
elseif ExpeInfo.nmouse==668
    RefSubtraction_multi('amplifier.dat',32,1,'M668',[0:31],0,[]);
elseif ExpeInfo.nmouse==667
    RefSubtraction_multi('amplifier.dat',32,1,'M667',[4],4,[0:3,5:31]);
elseif ExpeInfo.nmouse==688
    RefSubtraction_multi('amplifier.dat',32,1,'M688',[0:31],7,[]);
elseif ExpeInfo.nmouse==689
    RefSubtraction_multi('amplifier.dat',32,1,'M689',[0:31],8,[]);
elseif ExpeInfo.nmouse==739
    RefSubtraction_multi('amplifier.dat',32,1,'M739',[0:31],19,[]);
elseif ExpeInfo.nmouse==740
    RefSubtraction_multi('amplifier.dat',32,1,'M740',[0:31],6,[]);
elseif ExpeInfo.nmouse==750
    RefSubtraction_multi('amplifier.dat',32,1,'M750',[0:31],25,[]);
elseif ExpeInfo.nmouse==779
    RefSubtraction_multi('amplifier.dat',32,1,'M779',[0:31],7,[]);
elseif ExpeInfo.nmouse==778
    movefile('amplifier.dat','amplifier_M778.dat')
elseif ExpeInfo.nmouse==775
    RefSubtraction_multi('amplifier.dat',32,1,'M775',[0:31],23,[]);
elseif ExpeInfo.nmouse==777
    RefSubtraction_multi('amplifier.dat',32,1,'M777',[0:31],23,[]);
elseif ExpeInfo.nmouse==795
    RefSubtraction_multi('amplifier.dat',32,1,'M795',[0:31],7,[]);
end


