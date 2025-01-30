% AnalyseNREM_CheckDelta.m

% list of related scripts in NREMstages_scripts.m 


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2); 

thD=[2,2,1.5];% delta detected above 2SD (SD determined on sws)
th=75;% crucial element for noise detection (75ms) !!
freqDelta=[2 7];
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/Delta_vs_Down';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    clear MAT
    load([res,'/AnalyseNREM_checkDelta.mat'])
    MAT;
catch
    MAT={};
    for man=1:length(Dir.path)
        
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        clear tDelta1 tDelta DeltaEp1 DeltaEpoch
        [tDelta1,DeltaEp1]=GetDeltaML;
        MAT{man,1}=tDelta1;
        MAT{man,2}=DeltaEp1;
        
        if ~isempty(tDelta1)
            clear Down Dpfc deltaEp
            try load DownSpk.mat Down; MAT{man,9}=Down; end 
        
            [dSWS,dREM,~,dOsciEpoch,noise,SIEpoch,Immob]=FindSleepStageML('PFCx_deep');
            Epoch=Immob-noise;
            %[tDelta,DeltaEpoch]=GetDeltaML('PFCx',Epoch,dSWS);
            disp('GetDeltaML with changed freqDelta...')
            
            ch1=load('ChannelsToAnalyse/PFCx_deep.mat');
            try, ch2=load('ChannelsToAnalyse/PFCx_sup.mat');catch,ch2=load('ChannelsToAnalyse/PFCx_deltasup.mat');end
            eval(['temp1=load(''LFPData/LFP',num2str(ch1.channel),'.mat'');'])
            eval(['temp2=load(''LFPData/LFP',num2str(ch2.channel),'.mat'');'])
            
            for ji=3
                if ji==1
                    eegDeep=temp1.LFP;
                    eegSup=temp2.LFP;
                else
                    eegDeep=FilterLFP(temp1.LFP, [1 20], 1024);
                    eegSup=FilterLFP(temp2.LFP, [1 20], 1024);
                end
                
                % find factor to increase EEGsup signal compared to EEGdeep
                k=1;
                for i=0.1:0.1:4
                    S(k)=std(Data(eegDeep)-i*Data(eegSup));k=k+1;
                end
                Factor=find(S==min(S))*0.1;if length(Factor)>1, Factor=0;end
                
                %-------------------------------------------------
                % Difference between EEG deep and EEG sup (*factor)
                EEGsleepD=ResampleTSD(tsd(Range(eegDeep),Factor*Data(eegSup)-Data(eegDeep)),100);
                if ji<3, Filt_EEGd = FilterLFP(EEGsleepD, freqDelta, 1024); else, Filt_EEGd=EEGsleepD;end
                
                %-------------------------------------------------
                % Determine SD on sws signal
                OK_sws=max(-Data(Restrict(Filt_EEGd,dSWS)),0);
                try SDsws=std(OK_sws(OK_sws>0));end
                
                %-------------------------------------------------
                % calculate delta on whole Epoch
                Filt_EEGd = Restrict(Filt_EEGd,Epoch);
                OK=max(-Data(Filt_EEGd),0); tDelta=[];
                try
                    DeltaEpoch1=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,Epoch)), OK),thD(ji)*SDsws,'Direction','Above');
                    DeltaEpoch=dropShortIntervals(DeltaEpoch1,th*10); % crucial element for noise detection (75ms) !!!!!!!!!!!!!!!!!!!!!!!!!!
                    tDelta=Start(DeltaEpoch)+(End(DeltaEpoch)-Start(DeltaEpoch))/2;
                    disp(['number of detected Delta Waves = ',num2str(length(tDelta))])
                catch
                    disp('no delta wave detected during SWS')
                end
                
                MAT{man,2*ji+1}=tDelta;
                MAT{man,2*ji+2}=DeltaEpoch;
            end
            
            %load substages
            clear WAKE REM N1 N2 N3
            [WAKE,REM,N1,N2,N3]=RunSubstages;close;
            MAT(man,10:14)={WAKE,REM,N1,N2,N3};
        else
            MAT{man,3}=[];
            MAT{man,4}=intervalSet([],[]);
            MAT{man,5}=[];
            MAT{man,6}=intervalSet([],[]);
            MAT{man,7}=[];
            MAT{man,8}=intervalSet([],[]);
        end
        
    end
    save([res,'/AnalyseNREM_checkDelta.mat'],'Dir','thD','th','freqDelta','MAT')
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1]); numF=gcf;
xh=0:50:5000;
for man=1:length(Dir.path)
    
    subplot(2,2,1), hold on,
    h=hist(diff(MAT{man,1}/10),xh); xlim([min(xh),xh(end-1)]); plot(xh,h)
    ylabel('#Delta'); xlabel('Interval Inter Delta'); title('filter 1-5Hz')
    
    subplot(2,2,2), hold on,
    h=hist(diff(MAT{man,3}/10),xh); xlim([min(xh),xh(end-1)]); plot(xh,h)
    xlabel('Interval Inter Delta'); title('filter 2-7Hz')
    
    subplot(2,2,3), hold on,
    h=hist(diff(MAT{man,5}/10),xh); xlim([min(xh),xh(end-1)]); plot(xh,h)
    xlabel('Interval Inter Delta'); title({'filter 1-20Hz before diff','filter 2-7Hz'})
    
    subplot(2,2,4), hold on,
    h=hist(diff(MAT{man,7}/10),xh); xlim([min(xh),xh(end-1)]); plot(xh,h)
    xlabel('Interval Inter Delta'); title({'filter 1-20Hz before diff','no post filter, thSD=1.5'})
end
%saveFigure(numF.Number,['ISIDelta_FilterEffect_',date],FolderToSave);

