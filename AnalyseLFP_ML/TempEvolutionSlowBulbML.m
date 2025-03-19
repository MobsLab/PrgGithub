%TempEvolutionSlowBulbML

disp(' '); disp('                      ---------------------------------');
disp('                      --- TempEvolutionSlowBulbML.m ---')
disp('                      ---------------------------------');disp(' ');

%% ----------------- INPUTS ----------------------------------------------
%--------------------------------------------------------------------------


freqSlow=[2 4];
freqUSlow=[0.5 1.5];
clearBadData=0;
fac=1;
RescaleAndSmooth=1;
ZeitTime0=8; % time of the begining of the lighthase / 24h
useSleepScoringSB=0;
removeNoisyEpochs=1;
close all

% --------- choose data ---------
%%
Dir1=PathForExperimentsBULB('SLEEPBasal');
Dir1=RestrictPathForExperiment(Dir1,'Group','CTRL');
Dir2=PathForExperimentsML('BASAL');%'BASAL','PLETHYSMO','DPCPX', 'LPS', 'CANAB';
Dir2=RestrictPathForExperiment(Dir2,'Group',{'WT','C57'});
Dir=MergePathForExperiment(Dir1,Dir2);


%%
ANALYNAME='TempEvolutionSlowNew'; 
if useSleepScoringSB, ANALYNAME=[ANALYNAME,'SB']; else, ANALYNAME=[ANALYNAME,'ML'];end
A=unique(Dir.manipe);for i=1:length(A), ANALYNAME=[ANALYNAME,'_',A{i}];end


strains={'WT','CTRL','dKO','C57'};
nameEpochs={'SWS','Wake','REM'};

%dirToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlowBulb/';
dirToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseSlowDecrease/';


%% ------------------- CREATE DATA MATRIX ----------------------------------
%--------------------------------------------------------------------------

tic

a=1;
try
    load([dirToSave,ANALYNAME])
    InfoGroup(1,2);
    disp(['Analysis exists, loading data from AnalyseTempEvolutionSlowBulb/',ANALYNAME])
    
