% ControlStimMFBRipplesSleep

%cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012

try
    MFBburst;
catch
    MFBburst=1;
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

load behavResources
load LFPData


if MFBburst
    


        try
            load SleepGoodEpoch SleepGoodEpoch
            SleepEpoch=SleepGoodEpoch;
        end

        st=Range(stim,'s');
        bu = burstinfo(st,0.2);
        burst=tsd(bu.t_start*1E4,bu.i_start);
        idburst=bu.i_start;

        save StimMFB stim burst idburst

        try
            load StimMFB
            burst;
        catch

            CorrectedMakeData

        end


        try
            num;
        catch
            num=2;
        end


else
    
    load SpikeData
    try
        PlaceCellTrig; EpochPlaceCellTrig; namePlaceCellTrig;
    catch
    load PlaceCellTrig
    end
    burst=Restrict(S{PlaceCellTrig},EpochPlaceCellTrig);
    SleepEpoch=EpochPlaceCellTrig;
     
    
end








%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%%


bu=Range(Restrict(burst,SleepEpoch));



figure('color',[1 1 1]),[fh, rasterAx, histAx, matVal] = ImagePETH(LFP{num}, ts(bu), -1000, 0,'BinSize',50); caxis([-4000 4000]), close

testi=Data(matVal)'; [BE,idx]=sort(testi(:,120));
% 
% figure('color',[1 1 1]), imagesc(Range(matVal,'ms'),[1:size(Data(matVal),2)],testi),  caxis([-4000 4000])
% figure('color',[1 1 1]), imagesc(Range(matVal,'ms'),[1:size(Data(matVal),2)],testi(idx,:)),  caxis([-4000 4000])

Fil1=[];
Hil1=[];
Pha1=[];

rg=Range(matVal);