%% <<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1]); numF=gcf;
indDelt=[1,7]; tit={'Classical','No Filter'};NamEp={'N2','N3'};
for id=1:2
    for ep=1:2
        subplot(2,2,2*(id-1)+ep), hold on,
        for man=1:length(Dir.path)
            epoch=MAT{man,12+ep}; %N2 ou N3
            D1=MAT{man,indDelt(id)}; %delta
            if ~isempty(D1)
            Ts1=tsd(D1(1:end-1),diff(D1/10));
            Ts2=tsd(D1(2:end),D1(1:end-1));
            D1_ep=[Range(Restrict(Ts1,epoch)),Data(Restrict(Ts1,epoch))];
            D2_ep=Data(Restrict(Ts2,epoch));
            D_ep=D1_ep(ismember(D1_ep(:,1),D2_ep),2);
            h=hist(D_ep,xh); plot(xh,h)
            end
        end
        xlim([min(xh),xh(end-1)]);
        ylabel('#Delta'); xlabel('Interval Inter Delta')
        title([tit{id},' - ',NamEp{ep}])
    end
end
%saveFigure(numF.Number,['Delta_NoFilterEffect_N2N3_',date],FolderToSave);

%% <<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
M=[];
for man=1:length(Dir.path)
    I=intervalSet(Start(MAT{man,2})-200,Stop(MAT{man,2})+200);
    nb=length(Range(Restrict(ts(MAT{man,7}),I))); % filt 2-7Hz restrict on classic delta epoch
    M(man,1)=100*nb/length(Range(ts(MAT{man,7})));
    
    I=intervalSet(Start(MAT{man,8})-200,Stop(MAT{man,8})+200);
    nb=length(Range(Restrict(ts(MAT{man,1}),I))); % no filr restrict on classic delta epoch
    M(man,2)=100*nb/length(Range(ts(MAT{man,1})));
end
figure('Color',[1 1 1]); numF=gcf;
subplot(2,1,1),
bar([M(:,1),100-M(:,1)],'stacked'); colormap gray
title('# Delta detected with both filters (% classic delta 1-5Hz)')
subplot(2,1,2),
bar([M(:,2),100-M(:,2)],'stacked'); colormap gray
title('# Delta detected with both filters (% delta no filt)')
%saveFigure(numF.Number,['ISIDelta_FilterEffect_nbDelta_',date],FolderToSave);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<< cross with down <<<<<<<<<<<<<<<<<<<<<<<<<<<
M=nan(6);
for man=1:9
    if ~isempty(MAT{man,9})
        disp(Dir.path{man})
        Idown=intervalSet(Start(MAT{man,9})-500,Stop(MAT{man,9})+500);% down period
        % delta 1-5Hz
        nb=length(Range(Restrict(ts(MAT{man,1}),Idown)));
        M(man,1)=100*nb/length(Range(ts(MAT{man,1})));%delta
        M(man,4)=100*nb/length(Start(MAT{man,9})); %down
        % no filter delta 
        nb=length(Range(Restrict(ts(MAT{man,7}),Idown)));
        M(man,2)=100*nb/length(Range(ts(MAT{man,7})));%delta
        M(man,5)=100*nb/length(Start(MAT{man,9}));%down
        
        Idelt=intervalSet(Start(MAT{man,2})-500,Stop(MAT{man,2})+500);% classical delta
        nb=length(Range(Restrict(ts(MAT{man,7}),Idelt)));
        M(man,3)=100*nb/length(Range(ts(MAT{man,7})));% no filter delta
        M(man,6)=100*nb/length(Start(MAT{man,2}));%classical delta
    end
end

figure('Color',[1 1 1]);numF=gcf;
for ji=1:6
    subplot(2,3,ji),
    bar([M(:,ji),100-M(:,ji)],'stacked');
end
colormap gray
subplot(2,3,1), ylabel('# Delta n Down (%delta)');title('classic delta 1-5Hz')
subplot(2,3,4), ylabel('# Delta n Down (%down)');title('classic delta 1-5Hz')
subplot(2,3,2), ylabel('# Delta n Down (%delta)');title('no filter delta')
subplot(2,3,5), ylabel('# Delta n Down (%down)');title('no filter delta')
subplot(2,3,3), ylabel('# no filt n classical (%no filt)');title('Epoch classical delta')
subplot(2,3,6), ylabel('# no filt n classical (%classical)');title('Epoch classical delta')
%saveFigure(numF.Number,['Delta_NoFilterEffect_',date],FolderToSave);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< look at an example <<<<<<<<<<<<<<<<<<<<<<<<<<<
% inputs
cd /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013
thD=2;% delta detected above 2SD (SD determined on sws)
thDnew=1.5;
th=75;
% ---------------------------------------------------
% get delta, classical first steps (see GetDeltaML.m)
[dSWS,dREM,dWAKE,dOsciEpoch,noise,SIEpoch,Immob]=FindSleepStageML('PFCx_deep');
Epoch=Immob-noise;
ch1=load('ChannelsToAnalyse/PFCx_deep.mat');
try, ch2=load('ChannelsToAnalyse/PFCx_sup.mat');catch,ch2=load('ChannelsToAnalyse/PFCx_deltasup.mat');end
eval(['temp1=load(''LFPData/LFP',num2str(ch1.channel),'.mat'');'])
eval(['temp2=load(''LFPData/LFP',num2str(ch2.channel),'.mat'');'])
E1=Restrict(temp1.LFP,intervalSet(17680*1E4,21000*1E4));
E2=Restrict(temp2.LFP,intervalSet(17680*1E4,21000*1E4));
eegDeep=FilterLFP(E1, [1 20], 1024);
eegSup=FilterLFP(E2, [1 20], 1024);
hold on, plot(Range(eegSup,'s'),Data(eegSup)+3000)
plot(Range(eegDeep,'s'),Data(eegDeep))
k=1;for i=0.1:0.1:4,S(k)=std(Data(eegDeep)-i*Data(eegSup));k=k+1; end
Factor=find(S==min(S))*0.1;if length(Factor)>1, Factor=0;end
EEGsleepD=ResampleTSD(tsd(Range(eegDeep),Factor*Data(eegSup)-Data(eegDeep)),100);

