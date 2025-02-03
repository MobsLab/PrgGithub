function [CPre,BPre,CPost,BPost,NPre,NPost,N2Pre,N2Post]=BilanCrossCorrSpindles(LFPAnalysis,Struct1,Struct,LowHigh,fac)

try
    fac;
catch
    fac=1;
end

if Struct1=='Pfc'
nu=2; %Ref='Pfc';
elseif Struct1=='Par'
nu=3;    
elseif Struct1=='Aud'
nu=4;
end

para(1)=100;
para(2)=50;
smo=3;

try
    LFPAnalysis;
catch
    LFPAnalysis=0;
end
try 
if LowHigh=='H'
    clear LowHigh
    LowHigh{1}='H';
    LowHigh{2}='H';
end
end

try  
if LowHigh=='L'
    clear LowHigh
    LowHigh{1}='L';
    LowHigh{2}='L';
end
end

try
    LowHigh{1};
catch
    LowHigh{1}='H';
    LowHigh{2}='H';
end

try
    LowHigh{2};
catch
    LowHigh{2}=LowHigh(1);
end


try
Struct;
catch
Struct='Par';
end


load behavResources PreEpoch VEHEpoch LPSEpoch H24Epoch H48Epoch CPEpoch DPCPXEpoch 
load StateEpoch SWSEpoch

try
    try
        Epoch2=LPSEpoch;
    end

    try
        Epoch2=CPEpoch;
        PreEpoch=or(VEHEpoch,PreEPoch);
    end

    try
        Epoch2=DPCPXEpoch;
        PreEpoch=VEHEpoch;
    end


    try
        Epoch2=H24Epoch;
        PreEpoch=H24Epoch;
    end

    try
        Epoch2=H48Epoch;
        PreEpoch=H48Epoch;
    end

    Epoch2;

catch
    
    try
        Epoch2=VEHEpoch;
    end
end

    load StateEpoch NoiseEpoch WeirdNoiseEpoch GndNoiseEpoch 
try
    PreEpoch=PreEpoch-NoiseEpoch;
end
try
    PreEpoch=PreEpoch-GndNoiseEpoch;
end
try
    PreEpoch=PreEpoch-WeirdNoiseEpoch;
end
try
Epoch2=Epoch2-NoiseEpoch;
end
try
    Epoch2=Epoch2-GndNoiseEpoch;
end
try
    Epoch2=Epoch2-WeirdNoiseEpoch;
end


if nu==2;
   % load LFPPFCx
    
    try
        load('ChannelsToAnalyse/PFCx_deep')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{1}=LFP;
    try
    load('ChannelsToAnalyse/PFCx_sup')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    end
    LFPtemp{2}=LFP;
    LFP=LFPtemp;
    try
        LFP=tsdArray(LFP);
    end
    catch
        load LFPFCx
    end
    
    
    
    if LFPAnalysis
        for i=1:length(LFP)
        LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
        end
    LFPp=LFP;
    end
    
elseif nu==3
       % load LFPPaCx
        try
    load('ChannelsToAnalyse/PaCx_deep')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{1}=LFP;
    load('ChannelsToAnalyse/PaCx_sup')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{2}=LFP;
    LFP=LFPtemp;
    try
        LFP=tsdArray(LFP);
    end   
    catch
        
    load LFPPaCx
        end
    
    if LFPAnalysis
        for i=1:length(LFP)
        LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
        end        
    LFPp=LFP;
    end
elseif nu==4
        load LFPAuCx
    if LFPAnalysis
        for i=1:length(LFP)
        LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
        end        
    LFPp=LFP;
    end    
end

    
    
load SpindlesRipples Rip
load Spindles SpiH SpiL


if Struct=='Hpc'
    num=1;
    if LFPAnalysis
    
      %  load LFPdHpc
        
        
        try
        load LFPdHPC
        catch
            load SpindlesRipples LFPh
        end

            try
            for i=1:length(LFP)
            LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
            end
            LFPRip=LFP{1};
            catch
              LFPRip=LFPh{1};
              LFP=LFPh;

            end



        for i=1:length(LFP)
        LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
        end
    end
elseif Struct=='Par'
   if LFPAnalysis
           try
    load('ChannelsToAnalyse/PaCx_deep')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{1}=LFP;
    load('ChannelsToAnalyse/PaCx_sup')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{2}=LFP;
    LFP=LFPtemp;
    try
        LFP=tsdArray(LFP);
    end   
    catch
        
    load LFPPaCx
           end
        
               for i=1:length(LFP)
        LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
        end
   end
    num=3;
