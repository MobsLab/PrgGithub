for m=3:5
    try
     cd(filename{m})
     load(strcat(filename2{m},'StateEpoch.mat'))
     load(strcat(filename2{m},'LFPData/LFP0'))
     SWSEpoch1=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
     REMEpoch1=REMEpoch-NoiseEpoch-GndNoiseEpoch;
     Wake1=MovEpoch-NoiseEpoch-GndNoiseEpoch;
    load('StateEpochSB.mat');
    totSWS(m)=size(Data(Restrict(LFP,SWSEpoch)),1);
    SS(m)=size(Data(Restrict(LFP,And(SWSEpoch,SWSEpoch1))),1);
    SW(m)=size(Data(Restrict(LFP,And(SWSEpoch,Wake1))),1);
    SR(m)=size(Data(Restrict(LFP,And(SWSEpoch,REMEpoch1))),1);
    totREM(m)=size(Data(Restrict(LFP,REMEpoch)),1);
    RR(m)=size(Data(Restrict(LFP,And(REMEpoch,REMEpoch1))),1);
    RW(m)=size(Data(Restrict(LFP,And(REMEpoch,Wake1))),1);
    RS(m)=size(Data(Restrict(LFP,And(REMEpoch,SWSEpoch1))),1);
    totwake(m)=size(Data(Restrict(LFP,Wake)),1);
    WW(m)=size(Data(Restrict(LFP,And(Wake,Wake1))),1);
    WS(m)=size(Data(Restrict(LFP,And(Wake,SWSEpoch1))),1);
    WR(m)=size(Data(Restrict(LFP,And(Wake,REMEpoch1))),1);
    end
end

XS=[mean(SS(3:5)./totSWS(3:5)),mean(SW(3:5)./totSWS(3:5)),mean(SR(3:5)./totSWS(3:5))];
subplot(131)
pie(XS)
legend('SS','SW','SR')
colormap(summer)

XS=[mean(RR(3:5)./totREM(3:5)),mean(RW(3:5)./totREM(3:5)),mean(RS(3:5)./totREM(3:5))];
subplot(132)
pie(XS)
legend('RR','RW','RS')
colormap(summer)

XS=[mean(WW(3:5)./totwake(3:5)),mean(WS(3:5)./totwake(3:5)),mean(WR(3:5)./totwake(3:5))];
subplot(133)
pie(XS)
legend('WW','WS','WR')
colormap(summer)
