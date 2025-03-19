
try
    cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243
catch
    cd /media/karimjunior/MOBs_KJ/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243
end
%%




%%

load('B_High_Spectrum.mat')
    Spb=Spectro{1}; tb=Spectro{2};fb=Spectro{3};
    Sstdb=tsd(tb*1E4,Spb);

    res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    SpBulb=Sp;
    fBulb=f;
    tBulb=t;
    try
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel');
    catch
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
    end
    chHPC=tempchHPC.channel;
    try
    clear Sp
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
    Sp;
    catch
        [Sp,t,f]=LoadSpectrumML(chHPC,pwd,'low');
        eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
    end
    
    SpHpc=Sp;
    fHpc=f;
    tHpc=t;
    tempchPFC=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
    chPFC=tempchPFC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chPFC),'.mat'');'])
    SpPfc=Sp;
    fPfc=f;
    tPfc=t;



%%


[SleepCycle,Mat1,CaracSlCy,SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch,N1,N2,N3]=ComputeSleepCycle(15,0,DoAnlysisSB);

[Wake,REM,N1,N2,N3]=RunSubstages;

%%

en=End(REMEpochC);
st=Start(REMEpochC);
idc=find((End(REMEpochC,'s')-Start(REMEpochC,'s'))>15); % by default 25 sc
  
StsdPfc=tsd(tPfc*1E4,SpPfc);
[M1,S1,t1]=AverageSpectrogram(StsdPfc,fPfc,ts(en(idc)),200,200,1,[],1);  title('End REM - PFC')
StsdHpc=tsd(tHpc*1E4,SpHpc);
[M2,S2,t2]=AverageSpectrogram(StsdHpc,fHpc,ts(en(idc)),200,200,1,[],1);    title('End REM - HPC')       
StsdBulb=tsd(tBulb*1E4,SpBulb);
[M3,S3,t3]=AverageSpectrogram(StsdBulb,fBulb,ts(en(idc)),200,200,1,[],1);    title('End REM - Bulb')
[M4,S4,t4]=AverageSpectrogram(Sstdb,fb,ts(en(idc)),200,200,1,[],1);    title('End REM - Bulb High')

[M1b,S1b,t1b]=AverageSpectrogram(StsdPfc,fPfc,ts(st(idc)),200,200,1,[],1);  title('Start REM - PFC')
[M2b,S2b,t2b]=AverageSpectrogram(StsdHpc,fHpc,ts(st(idc)),200,200,1,[],1);    title('Start REM - HPC')       
[M3b,S3b,t3b]=AverageSpectrogram(StsdBulb,fBulb,ts(st(idc)),200,200,1,[],1);    title('Start REM - Bulb')
[M4b,S4b,t4b]=AverageSpectrogram(Sstdb,fb,ts(st(idc)),200,200,1,[],1);    title('Start REM - Bulb High')

en=End(N1);
st=Start(N1);
idc=find((End(N1,'s')-Start(N1,'s'))>3); % by default 25 sc
  
StsdPfc=tsd(tPfc*1E4,SpPfc);
[M1,S1,t1]=AverageSpectrogram(StsdPfc,fPfc,ts(en(idc)),200,200,1,[],1);  title('End N1 - PFC')
StsdHpc=tsd(tHpc*1E4,SpHpc);
[M2,S2,t2]=AverageSpectrogram(StsdHpc,fHpc,ts(en(idc)),200,200,1,[],1);    title('End N1 - HPC')       
StsdBulb=tsd(tBulb*1E4,SpBulb);
[M3,S3,t3]=AverageSpectrogram(StsdBulb,fBulb,ts(en(idc)),200,200,1,[],1);    title('End N1 - Bulb')
[M4,S4,t4]=AverageSpectrogram(Sstdb,fb,ts(en(idc)),200,200,1,[],1);    title('End N1 - Bulb High')

