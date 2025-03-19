%TempProportionSlowBulbML.m

disp(' '); 
disp('                 ----------------------------------');
disp('                 --- TempProportionSlowBulbML.m ---')
disp('                 ----------------------------------');
%% ----------------- INPUTS ----------------------------------------------
%--------------------------------------------------------------------------

freqSlow=[1.5 5];
%freqUSlow=[0.5 1.5];
%clearBadData=1;fac=1;
freqLFP=1250;% Hz, downsampling LFP
PasSlow=25; % for downsampling

ZeitTime0=8; % time of the begining of the lighthase / 24h
ZTinterest=[3,10];
useSleepScoringSB=0;
removeNoisyEpochs=1;

NameDir={'BASAL'};%={'BASAL','PLETHYSMO','DPCPX', 'LPS', 'CANAB'};
ANALYNAME='TempProportionSlow'; 
if useSleepScoringSB, ANALYNAME=[ANALYNAME,'SB']; else, ANALYNAME=[ANALYNAME,'ML'];end
for i=1:length(NameDir), ANALYNAME=[ANALYNAME,'_',NameDir{i}];end


strains={'WT','dKO','C57'};
nameEpochs={'SWS','Wake','REM','All'};

dirToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlowBulb/';
if ~exist([dirToSave,ANALYNAME],'dir'), mkdir([dirToSave,ANALYNAME]);end
res=pwd;