catch
  
    for man=1:length(Dir.path)
        
        try
            disp('  ')
            disp([Dir.group{man},' ',Dir.path{man}])
            cd(Dir.path{man})
            res=pwd;
            
            clear SWSEpoch Wake REMEpoch MovEpoch TimeDebRec TimeEndRec
            clear  tpsdeb tpsfin PreEpoch tdebR dur dosave
            
            % -------------------------------
            % Recording time
            load behavResources PreEpoch TimeEndRec tpsdeb tpsfin
            tfinR=TimeEndRec*[3600 60 1]';
            for ti=1:length(tpsdeb)
                dur(ti)=tpsfin{ti}-tpsdeb{ti};
                tdebR(ti)=tfinR(ti)-dur(ti);
                if ti>1 && tdebR(ti)<=tfinR(ti-1)
                    %disp([tfinR(ti-1),tdebR(ti)])
                    tdebR(ti)=tfinR(ti-1)+1;
                    dosave=1;
                end
            end
            
            if exist('dosave','var')
                disp('TimeDebRec are too early... redefining');
                TimeDebRec=[floor(tdebR/3600) floor(rem(tdebR,3600)/60) rem(rem(tdebR,3600),60)];
                save behavResources -append TimeDebRec
            end
            
            
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
                if exist('PreEpoch','var'), Wake=and(Wake,PreEpoch);end
            else
                try
                    load StateEpoch SWSEpoch MovEpoch REMEpoch
                    Wake=MovEpoch;
                catch
                    disp('No StateEpoch: Using SleepScoringSB.')
                    load StateEpochSB SWSEpoch Wake REMEpoch
                end
                if exist('PreEpoch','var'), Wake=and(Wake,PreEpoch);end
            end
            
            if exist('PreEpoch','var'), SWSEpoch=and(SWSEpoch,PreEpoch);end
            if exist('PreEpoch','var'), REMEpoch=and(REMEpoch,PreEpoch);end
            
            % -------------------------------
            % remove noisy epochs
            if removeNoisyEpochs
                clear WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch
                try load StateEpoch WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch
                catch, load StateEpochSB WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch;
                end
                if ~exist('WeirdNoiseEpoch','var'),WeirdNoiseEpoch=intervalSet([],[]);end
                    
                SWSEpoch=SWSEpoch-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
                REMEpoch=REMEpoch-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
                Wake=Wake-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
            end
            
            
            
            clear chBulb Slow USlow t Sp f LFP
            % -------------------------------
            % get channel and spectro Bulb
            tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
            chBulb=tempchBulb.channel;
            disp(['Loading Spetrum',num2str(chBulb)])
            try
                eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');']);
            catch
                disp('    ...calculating Spectrum')
                eval(['load(''',res,'','/LFPData/LFP',num2str(chBulb),'.mat'');']);
                [params,movingwin]=SpectrumParametersML('low');
                [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
                eval(['save(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'',''Sp'',''t'',''f'');']);
            end
            % Dir.CorrecAmpli(man) ???
            Slow=tsd(t*1E4,nanmean(Sp(:,find(f>freqSlow(1)&f<freqSlow(2))),2));
            USlow=tsd(t*1E4,nanmean(Sp(:,find(f>freqUSlow(1)&f<freqUSlow(2))),2));
            
            
            % -------------------------------
            % get channel and spectro PFCx_sup
            clear tempch SlowPFs t Sp f LFP
            try
                tempch=load([res,'/ChannelsToAnalyse/PFCx_sup.mat'],'channel');
                disp(['Loading Spetrum',num2str(tempch.channel)])
                eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(tempch.channel),'.mat'');']);
                SlowPFs=tsd(t*1E4,nanmean(Sp(:,find(f>freqSlow(1)&f<freqSlow(2))),2));
            catch
                disp('Problem spectrum PFCx_sup')
                try
                eval(['load(''',res,'','/LFPData/LFP',num2str(tempch.channel),'.mat'',''LFP'');']);
                [params,movingwin]=SpectrumParametersML('low');
                [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
                eval(['save(''',res,'','/SpectrumDataL/Spectrum',num2str(tempch.channel),'.mat'',''Sp'',''t'',''f'');']);
                SlowPFs=tsd(t*1E4,nanmean(Sp(:,find(f>freqSlow(1)&f<freqSlow(2))),2));
                disp('Done.')
                catch
                    SlowPFs=tsd([],[]);
                end
            end
           
            % -------------------------------
            % get channel and spectro PFCx_deep
            clear tempch SlowPFd t Sp f
            try
                tempch=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
                disp(['Loading Spetrum',num2str(tempch.channel)])
                eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(tempch.channel),'.mat'');']);
                SlowPFd=tsd(t*1E4,mean(Sp(:,find(f>freqSlow(1)&f<freqSlow(2))),2));
            catch
                disp('Problem spectrum PFCx_deep')
            end
            
            
            % -------------------------------
            % load ZT or Recalculate and save
            clear tsdZT
            try
                load behavResources tsdZT
                Range(tsdZT);
            catch
                disp('-> Calculating tsdZT and saving in behavResources')
                tim=[]; ZT=[];
                for ttt=1:length(tpsdeb)
                    tim_temp=t(t>=tpsdeb{ttt} & t<tpsfin{ttt});
                    if tpsdeb{ttt}~=tpsfin{ttt}
                        ZT_temp= interp1([tpsdeb{ttt},tpsfin{ttt}],[tdebR(ttt) tfinR(ttt)],tim_temp);
                        tim=[tim,tim_temp]; ZT=[ZT,ZT_temp];
                        if ~issorted(ZT); disp('problem, TimeEndRec unsorted');keyboard;end
                    end
                end
                
                tsdZT=tsd(1E4*tim',ZT');
                save behavResources -append tsdZT
            end
            
            
            % --------------------------------------------------------
            % --------------------------------------------------------
            
            % save InfoGroup = [group strains, nb mouse]
            InfoGroup(a,1:2)=[find(strcmp(strains,Dir.group{man})),str2double(Dir.name{man}(strfind(Dir.name{man},'Mouse')+5:end))];
            
            % save Epochs and time of recording
            AllEpochs(a,1:3)={SWSEpoch,Wake,REMEpoch};
            AllZT{a,1}=Data(Restrict(tsdZT,SWSEpoch));
            AllZT{a,2}=Data(Restrict(tsdZT,Wake));
            AllZT{a,3}=Data(Restrict(tsdZT,REMEpoch));
            
            % save spectra (heavy)
            OBSlow{a}=nan; OBUSlow{a}=nan; PFsSlow{a}=nan; PFdSlow{a}=nan;
            if 0
                OBSlow{a}=Slow;
                OBUSlow{a}=USlow;
                PFsSlow{a}=SlowPFs;
                PFdSlow{a}=SlowPFd;
            end
            
            % save spectra restricted to epochs
            OBSlowEpochs{a,1}=Data(Restrict(Slow,SWSEpoch));
            OBSlowEpochs{a,2}=Data(Restrict(Slow,Wake));
            OBSlowEpochs{a,3}=Data(Restrict(Slow,REMEpoch));
            
            OBUSlowEpochs{a,1}=Data(Restrict(USlow,SWSEpoch));
            OBUSlowEpochs{a,2}=Data(Restrict(USlow,Wake));
            OBUSlowEpochs{a,3}=Data(Restrict(USlow,REMEpoch));
            
            PFsSlowEpochs{a,1}=Data(Restrict(SlowPFs,SWSEpoch));
            PFsSlowEpochs{a,2}=Data(Restrict(SlowPFs,Wake));
            PFsSlowEpochs{a,3}=Data(Restrict(SlowPFs,REMEpoch));
            
            PFdSlowEpochs{a,1}=Data(Restrict(SlowPFd,SWSEpoch));
            PFdSlowEpochs{a,2}=Data(Restrict(SlowPFd,Wake));
            PFdSlowEpochs{a,3}=Data(Restrict(SlowPFd,REMEpoch));
            
            a=a+1;
            
            
        catch
            disp('PROBLEM')
            keyboard
        end
        
    end
    
    disp(['saving analysis in ',dirToSave(max(strfind(dirToSave(1:end-1),'/')):end),ANALYNAME])
    %save([dirToSave,ANALYNAME],'InfoGroup','freqSlow','freqUSlow','AllEpochs','AllZT','SpSlow','SpUSlow','SpSlowEpochs','SpUSlowEpochs')
    save([dirToSave,ANALYNAME],'Dir','InfoGroup','freqSlow','freqUSlow','AllEpochs','AllZT',...
        'OBSlow','OBUSlow','PFsSlow','PFdSlow','OBSlowEpochs','OBUSlowEpochs','PFsSlowEpochs','PFdSlowEpochs')
