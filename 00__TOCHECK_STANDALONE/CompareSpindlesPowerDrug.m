function [MeanEffect,spindles, spi]=CompareSpindlesPowerDrug(LFP, Epoch, CPEpoch,VEHEpoch,spindles,spi)


% MeanEffect(1)=max(Mlpre(:,2))-min(Mlpre(:,2));
% MeanEffect(2)=max(Mlveh(:,2))-min(Mlveh(:,2));
% MeanEffect(3)=max(Mlcp(:,2))-min(Mlcp(:,2));
% 
% MeanEffect(4)=max(Mhpre(:,2))-min(Mhpre(:,2));
% MeanEffect(5)=max(Mhveh(:,2))-min(Mhveh(:,2));
% MeanEffect(6)=max(Mhcp(:,2))-min(Mhcp(:,2));
% 
% MeanEffect(7)=mean(spi(idPRE,7));
% MeanEffect(8)=mean(spi(idVEH,7));
% MeanEffect(9)=mean(spi(idCP,7));
% 
% MeanEffect(10)=mean(spi(idPRE,3)-spi(idPRE,1));
% MeanEffect(11)=mean(spi(idVEH,3)-spi(idVEH,1));
% MeanEffect(12)=mean(spi(idCP,3)-spi(idCP,1));
% 
% MeanEffect(13)=mean(spi(idPRE,4));
% MeanEffect(14)=mean(spi(idVEH,4));
% MeanEffect(15)=mean(spi(idCP,4));
% 
% MeanEffect(16)=mean(spi(idPRE,6));
% MeanEffect(17)=mean(spi(idVEH,6));
% % MeanEffect(18)=mean(spi(idCP,6));
% 
% MeanEffect(19)=length(spi(idPRE,6));
% MeanEffect(20)=length(spi(idVEH,6));
% MeanEffect(21)=length(spi(idCP,6));
% 

st1=Start(VEHEpoch,'s');
st2=Start(CPEpoch,'s');

try 
    spindles;
catch
    spindles = FindSpindlesK(LFP,[4 16],Epoch);
end

try
    spi;
catch
    spi=RealignSpindlesAd(LFP,spindles);
end

idPRE=find(spi(:,2)<st1(1));
idVEH=find(spi(:,2)>st1(1)&spi(:,2)<st2(1));
idCP=find(spi(:,2)>st2(1));



LFPtest=ResampleTSD(LFP,250);
LFPtestH=FilterLFP(LFPtest,[10 15],512);
LFPtestL=FilterLFP(LFPtest,[2,6],512);

try
[Mlpre,Tlpre]=PlotRipRaw(LFPtestL,spi(idPRE,2),1000);close
end
[Mlveh,Tlveh]=PlotRipRaw(LFPtestL,spi(idVEH,2),1000);close
[Mlcp,Tlcp]=PlotRipRaw(LFPtestL,spi(idCP,2),1000);close

try
[Mhpre,Thpre]=PlotRipRaw(LFPtestH,spi(idPRE,2),1000);close
end
[Mhveh,Thveh]=PlotRipRaw(LFPtestH,spi(idVEH,2),1000);close
[Mhcp,Thcp]=PlotRipRaw(LFPtestH,spi(idCP,2),1000);close



MeanEffect(1)=max(Mlpre(:,2))-min(Mlpre(:,2));
MeanEffect(2)=max(Mlveh(:,2))-min(Mlveh(:,2));
MeanEffect(3)=max(Mlcp(:,2))-min(Mlcp(:,2));

MeanEffect(4)=max(Mhpre(:,2))-min(Mhpre(:,2));
MeanEffect(5)=max(Mhveh(:,2))-min(Mhveh(:,2));
MeanEffect(6)=max(Mhcp(:,2))-min(Mhcp(:,2));

MeanEffect(7)=mean(spi(idPRE,7));
MeanEffect(8)=mean(spi(idVEH,7));
MeanEffect(9)=mean(spi(idCP,7));

MeanEffect(10)=mean(spi(idPRE,3)-spi(idPRE,1));
MeanEffect(11)=mean(spi(idVEH,3)-spi(idVEH,1));
MeanEffect(12)=mean(spi(idCP,3)-spi(idCP,1));

MeanEffect(13)=mean(spi(idPRE,4));
MeanEffect(14)=mean(spi(idVEH,4));
MeanEffect(15)=mean(spi(idCP,4));

MeanEffect(16)=mean(spi(idPRE,6));
MeanEffect(17)=mean(spi(idVEH,6));
MeanEffect(18)=mean(spi(idCP,6));

MeanEffect(19)=length(spi(idPRE,6));
MeanEffect(20)=length(spi(idVEH,6));
MeanEffect(21)=length(spi(idCP,6));

if 0

    PlotErrorBar3(spi(idPRE,4),spi(idVEH,4),spi(idCP,4));
    title('Spindles amplitude')

    PlotErrorBar3(spi(idPRE,6),spi(idVEH,6),spi(idCP,6));
    title('Spindles amplitude (High frequency component)')

    PlotErrorBar3(spi(idPRE,7),spi(idVEH,7),spi(idCP,7));
    title('Spindles frequency')

    PlotErrorBar3(length(spi(idPRE,4)),length(spi(idVEH,4)),length(spi(idCP,4)));
    title('number of spindles')
    figure('color',[1 1 1]) , 
    subplot(2,1,1),
    try
    plot(mean(Tlpre),'k')
    end
    hold on, plot(mean(Tlveh)), plot(mean(Tlcp),'r')

    subplot(2,1,2),
    try
        plot(mean(Thpre),'k')
    end
    hold on, plot(mean(Thveh)), plot(mean(Thcp),'r')

end
