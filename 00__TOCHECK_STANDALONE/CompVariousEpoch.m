function [c,SpBulb1,SpBulb2,SpBulb3,SpBulb4,SpBulb5,SpPFC1,SpPFC2,SpPFC3,SpPFC4,SpPFC5,SpPaC1,SpPaC2,SpPaC3,SpPaC4,SpPaC5,f,Ct1,Bt1,Ct2,Bt2,DurPeriods,Prop,vX,mHpc1a,sHpc1a,tpsHpc1a,mHpc1b,sHpc1b,tpsHpc1b,mHpc1c,sHpc1c,tpsHpc1c,mHpc2a,sHpc2a,tpsHpc2a,mHpc2b,sHpc2b,tpsHpc2b,mHpc2c,sHpc2c,tpsHpc2c]=CompVariousEpoch(Epoch)


%Sub Sleep Stages from PaCx ligne 45

limDeltaB=1;

SpBulb1=[];
SpBulb2=[];
SpBulb3=[];
SpBulb4=[];
SpBulb5=[];
SpPFC1=[];
SpPFC2=[];
SpPFC3=[];
SpPFC4=[];
SpPFC5=[];
SpPaC1=[];
SpPaC2=[];
SpPaC3=[];
SpPaC4=[];
SpPaC5=[];

freq=0.1:0.1:20;

res=pwd;
tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
chBulb=tempchBulb.channel;
eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])

% try
load StateEpochSB SWSEpoch REMEpoch Wake
    
  SWSEpoch;
  REMEpoch;
  Wake;  
    
% catch
% BulbSleepScriptKB(0)
% end



try
   Epoch;
   SWSEpoch=Restrict(SWSEpoch,Epoch);
    REMEpoch=Restrict(REMEpoch,Epoch);
    Wake=Restrict(Wake,Epoch);
end


[EpochSlow,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1,[5 6]);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% Sub-stages SWS from PaCx
% try
load SleepStagesPaCxDeep S12 S34 S5
S12;
% catch
%     GenerateDeltaSpindlesRipplesKB
%     load SleepStagesPaCxDeep S12 S34 S5
% end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


% try
%     load DeltaWaves
%     Dpfc;
%     Dpac;
% catch
%     rg1=End(SWSEpoch);
%     rg2=End(Wake);
%     rg3=End(REMEpoch);
%     TotEpoch=intervalSet(0,max([rg1;rg2;rg3]));
%     load StateEpochSB NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch TotalNoiseEpoch
%     try
%     TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),or(WeirdNoiseEpoch,ThresholdedNoiseEpoch));
%     catch
%            try
%             TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
%         catch
%             TotalNoiseEpoch=or(GndNoiseEpoch,NoiseEpoch);
%            end
%     end
%     TotEpoch=TotEpoch-TotalNoiseEpoch;
% 
% 
%     [Dpac,DeltaEpochPACx]=FindDeltaWavesChanGL('PaCx',TotEpoch);
%     Dpac=ts(Dpac);
% 
%     [Dpfc,DeltaEpochPFCx]=FindDeltaWavesChanGL('PFCx',TotEpoch);
%     Dpfc=ts(Dpfc);
% 
%     save DeltaWaves Dpfc Dpac
% 
% end

% 
% [BurstDeltaEpochPACx,NbD]=FindDeltaBurst2(Dpac,limDeltaB);
% [BurstDeltaEpochPFCx,NbD]=FindDeltaBurst2(Dpfc,limDeltaB);
% BurstDeltaEpoch=or(BurstDeltaEpochPACx,BurstDeltaEpochPFCx);
%     

[BurstDeltaEpoch,NbD]=FindDeltaBurst;

DurPeriods(1)=sum(End(S12,'s')-Start(S12,'s'));
DurPeriods(2)=sum(End(S34,'s')-Start(S34,'s'));
DurPeriods(3)=sum(End(BurstDeltaEpoch,'s')-Start(BurstDeltaEpoch,'s'));
DurPeriods(4)=sum(End(EpochSlow{11},'s')-Start(EpochSlow{11},'s'));
DurPeriods(5)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