% ---------------------------------------------------
% filter diff signal 1-5Hz
freqDelta=[1 5];
Filt_EEGd = FilterLFP(EEGsleepD, freqDelta, 1024);
OK_sws=max(-Data(Restrict(Filt_EEGd,dSWS)),0);
try SDsws=std(OK_sws(OK_sws>0));end
Filt_EEGd = Restrict(Filt_EEGd,Epoch);
OK=max(-Data(Filt_EEGd),0); tDelta=[];
DeltaEpoch1=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,Epoch)), OK),thD*SDsws,'Direction','Above');
DeltaEpoch=dropShortIntervals(DeltaEpoch1,th*10); % crucial element for noise detection (75ms) !!!!!!!!!!!!!!!!!!!!!!!!!!
tDelta=Start(DeltaEpoch)+(End(DeltaEpoch)-Start(DeltaEpoch))/2;
disp(['number of detected Delta Waves = ',num2str(length(tDelta))])

% ---------------------------------------------------
% filter diff signal 2-7Hz
freqDelta2=[2 7];
Filt_EEGd2 = FilterLFP(EEGsleepD, freqDelta2, 1024);
OK_sws=max(-Data(Restrict(Filt_EEGd2,dSWS)),0);
try SDsws2=std(OK_sws(OK_sws>0));end
Filt_EEGd2 = Restrict(Filt_EEGd2,Epoch);
OK2=max(-Data(Filt_EEGd2),0); tDelta2=[];
DeltaEpoch1=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,Epoch)), OK2),thD*SDsws2,'Direction','Above');
DeltaEpoch2=dropShortIntervals(DeltaEpoch1,th*10); % crucial element for noise detection (75ms) !!!!!!!!!!!!!!!!!!!!!!!!!!
tDelta2=Start(DeltaEpoch2)+(End(DeltaEpoch2)-Start(DeltaEpoch2))/2;
disp(['number of detected Delta Waves = ',num2str(length(tDelta2))])

% ---------------------------------------------------
% do not filter diff signal 
Filt_EEGd3 = EEGsleepD;
OK_sws=max(-Data(Restrict(Filt_EEGd3,dSWS)),0);
try SDsws3=std(OK_sws(OK_sws>0));end
Filt_EEGd3 = Restrict(Filt_EEGd3,Epoch);
OK3=max(-Data(Filt_EEGd3),0); tDelta3=[];
DeltaEpoch1=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,Epoch)), OK3),thDnew*SDsws3,'Direction','Above');
DeltaEpoch3=dropShortIntervals(DeltaEpoch1,th*10); % crucial element for noise detection (75ms) !!!!!!!!!!!!!!!!!!!!!!!!!!
tDelta3=Start(DeltaEpoch3)+(End(DeltaEpoch3)-Start(DeltaEpoch3))/2;
disp(['number of detected Delta Waves = ',num2str(length(tDelta3))])

% ---------------------------------------------------
% display raw and filtered signal
figure('Color',[1 1 1]), 
subplot(3,1,1:2),hold on,
plot(Range(E1,'s'),Data(E1)+4000)
plot(Range(eegDeep,'s'),Data(eegDeep)+4000,'linewidth',2)
plot(Range(E2,'s'),Data(E2))
plot(Range(eegSup,'s'),Data(eegSup),'linewidth',2)
xlim([19862 19872]);
plot(Range(EEGsleepD,'s'),Data(EEGsleepD)-5000,'linewidth',2)
% freqDelta=[1 5];
plot(Range(Filt_EEGd,'s'),Data(Filt_EEGd)-10000,'linewidth',2)
line([17680,21000],[0 0]-thD*SDsws-10000,'Color','k'); 
plot(tDelta/1E4,zeros(length(tDelta),1)-10000,'*r')
%freqDelta2=[2 7];
plot(Range(Filt_EEGd2,'s'),Data(Filt_EEGd2)-15000,'linewidth',2)
line([17680,21000],[0 0]-thD*SDsws2-15000,'Color','k'); 
plot(tDelta2/1E4,zeros(length(tDelta2),1)-15000,'*m')
%freqDelta2=no filter;
plot(Range(Filt_EEGd3,'s'),Data(Filt_EEGd3)-20000,'linewidth',2)
line([17680,21000],[0 0]-thDnew*SDsws3-20000,'Color','k'); 
plot(tDelta3/1E4,zeros(length(tDelta3),1)-20000,'*r')

legend({'deep','deep filt 1-20Hz','sup','sup filt 1-20Hz','diff',...
    'diff filt 1-5Hz','thresh','delta','diff filt 2-7Hz','thresh','delta','diff no filt','thresh','delta'})

% ---------------------------------------------------
% display thresholds and detection
subplot(3,1,3),hold on,
plot(Range(Filt_EEGd,'s'),OK)
line([17680,21000],[0 0]+thD*SDsws,'Color','k');
plot(Range(Filt_EEGd2,'s'),OK2-3000)
line([17680,21000],[0 0]+thD*SDsws2-3000,'Color','k');
plot(Range(Filt_EEGd3,'s'),OK3-6000)
line([17680,21000],[0 0]+thDnew*SDsws3-6000,'Color','k');
plot(tDelta/1E4,zeros(length(tDelta),1)+2000,'*r')
plot(tDelta2/1E4,zeros(length(tDelta2),1)-1000,'*m')
plot(tDelta3/1E4,zeros(length(tDelta3),1)-4000,'*r')
legend({'Filt 1-5Hz','thresh','Filt 2-7Hz','thresh','no Filt','thresh'})