[M1b,S1b,t1b]=AverageSpectrogram(StsdPfc,fPfc,ts(st(idc)),200,200,1,[],1);  title('Start N1 - PFC')
[M2b,S2b,t2b]=AverageSpectrogram(StsdHpc,fHpc,ts(st(idc)),200,200,1,[],1);    title('Start N1 - HPC')       
[M3b,S3b,t3b]=AverageSpectrogram(StsdBulb,fBulb,ts(st(idc)),200,200,1,[],1);    title('Start N1 - Bulb')
[M4b,S4b,t4b]=AverageSpectrogram(Sstdb,fb,ts(st(idc)),200,200,1,[],1);    title('Start N1 - Bulb High')

en=End(N2);
st=Start(N2);
idc=find((End(N2,'s')-Start(N2,'s'))>3); % by default 25 sc
  
StsdPfc=tsd(tPfc*1E4,SpPfc);
[M1,S1,t1]=AverageSpectrogram(StsdPfc,fPfc,ts(en(idc)),200,200,1,[],1);  title('End N2 - PFC')
StsdHpc=tsd(tHpc*1E4,SpHpc);
[M2,S2,t2]=AverageSpectrogram(StsdHpc,fHpc,ts(en(idc)),200,200,1,[],1);    title('End N2 - HPC')       
StsdBulb=tsd(tBulb*1E4,SpBulb);
[M3,S3,t3]=AverageSpectrogram(StsdBulb,fBulb,ts(en(idc)),200,200,1,[],1);    title('End N2 - Bulb')
[M4,S4,t4]=AverageSpectrogram(Sstdb,fb,ts(en(idc)),200,200,1,[],1);    title('End N2 - Bulb High')

[M1b,S1b,t1b]=AverageSpectrogram(StsdPfc,fPfc,ts(st(idc)),200,200,1,[],1);  title('Start N2 - PFC')
[M2b,S2b,t2b]=AverageSpectrogram(StsdHpc,fHpc,ts(st(idc)),200,200,1,[],1);    title('Start N2 - HPC')       
[M3b,S3b,t3b]=AverageSpectrogram(StsdBulb,fBulb,ts(st(idc)),200,200,1,[],1);    title('Start N2 - Bulb')
[M4b,S4b,t4b]=AverageSpectrogram(Sstdb,fb,ts(st(idc)),200,200,1,[],1);    title('Start N2 - Bulb High')

en=End(N3);
st=Start(N3);
idc=find((End(N3,'s')-Start(N3,'s'))>3); % by default 25 sc
  
StsdPfc=tsd(tPfc*1E4,SpPfc);
[M1,S1,t1]=AverageSpectrogram(StsdPfc,fPfc,ts(en(idc)),200,200,1,[],1);  title('End N3 - PFC')
StsdHpc=tsd(tHpc*1E4,SpHpc);
[M2,S2,t2]=AverageSpectrogram(StsdHpc,fHpc,ts(en(idc)),200,200,1,[],1);    title('End N3 - HPC')       
StsdBulb=tsd(tBulb*1E4,SpBulb);
[M3,S3,t3]=AverageSpectrogram(StsdBulb,fBulb,ts(en(idc)),200,200,1,[],1);    title('End N3 - Bulb')
[M4,S4,t4]=AverageSpectrogram(Sstdb,fb,ts(en(idc)),200,200,1,[],1);    title('End N3 - Bulb High')

[M1b,S1b,t1b]=AverageSpectrogram(StsdPfc,fPfc,ts(st(idc)),200,200,1,[],1);  title('Start N3 - PFC')
[M2b,S2b,t2b]=AverageSpectrogram(StsdHpc,fHpc,ts(st(idc)),200,200,1,[],1);    title('Start N3 - HPC')       
[M3b,S3b,t3b]=AverageSpectrogram(StsdBulb,fBulb,ts(st(idc)),200,200,1,[],1);    title('Start N3 - Bulb')
[M4b,S4b,t4b]=AverageSpectrogram(Sstdb,fb,ts(st(idc)),200,200,1,[],1);    title('Start N3 - Bulb High')

    
%%  