op{1}=S12;
op{2}=S34;
op{3}=BurstDeltaEpoch;
op{4}=EpochSlow{11};
op{5}=REMEpoch;

tiOp{1}='S12';
tiOp{2}='S34';
tiOp{3}='Burst Delta';
tiOp{4}='Slow Bulb osci';
tiOp{5}='REM';

SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1,0,op,[0.5 1.5 2 2.5]);

[Prop,vX]=CompPropEpoch(op,1);

try
load RipplesdHPC25 dHPCrip
rip=ts(dHPCrip(:,2)*1E4);
end

try
    Dpac;
catch
    load DeltaPaCx
    Dpac=tDeltaT2;
end

try
    Dpfc;
catch
    load DeltaPFCx
    Dpfc=tDeltaT2;
end

try
    load SpindlesPaCxDeep SpiHigh
    SpiHigh;
catch
    GenerateDeltaSpindlesRipplesKB
end

load SpindlesPaCxDeep
spiHa=ts(SpiHigh(:,1)*1E4);
%spiHa=ts(SpiLow(:,1)*1E4);
%spiHa=ts(SpiULow(:,1)*1E4);

load SpindlesPFCxDeep
spiHf=ts(SpiHigh(:,1)*1E4);
%spiHf=ts(SpiLow(:,1)*1E4);
%spiHf=ts(SpiULow(:,1)*1E4);

clear c
for i=1:length(op)
c(1,i)=length(Range(Restrict(Dpfc,op{i})))/Prop(i,i);
end
for i=1:length(op)
c(2,i)=length(Range(Restrict(Dpac,op{i})))/Prop(i,i);
end
for i=1:length(op)
    try
c(3,i)=length(Range(Restrict(rip,op{i})))/Prop(i,i);
    catch
c(3,i)=nan;        
    end
end
for i=1:length(op)
c(4,i)=length(Range(Restrict(spiHf,op{i})))/Prop(i,i);
end
for i=1:length(op)
c(5,i)=length(Range(Restrict(spiHa,op{i})))/Prop(i,i);
end



[Ct1,Bt1]=CrossSpiRipDelta(spiHf,rip,Dpac,Dpfc,S12,S34);
[Ct2,Bt2]=CrossSpiRipDelta(spiHf,rip,Dpac,Dpfc,BurstDeltaEpoch,EpochSlow{11});



res=pwd;
tempchHpc=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
chHpc=tempchHpc.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHpc),'.mat'');'])

Fil=FilterLFP(LFP,[130 250],512);
Hil=tsd(Range(Fil),abs(hilbert(Data(Fil))));

load SpindlesPFCxDeep
[mHpc1a,sHpc1a,tpsHpc1a]=mETAverage(SpiHigh(:,2)*1E4,Range(Hil),Data(Hil),1,2000);
[mHpc1b,sHpc1b,tpsHpc1b]=mETAverage(SpiLow(:,2)*1E4,Range(Hil),Data(Hil),1,2000);
[mHpc1c,sHpc1c,tpsHpc1c]=mETAverage(SpiULow(:,2)*1E4,Range(Hil),Data(Hil),1,2000);

load SpindlesPaCxDeep
[mHpc2a,sHpc2a,tpsHpc2a]=mETAverage(SpiHigh(:,2)*1E4,Range(Hil),Data(Hil),1,2000);
[mHpc2b,sHpc2b,tpsHpc2b]=mETAverage(SpiLow(:,2)*1E4,Range(Hil),Data(Hil),1,2000);
[mHpc2c,sHpc2c,tpsHpc2c]=mETAverage(SpiULow(:,2)*1E4,Range(Hil),Data(Hil),1,2000);