elseif Struct=='Aud'
    if LFPAnalysis
        load LFPAuCx
                for i=1:length(LFP)
        LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
        end
    end
    num=4;
elseif Struct=='Pfc'
    num=2;
     try
        load('ChannelsToAnalyse/PFCx_deep')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{1}=LFP;
    load('ChannelsToAnalyse/PFCx_sup')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{2}=LFP;
    LFP=LFPtemp;
    try
        LFP=tsdArray(LFP);
    end
    catch
        load LFPFCx
     end
    
end




%%

if LowHigh{1}=='H'
    for i=1:3
    GoodSpiH{i}=SpiH{nu,i};
    end
else
    for i=1:3
    GoodSpiH{i}=SpiL{nu,i};
    end
end



for i=1:3
    try
spitsdH{i}=tsd(GoodSpiH{i}(:,2)*1E4,GoodSpiH{i});
    catch
        try
spitsdH{i}=tsd(GoodSpiH{i-1}(:,2)*1E4,GoodSpiH{i-1});  
        catch
            spitsdH{i}=tsd(1,1);
        end
    end
    
end
try
spitsdH=tsdArray(spitsdH);
end

spitsdtemp=Restrict(spitsdH,PreEpoch);
for i=1:3
    GoodSpiPreH{i}=Data(spitsdtemp{i});
    NPre{i}=size(GoodSpiPreH{i},1)/sum(End(and(PreEpoch,SWSEpoch),'s')-Start(and(PreEpoch,SWSEpoch),'s'));;
end
spitsdtemp=Restrict(spitsdH,Epoch2);
for i=1:3
    GoodSpiPostH{i}=Data(spitsdtemp{i});
    NPost{i}=size(GoodSpiPostH{i},1)/sum(End(and(Epoch2,SWSEpoch),'s')-Start(and(Epoch2,SWSEpoch),'s'));;
end


if LFPAnalysis

        ylF=[0 0];
        figure('color',[1 1 1]), 
        for i=1:3
        M1SpiPre{i}=PlotRipRaw(LFPp{1},GoodSpiPreH{i},500);close
        M2SpiPre{i}=PlotRipRaw(LFPp{2},GoodSpiPreH{i},500);close
        try
        M3SpiPre{i}=PlotRipRaw(LFPp{3},GoodSpiPreH{i},500);close
        catch
            M3SpiPre{i}=[];
        end
        subplot(2,3,i),
        try
        plot(M1SpiPre{i}(:,1),M1SpiPre{i}(:,2),'b','linewidth',2)
        hold on, plot(M2SpiPre{i}(:,1),M2SpiPre{i}(:,2),'k','linewidth',2)
        end
        try
        hold on, plot(M3SpiPre{i}(:,1),M3SpiPre{i}(:,2),'r','linewidth',2)
        end
        yl=ylim;
        ylF=[min(ylF(1),yl(1)) max(ylF(2),yl(2))];
        end
        subplot(2,3,1),ylim(ylF)
        subplot(2,3,2),ylim(ylF),title(pwd)
        subplot(2,3,3),ylim(ylF)


        for i=1:3
        M1SpiPost{i}=PlotRipRaw(LFPp{1},GoodSpiPostH{i},500);close
        M2SpiPost{i}=PlotRipRaw(LFPp{2},GoodSpiPostH{i},500);close
        try
        M3SpiPost{i}=PlotRipRaw(LFPp{3},GoodSpiPostH{i},500);close
        catch
            M3SpiPost{i}=[];
        end
            subplot(2,3,i+3),
            try
                plot(M1SpiPost{i}(:,1),M1SpiPost{i}(:,2),'b','linewidth',2)
        hold on, plot(M2SpiPost{i}(:,1),M2SpiPost{i}(:,2),'k','linewidth',2)
            end
        try
        hold on, plot(M3SpiPost{i}(:,1),M3SpiPost{i}(:,2),'r','linewidth',2)
        end
        yl=ylim;
        ylF=[min(ylF(1),yl(1)) max(ylF(2),yl(2))];
        end
        subplot(2,3,4),ylim(ylF)
        subplot(2,3,5),ylim(ylF),
    
            title(Struct1)
   
        subplot(2,3,6),ylim(ylF)

end

%%
if Struct=='Hpc'
    for i=1:3
    GoodSpiH2{i}=Rip;
    end
else
    
if LowHigh{2}=='H'
    for i=1:3
    GoodSpiH2{i}=SpiH{num,i};
    end
else
    for i=1:3
    GoodSpiH2{i}=SpiL{num,i};
    end
end
end

for i=1:3
    try