xlim([19862 19872]);ylim([-7000 3000])


% a=1;xlim([19862 19872]+a*10);
% a=a+1;subplot(3,1,1:2),xlim([19862 19872]+a*10);subplot(3,1,3),xlim([19862 19872]+a*10);
%saveFigure(1,'ISIDelta_FilterEffect8example1',FolderToSave);


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<< distribution interval inter-delta <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
temp=load('AnalyNREMsubstagesSD24h_1hStep_Wnz.mat','Dir');
DoDir=temp.Dir(:,1);
DoDir=[DoDir;Dir.path'];

MAT={};name=[];ALL=[];
for man=1:length(DoDir)
    try
        cd(DoDir{man})
        Dpfc=GetDeltaML;
        MAT{man}=ts(Dpfc);
        ALL=[ALL,diff(Dpfc/10)];
    end
end

figure('Color',[1 1 1]), subplot(1,2,1), hold on,
xh=0:100:5000;
H=nan(length(MAT),length(xh)-1);
for man=1:length(DoDir)
    if ~isempty(MAT{man})
        h=hist(diff(Range(MAT{man},'ms')),xh);
        plot(xh(1:end-1),100*smooth(h(1:end-1),2)/sum(h(1:end-1)))
        H(man,:)=100*h(1:end-1)/sum(h(1:end-1));
        name=[name;{DoDir{man}(max([strfind(DoDir{man},'Mouse'),strfind(DoDir{man},'Mouse-')+1])+[5:7])}];
    end
end
% atention: outlier /media/DataMOBsRAID/ProjetAstro/Mouse147/20140804/BULB-Mouse-147-04082014
xlabel('Time inter-delta (ms)'); ylabel('%total ISI<5s')
legend(name);

subplot(1,2,2), hold on,
mice=unique(name);
Hmi=nan(length(mice),length(xh)-1);
for mi=1:length(mice)
    id=strcmp(name,mice{mi});
    Hmi(mi,:)=nanmean(H(id,:),1);
    plot(xh(1:end-1),smooth(Hmi(mi,:),2),'Linewidth',2)
end
xlabel('Time inter-delta (ms)'); ylabel('%total ISI<5s')
legend(mice);
N3Thresh=GetGammaThresh(ALL);close
N3Thresh=exp(N3Thresh);
hold on, line(N3Thresh*[1 1],ylim,'Linewidth',3,'Color','r')
text(N3Thresh*1.1,0.9*max(ylim),{'Automatic gaussian fit',sprintf('thresh = %1.0f ms',N3Thresh)},'Color','r')

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% check with down states
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251]);% 252 has no neurons
xh=0:100:5000;
name=[]; N=nan(length(Dir1.path),2);
figure('Color',[1 1 1]), subplot(1,2,1), 
for man=1:length(Dir1.path)
    disp((Dir1.path{man})); cd(Dir1.path{man})
    
    clear Down Dpfc deltaEp
    try
        load DownSpk.mat Down
        
        D1=Start(Down)+(Stop(Down)-Start(Down))/2;
        h1=hist(diff(D1/10),xh);
        subplot(2,3,1), hold on,
        plot(xh(1:end-1),100*smooth(h1(1:end-1),2)/sum(h1(1:end-1)))
        title('#Down')
        
        [Dpfc,deltaEp]=GetDeltaML;
        deltaEp=intervalSet(Start(deltaEp)-500,Stop(deltaEp)+500);
        h2=hist(diff(Dpfc/10),xh);
        subplot(2,3,4), hold on,
        plot(xh(1:end-1),100*smooth(h2(1:end-1),2)/sum(h2(1:end-1)))
        name=[name;{Dir1.path{man}(max([strfind(Dir1.path{man},'Mouse'),strfind(Dir1.path{man},'Mouse-')+1])+[5:7])}];
        title('#Delta')
        
        h4=hist(diff(Range(Restrict(ts(D1),deltaEp))/10),xh);
        N(man,1)=100*length(Range(Restrict(ts(D1),deltaEp)))/length(Start(Down));
        subplot(2,3,2), hold on,
        plot(xh(1:end-1),100*smooth(h4(1:end-1),2)/sum(h4(1:end-1)))
        
        h3=hist(diff(Range(Restrict(ts(Dpfc),Down))/10),xh);
        N(man,2)=100*length(Range(Restrict(ts(Dpfc),Down)))/length(Dpfc);
        subplot(2,3,5), hold on,
        plot(xh(1:end-1),100*smooth(h3(1:end-1),2)/sum(h3(1:end-1)))
        
        subplot(2,3,3),hold on,
        durDown=Stop(Down)/10-Start(Down)/10;
        plot(durDown(1:end-1),diff(D1/10),'.k');
        
        subplot(2,3,6),hold on,
        Dondelt=tsd(D1,Stop(Down)/10-Start(Down)/10);
        durDondelt=Data(Restrict(Dondelt,deltaEp));
        plot(durDondelt(1:end-1),diff(Range(Restrict(Dondelt,deltaEp))/10),'.k');
    end
end
subplot(2,3,2), title({'#Down restricted on Delta epoch',...
    sprintf('corresponds to %1.1fperc +/-%1.1f of Down',nanmean(N(:,1)),std(N(:,1)))})
subplot(2,3,5), title({'#Delta restricted on Down epoch',...
    sprintf('corresponds to %1.1fperc +/-%1.1f of Delta',nanmean(N(:,2)),std(N(:,2)))})
legend(name)
subplot(2,3,3), xlabel('Down Duration (ms)'); ylabel('interval inter Down')
set(gca,'Xscale','log'); xlim([75 500]); set(gca,'Yscale','log'); ylim([75 1E5]);