%% ------------------- GET HILBERT TRANSFORM ------------------------------
%--------------------------------------------------------------------------
disp(' '); disp('                 -------- HilbertTSDarray ---------');
if ~exist('HilbertTSDarray','var')
    tic
    try
        load([dirToSave,ANALYNAME,'/InfoGroup.mat'],'InfoGroup'); InfoGroup(1,2);
        load([dirToSave,ANALYNAME,'/AllDir.mat'],'AllDir')
        
        HilbertTSDarray=tsdArray;
        disp(['reconstructing HilbertTSDarray from ',ANALYNAME])
        for a=1:length(AllDir)
            disp(['    - Hilbert',num2str(a),'.mat ...']); clear temp
            temp=load([dirToSave,ANALYNAME,'/Hilbert',num2str(a),'.mat'],'Hilslow');
            HilbertTSDarray{a}=temp.Hilslow;
        end
        
    catch
        a=1;
        for i=1:length(NameDir)
            Dir=PathForExperimentsML(NameDir{i});
            
            for man=1:length(Dir.path)
                try
                    disp('  '); disp([Dir.group{man},' ',Dir.path{man}])
                    cd(Dir.path{man}); 
                    AllDir{a}=Dir.path{man};
                    
                    clear chBulb Slow USlow LFP
                    % -------------------------------
                    % get channel and spectro Bulb
                    tempchBulb=load([Dir.path{man},'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
                    chBulb=tempchBulb.channel;
                    disp(['... Loading LFP',num2str(chBulb)])
                    eval(['load(''',Dir.path{man},'','/LFPData/LFP',num2str(chBulb),'.mat'',''LFP'');'])
                    
                    disp('... Filtering LFP for slow oscillations')
                    slow=FilterLFP(LFP,freqSlow,1024);
                    
                    disp('... Caculating Hilbert transform')
                    Hil=hilbert(Data(slow));
                    H=abs(Hil);
                    H(H<100)=100;
                    
                    rg=Range(slow);
                    Hilslow=tsd(rg(1:PasSlow:end),H(1:PasSlow:end));
                    
                    % -------------------------------
                    % save InfoGroup = [group strains, nb mouse]
                    InfoGroup(a,1:2)=[find(strcmp(strains,Dir.group{man})),str2double(Dir.name{man}(strfind(Dir.name{man},'Mouse')+5:end))];
                    
                    % save Hilslow
                    HilbertTSDarray{a}=Hilslow;
                    disp(['... Saving in ',ANALYNAME]);
                    save([dirToSave,ANALYNAME,'/Hilbert',num2str(a),'.mat'],'Hilslow','freqSlow');
                    a=a+1;
                end
            end
        end
        
        save([dirToSave,ANALYNAME,'/InfoGroup.mat'],'InfoGroup')
        save([dirToSave,ANALYNAME,'/AllDir.mat'],'AllDir');
        
    end
    toc
else
    disp('using variable HilbertTSDarray')
end

%% ------------------- CREATE DATA MATRIX ---------------------------------
%--------------------------------------------------------------------------
disp(' '); disp('                 ------------ MattHist ------------');
try
    load([dirToSave,ANALYNAME,'/MattHist.mat'],'MattHist')
    MattHist{1}(1,2);
    disp(['MattHist exists, loading from AnalyseTempEvolutionSlowBulb/',ANALYNAME])
catch
    % initiate
    for i=1:4, MattHist{i}=nan(length(AllDir),1000);end
    
    for a=1:length(AllDir)
        try
            disp('  '); disp([strains{InfoGroup(a,1)},'- ',AllDir{a}(max(strfind(AllDir{a},'Mouse')):end)])
            cd(AllDir{a});
            
            H=Data(HilbertTSDarray{a}); rg=Range(HilbertTSDarray{a});
            Hilslow=tsd(rg(1:PasSlow:end),H(1:PasSlow:end));
            
            clear SWSEpoch Wake REMEpoch MovEpoch PreEpoch SWS REM
            clear  tpsdeb tpsfin TimeEndRec PreEpoch tdebR dur dosave
            
            
            disp('... Recalculating ZeitgeberTime')
            % -------------------------------
            % Recording time
            load behavResources PreEpoch TimeEndRec tpsdeb tpsfin
            tfinR=TimeEndRec*[3600 60 1]';
            for ti=1:length(tpsdeb)
                dur(ti)=tpsfin{ti}-tpsdeb{ti};
                tdebR(ti)=tfinR(ti)-dur(ti);
                if ti>1 && tdebR(ti)<=tfinR(ti-1)
                    tdebR(ti)=tfinR(ti-1)+1;
                end
            end
            
            % -------------------------------
            % Recalculate ZT
            clear tsdZT t ZT tim ZTstart ZTstop ZTepoch
            tim=[]; ZT=[]; t=Range(Hilslow,'s')';
            for ttt=1:length(tpsdeb)
                tim_temp=t(t>=tpsdeb{ttt} & t<tpsfin{ttt});
                if tpsdeb{ttt}~=tpsfin{ttt}
                    ZT_temp= interp1([tpsdeb{ttt},tpsfin{ttt}],[tdebR(ttt) tfinR(ttt)],tim_temp);
                    tim=[tim,tim_temp]; ZT=[ZT,ZT_temp];
                    if ~issorted(ZT); disp('problem, TimeEndRec unsorted');keyboard;end
                end
            end
            tsdZT=tsd(1E4*tim',ZT'/3600);
            ZTstart=thresholdIntervals(tsdZT,ZeitTime0+ZTinterest(1),'Direction','Above');
            ZTstop=thresholdIntervals(tsdZT,ZeitTime0+ZTinterest(2),'Direction','Below');
            ZTepoch=and(ZTstart,ZTstop);
            
            
            disp('... Loading sleep Epochs')
            % -------------------------------
            % sleepscoring info, classical or with bulb SB
            if useSleepScoringSB
                try
                    load StateEpochSB SWSEpoch Wake REMEpoch
                    SWSEpoch;
                catch
                    BulbSleepScriptKB
                    close all
                    load StateEpochSB SWSEpoch Wake REMEpoch
                end
                Wake=and(Wake,PreEpoch);
            else
                load StateEpoch SWSEpoch MovEpoch REMEpoch
                Wake=and(MovEpoch,PreEpoch);
            end
            
            SWS=and(and(SWSEpoch,PreEpoch),ZTepoch);
            REM=and(and(REMEpoch,PreEpoch),ZTepoch);
            
            % -------------------------------
            % remove noisy epochs
            if removeNoisyEpochs
                clear WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch
                load StateEpoch WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch
                if ~exist('WeirdNoiseEpoch','var'), WeirdNoiseEpoch=intervalSet([],[]);end
                if ~exist('GndNoiseEpoch','var'), GndNoiseEpoch=intervalSet([],[]);end
                if ~exist('NoiseEpoch','var'), NoiseEpoch=intervalSet([],[]);end
                SWS=SWS-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
                REM=REM-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
                Wake=Wake-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
            end
            
            
            % -------------------------------
            % save histogram Hilbert transform
            
            for et=1:4
                clear epoch h Mtemp
                if et==4, epoch=intervalSet(min(Range(Hilslow)),max(Range(Hilslow)));
                else, eval(['epoch=',nameEpochs{et},';'])
                end
                h=hist(Data(Restrict(Hilslow,epoch)),1:5:5000);
                Mtemp=MattHist{et};
                Mtemp(a,1:1000)=h/freqLFP;
                MattHist{et}=Mtemp;
                
            end
            MatEpoch(a,1:4)={SWS,Wake,REM,ZTepoch};
            %SumEpoch(a,1:4)=[sum(Stop(SWS)-Start(SWS)),sum(Stop(Wake)-Start(Wake)), sum(Stop(REM)-Start(REM)) sum(Stop(ZTepoch)-Start(ZTepoch))]/1E4;
        catch
            keyboard
        end
    end
    disp(['Saving MattHist in ',ANALYNAME]);
    save([dirToSave,ANALYNAME,'/MattHist.mat'],'MattHist','ZeitTime0','ZTinterest');
    save([dirToSave,ANALYNAME,'/MatEpoch'],'MatEpoch','ZeitTime0','ZTinterest');
end
cd(res)


%% ------------- GET HIGH OSCILLATION PERIODS -----------------------------
%--------------------------------------------------------------------------
fact=[1.5 2 2.5 3];
disp(' '); disp('                 ------------ OscillBO ------------');
try
    load([dirToSave,ANALYNAME,'/OscillBO.mat'],'OscillBO','fact')
    Start(OscillBO{1,1,1});
    disp(['OscillBO exists, loading from AnalyseTempEvolutionSlowBulb/',ANALYNAME])
catch
    for a=1:length(AllDir)
        disp('  '); disp([strains{InfoGroup(a,1)},'- ',AllDir{a}(max(strfind(AllDir{a},'Mouse')):end)])
        cd(AllDir{a})
        
        clear chBulb slow tempchBulb LFP EEG
        % -------------------------------
        % get channel and spectro Bulb
        tempchBulb=load([Dir.path{man},'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
        chBulb=tempchBulb.channel;
        disp(['... Loading LFP',num2str(chBulb)])
        eval(['load(''',Dir.path{man},'','/LFPData/LFP',num2str(chBulb),'.mat'',''LFP'');'])
        
        disp('... Filtering LFP for slow oscillations')
        EEG=FilterLFP(LFP,freqSlow,1024);
        
        disp('... Getting large OB oscillation periods')
        for et=1:4
            clear epoch FilOB mnOB stdOB
            epoch=MatEpoch{a,et};
            FilOB=Restrict(EEG,epoch);
            mnOB=nanmean(Data(FilOB));
            stdOB=nanstd(Data(FilOB));
            try
                for f=1:length(fact)
                    clear BRST r pks
                    pks=findpeaks(Data(FilOB),mnOB+fact(f)*stdOB);
                    r=Range(FilOB,'s');
                    BRST=burstinfo(r(pks.loc),0.5);
                    OscillBO{a,et,f}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
                    fprintf('-> ok'),disp(' ');
                end
            catch
                OscillBO{a,et,f}=intervalSet([],[]); fprintf('-> empty'),disp(' ');
            end
        end
    end
        disp(['Saving OscillBO in ',ANALYNAME]);
        save([dirToSave,ANALYNAME,'/OscillBO.mat'],'OscillBO','fact');
end
cd(res)


%% -------------------- PLOT HISTOGRAMS PER EPOCHS ------------------------
%--------------------------------------------------------------------------

figure('Color',[1 1 1])
ind_Wt=find(InfoGroup(:,1)==1);
ind_dKO=find(InfoGroup(:,1)==2);

for et=1:4    
    for f=1:length(fact)
        subplot(4,length(fact),length(fact)*(et-1)+f),
        Matt=nan(max(length(ind_Wt),length(ind_dKO)),2);
        a_dko=1;a_WT=1;
        for a=1:length(AllDir)
            temp=OscillBO{a,et,f};
            try
                if InfoGroup(a,1)==1 && ~isempty(Start(temp))
                    Matt(a_WT,1)=sum(Stop(temp,'s')-Start(temp,'s'));
                    InfoMiceWT(a_WT)=InfoGroup(a,2);
                    a_WT=a_WT+1;
                    
                elseif InfoGroup(a,1)==2 && ~isempty(Start(temp))
                    Matt(a_dko,2)=sum(Stop(temp,'s')-Start(temp,'s'));
                    InfoMicedKO(a_dko)=InfoGroup(a,2);
                    a_dko=a_dko+1;
                end
            end
        end
        
        Uwt=unique(InfoMiceWT);
        Udko=unique(InfoMicedKO);
        MattM=nan(max(length(Uwt),length(Udko)),2);
        for i=1:length(Uwt)
            MattM(i,1)=nanmean(Matt(InfoMiceWT==Uwt(i),1));
        end
        for i=1:length(Udko)
            MattM(i,2)=nanmean(Matt(InfoMicedKO==Udko(i),1));
        end
        
        % pool mice
        
        PlotErrorBarN(MattM,0,0);
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'WT','dKO'})
        Title(['BO oscillation >',num2str(fact(f)),'std'])
        ylabel(['Time in ',nameEpochs{et},' (s)'])
    end
end








%% -------------------- PLOT HISTOGRAMS PER EPOCHS ------------------------
%--------------------------------------------------------------------------
% pool strains
sbt(1)=ceil(sqrt(size(InfoGroup,1)));
sbt(2)=ceil(size(InfoGroup,1)/sbt(1));

for et=1:4
    figure('Color',[1 1 1]),numF(et)=gcf;
    Mtemp=MattHist{et};
    for a=1:size(InfoGroup,1)
        subplot(sbt(1),sbt(2),a), hold on,
        if InfoGroup(a,1)==1
            plot(110:5:4990,100*Mtemp(a,23:999)/sum(Mtemp(a,2:999)),'k');
        elseif InfoGroup(a,1)==2
            plot(110:5:4990,100*Mtemp(a,23:999)/sum(Mtemp(a,2:999)),'r');
        end
    title([strains{InfoGroup(a,1)},'- ',AllDir{a}(max(strfind(AllDir{a},'Mouse')):end)])
    ylim([0 1])
    end
    xlabel(['Hilbert amplitude (',num2str(freqSlow(1)),'-',num2str(freqSlow(2)),'Hz)'])
    subplot(sbt(1),sbt(2),1),ylabel(['% time of ',nameEpochs{et}]); 
end


MatEpoch(a,1:4)



PlotErrorBarN(MatEpoch)
set(gca,'xtick',[1:4])
set(gca,'xticklabel',nameEpochs)




