%%FigureScriptCoupUncoup
clear Dat
%Ripples
load(strcat('LFPData/LFP',num2str(Ripch(m)),'.mat'));
[MSRS,TSRS]=PlotRipRaw(LFP,Range(Restrict(RipS,Epoch))/1e4,50); close;
DT=100/125;
Dat{1}=zscore(MSRS(:,2));
[MSRD,TSRD]=PlotRipRaw(LFP,Range(Restrict(RipD,Epoch))/1e4,50); close;
Dat{2}=zscore(MSRD(:,2));

%Spindles
if sum(struct=='PaCx')==4
    ch=PaCxch(m,2);
else
    ch=PFCxch(m,2);
end
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
[MSPa,TSPa]=PlotRipRaw(LFP,Range(Restrict(SpiR,Epoch))/1e4,1000); close;
Dat{3}=zscore(MSPa(:,2));
[MSPa,TSPa]=PlotRipRaw(LFP,Range(Restrict(SpiD,Epoch))/1e4,1000); close;
Dat{4}=zscore(MSPa(:,2));

%Delta waves
if struct=='PaCx'
    ch=PaCxch(m,1);
else
    ch=PFCxch(m,1);
end
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
try
    [MDSd,TDSd]=PlotRipRaw(LFP,Data(Restrict(DelR,Epoch))/1e4,500); close;
    Dat{5}=zscore(MDSd(:,2));
    [MDSd,TDSd]=PlotRipRaw(LFP,Data(Restrict(DelS,Epoch))/1e4,500); close;
    Dat{6}=zscore(MDSd(:,2));
catch
    MDSd=[];
    TDSd=[];
    timeD=[];
    Dat{6}=NaN;
    Dat{5}=NaN;
    
end

if struct=='PaCx'
    ch=PaCxch(m,2);
else
    ch=PFCxch(m,2);
end
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
try
    [MDSd,TDSd]=PlotRipRaw(LFP,Data(Restrict(DelR,Epoch))/1e4,500); close;
    Dat{7}=zscore(MDSd(:,2));
    [MDSd,TDSd]=PlotRipRaw(LFP,Data(Restrict(DelS,Epoch))/1e4,500); close;
    Dat{8}=zscore(MDSd(:,2));
catch
    MDSd=[];
    TDSd=[];
    timeD=[];
    Dat{7}=NaN;
    Dat{8}=NaN;
    
end


% Cross correlograms
Ri=Data(Restrict(Ripples{1},Epoch));
De=Data(Restrict(DeltaPa{1},Epoch));
Sp=Range(Restrict(SpindlesPa{s,1},Epoch));

[Dat{9}, B] = CrossCorr(De, Range(Restrict(RipS,Epoch)), 1500, 40);
[Dat{10}, B] = CrossCorr(Sp, Range(Restrict(RipD,Epoch)), 1500, 40);
[Dat{11}, B] = CrossCorr(De, Range(Restrict(SpiR,Epoch)), 1500, 40);
[Dat{12}, B] = CrossCorr(Ri, Range(Restrict(SpiD,Epoch)), 1500, 40);
[Dat{13}, B] = CrossCorr(Sp, Range(Restrict(DelR,Epoch)), 1500, 40);
[Dat{14}, B] = CrossCorr(Ri, Range(Restrict(DelS,Epoch)), 1500, 40);