end

cd(dirToSave)
toc
%% use older saved .mat
if ~exist('OBSlowEpochs','var'), OBSlowEpochs=SpSlowEpochs;end
if ~exist('OBUSlowEpochs','var'), OBUSlowEpochs=SpUSlowEpochs;end

%% ------------------------ CLEAR SPECTRA ---------------------------------
% -------------------------------------------------------------------------
if clearBadData % OB only
    
    for a=1:length(AllZT)
        % clear SWS
        ind=find(OBUSlowEpochs{a,1}>fac*OBSlowEpochs{a,1});
        OBSlowEpochs{a,1}(ind)=nan;
        OBUSlowEpochs{a,1}(ind)=nan;
        
        % clear Wake
        ind=find(OBUSlowEpochs{a,2}>fac*OBSlowEpochs{a,2});
        OBSlowEpochs{a,2}(ind)=nan;
        OBUSlowEpochs{a,2}(ind)=nan;
    end
end
                

%% ------------------------ RESCALE 0 - 1 ---------------------------------
% -------------------------------------------------------------------------
if RescaleAndSmooth
    for a=1:length(AllZT)
        %         try SpSlowEpochs{a,1}=SmoothDec(rescale(SpSlowEpochs{a,1},0,1),200);end
        %         try SpSlowEpochs{a,2}=SmoothDec(rescale(SpSlowEpochs{a,2},0,1),200);end
        %         try SpSlowEpochs{a,3}=SmoothDec(rescale(SpSlowEpochs{a,3},0,1),200);end
        for et=1:3
            try OBSlowEpochs{a,et}=SmoothDec(nanzscore(OBSlowEpochs{a,et}),200);end
            try PFsSlowEpochs{a,et}=SmoothDec(nanzscore(PFsSlowEpochs{a,et}),200);end
            try PFdSlowEpochs{a,et}=SmoothDec(nanzscore(PFdSlowEpochs{a,et}),200);end
            
        end
    end