[Wake,REM,N1,N2,N3]=RunSubstages;


for i=1:37
try
eval(['load(''',res,'','/LFPData/LFP',num2str(i),'.mat'');'])
[mto{i,1},sto{i,1},tpsto{i,1}]=mETAverage(TONEtime2,Range(LFP),Data(LFP),1,5000);
[mto{i,2},sto{i,2},tpsto{i,2}]=mETAverage(Range(Restrict(ts(TONEtime2),Wake)),Range(LFP),Data(LFP),1,5000);
[mto{i,3},sto{i,3},tpsto{i,3}]=mETAverage(Range(Restrict(ts(TONEtime2),REM)),Range(LFP),Data(LFP),1,5000);
[mto{i,4},sto{i,4},tpsto{i,4}]=mETAverage(Range(Restrict(ts(TONEtime2),N1)),Range(LFP),Data(LFP),1,5000);
[mto{i,5},sto{i,5},tpsto{i,5}]=mETAverage(Range(Restrict(ts(TONEtime2),N2)),Range(LFP),Data(LFP),1,5000);
[mto{i,6},sto{i,6},tpsto{i,6}]=mETAverage(Range(Restrict(ts(TONEtime2),N3)),Range(LFP),Data(LFP),1,5000);

clear LFP
figure, hold on
plot(tpsto{i,1},mto{i,1},'k')
plot(tpsto{i,2},mto{i,2},'color',[0.6 0.6 0.6])
plot(tpsto{i,3},mto{i,3},'color','g')
plot(tpsto{i,4},mto{i,4},'color',[1 0 0])
plot(tpsto{i,5},mto{i,5},'color',[1 0 0.5])
plot(tpsto{i,6},mto{i,6},'color','b')
line([0 0],ylim,'color','r')
pause(0)
end
end



figure, 
for i=[[1:6],[16:34]]
subplot(3,2,1), hold on, plot(tpsto{i,1},mto{i,1},'k'),line([0 0],ylim,'color','r')
subplot(3,2,2), hold on, plot(tpsto{i,2},mto{i,2},'color',[0.6 0.6 0.6]),line([0 0],ylim,'color','r')
subplot(3,2,3), hold on, plot(tpsto{i,3},mto{i,3},'color','g'),line([0 0],ylim,'color','r')
subplot(3,2,4), hold on, plot(tpsto{i,4},mto{i,4},'color',[1 0 0]),line([0 0],ylim,'color','r')
subplot(3,2,5), hold on, plot(tpsto{i,5},mto{i,5},'color',[1 0 0.5]),line([0 0],ylim,'color','r')
subplot(3,2,6), hold on, plot(tpsto{i,6},mto{i,6},'color','b'),line([0 0],ylim,'color','r')
end

figure, 
for i=[[1:6],[16:34]]
hold on, plot(tpsto{i,6},mto{i,6},'k'),line([0 0],ylim,'color','r')
end
figure, [fh,sq,sweeps] = RasterPETH(S{7}, Restrict(ts(TONEtime2),Wake), -15000,+15000,'BinSize',50,'Markers',{ts(TONEtime1)},'MarkerTypes',{'ro','r'});
figure, [fh,sq,sweeps] = RasterPETH(S{7}, Restrict(ts(TONEtime2),or(N2,N3)), -15000,+15000,'BinSize',50,'Markers',{ts(TONEtime1)},'MarkerTypes',{'ro','r'});
figure, [fh,sq,sweeps] = RasterPETH(S{7}, Restrict(ts(TONEtime2),or(N1,REM)), -15000,+15000,'BinSize',50,'Markers',{ts(TONEtime1)},'MarkerTypes',{'ro','r'});