subplot(2,3,6), xlabel('Down Duration (ms)'); ylabel('interval inter Down') 
set(gca,'Xscale','log'); xlim([75 500]); set(gca,'Yscale','log'); ylim([75 1E5]);


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% DOWN versus DELTA
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251]);% 252 has no neurons
FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/Delta_vs_Down';
xh=0:100:5000;
DoNew=1; 
for man=1:length(Dir1.path)
    disp(' ');disp((Dir1.path{man})); cd(Dir1.path{man})
    
    % load substages
    clear WAKE REM N1 N2 N3
    [WAKE,REM,N1,N2,N3]=RunSubstages(DoNew); close
    % load delta
    clear Down LFP tDelta Q channel ST SWSEpoch
    load AllDeltaPFCx tDelta SWSEpoch
    deltaEp=intervalSet(tDelta-1E3,tDelta+1E3);
    
    % load down
    load newDownState.mat Down
    D1=Start(Down)+(Stop(Down)-Start(Down))/2;
    Down=and(Down,SWSEpoch);
    
    % load LFP
    disp('Loading LFP...')
    load ChannelsToAnalyse/PFCx_deep.mat channel
    eval(sprintf('load LFPData/LFP%d.mat',channel))
    
    % load neurons
    [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
    nN=numNeurons;
    for s=1:length(numNeurons)
        if TT{numNeurons(s)}(2)==1,nN(nN==numNeurons(s))=[];end
    end
    T=PoolNeurons(S,nN);
    ST{1}=T;ST=tsdArray(ST);
    Q = MakeQfromS(ST,10*10);
    Q=tsd(Range(Q),full(Data(Q)));
    
    % numbers of events
    nD=length(Start(Down));
    nD_Delt=length(Range(Restrict(ts(Start(Down)),deltaEp)));
    nDelt=length(tDelta);
    
    tbins=4;nbbins=300;
    [ma1,sa1,tpsa1]=mETAverage(Range(ts(Start(Down))), Range(LFP),Data(LFP),tbins,nbbins);
    [ma2,sa2,tpsa2]=mETAverage(Range(Restrict(ts(Start(Down)),deltaEp)), Range(LFP),Data(LFP),tbins,nbbins);
    [ma3,sa3,tpsa3]=mETAverage(Range(ts(tDelta)), Range(LFP),Data(LFP),tbins,nbbins);
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.7 0.8]), numF(man)=gcf;
    subplot(2,2,1),hold on
    plot(tpsa1,ma1,'linewidth',2),
    plot(tpsa2,ma2,'linewidth',2),
    plot(tpsa3,ma3,'linewidth',2),
    legend(sprintf('AllDown n=%d',nD),sprintf('Down on delta n=%d',nD_Delt),sprintf('AllDelta n=%d',nDelt))
    ylabel('LFP averaged on time of...'); xlabel('Time (ms)')
    title(pwd)
    
    tbins=12;nbbins=100;
    [ma1,sa1,tpsa1]=mETAverage(Range(ts(Start(Down))), Range(Q),Data(Q),tbins,nbbins);
    [ma2,sa2,tpsa2]=mETAverage(Range(Restrict(ts(Start(Down)),deltaEp)), Range(Q),Data(Q),tbins,nbbins);
    [ma3,sa3,tpsa3]=mETAverage(Range(ts(tDelta)), Range(Q),Data(Q),tbins,nbbins);
    subplot(2,2,2),hold on
    plot(tpsa1,ma1,'linewidth',2),
    plot(tpsa2,ma2,'linewidth',2),
    plot(tpsa3,ma3,'linewidth',2),
    legend('AllDown','Down on delta','AllDelta')
    ylabel('MUA averaged on time of...'); xlabel('Time (ms)')
    
    subplot(2,2,3), hold on,
    hist(diff(D1/10),xh); xlim([min(xh),xh(end-1)])
    Ts1=tsd(D1(1:end-1),diff(D1/10));
    Ts2=tsd(D1(2:end),D1(1:end-1));
    D1_N2=[Range(Restrict(Ts1,N2)),Data(Restrict(Ts1,N2))];
    D2_N2=Data(Restrict(Ts2,N2));
    D_N2=D1_N2(ismember(D1_N2(:,1),D2_N2),2);
    D1_N3=[Range(Restrict(Ts1,N3)),Data(Restrict(Ts1,N3))];
    D2_N3=Data(Restrict(Ts2,N3));
    D_N3=D1_N3(ismember(D1_N3(:,1),D2_N3),2);
    h=hist(D_N2,xh); plot(xh,h,'linewidth',2)
    h=hist(D_N3,xh); plot(xh,h,'linewidth',2)
    title('#Down'); xlabel('Interval Inter Down')
    legend('All down','N2','N3')
    
    subplot(2,2,4), hold on,
    hist(diff(tDelta/10),xh); xlim([min(xh),xh(end-1)])
    Ts1=tsd(tDelta(1:end-1),diff(tDelta/10));
    Ts2=tsd(tDelta(2:end),tDelta(1:end-1));
    D1_N2=[Range(Restrict(Ts1,N2)),Data(Restrict(Ts1,N2))];
    D2_N2=Data(Restrict(Ts2,N2));
    D_N2=D1_N2(ismember(D1_N2(:,1),D2_N2),2);
    D1_N3=[Range(Restrict(Ts1,N3)),Data(Restrict(Ts1,N3))];
    D2_N3=Data(Restrict(Ts2,N3));
    D_N3=D1_N3(ismember(D1_N3(:,1),D2_N3),2);
    h=hist(D_N2,xh); plot(xh,h,'linewidth',2)
    h=hist(D_N3,xh); plot(xh,h,'linewidth',2)
    title('#Delta'); xlabel('Interval Inter Delta')
    legend('All delta','N2','N3')
    
    if DoNew
        saveFigure(numF(man).Number,sprintf('Delta_vs_Down%d_NewSubstages',man),FolderToSave);
    else
        saveFigure(numF(man).Number,sprintf('Delta_vs_Down%d',man),FolderToSave);
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< Analyse DOWN distribution <<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
epoch{1}=intervalSet(10500*1E4,11000*1E4);
Dir{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243';
Dir{3}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
epoch{3}=intervalSet(4800*1E4,6000*1E4);
Dir{4}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';

man=3;
disp(' ');disp((Dir{man})); cd(Dir{man})
clear Down LFP tDelta Q channel ST

%% load down
load newDownState.mat Down
D1=Restrict(ts(Start(Down)+(Stop(Down)-Start(Down))/2),epoch{man});
% load delta
load AllDeltaPFCx tDelta SWSEpoch
delt=Restrict(ts(tDelta),epoch{man});
% load LFPs
ch1=load('ChannelsToAnalyse/PFCx_deltasup.mat','channel');
ch2=load('ChannelsToAnalyse/PFCx_deltadeep.mat','channel');
try load(sprintf('LFPData/LFP%d.mat',ch1.channel),'LFP');end
E1=Restrict(LFP,epoch{man});
try load(sprintf('LFPData/LFP%d.mat',ch2.channel),'LFP');end
E2=Restrict(LFP,epoch{man});

% load neurons
[S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
nN=numNeurons;
for s=1:length(numNeurons)
    if TT{numNeurons(s)}(2)==1,nN(nN==numNeurons(s))=[];end
end
T=PoolNeurons(S,nN);
ST{1}=T;ST=tsdArray(ST);
Q = MakeQfromS(ST,10*10);
Q=tsd(Range(Q),full(Data(Q)));
Qep=Restrict(Q,epoch{man});
%%
figure('Color',[1 1 1]), hold on,
imagesc(Range(Qep,'s'),1,Data(Qep)'); colormap pink
plot(Range(E1,'s'),Data(E1)/1000+4,'Linewidth',2)
plot(Range(E2,'s'),Data(E2)/1000+6,'Linewidth',2)
plot(Range(delt,'s'),1.1+ones(length(Data(delt)),1),'*r')
plot(Range(D1,'s'),0.8+ones(length(Data(D1)),1),'*g')
a=0; xl=Start(epoch{man},'s')+10*[a a+1];xlim(xl)
legend({'LFPsup','LFPdeep','Delta','Down'})
%%
a=a+1; xl=Start(epoch{man},'s')+10*[a a+1];xlim(xl);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< Redo Delta for all days <<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

for do=2 %delta ch1.channel 1:4, 5:13
    clear Dir Rootpath chsup_night chdeep_night chsup chdeep chob chob_night
    if do==1
        Rootpath={'/media/DataMOBsRAID/ProjetNREM/Mouse294','/media/DataMOBsRAIDN/ProjetNREM/Mouse294'};
        chsup_night=4; chdeep_night=3;
        chsup=31; chdeep=30;
        chob=0; chob_night=0; 
    elseif do==2
        Rootpath={'/media/DataMOBsRAID/ProjetNREM/Mouse330','/media/DataMOBsRAIDN/ProjetNREM/Mouse330'};
        chsup_night=4; chdeep_night=0;
        chsup=25; chdeep=12;
        chob=19; chob_night=2; 
    elseif do==3
        Rootpath={'/media/DataMOBsRAIDN/ProjetNREM/Mouse393','/media/DataMOBsRAID/ProjetNREM/Mouse393'};
        chsup_night=[]; chdeep_night=1;
        chsup=[]; chdeep=6;
        chob=14; chob_night=5;
    elseif do==4
        Dir{1}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
        Dir{2}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160705';
        Dir{3}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160706';
        Dir{4}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160711';
        chsup=25; chdeep=19;
        chob=14; 
    elseif do==5
        Dir{1}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160719';    
        Dir{2}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160720';
        Rootpath={'/media/DataMOBsRAIDN/ProjetNREM/Mouse394'};
        chsup_night=[]; chdeep_night=1;
        chsup=[]; chdeep=3;
        chob=14; chob_night=5;
    elseif do==6
        Rootpath={'/media/DataMOBsRAIDN/ProjetNREM/Mouse395','/media/DataMOBsRAID/ProjetNREM/Mouse395'};
        chsup_night=0; chdeep_night=5;
        chsup=0; chdeep=17;
        chob=14; chob_night=4;
    elseif do==7
        Rootpath={'/media/DataMOBsRAIDN/ProjetNREM/Mouse400','/media/DataMOBsRAID/ProjetNREM/Mouse400'};
        chsup_night=[]; chdeep_night=4;
        chsup=[]; chdeep=20;
        chob=13; chob_night=3;
    elseif do==8
        Rootpath={'/media/DataMOBsRAIDN/ProjetNREM/Mouse402','/media/DataMOBsRAID/ProjetNREM/Mouse402'};
        chsup_night=4; chdeep_night=5; %try chsup_night=[]; 
        chsup=17; chdeep=28; %try chsup=[]; 
        chob=14; chob_night=3;
    elseif do==9
        Rootpath={'/media/DataMOBsRAIDN/ProjetNREM/Mouse403','/media/DataMOBsRAID/ProjetNREM/Mouse403'};
        chsup_night=1; chdeep_night=0;%try chsup_night=[]; 
        chsup=12; chdeep=4;%try chsup=[];
        chob=30; chob_night=5;
    elseif do==10
        Dir{1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
        Dir{2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913-night';
        Dir{3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915';
        Dir{4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915-night';
        Dir{5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916';
        Dir{6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916-night';
        chsup_night=[]; chdeep_night=5;
        chsup=[]; chdeep=22;
        chob=14; chob_night=3;
    elseif do==11
        Dir{1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010';
        Dir{2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161011';
        Dir{3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161012';
        chsup_night=5; chdeep_night=0;
        chsup=22; chdeep=6;
        chob=14; chob_night=3;
    elseif do==12
        Dir{1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
        Dir{2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913-night';
        Dir{3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915';
        Dir{4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915-night';
        Dir{5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916';
        Dir{6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916-night';
        chsup_night=[]; chdeep_night=1;%before chsup_night=0;
        chsup=[]; chdeep=10;%before chsup=8; 
        chob=30; chob_night=5;
    elseif do==13
        Dir{1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161010';
        Dir{2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161011';
        Dir{3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161012';
        chsup=12; chdeep=15;
        chob=30; chob_night=5;
    elseif do==14
        Dir{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243';
        Dir{2}= '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
        chsup=27; chdeep=26;
    elseif do==15
        Dir{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
        %Dir{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244'; %fait
        chsup=58; chdeep=63;
    elseif do==16
        Dir{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251';
        Dir{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251';
        Dir{3}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251';
        Dir{4}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251';
        Dir{5}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251';
        chsup=30; chdeep=11;
    elseif do==17
        Dir{1}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252';
        Dir{2}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252';
        Dir{3}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252';
        Dir{4}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252';
        chsup=40; chdeep=62;
    elseif do==18
        Dir{1}='/media/DataMOBsRAID/ProjetAstro/Mouse051/20130313/BULB-Mouse-51-13032013';
        chsup=21;  chdeep=20;
    elseif do==19
        Dir{1}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013';
        Dir{2}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013';
        Dir{3}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130416/BULB-Mouse-60-16042013';
        chsup=6; chdeep=4;
    elseif do==20
        Dir{1}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013';
        Dir{2}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013';
        Dir{3}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130416/BULB-Mouse-61-16042013';
        chsup=0; chdeep=1;
    elseif do==21
        Dir{1}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130729/BULB-Mouse-82-29072013';
        Dir{2}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013';
        chsup=8; chdeep=12;
    elseif do==22
        Dir{1}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130723/BULB-Mouse-83-23072013';
        Dir{2}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130729/BULB-Mouse-83-29072013';
        Dir{3}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013';
        chsup=1; chdeep=5;
    elseif do==23
        Dir{1}='/media/DataMOBsRAID/ProjetAstro/Mouse147/20140804/BULB-Mouse-147-04082014';
        chsup=6; chdeep=10;
    elseif do==24
        Dir{1}='/media/DataMOBsRAID/ProjetAstro/Mouse148/20140828/BULB-Mouse-148-28082014';
        chsup=6; chdeep=8;
    elseif do==25
        Dir{1}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141219/BULB-Mouse-160-19122014';
        Dir{2}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141222/BULB-Mouse-160-22122014';
        Dir{3}='/media/DataMOBsRAID/ProjetAstro/Mouse160/20141223/BULB-Mouse-160-23122014';
        chsup=6; chdeep=10;
    elseif do==26
        Dir{1}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141209/BULB-Mouse-161-09122014';
        Dir{2}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141211/BULB-Mouse-161-11122014';
        Dir{3}='/media/DataMOBsRAID/ProjetAstro/Mouse161/20141217/BULB-Mouse-161-17122014';
        chsup=[]; chdeep=10;
    elseif do==27
        Dir{1}='/media/DataMOBsRAID/ProjetAstro/Mouse162/20141215/BULB-Mouse-162-15122014';
        Dir{2}='/media/DataMOBsRAID/ProjetAstro/Mouse162/20141216/BULB-Mouse-162-16122014';
        Dir{3}='/media/DataMOBsRAID/ProjetAstro/Mouse162/20141218/BULB-Mouse-162-18122014';
        chsup=6; chdeep=10;
    end
    
    if exist('Rootpath','var')
        if ~exist('Dir','var'), Dir=[];end
        for r=1:length(Rootpath)
            list=dir(Rootpath{r});
            for li=3:length(list)
                if strcmp(list(li).name(1:4),'2016')
                    Dir=[Dir,{[Rootpath{r},'/',list(li).name]}];
                end
            end
        end
    end
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<<<<<< Bulb channel <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    if 0
        for man=1:length(Dir)
            disp(' ');disp(Dir{man})
            cd(Dir{man})
            if ~isempty(strfind(Dir{man},'night'))
                chnew=chob_night; 
            else
                chnew=chob; 
            end
            if exist('chob','var')
                try ch1=load('ChannelsToAnalyse/Bulb_deep.mat','channel');end
                if ~exist('ch1','var') || ~isequal(chnew,ch1.channel)
                    try disp(sprintf('Channel Bulb_deep=%d',ch1.channel));catch, disp('Channel Bulb_deep undefined');end
                    channel=chnew;
                    save ChannelsToAnalyse/Bulb_deep.mat channel
                    disp(sprintf('    -> changed to channel=%d',channel))
                else
                    disp(sprintf('Channel Bulb_deep=%d  -> OK',ch1.channel));
                end
            else
                disp('No channel Bulb specified for checking')
            end
        end
    end
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<< PFCx deltasup et deltadeep <<<<<<<<<<<<<<<<<<<<<<

    if 1
        for man=1:length(Dir)
            disp(' ');disp(Dir{man})
            cd(Dir{man})
            
            if ~isempty(strfind(Dir{man},'night'))
                chnew1=chsup_night; chnew2=chdeep_night;
            else
                chnew1=chsup; chnew2=chdeep;
            end
            %
            try
                temp=load('AllDeltaPFCx.mat','ch1','ch2');
                if temp.ch1==chnew2 && temp.ch2==chnew1
                    disp('Deltanew done');
                else
                    disp('Deltanew exists.. overrighting!');error
                end
                
            catch
                % <<<<<<<<<<<< PFCx_deltasup <<<<<<<<<<<<
                try ch1=load('ChannelsToAnalyse/PFCx_deltasup.mat','channel');end
                if ~exist('ch1','var') || ~isequal(chnew1,ch1.channel)
                    try disp(sprintf('Channel DeltaSup=%d',ch1.channel));catch, disp('Channel DeltaSup undefined');end
                    channel=chnew1;
                    save ChannelsToAnalyse/PFCx_deltasup.mat channel
                    disp(sprintf('    -> changed to channel=%d',channel))
                    if ~exist('AllDeltaPFCx_old.mat','file')
                        try movefile('AllDeltaPFCx.mat','AllDeltaPFCx_old.mat');end
                        try movefile('NREMepochsML.mat','NREMepochsML_old.mat');end
                    else
                        delete('AllDeltaPFCx.mat')
                        delete('NREMepochsML.mat')
                    end
                end
                % <<<<<<<<<<<< PFCx_deep <<<<<<<<<<<<
                try ch2=load('ChannelsToAnalyse/PFCx_deltadeep.mat','channel');end
                if ~exist('ch2','var') || ~isequal(chnew2,ch2.channel)
                    try disp(sprintf('Channel DeltaDeep=%d',ch2.channel));catch, disp('Channel DeltaDeep undefined');end
                    channel=chnew2;
                    save ChannelsToAnalyse/PFCx_deltadeep.mat channel
                    disp(sprintf('    -> changed to channel=%d',channel))
                    if ~exist('AllDeltaPFCx_old.mat','file')
                        try movefile('AllDeltaPFCx.mat','AllDeltaPFCx_old.mat');end
                        try movefile('NREMepochsML.mat','NREMepochsML_old.mat');end
                    else
                        delete('AllDeltaPFCx.mat')
                        delete('NREMepochsML.mat')
                    end
                end
                
                 % <<<<<<<<<<<<< Redo substages and delta <<<<<<<<<<<<<<<<<
                 clear opNew op NamesOp Dpfc Epoch noise wholeEpoch
                 try
                     [op,NamesOp,Dpfc,Epoch,noise,opNew]=FindNREMepochsML;
                     save NREMepochsML.mat op NamesOp Dpfc Epoch noise opNew
                 end
            end
        end
    end

    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<< Run BulbSleepScript <<<<<<<<<<<<<<<<<<<<<<<<<<<<
    if 0
        for man=1:length(Dir)
            %%
            disp(' ');disp(Dir{man})
            cd(Dir{man})
            clear SWSEpoch channel chH chB
            try 
                load StateEpochSB SWSEpoch
                SWSEpoch; disp('OK')
            catch
                
                try load('ChannelsToAnalyse/dHPC_deep.mat');chH=channel;
                catch
                    try load('ChannelsNaNToAnalyse/dHPC_rip.mat');chH=channel;end
                end
                
                try load('ChannelsToAnalyse/Bulb_deep.mat');chB=channel;end
                if ~(exist([Dir{man},'/B_High_Spectrum.mat'], 'file') == 2)
                    disp('calculating Bulb Spectrum');HighSpectrum([pwd,'/'],chB,'B');
                end
                disp('Bulb Spectrum done')
                if ~(exist([Dir{man},'/H_Low_Spectrum.mat'], 'file') == 2)
                    disp('calculating Hpc spectrum');LowSpectrumSB([pwd,'/'],chH,'H');
                end
                disp('Hpc spectrum done')
                disp('Running BulbSleepScript')
                try
                    BulbSleepScript;
                catch
                    disp('Problem, skip')
                end
                close all
            end
        end
    end
end



%% saveFigure from GenerateIDSleepRecord
p=1;Dir.path{p}=pwd;
Dir.name{p}=Dir.path{p}(max(strfind(Dir.path{p},'Mouse'))+[0:7]);
    Dir.date{p}=Dir.path{p}(strfind(Dir.path{p},'/201')+[1:8]);
    Dir.manipe{p}='BSL';
    %title
    title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ')'];
    filename_fig = ['IDfigures_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
cd('/media/DataMOBsRAIDN/ProjetNREM/Figures/FigureID-deltaCheck')
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    cd(Dir.path{p})
%%
%[DirT,nameSessions]=NREMstages_path('SD6h');
[DirT,nameSessions]=NREMstages_path('SD24h');
%[DirT,nameSessions]=NREMstages_path('OR');
Dir.path=DirT(:);
%%
Dir=PathForExperimentsMLnew('Spikes');
for p=1:length(Dir.path)
    disp(' ');disp('***************************************************')
    cd(Dir.path{p});disp(Dir.path{p})
    clearvars -except Dir p
    
    %disp(pwd)
    Dir.name{p}=Dir.path{p}(max(strfind(Dir.path{p},'Mouse'))+[0:7]);
    Dir.date{p}=Dir.path{p}(strfind(Dir.path{p},'/201')+[1:8]);
    Dir.manipe{p}='BSL';
    filename_fig = ['IDfigures_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
   
    if ~exist([filename_fig,'.fig'],'file'),
        if ~exist('IdFigureData.mat','file')
            checkBeforeGenerateID;
            GenerateIDSleepRecord;
        else
            disp('IdFigureData.mat exists.. ploting')
            PlotIDSleepRecord;
        end
        
        %title
        title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ')'];
        % suptitle
        suplabel(title_fig,'t');
        %save figure
        savefig(filename_fig);
    else
        open([filename_fig,'.fig']);
        disp([filename_fig,'.fig exists.. ploting'])
    end
    
    cd('/media/DataMOBsRAIDN/ProjetNREM/Figures/FigureID-deltaCheck')
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    close all
end