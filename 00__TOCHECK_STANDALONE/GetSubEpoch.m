function newEp=GetSubEpoch(Epoch1,Epoch2)
st=Start(Epoch1);
sp=Stop(Epoch1);
beg=Start(Epoch2);
endin=Stop(Epoch2);
w=find(st>beg,1,'first');
 q=find(sp>endin,1,'first');
 newEp=intervalSet(st(w:q),sp(w:q));
end