%figure('color',[1 1 1]), imagesc(c)
tic{1}='Delta Pfc';
tic{2}='Delta Par';
tic{3}='Ripples';
tic{4}='Spindles Pfc';
tic{5}='Spindles Par';



figure('color',[1 1 1]),
for i=1:length(op)
    try
subplot(5,1,i), PlotErrorBarN(c(i,:),0);title(tic{i})
set(gca,'Xtick',[1:4])
set(gca,'XTickLabel',tiOp)
    end
end




if 1
    
    clear Sp
    clear f
    clear t
    
    try
    try
        tempchBulb=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        Sp;
    catch
    load LFPData/InfoLFP
    [params,movingwin,suffix]=SpectrumParametersML('low');
    ComputeSpectrogram_newML(movingwin,params,InfoLFP,'PFCx','All',suffix);
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    end
    
    a=1;
    Stsd=tsd(t*1E4,Sp);
    for kl=1:length(op)
    temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
    temp2{kl}=tsd(f,temp{kl}');
    end
    SpPFC1(a,:)=Data(Restrict(temp2{1},freq))';
    SpPFC2(a,:)=Data(Restrict(temp2{2},freq))';
    SpPFC3(a,:)=Data(Restrict(temp2{3},freq))';
    SpPFC4(a,:)=Data(Restrict(temp2{4},freq))';
    SpPFC5(a,:)=Data(Restrict(temp2{5},freq))';
  
    figure('color',[1 1 1]), plot(f,mean(Data(Restrict(Stsd,op{1}))),'r','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{2}))),'m','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{3}))),'k','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{4}))),'b','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{5}))),'g','linewidth',2)
   title('PFC, deep')
    end
    
    clear Sp
    clear f
    clear t
   try
       
    clear ChBulb
    try
      tempchBulb=load([res,'/ChannelsToAnalyse/PaCx_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        Sp;
    catch
    load LFPData/InfoLFP
    [params,movingwin,suffix]=SpectrumParametersML('low');
    ComputeSpectrogram_newML(movingwin,params,InfoLFP,'PaCx','All',suffix);
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        end
    
    a=1;
    Stsd=tsd(t*1E4,Sp);
    for kl=1:length(op)
    temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
    temp2{kl}=tsd(f,temp{kl}');
    end
    SpPaC1(a,:)=Data(Restrict(temp2{1},freq))';
    SpPaC2(a,:)=Data(Restrict(temp2{2},freq))';
    SpPaC3(a,:)=Data(Restrict(temp2{3},freq))';
    SpPaC4(a,:)=Data(Restrict(temp2{4},freq))';
    SpPaC5(a,:)=Data(Restrict(temp2{5},freq))';

    figure('color',[1 1 1]), plot(f,mean(Data(Restrict(Stsd,op{1}))),'r','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{2}))),'m','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{3}))),'k','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{4}))),'b','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{5}))),'g','linewidth',2)
   title('PaCx, deep')
%    catch
%        keyboard
   end
   
   
    clear Sp
    clear f
    clear t
    
   try
       try
    clear ChBulb
      tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])

        Sp;
    catch
    load LFPData/InfoLFP
    [params,movingwin,suffix]=SpectrumParametersML('low');
    ComputeSpectrogram_newML(movingwin,params,InfoLFP,'Bulb','All',suffix);
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
     end
        
    a=1;
    Stsd=tsd(t*1E4,Sp);
     for kl=1:length(op)
    temp{kl}=mean(Data(Restrict(Stsd,op{kl})));
    temp2{kl}=tsd(f,temp{kl}');
     end
    SpBulb1(a,:)=Data(Restrict(temp2{1},freq))';
    SpBulb2(a,:)=Data(Restrict(temp2{2},freq))';
    SpBulb3(a,:)=Data(Restrict(temp2{3},freq))';
    SpBulb4(a,:)=Data(Restrict(temp2{4},freq))';
    SpBulb5(a,:)=Data(Restrict(temp2{5},freq))';
    
    figure('color',[1 1 1]), plot(f,mean(Data(Restrict(Stsd,op{1}))),'r','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{2}))),'m','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{3}))),'k','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{4}))),'b','linewidth',2)
    hold on, plot(f,mean(Data(Restrict(Stsd,op{5}))),'g','linewidth',2)
      title('Bulb, deep')      
   end      
    
   