spitsdH2{i}=tsd(GoodSpiH2{i}(:,2)*1E4,GoodSpiH2{i});
    catch
spitsdH2{i}=tsd(GoodSpiH2{i-1}(:,2)*1E4,GoodSpiH2{i-1});        
    end
    
end
try
spitsdH2=tsdArray(spitsdH2);
end

spitsdtemp2=Restrict(spitsdH2,PreEpoch);
for i=1:3
    GoodSpiPreH2{i}=Data(spitsdtemp2{i});
    N2Pre{i}=size(GoodSpiPreH2{i},1)/sum(End(and(PreEpoch,SWSEpoch),'s')-Start(and(PreEpoch,SWSEpoch),'s'));
end
spitsdtemp2=Restrict(spitsdH2,Epoch2);
for i=1:3
    GoodSpiPostH2{i}=Data(spitsdtemp2{i});
    N2Post{i}=size(GoodSpiPostH2{i},1)/sum(End(and(Epoch2,SWSEpoch),'s')-Start(and(Epoch2,SWSEpoch),'s'));
end



if LFPAnalysis

        ylF=[0 0];
        figure('color',[1 1 1]), 
        for i=1:3
        M1SpiPre2{i}=PlotRipRaw(LFP{1},GoodSpiPreH2{i},500);close
        M2SpiPre2{i}=PlotRipRaw(LFP{2},GoodSpiPreH2{i},500);close
        try
        M3SpiPre2{i}=PlotRipRaw(LFP{3},GoodSpiPreH2{i},500);close
        catch
            M3SpiPre2{i}=[];
        end
        subplot(2,3,i),
        try
        plot(M1SpiPre2{i}(:,1),M1SpiPre2{i}(:,2),'b','linewidth',2)
        hold on, plot(M2SpiPre2{i}(:,1),M2SpiPre2{i}(:,2),'k','linewidth',2)
        end
        try
        hold on, plot(M3SpiPre2{i}(:,1),M3SpiPre2{i}(:,2),'r','linewidth',2)
        end
        yl=ylim;
        ylF=[min(ylF(1),yl(1)) max(ylF(2),yl(2))];
        end
        subplot(2,3,1),ylim(ylF)
        subplot(2,3,2),ylim(ylF),title(pwd)
        subplot(2,3,3),ylim(ylF)


        for i=1:3
        M1SpiPost2{i}=PlotRipRaw(LFP{1},GoodSpiPostH2{i},500);close
        M2SpiPost2{i}=PlotRipRaw(LFP{2},GoodSpiPostH2{i},500);close
        try
        M3SpiPost2{i}=PlotRipRaw(LFP{3},GoodSpiPostH2{i},500);close
        catch
            M3SpiPost2{i}=[];
        end
            subplot(2,3,i+3),
            try
                plot(M1SpiPost2{i}(:,1),M1SpiPost2{i}(:,2),'b','linewidth',2)
        hold on, plot(M2SpiPost2{i}(:,1),M2SpiPost2{i}(:,2),'k','linewidth',2)
            end
        try
        hold on, plot(M3SpiPost2{i}(:,1),M3SpiPost2{i}(:,2),'r','linewidth',2)
        end
        yl=ylim;
        ylF=[min(ylF(1),yl(1)) max(ylF(2),yl(2))];
        end
        subplot(2,3,4),ylim(ylF)
        subplot(2,3,5),ylim(ylF),title(Struct)
        subplot(2,3,6),ylim(ylF)

end

%%



for i=1:3
    for j=i:3
try
        [CPre{i,j},BPre{i,j}]=CrossCorr(GoodSpiPreH{i}(:,2)*1E4,GoodSpiPreH2{j}(:,2)*1E4,para(1),para(2));
catch
    CPre{i,j}=[];
    BPre{i,j}=[];
end
try
[CPost{i,j},BPost{i,j}]=CrossCorr(GoodSpiPostH{i}(:,2)*1E4,GoodSpiPostH2{j}(:,2)*1E4,para(1),para(2));
   catch
    CPost{i,j}=[];
    BPost{i,j}=[];
end
end
end



figure('color',[1 1 1])
for i=1:3
    for j=i:3
subplot(3,3,MatXY(i,j,3)),hold on
try
        plot(BPre{i,j}/1E3,smooth(CPre{i,j},smo),'k')
        plot(BPost{i,j}/1E3,smooth(CPost{i,j},smo),'r')        
        xlim([-para(1)*para(2)/2E3 para(1)*para(2)/2E3])
        yl=ylim;
        line([0 0],yl,'color',[0.7 0.7 0.7])
end
    end
end