end

%% ------------------------ PLOT SPECTRA PER ZT ---------------------------
%--------------------------------------------------------------------------
% pool strains
nameStructure={'OB','PFs','PFd'};
nbBins=1E3;
ZTrange=[0 12];% hours
ZTmat=min(ZTrange)+(max(ZTrange)-min(ZTrange))*[1:nbBins]/nbBins;

for s=1:length(nameStructure)
    figure('Color',[1 1 1]),
    for et=1:3, MAT{s,et}=nan(length(AllZT),nbBins);end
    
    for a=1:length(AllZT)
        for et=1:3
            subplot(3,1,et), hold on,
            if isempty(AllZT{a,et})==0
                ZT_temp=AllZT{a,et}/3600-ZeitTime0;
                % OB PFs PFd
                eval(['temp=',nameStructure{s},'SlowEpochs{',num2str(a),',',num2str(et),'};']);
                if ~isempty(temp)
                    Mat_temp=MAT{s,et};
                    [tr,xdeb]=min(abs(ZTmat-ZT_temp(1)));
                    [tr,xfin]=min(abs(ZTmat-ZT_temp(end)));
                    %                 warning off
                    %                 newData=interp1(ZT_temp,temp,ZTmat(xdeb:xfin));
                    %                 warning on
                    m= min(length(temp),length(ZT_temp));
                    temptsd=tsd(ZT_temp(1:m),temp(1:m));
                    newData=Data(Restrict(temptsd,ts(ZTmat(xdeb:xfin))));
                    Mat_temp(a,xdeb:xfin)=newData;
                    MAT{s,et}=Mat_temp;
                    
                    if InfoGroup(a,1)==1
                        plot(ZTmat,Mat_temp,'k');
                    elseif InfoGroup(a,1)==2
                        plot(ZTmat,Mat_temp,'r');
                    end
                end
            end
            title(['Single experiment ',nameEpochs{et},' ',strains{1},'(k), ',strains{2},'(r)'])
            ylabel([nameStructure{s},' spectrum'])
        end
    end
    xlabel('ZeitTime')
end
%% plot decrease over time, pooled expe
for s=1:length(nameStructure)
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.05 0.4 0.8]),
    
    Ylim=[];
    Ylim2=[];
    for et=1:3
        subplot(3,2,2*et-1)
        ind_wt=find(InfoGroup(:,1)==1|InfoGroup(:,1)==2);
        plot(ZTmat, nanmean(MAT{s,et}(ind_wt,:)),'k','Linewidth',2)
        hold on, plot(ZTmat, nanmean(MAT{s,et}(ind_wt,:))+stdError(MAT{s,et}(ind_wt,:)),'k')
        hold on, plot(ZTmat, nanmean(MAT{s,et}(ind_wt,:))-stdError(MAT{s,et}(ind_wt,:)),'k')
        
        ind_dko=find(InfoGroup(:,1)==3);
        hold on, plot(ZTmat, nanmean(MAT{s,et}(ind_dko,:)),'r','Linewidth',2)
        hold on, plot(ZTmat, nanmean(MAT{s,et}(ind_dko,:))+stdError(MAT{s,et}(ind_dko,:)),'r')
        hold on, plot(ZTmat, nanmean(MAT{s,et}(ind_dko,:))-stdError(MAT{s,et}(ind_dko,:)),'r')
        xlim([3 10]);
        Ylim=[Ylim,ylim];
        
        subplot(3,2,2*et)
        ind_wt=find(InfoGroup(:,1)==1|InfoGroup(:,1)==2);
        plot(ZTmat, nanmedian(MAT{s,et}(ind_wt,:)),'k','Linewidth',2)
        hold on, plot(ZTmat, nanmedian(MAT{s,et}(ind_wt,:))+stdError(MAT{s,et}(ind_wt,:)),'k')
        hold on, plot(ZTmat, nanmedian(MAT{s,et}(ind_wt,:))-stdError(MAT{s,et}(ind_wt,:)),'k')
        
        ind_dko=find(InfoGroup(:,1)==3);
        hold on, plot(ZTmat, nanmedian(MAT{s,et}(ind_dko,:)),'r','Linewidth',2)
        hold on, plot(ZTmat, nanmedian(MAT{s,et}(ind_dko,:))+stdError(MAT{s,et}(ind_dko,:)),'r')
        hold on, plot(ZTmat, nanmedian(MAT{s,et}(ind_dko,:))-stdError(MAT{s,et}(ind_dko,:)),'r')
        xlim([3 10]);
        Ylim2=[Ylim2,ylim];
    end
    legend({strains{1:2},['(n=',num2str(length(ind_wt)),')'],' ',strains{3},['(n=',num2str(length(ind_dko)),')']})
    xlabel('ZeitTime')
    for et=1:3
        subplot(3,2,2*et-1)
        ylim([min(Ylim),max(Ylim)])
        title(['mean ',nameEpochs{et}]); ylabel([nameStructure{s},' spectrum'])
        
        subplot(3,2,2*et)
        ylim([min(Ylim2),max(Ylim2)])
        title(['median ',nameEpochs{et}]); ylabel([nameStructure{s},' spectrum'])
    end
    saveFigure(gcf,['TempEvolSlow',nameStructure{s},'-globalDecrease'],dirToSave)
    