%    load LFPData/InfoLFP
%    [params,movingwin,suffix]=SpectrumParametersML('low');
%    ComputeSpectrogram_newML(movingwin,params,InfoLFP,'dHPC','All',suffix);
%     
    
else
    
    

        load LFPData/InfoLFP

        res=pwd;
        a=1;
        for i=1:32
            try
            if InfoLFP.structure{i}=='PFCx'
            eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(InfoLFP.channel(i)),'.mat'');']) 
            Stsd=tsd(t*1E4,Sp);
            SpPFC1(a,:)=mean(Data(Restrict(Stsd,op{1})));
            SpPFC2(a,:)=mean(Data(Restrict(Stsd,op{2})));
            SpPFC3(a,:)=mean(Data(Restrict(Stsd,op{3})));
            SpPFC4(a,:)=mean(Data(Restrict(Stsd,op{4})));
            SpPFC5(a,:)=mean(Data(Restrict(Stsd,op{5})));
            
            figure('color',[1 1 1]), plot(f,mean(Data(Restrict(Stsd,op{1}))),'r','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{2}))),'m','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{3}))),'k','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{4}))),'b','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{5}))),'g','linewidth',2)
            title([InfoLFP.structure(i), ' ',num2str(InfoLFP.depth(i))])
            a=a+1;
            end
            end
        end

        a=1;
        res=pwd;
        for i=1:32
             try
            if InfoLFP.structure{i}=='PaCx'
            eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(InfoLFP.channel(i)),'.mat'');']) 
            Stsd=tsd(t*1E4,Sp);
            SpPaC1(a,:)=mean(Data(Restrict(Stsd,op{1})));
            SpPaC2(a,:)=mean(Data(Restrict(Stsd,op{2})));
            SpPaC3(a,:)=mean(Data(Restrict(Stsd,op{3})));
            SpPaC4(a,:)=mean(Data(Restrict(Stsd,op{4})));
            SpPaC5(a,:)=mean(Data(Restrict(Stsd,op{5})));
            
            figure('color',[1 1 1]), plot(f,mean(Data(Restrict(Stsd,op{1}))),'r','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{2}))),'m','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{3}))),'k','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{4}))),'b','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{5}))),'g','linewidth',2)
            title([InfoLFP.structure(i), ' ',num2str(InfoLFP.depth(i))])
                a=a+1; 
            end
            end
        end

        a=1;
        res=pwd;
        for i=1:32
            try
            if InfoLFP.structure{i}=='Bulb'
            eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(InfoLFP.channel(i)),'.mat'');']) 
            Stsd=tsd(t*1E4,Sp);
            SpBulb1(a,:)=mean(Data(Restrict(Stsd,op{1})));
            SpBulb2(a,:)=mean(Data(Restrict(Stsd,op{2})));
            SpBulb3(a,:)=mean(Data(Restrict(Stsd,op{3})));
            SpBulb4(a,:)=mean(Data(Restrict(Stsd,op{4})));
            SpBulb5(a,:)=mean(Data(Restrict(Stsd,op{5})));
            figure('color',[1 1 1]), plot(f,mean(Data(Restrict(Stsd,op{1}))),'r','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{2}))),'m','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{3}))),'k','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{4}))),'b','linewidth',2)
            hold on, plot(f,mean(Data(Restrict(Stsd,op{5}))),'g','linewidth',2)
            title([InfoLFP.structure(i), ' ',num2str(InfoLFP.depth(i))])
                a=a+1;
            end
            end
        end

end