for i=1:size(testi,1)
        
    testiTsd=tsd(rg(1:end-6)-rg(1),testi(i,1:end-6)');    
    
    fil1=FilterLFP(testiTsd,[130 250],96/3);
    zr=hilbert(Data(fil1)); 
    
    phzr = atan2(imag(zr), real(zr));
    phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
    
    
    hil1=abs(zr); 
    pha1=phzr;
    
    
    Fil1=[Fil1; Data(fil1)'];
    Hil1=[Hil1; hil1'];
    Pha1=[Pha1; pha1'];

end

%%
figure('color',[1 1 1])
imagesc((Hil1)), axis xy
hold on, plot(mean((Hil1)),'r','linewidth',2)
colormap(gray)
caxis([-100 500])

            % 
            % 
            % [BE,idx]=sort(mean(Hil1(:,113:116)'));
            % % 
            % % figure('color',[1 1 1])
            % % imagesc((Hil1(idx,:))), axis xy
            % % hold on, plot(mean(Hil1),'r','linewidth',2)
            % % colormap(gray)
            % % caxis([-100 500])
            % % xlim([1 116])
            % 
            % 
            % 
            % 
            % [BE,idx2]=sort(mean(Pha1(:,115:116)'));
            % % 
            % % figure('color',[1 1 1])
            % % imagesc((Pha1(idx2,:))), axis xy
            % % %hold on, plot(mean(Pha1),'r','linewidth',2)
            % % colormap(hsv)
            % % xlim([1 116])
            % % 
            % % 
            % % figure('color',[1 1 1])
            % % imagesc((Pha1(idx,:))), axis xy
            % % %hold on, plot(mean(Pha1),'r','linewidth',2)
            % % colormap(hsv)
            % % xlim([1 116])




[BE,idx]=sort(mean(Hil1(:,113:116)'));
[BE2,idx2]=sort(mean(Pha1(:,115:116)'));


%%

try
 pas=1;
 pstat=0.05;

nu=1;
for i=1:pas:size(Pha1,2)
    
    figure, [muPre(nu), KappaPre(nu), pvalPre(nu)]=JustPoltMod(Pha1(:,i),20); close
    nu=nu+1;
end


figure('color',[1 1 1]),
subplot(2,1,1), 
imagesc((Hil1(idx,:))), axis xy
hold on, plot(mean(Hil1),'r','linewidth',2)
colormap(gray)
caxis([-100 500])
xlim([1 116])

subplot(2,1,2), 
imagesc((Pha1(idx,:))), axis xy
%hold on, plot(muPre*100,'r','linewidth',2)
hold on, plot(pvalPre*800,'w','linewidth',2)
hold on, plot(KappaPre*1500,'k','linewidth',2)
colormap(hsv)
xlim([1 116])
% 
% subplot(3,1,3), 
% imagesc((Pha1(idx2,:))), axis xy
% 
% colormap(hsv)
% xlim([1 116])


end
%%

if 0
figure('color',[1 1 1]),watercolor_reg(ones(size(Fil1),1)*Range(fil1,'ms')', Fil1, 80,1,150, [0.5 0 0]);
end

testj=Data(matVal)'; [BE,idx]=sort(testj(:,115));
% figure('color',[1 1 1]), imagesc(Range(matVal,'ms'),[1:size(Data(matVal),2)],testj(idx,:)),  caxis([-4000 4000])

if 0

    fil=FilterLFP(LFP{num},[130 250],128);
    figure('color',[1 1 1]),[fh, rasterAx, histAx, matValF] = ImagePETH(fil, ts(bu), -1000, 0,'BinSize',50); caxis([-4000 4000])
    testF=Data(matValF)'; [BE,idx]=sort(testF(:,120));
    figure('color',[1 1 1]), imagesc(Range(matValF,'ms'),[1:size(Data(matValF),2)],testF),  caxis([-4000 4000])
    figure('color',[1 1 1]), imagesc(Range(matValF,'ms'),[1:size(Data(matValF),2)],testF(idx,:)),  caxis([-4000 4000])
    figure('color',[1 1 1]),watercolor_reg(ones(size(testF),1)*Range(matValF,'ms')', testF, 80,1,150, [0.5 0 0]);

end


%%

params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 30];
%params.tapers=[1 2];


movingwin=[3 0.2];
params.tapers=[3 5];
[Sp,t,f]=mtspecgramc(Data(Restrict(LFP{num},SleepEpoch)),movingwin,params);


stt=Start(SleepEpoch);
bus=Range(Restrict(burst,SleepEpoch),'s');


figure('color',[1 1 1]), imagesc((t*1E4+stt(1))/1E4,f,10*log10(Sp)'), axis xy, caxis([20 55])
hold on, plot(bus,3*ones(length(bus),1),'ko','markerfacecolor','w')
ylabel('Frequency (Hz)')
xlabel('Time (s)')

%%
%--------------------------------------------------------------------------
% find epochs with Stimulation ON
%--------------------------------------------------------------------------

for i=1:10
    try
        if char(eval(evt{i}))=='R'
%             evt{i}
%             char(eval(evt{i}))
            timeR=tpsEvt{i};
%             length(timeR)
        end
    end
    try
        if char(eval(evt{i}))=='B'
%             evt{i}
%             char(eval(evt{i}))
            timeB=tpsEvt{i};
%             length(timeB)
        end
    end
end

try
    hold on, line([timeR timeR],[0 30],'color','k','linewidth',2)
    hold on, line([timeB timeB],[0 30],'color','w','linewidth',2)


    deb=ts(timeR*1E4);deb=Restrict(deb,SleepEpoch);deb=Range(deb,'s');
    fin=ts(timeB*1E4);fin=Restrict(fin,SleepEpoch);fin=Range(fin,'s');
    deb=[Start(SleepEpoch,'s');deb];
    fin=[fin;max(End(SleepEpoch,'s'))];
    fin=fin(fin>deb(1));


    % 
    % for i=1:length(deb)
    %     try
    %     if deb(i+1)<fin(i)
    %         deb(i+1)=[];
    %     end
    %     end
    % end
    % 
    % for i=1:length(deb)
    %     try
    %     if fin(i)<deb(i)
    %         fin(i)=[];
    %     end
    %     end
    % end


    for kl=1:50

    for i=1:length(deb)+10
        try
    if length(find(fin(i+1)>fin(i)&fin(i+1)<deb(i+1)))>0
        fin(i)=[];
    end
        end
    end


    for i=1:length(deb)+10
        try
    if length(find(deb(i+1)>deb(i)&deb(i+1)<fin(i)))>0
        deb(i+1)=[];
    end
        end
    end


    for i=1:length(deb)+10
        try
    if length(find(deb>fin(i)&deb<fin(i+1)))==0
        fin(i)=[];
    end
        end
    end


    for i=1:length(deb)+10
        try
    if length(find(fin>deb(i)&fin<deb(i+1)))==0
        deb(i+1)=[];
    end
        end
    end



    end

    % 
    % hold on, line([deb deb],[0 30],'color','k','linewidth',2)
    % hold on, line([fin fin],[0 30],'color','w','linewidth',2)

    GoodEpoch=intervalSet(deb*1E4,fin*1E4);

catch
    GoodEpoch=SleepEpoch;
end



%%
%--------------------------------------------------------------------------
% find theta epochs
%--------------------------------------------------------------------------

pasTheta=100;

FilTheta=FilterLFP(Restrict(LFP{num},SleepEpoch),[5 10],1024);
FilDelta=FilterLFP(Restrict(LFP{num},SleepEpoch),[3 6],1024);

HilTheta=hilbert(Data(FilTheta));
HilDelta=hilbert(Data(FilDelta));

ThetaRatio=abs(HilTheta)./abs(HilDelta);
rgThetaRatio=Range(FilTheta,'s');

ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
rgThetaRatio=rgThetaRatio(1:pasTheta:end);

plot(rgThetaRatio,ThetaRatio,'k','linewidth',2)

ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);

thetaPeriod=thresholdIntervals(ThetaRatioTSD,2.5,'Direction','Above');
thetaPeriod=mergeCloseIntervals(thetaPeriod,10*1E4);
thetaPeriod=dropShortIntervals(thetaPeriod,20*1E4);

% hold on, line([Start(thetaPeriod,'s') Start(thetaPeriod,'s')],[0 30],'color','b','linewidth',4)
% hold on, line([End(thetaPeriod,'s') End(thetaPeriod,'s')],[0 30],'color','b','linewidth',4)

hold on, line([Start(thetaPeriod,'s') Start(thetaPeriod,'s')]',(ones(size(Start(thetaPeriod,'s'),1),1)*[0 30])','color','b','linewidth',4)
hold on, line([End(thetaPeriod,'s') End(thetaPeriod,'s')]',(ones(size(End(thetaPeriod,'s'),1),1)*[0 30])','color','b','linewidth',4)



FreqStimTheta=length(Restrict(burst,and(GoodEpoch,thetaPeriod)))/sum(End(and(GoodEpoch,thetaPeriod),'s')-Start(and(GoodEpoch,thetaPeriod),'s'));

FreqStimSWS=length(Restrict(burst,(GoodEpoch-thetaPeriod)))/sum(End((GoodEpoch-thetaPeriod),'s')-Start((GoodEpoch-thetaPeriod),'s'));

NbStimREM=length(Restrict(burst,and(GoodEpoch,thetaPeriod)));
NbStimSWS=length(Restrict(burst,(GoodEpoch-thetaPeriod)));

DurationSWS= sum(End((SleepEpoch-thetaPeriod),'s')-Start((SleepEpoch-thetaPeriod),'s'));
DurationREM=sum(End(and(SleepEpoch,thetaPeriod),'s')-Start(and(SleepEpoch,thetaPeriod),'s'));

try
    deb;
    fin;
catch
    
deb=Start(SleepEpoch); deb=deb(1);
fin=Start(SleepEpoch); fin=fin(end);

end


title(['Number of stim: ',num2str(length(bus)), ', frequency: ',num2str(length(bus)/(sum(fin-deb))),' Hz'])





%%

try
    choicTh;
catch
    choicTh=5;
end

A=5*Hil1(:,90:end);

figure('color',[1 1 1]), 
subplot(2,1,1), hist(A(:),100,'color','k')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','k','EdgeColor','k')

thresholdvalues=[500,750,1000,1500,2000,2500,3000,3500,4000,5000];
j=1;
for Thr=[500,750,1000,1500,2000,2500,3000,3500,4000,5000];

    StimRip(j)=1;StimTot(j)=1;
    for i=1:size(testj,1)
        if sum(5*Hil1(i,90:end)>Thr)>5
            StimRip(j)=StimRip(j)+1;
            StimTot(j)=StimTot(j)+1;
        else
            StimTot(j)=StimTot(j)+1;
        end
    end
    j=j+1;
end
title(['Number of stimulation: ',num2str(length(bus)), ', frequency: ',num2str(length(bus)/(sum(fin-deb))),' Hz'])
xl=xlim;
subplot(2,1,2), plot([500,750,1000,1500,2000,2500,3000,3500,4000,5000], StimRip./StimTot,'ko-','linewidth',2)
xlim(xl)
title(['Percentage of stimulation during riplpes : ',num2str(floor(10*StimRip(choicTh)/StimTot(choicTh)*100)/10),' %'])


%%
% 
% 
bu=Range(Restrict(burst,SleepEpoch));
BurstEpoch=intervalSet(bu-300,bu+2500);

epoch1=SleepEpoch;
%figure, plot(Range(Restrict(LFP{1},epoch1),'s'),Data(Restrict(LFP{1},epoch1)))
if MFBburst
    epoch2=GoodEpoch-BurstEpoch;
else
    epoch2=epoch1;
end

%hold on, plot(Range(Restrict(LFP{1},epoch2),'s'),Data(Restrict(LFP{1},epoch2)),'r')

ParamRip=[3 5];

%ParamRip=[4 7];

Ripples=[];
for i=1:length(Start(epoch2))
    try
    FilRip=FilterLFP(Restrict(LFP{num},subset(epoch2,i)),[130 250],96);
    filtered=[Range(FilRip,'s') Data(FilRip)];
    rgFil=Range(FilRip,'s');
    [ripples,stdev,noise] = FindRipples(filtered,'thresholds',ParamRip);%,'durations',[30,30,100]);
    if length(ripples)>1
    Ripples=[Ripples;ripples];
    end
    end
end
    
M=PlotRipRaw(LFP{num},Ripples,70);

%M=PlotRipRaw(LFP{num},Ripples,200);

RIPtsd=tsd((Ripples(:,2))*1E4,Ripples);

if MFBburst==0
    ripplesEpoch=intervalSet((Ripples(:,1)-0.03)*1E4, (Ripples(:,3)+0.03)*1E4);
    ripplesEpoch=mergeCloseIntervals(ripplesEpoch,10);
    NbSpikeRipples=length(Restrict(burst,ripplesEpoch));
    nbri=0;
    for kj=1:length(Start(ripplesEpoch))
        if length(Restrict(burst,subset(ripplesEpoch,kj)))>=1
           nbri=nbri+1; 
        end
    end
    NbRipplesWithSpikes=nbri;
    NombreRipples=size(Ripples,1);
    NombreSpikes=length(Restrict(burst,SleepEpoch));
    DurationPeriod=sum(End(SleepEpoch,'s')-Start(SleepEpoch,'s'));
end

ripSWS=length(Range(Restrict(RIPtsd,(SleepEpoch-thetaPeriod))));
ripREM=length(Range(Restrict(RIPtsd,and(SleepEpoch,thetaPeriod))));

M=PlotRipRaw(LFP{num},Data(Restrict(RIPtsd,thetaPeriod)),70);

PercRipStim=StimRip(4)/StimTot(4)*100;
nbStimulation=length(bu);

nbStimulationREM=length(Restrict(burst,and(GoodEpoch,thetaPeriod)));
nbStimulationSWS=length(Restrict(burst,(GoodEpoch-thetaPeriod)));


ripSWScorrected=floor(ripSWS+PercRipStim*nbStimulationSWS/100);
ripREMcorrected=floor(ripREM+PercRipStim*nbStimulationREM/100);

%%
disp(' ')
disp(' ')
disp(' ')
disp(pwd)
disp(' ')

if MFBburst
    disp('MFBburst')
else
    disp('Control')
end

disp(['channel: ',num2str(floor(num))])
% disp(' ')
disp(['Duration SWS: ',num2str(floor(DurationSWS)),' s'])
% disp(' ')
disp(['Duration REM: ',num2str(floor(DurationREM)),' s'])
% disp(' ')
disp(['Ratio REM/SWS: ' ,num2str(floor(DurationREM/DurationSWS*100*10)/10),' %'])
% disp(' ')

disp(['Number of stimulation during REM sleep : ',num2str(NbStimREM)])
% disp(' ')
disp(['Number of stimulation during SWS : ',num2str(NbStimSWS)])
% disp(' ')


disp(['Frequency of stimulation during REM sleep : ',num2str(FreqStimTheta),' Hz'])
% disp(' ')
disp(['Frequency of stimulation during SWS : ',num2str(FreqStimSWS),' Hz'])
% disp(' ')


disp(['Percentage of stimulation during riplpes : ',num2str(floor(10*StimRip(choicTh)/StimTot(choicTh)*100)/10),' %'])

% disp(' ')
disp(['Number of intact ripples outside stimulation: ', num2str(length(Ripples))])
% disp(' ')


disp(['Number of intact ripples during SWS: ',num2str(ripSWS)])
% disp(' ')
disp(['Number of intact ripples during REM: ',num2str(ripREM)])
% disp(' ')


disp(['Frequency of intact ripples during SWS: ',num2str(ripSWS/DurationSWS),' Hz'])
% disp(' ')
disp(['Frequency of intact ripples during REM: ',num2str(ripREM/DurationREM),' Hz'])
% disp(' ')

disp(['Number of ripples during SWS corrected: ',num2str(ripSWScorrected)])
% disp(' ')
disp(['Number of intact ripples during REM corrected: ',num2str(ripREMcorrected)])
% disp(' ')



disp(['Frequency of ripples during SWS corrected: ',num2str(ripSWScorrected/DurationSWS),' Hz'])
% disp(' ')
disp(['Frequency of ripples during REM corrected: ',num2str(ripREMcorrected/DurationREM),' Hz'])
% disp(' ')

if MFBburst==0
disp(' ')
disp(['Nb spike: ',num2str(NombreSpikes)])
disp(['Nb spike during ripples: ',num2str(NbSpikeRipples)]) 
disp(['Nb ripples: ',num2str(NombreRipples)])
disp(['Nb ripples with spikes: ',num2str(NbRipplesWithSpikes)])
disp(['Duration of recording: ',num2str(DurationPeriod), ' s'])
disp(' ')
end

%%


% % NoiseRip=FilterLFP(Restrict(LFP{num+1},SleepEpoch),[130 200],96);
% % filteredNoise=[Range(NoiseRip,'s') Data(NoiseRip)];
% 
% FilRip=FilterLFP(Restrict(LFP{num},SleepEpoch),[130 200],96);
% filtered=[Range(FilRip,'s') Data(FilRip)];
% rgFil=Range(FilRip,'s');
% %[ripples,stdev,noise] = FindRipples(filtered,'thresholds',[3 5],'noise',filteredNoise,'show','off');
% [ripples,stdev,noise] = FindRipples(filtered,'thresholds',[3 5]);
% 
% [maps,data,stats] = RippleStats(filtered,ripples);
% PlotRippleStats(ripples,maps,data,stats)
% 
% 
% % RipPeriods=tsd((ripples(:,2)+rgFil(1)-0.06)*1E4,ripples);
% delaiperiodripples=500;
% ripEvt=intervalSet((ripples(:,2)+rgFil(1)-delaiperiodripples)*1E4,(ripples(:,2)+rgFil(1)+delaiperiodripples)*1E4);
% 
% 
%%

bu=Range(Restrict(burst,SleepEpoch));
lim=15000;
ste=Start(SleepEpoch);
Stsd=tsd(t*1E4+ste(1),Sp);
BurstEpoch2=intervalSet(bu-lim,bu+lim+4000);
BurstEpoch2=mergeCloseIntervals(BurstEpoch2,1000);

SWSEpoch=SleepEpoch-thetaPeriod;
SWSEpoch=SWSEpoch-BurstEpoch2;
% 
% 
% figure('color',[1 1 1]),
% hold on, plot(Range(Restrict(LFP{num},SleepEpoch),'s'),Data(Restrict(LFP{num},SleepEpoch)))
% hold on, plot(Range(Restrict(LFP{num},SleepEpoch-BurstEpoch),'s'),Data(Restrict(LFP{num},SleepEpoch-BurstEpoch)),'r')
%  
% 
% figure('color',[1 1 1]),
% hold on, plot(Range(Restrict(LFP{num},SleepEpoch),'s'),Data(Restrict(LFP{num},SleepEpoch)))
% hold on, plot(Range(Restrict(LFP{num},SleepEpoch-BurstEpoch2),'s'),Data(Restrict(LFP{num},SleepEpoch-BurstEpoch2)),'r')
%  
% figure('color',[1 1 1]),
% hold on, plot(Range(Restrict(LFP{num},SleepEpoch),'s'),Data(Restrict(LFP{num},SleepEpoch)))
% hold on, plot(Range(Restrict(LFP{num},SWSEpoch),'s'),Data(Restrict(LFP{num},SWSEpoch)),'r')
% 
%  
% figure('color',[1 1 1]),
% hold on, plot(Range(Restrict(LFP{num},SleepEpoch),'s'),Data(Restrict(LFP{num},SleepEpoch)))
% hold on, plot(Range(Restrict(LFP{num},thetaPeriod-BurstEpoch2),'s'),Data(Restrict(LFP{num},thetaPeriod-BurstEpoch2)),'r')
% 

 

figure('color',[1 1 1]),
subplot(2,1,1),imagesc(Range(Restrict(Stsd,thetaPeriod-BurstEpoch2),'s'),f,10*log10(Data(Restrict(Stsd,thetaPeriod-BurstEpoch2))')), axis xy
subplot(2,1,2),imagesc(Range(Restrict(Stsd,SWSEpoch),'s'),f,10*log10(Data(Restrict(Stsd,SWSEpoch))')), axis xy

figure('color',[1 1 1]),
subplot(2,2,1), plot(f,10*log10(mean(Data(Restrict(Stsd,thetaPeriod-BurstEpoch2)))),'k','linewidth',1), title('REM'), xlabel('Frequency (Hz)'), ylabel('Power')
subplot(2,2,2),
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,thetaPeriod-BurstEpoch2)))),'k','linewidth',1), title('REM'), xlabel('Frequency (log scale)'), ylabel('Power (log scale)')
xlim([-5 10*log10(30)])
subplot(2,2,3), plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'k','linewidth',1), title('SWS'), xlabel('Frequency (Hz)'), ylabel('Power')
subplot(2,2,4),
plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'k','linewidth',1), title('SWS'), xlabel('Frequency (log scale)'), ylabel('Power (log scale)')
xlim([-5 10*log10(30)])

% 
% movingwin = [2, 0.05];
% params.tapers=[10,19];
% params.tapers=[3,5];
% params.err = [2, 0.95];
% params.trialave = 0;
% params.Fs =1250;
% Fh=300;
% params.fpass = [0 Fh];
% params.pad=2;
% 
% [S1,f1,Serr1]=mtspectrumc(Data(Restrict(LFP{num},thetaPeriod)),params);




%%



if 0
   
    Thr=thresholdvalues(choicTh);
    figure('color',[1 1 1]),
    for i=1:size(testj,1)
    clf, hold on, 
    plot(testj(i,:)-mean(testj(i,:)),'k'),
    plot(Hil1(i,:)*5,'bo-'),
    plot(Fil1(i,:),'r','linewidth',2), ylim([-3500 3500])
    line([0 130],[Thr Thr],'color','r')
    if sum(5*Hil1(i,90:end)>Thr)>5
    title([num2str(i),' Ripples'])
    else
    title(num2str(i))
    end
    pause(2)
    end


end







%%



channel=num;
DurationSWS;
DurationREM;
RatioREMSWS=DurationREM/DurationSWS*100;
NbStimREM;
NbStimSWS;

FreqStimTheta;
FreqStimSWS;

PercStimRiplpes=StimRip(choicTh)/StimTot(choicTh)*100;

NbIntactRipplesOutsideStim=length(Ripples);

NbIntactRipplesDuringSWS=ripSWS;
NbIntactRipplesDuringREM=ripREM;

FreqIntactRipplesDuringSWS=ripSWS/DurationSWS;
FreqIntactRipplesDuringREM=ripREM/DurationREM;

NbRipplesCorrectedDuringSWS=ripSWScorrected;
NbRipplesCorrectedDuringREM=ripREMcorrected;

FreqRipplesCorrectedDuringSWS=ripSWScorrected/DurationSWS;
FreqRipplesCorrectedDuringREM=ripREMcorrected/DurationREM;

freq=f;
SpectrumSWS=mean(Data(Restrict(Stsd,SWSEpoch)));
SpectrumREM=mean(Data(Restrict(Stsd,thetaPeriod-BurstEpoch2)));
 
debSleep=Start(SleepEpoch);
if MFBburst
    
OccurenceBefore=length(Range(Restrict(burst,intervalSet(0,debSleep(1)*1E4))));
FreqBefore=OccurenceBefore/debSleep(1);
else
OccurenceBefore=length(Range(Restrict(S{PlaceCellTrig},intervalSet(0,debSleep(1)*1E4))));    
FreqBefore=OccurenceBefore/debSleep(1);
end

disp(['Occurence before: ',num2str(OccurenceBefore)])
disp(['Frequence before: ',num2str(FreqBefore)])
disp(' ')

load PlaceCellTrig
PlaceCellTrigCtrl=PlaceCellTrig;






if MFBburst
    save ResAnalysisSPWRStimMFBburst channel DurationSWS DurationREM RatioREMSWS NbStimREM NbStimSWS  FreqStimTheta  FreqStimSWS PercStimRiplpes NbIntactRipplesOutsideStim NbIntactRipplesDuringSWS NbIntactRipplesDuringREM FreqIntactRipplesDuringSWS FreqIntactRipplesDuringREM NbRipplesCorrectedDuringSWS NbRipplesCorrectedDuringREM FreqRipplesCorrectedDuringSWS FreqRipplesCorrectedDuringREM freq SpectrumSWS SpectrumREM Thr OccurenceBefore FreqBefore
else
    eval(['save ResAnalysisSPWRStimCtrl',num2str(PlaceCellTrigCtrl),' channel DurationSWS DurationREM RatioREMSWS NbStimREM NbStimSWS  FreqStimTheta  FreqStimSWS PercStimRiplpes NbIntactRipplesOutsideStim NbIntactRipplesDuringSWS NbIntactRipplesDuringREM FreqIntactRipplesDuringSWS FreqIntactRipplesDuringREM NbRipplesCorrectedDuringSWS NbRipplesCorrectedDuringREM FreqRipplesCorrectedDuringSWS FreqRipplesCorrectedDuringREM freq SpectrumSWS SpectrumREM NbSpikeRipples NombreRipples NombreSpikes DurationPeriod NbRipplesWithSpikes Thr OccurenceBefore FreqBefore PlaceCellTrigCtrl'])
    
    if PlaceCellTrigCtrl==PlaceCellTrig
    eval(['save ResAnalysisSPWRStimCtrl channel DurationSWS DurationREM RatioREMSWS NbStimREM NbStimSWS  FreqStimTheta  FreqStimSWS PercStimRiplpes NbIntactRipplesOutsideStim NbIntactRipplesDuringSWS NbIntactRipplesDuringREM FreqIntactRipplesDuringSWS FreqIntactRipplesDuringREM NbRipplesCorrectedDuringSWS NbRipplesCorrectedDuringREM FreqRipplesCorrectedDuringSWS FreqRipplesCorrectedDuringREM freq SpectrumSWS SpectrumREM NbSpikeRipples NombreRipples NombreSpikes DurationPeriod NbRipplesWithSpikes Thr OccurenceBefore FreqBefore PlaceCellTrig'])
    end
end



