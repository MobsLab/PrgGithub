[aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);

EpTrans=bef_cell(2,1);
EpTrans=EpTrans{1};
StTrans=Start(EpTrans);
del=5;
for k=1:length(StTrans)
    if k==1
    SEP=intervalSet(StTrans(k)-del*1.5*1e4,StTrans(k)-del*0.5*1e4);
    TEP=intervalSet(StTrans(k)-del*0.5*1e4,StTrans(k)+del*0.5*1e4);
    AEP=intervalSet(StTrans(k)+del*0.5*1e4,StTrans(k)+del*1.5*1e4);
    else
    SEP=Or(SEP,intervalSet(StTrans(k)-del*1.5*1e4,StTrans(k)-del*0.5*1e4));
    TEP=Or(TEP,intervalSet(StTrans(k)-del*0.5*1e4,StTrans(k)+del*0.5*1e4));
    AEP=Or(AEP,intervalSet(StTrans(k)+del*0.5*1e4,StTrans(k)+del*1.5*1e4));
    end
end
AEP=And(AEP,REMEpoch);
size(Data(Restrict(Ripples,TEP)))
size(Data(Restrict(Ripples,AEP)))
size(Data(Restrict(Ripples,SEP)))

EpTrans=bef_cell(2,1);
EpTrans=EpTrans{1};
StTrans=Stop(EpTrans);
del=5;
for k=1:length(StTrans)
    if k==1
    SEP=intervalSet(StTrans(k)-del*1.5*1e4,StTrans(k)-del*0.5*1e4);
    TEP=intervalSet(StTrans(k)-del*0.5*1e4,StTrans(k)+del*0.5*1e4);
    AEP=intervalSet(StTrans(k)+del*0.5*1e4,StTrans(k)+del*1.5*1e4);
    else
    SEP=Or(SEP,intervalSet(StTrans(k)-del*1.5*1e4,StTrans(k)-del*0.5*1e4));
    TEP=Or(TEP,intervalSet(StTrans(k)-del*0.5*1e4,StTrans(k)+del*0.5*1e4));
    AEP=Or(AEP,intervalSet(StTrans(k)+del*0.5*1e4,StTrans(k)+del*1.5*1e4));
    end
end
AEP=And(AEP,REMEpoch);
size(Data(Restrict(Ripples,TEP)))
size(Data(Restrict(Ripples,AEP)))
size(Data(Restrict(Ripples,SEP)))

[aft_cell,bef_cell]=transEpoch(SWSEpoch,wakeper);
EpTrans=bef_cell(2,1);
EpTrans=EpTrans{1};
StTrans=Start(EpTrans);
del=5;
for k=1:length(StTrans)
    if k==1
    SEP=intervalSet(StTrans(k)-del*1.5*1e4,StTrans(k)-del*0.5*1e4);
    TEP=intervalSet(StTrans(k)-del*0.5*1e4,StTrans(k)+del*0.5*1e4);
    AEP=intervalSet(StTrans(k)+del*0.5*1e4,StTrans(k)+del*1.5*1e4);
    else
    SEP=Or(SEP,intervalSet(StTrans(k)-del*1.5*1e4,StTrans(k)-del*0.5*1e4));
    TEP=Or(TEP,intervalSet(StTrans(k)-del*0.5*1e4,StTrans(k)+del*0.5*1e4));
    AEP=Or(AEP,intervalSet(StTrans(k)+del*0.5*1e4,StTrans(k)+del*1.5*1e4));
    end
end
AEP=And(AEP,REMEpoch);
size(Data(Restrict(Spindles,TEP)))
size(Data(Restrict(Spindles,AEP)))
size(Data(Restrict(Spindles,SEP)))