for i=1:length(S)
    figure
    [C,B]=CrossCorr(TONEtime1,Range(S{i}),50,100); 
    [C2,B2]=CrossCorr(TONEtime2,Range(S{i}),50,100); 
    subplot(3,2,1), hold on
    plot(B/1E3,C,'k'), 
    plot(B2/1E3,C2,'b'), 
    line([0 0],ylim,'color','r')
    title([num2str(i),' - total'])
    
    [C,B]=CrossCorr(Range(Restrict(ts(TONEtime1),Wake)),Range(S{i}),50,100); 
    [C2,B2]=CrossCorr(Range(Restrict(ts(TONEtime2),Wake)),Range(S{i}),50,100); 
    subplot(3,2,2), hold on
    plot(B/1E3,C,'k'), 
    plot(B2/1E3,C2,'b'), 
    line([0 0],ylim,'color','r')
    title([num2str(i),' - Wake'])
    
    [C,B]=CrossCorr(Range(Restrict(ts(TONEtime1),REMEpoch)),Range(S{i}),50,100); 
    [C2,B2]=CrossCorr(Range(Restrict(ts(TONEtime2),REMEpoch)),Range(S{i}),50,100); 
        subplot(3,2,3), hold on
    plot(B/1E3,C,'k'), 
    plot(B2/1E3,C2,'b'), 
    line([0 0],ylim,'color','r')
    title([num2str(i),' - REM'])
    
    [C,B]=CrossCorr(Range(Restrict(ts(TONEtime1),N1)),Range(S{i}),50,100); 
    [C2,B2]=CrossCorr(Range(Restrict(ts(TONEtime2),N1)),Range(S{i}),50,100); 
        subplot(3,2,4), hold on
    plot(B/1E3,C,'k'), 
    plot(B2/1E3,C2,'b'), 
    line([0 0],ylim,'color','r')
    title([num2str(i),' - N1'])    
    
    [C,B]=CrossCorr(Range(Restrict(ts(TONEtime1),N2)),Range(S{i}),50,100); 
    [C2,B2]=CrossCorr(Range(Restrict(ts(TONEtime2),N2)),Range(S{i}),50,100); 
    subplot(3,2,5), hold on
    plot(B/1E3,C,'k'), 
    plot(B2/1E3,C2,'b'), 
    line([0 0],ylim,'color','r')
    title([num2str(i),' - N2'])
    
    [C,B]=CrossCorr(Range(Restrict(ts(TONEtime1),N3)),Range(S{i}),50,100); 
    [C2,B2]=CrossCorr(Range(Restrict(ts(TONEtime2),N3)),Range(S{i}),50,100); 

    
    subplot(3,2,6), hold on
    plot(B/1E3,C,'k'), 
    plot(B2/1E3,C2,'b'), 
    line([0 0],ylim,'color','r')
    title([num2str(i),' - N3'])    
end

figure, [fh,sq,sweeps] = RasterPETH(S{7}, Restrict(ts(TONEtime2),Wake), -15000,+15000,'BinSize',50,'Markers',{ts(TONEtime1)},'MarkerTypes',{'ro','r'});
figure, [fh,sq,sweeps] = RasterPETH(S{7}, Restrict(ts(TONEtime2),or(N2,N3)), -15000,+15000,'BinSize',50,'Markers',{ts(TONEtime1)},'MarkerTypes',{'ro','r'});
figure, [fh,sq,sweeps] = RasterPETH(S{7}, Restrict(ts(TONEtime2),or(N1,REM)), -15000,+15000,'BinSize',50,'Markers',{ts(TONEtime1)},'MarkerTypes',{'ro','r'});


listUp=[7,9,10,32];
listDown=[23,30,35,36];




%%

try
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel');
    catch
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
    end
    chHPC=tempchHPC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
    SpHpc=Sp;
    fHpc=f;
    tHpc=t;
    tempchPFC=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
    chPFC=tempchPFC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chPFC),'.mat'');'])
    SpPfc=Sp;
    fPfc=f;
    tPfc=t;