end

%% ------------------------ PLOT RATIO SPECTRA ZT1/ZT2 ---------------------------
%--------------------------------------------------------------------------

ZT1=[3 4.5]; % early sleep period
ZT2=[8.5 10]; % late sleep period
% pool strains

% % plot all data, differentiate mice
% ind_wt=find(InfoGroup(:,1)==1);
% ind_dko=find(InfoGroup(:,1)==2);

for s=1:length(nameStructure)
    disp(' '); disp(nameStructure{s})
    
    ind_wt=find(InfoGroup(:,1)==1 | InfoGroup(:,1)==2);
    ind_dko=find(InfoGroup(:,1)==3);
    Uwt=unique(InfoGroup(ind_wt,2));
    Udko=unique(InfoGroup(ind_dko,2));
    % ---------------------------------------------------------------------
    % ---------------------------------------------------------------------
    disp('    Compute matrix for each vigilance state')
    MATT=nan(length(AllZT),6);
    for a=1:length(AllZT)
        for et=1:3
            if isempty(AllZT{a,et})==0
                ZT_temp=AllZT{a,et}/3600-ZeitTime0;
                eval(['temp=',nameStructure{s},'SlowEpochs{',num2str(a),',',num2str(et),'};']);
                m=min(length(temp),length(ZT_temp));
                index1=find(ZT_temp(1:m)<ZT1(2) & ZT_temp(1:m)>=ZT1(1));
                index2=find(ZT_temp(1:m)<ZT2(2) & ZT_temp(1:m)>=ZT2(1));
                
                MATT(a,et)=nanmean(temp(index1));
                MATT(a,3+et)=nanmean(temp(index2));
            end
        end
    end
    
    % ---------------------------------------------------------------------
    % ---------------------------------------------------------------------
    disp('    Plot intra/inter-individual variability')
    legwt={};
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.05 0.4 0.8]),
    for i=1:length(ind_wt)
        for et=1:3
            subplot(3,1,et), hold on,
            plot(find(Uwt==InfoGroup(ind_wt(i),2)),MATT(ind_wt(i),et),'ok','MarkerFaceColor','k')
            plot(find(Uwt==InfoGroup(ind_wt(i),2)),MATT(ind_wt(i),et+3),'ob','MarkerFaceColor','b')
        end
        legwt{find(Uwt==InfoGroup(ind_wt(i),2))}=num2str(InfoGroup(ind_wt(i),2));
    end
    
    legdko={};
    for i=1:length(ind_dko)
        for et=1:3
            subplot(3,1,et), hold on,
            plot(find(Udko==InfoGroup(ind_dko(i),2))+length(Uwt),MATT(ind_dko(i),et),'or','MarkerFaceColor','r')
            plot(find(Udko==InfoGroup(ind_dko(i),2))+length(Uwt),MATT(ind_dko(i),et+3),'om','MarkerFaceColor','m')
        end
        legdko{find(Udko==InfoGroup(ind_dko(i),2))}=num2str(InfoGroup(ind_dko(i),2));
    end
    for et=1:3
        subplot(3,1,et), hold on,
        set(gca,'xtick',1:length(Uwt)+1);set(gca,'xticklabel',[legwt,legdko])
        ylabel(nameEpochs{et})
        if et==1, title([nameStructure{s},...
                sprintf(' oscillation amplitude early (%1.1f-%1.1fh, k/r) and later (%1.1f-%1.1fh, b/m) in the day',ZT1(1),ZT1(2),ZT2(1),ZT2(2))]);
        end
    end
    
    % save Figure
    saveFigure(gcf,['TempEvolSlow',nameStructure{s},'-interindiv'],dirToSave)
    
    
    % ---------------------------------------------------------------------
    % ------------------------ POOL MICE ---------------------------------
    disp('    Pool mice')
    Umice=unique(InfoGroup(:,2));
    MATTm=nan(length(Umice),6);
    for a=1:length(Umice)
        Infom(a)=min(unique(InfoGroup(InfoGroup(:,2)==Umice(a),1)));
        for et=1:3
            MATTm(a,et)=nanmean(MATT(find(InfoGroup(:,2)==Umice(a)),et));
            MATTm(a,3+et)=nanmean(MATT(find(InfoGroup(:,2)==Umice(a)),3+et));
        end
    end
    
    % ---------------------------------------------------------------------
    % ------------------------ quantify ---------------------------------
    disp('    quantify ZT1 versus ZT2')
    
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.05 0.4 0.8]),
    ind_wt=find(Infom==1);
    ind_dko=find(Infom==2);
    Ylim=[];
    for et=1:3
        
        subplot(3,4,4*(et-1)+1)
        p=PlotErrorBarN([MATTm(ind_wt,et),MATTm(ind_wt,3+et)],0,1);
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{['ZT ',num2str(ZT1(1)),'-',num2str(ZT1(2))],...
            ['ZT ',num2str(ZT2(1)),'-',num2str(ZT2(2))]})
        title([nameEpochs{et},' ',strains{1},' (p=',num2str(floor(1E3*p)/1E3),')'])
        
        subplot(3,4,4*(et-1)+2)
        p=PlotErrorBarN([MATTm(ind_dko,et),MATTm(ind_dko,3+et)],0,1);
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{['ZT ',num2str(ZT1(1)),'-',num2str(ZT1(2))],...
            ['ZT ',num2str(ZT2(1)),'-',num2str(ZT2(2))]})
        title([nameEpochs{et},' ',strains{3},' (p=',num2str(floor(1E3*p)/1E3),')'])
        
        % difference pooled
        diffMATTm=nan(max(length(ind_wt),length(ind_dko)),2);
        diffMATTm(1:length(ind_wt),1)=MATTm(ind_wt,et)-MATTm(ind_wt,3+et);
        diffMATTm(1:length(ind_dko),2)=MATTm(ind_dko,et)-MATTm(ind_dko,3+et);
        subplot(3,4,4*(et-1)+3)
        p=PlotErrorBarN(diffMATTm,0,0);
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{[strains{1},' (n=',num2str(length(ind_wt)),')'],[strains{3},' (n=',num2str(length(ind_dko)),')']})
        title([nameEpochs{et},' ZT2 - ZT1 (p=',num2str(floor(1E3*p)/1E3),')'])
        
        % ratio
        ratioMATTm=nan(max(length(ind_wt),length(ind_dko)),2);
        ratioMATTm(1:length(ind_wt),1)=MATTm(ind_wt,et)./MATTm(ind_wt,3+et);
        ratioMATTm(1:length(ind_dko),2)=MATTm(ind_dko,et)./MATTm(ind_dko,3+et);
        subplot(3,4,4*(et-1)+4)
        p=PlotErrorBarN(ratioMATTm,0,0);
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{[strains{1},' (n=',num2str(length(ind_wt)),')'],[strains{3},' (n=',num2str(length(ind_dko)),')']})
        title([nameEpochs{et},' ZT2 / ZT1 (p=',num2str(floor(1E3*p)/1E3),')'])
        
    end
    
    for et=1:3
        subplot(3,4,4*(et-1)+1), ylabel([nameStructure{s},' 2-4Hz amp']);
        subplot(3,4,4*(et-1)+2), 
    end
    saveFigure(gcf,['TempEvolSlow',nameStructure{s},'-BarPlot'],dirToSave)
    
end



%%
% see TempEvolutionSlowBulb.m
% code Karim