StsdPfc=tsd(tPfc*1E4,SpPfc);
Stsd=tsd(tPfc*1E4,SpHpc);

enn1=End(N1);
stn1=Start(N1);

enn2=End(N2);
stn2=Start(N2);

enn3=End(N3);
stn3=Start(N3);

enrem=End(REM);
strem=Start(REM);

enwake=End(WAKE);
stwake=Start(WAKE);

tt=stn1;
tt=enn1;
[M1pfc,S1pfc,t1pfc]=AverageSpectrogram(StsdPfc,fPfc,ts(tt),200,200,1,[],1); title('PFC')
[M1,S1,t1]=AverageSpectrogram(Stsd,fHpc,ts(tt),200,200,1,[],1); title('HPC')




rgg=Range(Restrict(StsdPfc,TempEpoch),'s');
        figure, 
        subplot(2,1,1), imagesc(Range(Restrict(StsdPfc,TempEpoch),'s')-rgg(1),fPfc,10*log10(Data(Restrict(StsdPfc,TempEpoch))')), axis xy
        subplot(2,1,2), imagesc(Range(Restrict(StsdPfc,TempEpoch),'s')-rgg(1),fPfc,10*log10(Data(Restrict(Stsd,TempEpoch))')), axis xy
        hold  on, 
        plot(Range(Hil,'s')-rgg(1),rescaleKB(Data(Hil),10,20),'k','linewidth',2)
        line([limEn(i) limEn(i)]-tpstemp(1)/1E4,[0 20],'color','k')
        
        
        
i=i+1;
 TempEpoch=intervalSet((en(i)-35)*1E4, (en(i)+15)*1E4);
        Fil=FilterLFP(Restrict(LFP,TempEpoch),[6.5 9],1024);
        hil=hilbert(Data(Fil));
        Hil=tsd(Range(Fil),abs(hil));
        Hil=FilterLFP(Hil,[0.01 0.5],2048);
        tpstemp=Range(Hil);
        [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p,k,perc1,perc2]=fitsigmoid(Range(Hil),Data(Hil),0);
        limEn(i)=(tpstemp(1)+mean([perc1,perc2])*(tpstemp(end)-tpstemp(1))/100)/1E4;
        rgg=Range(Restrict(StsdPfc,TempEpoch),'s');
        figure, 
        subplot(2,1,1), imagesc(Range(Restrict(StsdPfc,TempEpoch),'s')-rgg(1),fPfc,10*log10(Data(Restrict(StsdPfc,TempEpoch))')), axis xy
        subplot(2,1,2), imagesc(Range(Restrict(StsdPfc,TempEpoch),'s')-rgg(1),fPfc,10*log10(Data(Restrict(Stsd,TempEpoch))')), axis xy
        hold  on, 
        plot(Range(Hil,'s')-rgg(1),rescaleKB(Data(Hil),10,20),'k','linewidth',2)
        line([limEn(i) limEn(i)]-tpstemp(1)/1E4,[0 20],'color','k')
        
        en=End(REM,'s');
        st=Start(REM,'s');
        
         
        en=End(REMEpochC,'s');
        st=Start(REMEpochC,'s');
        
        i=i+1;
        TempEpoch=intervalSet((st(i)-10)*1E4, (en(i)+10)*1E4);
        rgg=Range(Restrict(Stsd,TempEpoch),'s');
        imagesc(Range(Restrict(Stsd,TempEpoch),'s')-rgg(1),fPfc,10*log10(Data(Restrict(Stsd,TempEpoch))')), axis xy
        
        
clf
i=i+1;
TempEpoch=intervalSet((en(i)-35)*1E4, (en(i)+25)*1E4);
imagesc(Range(Restrict(StsdHpc,TempEpoch),'s'),fHpc,10*log10(Data(Restrict(StsdHpc,TempEpoch))')), axis xy
hold on
line([(en(i)) (en(i))],ylim,'color','k')

%%
