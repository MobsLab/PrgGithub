%AnalyseNREMsubstages_SpectrumML
%
% see also
% 1. AnalyseNREMsubstagesML.m
% 2. AnalyseNREMsubstages_transitionML.m
% 3. AnalyseNREMsubstages_transitionprobML.m
% 4. AnalyseNREMsubstages_EvolRescaleML.m
% 5. AnalyseNREMsubstages_OBslowOscML.m
% 6. AnalyseNREMsubstages_EvolSlowML.m
% 7. AnalyseNREMsubstages_mergeDropML.m
% 8. AnalyseNREMsubstages_SpikesML.m
% 9. AnalyseNREMsubstages_MultiParamMatrix.m
% 10. AnalyseNREMsubstages_SpikesAndRhythms.m
% 11. AnalyseNREMsubstages_SpectrumML.m
% 12. AnalyseNREMsubstages_Rhythms.m
% 13. AnalyseNREMsubstages_N1evalML.m
% 14. AnalyseNREMsubstages_TrioTransitionML.m
% 15. AnalyseNREMsubstages_TrioTransRescaleML.m
% 16. AnalyseNREMsubstages_OBX.m
% 17. AnalyseNREMsubstages_SpikesInterPyrML.m
% 18. AnalyseNREMsubstagesdKOML.m
% CaracteristicsSubstagesML.m
% CodePourMarieCrossCorrDeltaSpindlesRipples.m
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
plotCrossFreqCoupling=0;
[params]=SpectrumParametersML('newlow');
Fsamp=0.5:0.05:20;
colori=[0.5 0.2 0.1;0.1 0.7 0 ; 0.8 0 0.7 ; 1 0 1 ;0.7 0.2 0.8];
Fs=1250;
UnitTime=10; % in sec
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< mean Spectrum for substages <<<<<<<<<<<<<<<<<<<
plotIndiv=0;
if plotIndiv, for i=1:2, figure('Color',[1 1 1]); numF(i)=gcf;end;end
nameAnaly='Analyse_meanSpectrumNREMStages.mat';

dodKO=0;
if dodKO
    Dir=PathForExperimentsML('BASAL');
    Dir=RestrictPathForExperiment(Dir,'Group','dKO');
    nameAnaly='Analyse_meanSpectrumNREMStages_dKO';
end
mice=unique(Dir.name);


try
    load([res,'/',nameAnaly],'Fsamp','MATOB','MATPF','MATHP')
    MATPF;MATHP;
    disp([nameAnaly,' already exists and has been loaded']);
    
catch
    % initiation
    MATOB=nan(length(Dir.path),5,length(Fsamp));
    MATPF=MATOB; MATHP=MATOB;
    
    % compute
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        clear temp SpBO SpPFCx fOB fPF SpHP fHP chHPC
        clear WAKE REM N1 N2 N3 NamesStages
        try
            % Substages
            disp('- RunSubstages.m')
            [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;
            close
        end
        if exist('WAKE','var')
            try
                % Bulb_deep
                disp('- ChannelsToAnalyse/Bulb_deep')
                temp=load('ChannelsToAnalyse/Bulb_deep.mat');
                disp(sprintf('   ... Loading Spectrum%d.mat',temp.channel))
                eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',temp.channel));
                SpBO=tsd(t*1E4,Sp);fOB=f;
                
                % PFCx_deep
                disp('- ChannelsToAnalyse/PFCx_deep')
                temp=load('ChannelsToAnalyse/PFCx_deep.mat');
                disp(sprintf('   ... Loading Spectrum%d.mat',temp.channel))
                eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',temp.channel));
                SpPFCx=tsd(t*1E4,Sp); fPF=f;
                
                %dHPC
                disp('- ChannelsToAnalyse/dHPC_rip')
                try
                    temp=load('AllRipplesdHPC25.mat','chHPC');
                    disp(sprintf('   ... Loading Spectrum%d.mat',temp.chHPC))
                    eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',temp.chHPC));
                    SpHP=tsd(t*1E4,Sp); fHP=f; 
                end
                % spectrum for each stages
                for n=1:5
                    clear epoch
                    eval(['epoch=',NamesStages{n},';'])
                    %OB
                    tempB=nanmean(Data(Restrict(SpBO,epoch)));
                    MATOB(man,n,:)=interp1(fOB,tempB,Fsamp);
                    %PFCx
                    tempF=nanmean(Data(Restrict(SpPFCx,epoch)));
                    MATPF(man,n,:)=interp1(fPF,tempF,Fsamp); 
                    %dHPC
                    try
                        tempH=nanmean(Data(Restrict(SpHP,epoch)));
                        MATHP(man,n,:)=interp1(fHP,tempH,Fsamp);
                    end
                    
                    if plotIndiv
                        figure(numF(1)),subplot(4,ceil(length(Dir.path)/4),man)
                        hold on, plot(fOB,tempB,'Color',colori(n,:),'Linewidth',2)
                        title(['OB ',Dir.name{man}])
                        figure(numF(2)),subplot(4,ceil(length(Dir.path)/4),man)
                        hold on, plot(fPF,tempF,'Color',colori(n,:),'Linewidth',2)
                        title(['PF ',Dir.name{man}])
                    end
                end
                %save([res,'/',nameAnaly],'-append','MATOB','MATPF','MATHP')
                
                
            catch
                disp('Problem'); %keyboard
            end
        end
    end
    
    save([res,'/',nameAnaly],'Fsamp','Dir','colori','params','MATOB','MATPF','MATHP');
end

%% pool mice
NamesStages={'WAKE','REM','N1','N2','N3'};
figure('Color',[1 1 1])
leg=[];
for n=1:5
    MiOB=nan(length(mice),length(Fsamp));
    MiPF=MiOB; MiHP=MiOB;
    for mi=1:length(mice)
        ind=find(strcmp(mice(mi),Dir.name));
        MiPF(mi,:)=10*log10(nanmean(squeeze(MATPF(ind,n,:)),1));
        MiOB(mi,:)=10*log10(nanmean(squeeze(MATOB(ind,n,:)),1));
        MiHP(mi,:)=10*log10(nanmean(squeeze(MATHP(ind,n,:)),1));
    end
    % display PF
    subplot(1,3,1), hold on
    plot(Fsamp,nanmean(MiPF,1),'Color',colori(n,:),'Linewidth',2)
    plot(Fsamp,nanmean(MiPF,1)+nanstd(MiPF)/sqrt(sum(~isnan(nanmean(MiPF,2)))),'Color',colori(n,:))
    plot(Fsamp,nanmean(MiPF,1)-nanstd(MiPF)/sqrt(sum(~isnan(nanmean(MiPF,2)))),'Color',colori(n,:))
    % display OB
    subplot(1,3,2), hold on
    plot(Fsamp,nanmean(MiOB,1),'Color',colori(n,:),'Linewidth',2)
    plot(Fsamp,nanmean(MiOB,1)+nanstd(MiOB)/sqrt(sum(~isnan(nanmean(MiOB,2)))),'Color',colori(n,:))
    plot(Fsamp,nanmean(MiOB,1)-nanstd(MiOB)/sqrt(sum(~isnan(nanmean(MiOB,2)))),'Color',colori(n,:))
    % display HPC
    subplot(1,3,3), hold on
    plot(Fsamp,nanmean(MiHP,1),'Color',colori(n,:),'Linewidth',2)
    plot(Fsamp,nanmean(MiHP,1)+nanstd(MiOB)/sqrt(sum(~isnan(nanmean(MiHP,2)))),'Color',colori(n,:))
    plot(Fsamp,nanmean(MiHP,1)-nanstd(MiOB)/sqrt(sum(~isnan(nanmean(MiHP,2)))),'Color',colori(n,:))
    leg=[leg,{NamesStages{n},'sem',''}];
end
subplot(1,3,1),
title(sprintf('PFCx spectrum (n=%d)',sum(~isnan(nanmean(MiPF,2))))); 
xlabel('Frequency (Hz)'); legend(leg)
subplot(1,3,2), 
title(sprintf('OB spectrum (n=%d)',sum(~isnan(nanmean(MiOB,2))))); 
xlabel('Frequency (Hz)');
subplot(1,3,3), 
title(sprintf('HPC spectrum (n=%d)',sum(~isnan(nanmean(MiHP,2))))); 
xlabel('Frequency (Hz)');

%saveFigure(gcf,'AnalyseNREM_MeanPFSpectrum','/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureNREMstages');
        
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< OB freq depending on stages <<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/meanSpectrumNREMstages';

% <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
MATf=nan(length(Dir.path),10); MATa=MATf;
for man=1:length(Dir.path)
    disp(' '); disp(Dir.path{man})
    cd(Dir.path{man})
    clear temp lfpBO SpBO lfpPFCx SpPFCx
    clear WAKE REM N1 N2 N3 NamesStages
    try
        % Substages
        disp('- RunSubstages.m')
        [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;
        close
        
        % Bulb_deep
        disp('- ChannelsToAnalyse/Bulb_deep')
        temp=load('ChannelsToAnalyse/Bulb_deep.mat');
        disp(sprintf('   ... Loading LFP%d.mat',temp.channel))
        eval(sprintf('load(''LFPData/LFP%d.mat'')',temp.channel));
        lfpBO=LFP;
        
        % PFCx_deep
        disp('- ChannelsToAnalyse/PFCx_deep')
        temp=load('ChannelsToAnalyse/PFCx_deep.mat');
        disp(sprintf('   ... Loading LFP%d.mat',temp.channel))
        eval(sprintf('load(''LFPData/LFP%d.mat'')',temp.channel));
        lfpPFCx=LFP;
        
        
        % Display and Save
        figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.4 0.6]),
        piks=[];leg=[];
        for n=1:5
            clear epoch
            eval(['epoch=',NamesStages{n},';'])
            Mat1=nan(length(Start(epoch)),length(Fsamp));Mat2=Mat1;
            
            for s=1:length(Start(epoch))
                try [S,f,Serr]=mtspectrumc(Data(Restrict(lfpBO,subset(epoch,s))),params);
                    Mat1(s,:)=interp1(f,S,Fsamp)';end
                
                try [S,f,Serr]=mtspectrumc(Data(Restrict(lfpPFCx,subset(epoch,s))),params);
                    Mat2(s,:)=interp1(f,S,Fsamp)';end
                
                try piks=[piks;[n 1 Fsamp(Mat1(s,:)==max(Mat1(s,:)))]; [n 2 Fsamp(Mat2(s,:)==max(Mat2(s,:)))]];end
%                 keyboard
            end
            
            subplot(1,2,1), hold on, plot(Fsamp,SmoothDec(nanmean(Mat1,1),3),'Linewidth',3,'Color',colori(n,:))
            plot(Fsamp,nanmean(Mat1,1)+nanstd(Mat1)/sqrt(length(Start(epoch))),'Color',colori(n,:))
            plot(Fsamp,nanmean(Mat1,1)-nanstd(Mat1)/sqrt(length(Start(epoch))),'Color',colori(n,:))
            title('Spectrum OB'); xlabel('Frequency (Hz)'); ylabel('10log10(amp)')
            subplot(1,2,2), hold on, plot(Fsamp,SmoothDec(nanmean(Mat2,1),3),'Linewidth',3,'Color',colori(n,:))
            plot(Fsamp,nanmean(Mat2,1)+nanstd(Mat2)/sqrt(length(Start(epoch))),'Color',colori(n,:))
            plot(Fsamp,nanmean(Mat2,1)-nanstd(Mat2)/sqrt(length(Start(epoch))),'Color',colori(n,:))
            title('Spectrum PFCx'); xlabel('Frequency (Hz)')
            leg=[leg,{NamesStages{n},' ',' '}];
            
            % fill mat
            MATf(man,n)=Fsamp(SmoothDec(nanmean(Mat1,1),3)==max(SmoothDec(nanmean(Mat1,1),3)));
            MATf(man,5+n)=Fsamp(SmoothDec(nanmean(Mat2,1),3)==max(SmoothDec(nanmean(Mat2,1),3)));
            MATa(man,n)=max(SmoothDec(nanmean(Mat1,1),3));
            MATa(man,5+n)=max(SmoothDec(nanmean(Mat2,1),3));
        end
        legend(leg);
        subplot(1,2,1), text(0,(max(ylim)-min(ylim))*1.07+min(ylim),Dir.path{man})
        saveFigure(gcf,['meanSpectrumNREMStages',num2str(man),'_',Dir.name{man}],FolderToSave)
        if man==2, keyboard;end
        
    catch
        disp('Problem')    
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% >>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>> xCorr >>>>>>>>>>>>>>>>>>>>>><<<<>>>>>

% <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/CrossFreqCoupling/';
nameAnaly='AnalyseCrossCouplingNREMstages';

if ~exist([res,'/',nameAnaly,'.mat'],'file')
    save([res,'/',nameAnaly,'.mat'],'Fsamp','params','Fs','UnitTime','Dir');
end

try
    error;
    load([res,'/',nameAnaly,'.mat'])
    NamesStages={'WAKE','REM','N1','N2','N3'};
    CrossCoup;
catch
    MAT=[];MatS=[];MatInfo=[];
    CrossCoup={};
%
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        clear temp lfpBO SpBO lfpPFCx SpPFCx
        clear WAKE REM N1 N2 N3 NamesStages
        try
            % Substages
            disp('- RunSubstages.m')
            [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;
            close
            
            % Bulb_deep
            disp('- ChannelsToAnalyse/Bulb_deep')
            temp=load('ChannelsToAnalyse/Bulb_deep.mat');
            disp(sprintf('   ... Loading LFP%d.mat',temp.channel))
            eval(sprintf('load(''LFPData/LFP%d.mat'')',temp.channel));
            lfpBO=LFP;
            disp(sprintf('   ... Loading Spectrum%d.mat',temp.channel))
            try
                eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',temp.channel));
            catch
                disp('RUN [params,movingwin]=SpectrumParametersML(''low'');')
                disp('    [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);')
                disp(sprintf('    save(''SpectrumDataL/Spectrum%d.mat'',''Sp'',''t'',''f'',''params'',''movingwin'')',temp.channel));
                keyboard
            end
            SpBO=tsd(t*1E4,Sp); fSp=f;
            
            % PFCx_deep
            disp('- ChannelsToAnalyse/PFCx_deep')
            temp=load('ChannelsToAnalyse/PFCx_deep.mat');
            disp(sprintf('   ... Loading LFP%d.mat',temp.channel))
            eval(sprintf('load(''LFPData/LFP%d.mat'')',temp.channel));
            lfpPFCx=LFP;
            disp(sprintf('   ... Loading Spectrum%d.mat',temp.channel))
            try
                eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',temp.channel));
            catch
                disp('RUN [params,movingwin]=SpectrumParametersML(''low'');')
                disp('    [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);')
                disp(sprintf('    save(''SpectrumDataL/Spectrum%d.mat'',''Sp'',''t'',''f'',''params'',''movingwin'')',temp.channel));
                keyboard
            end
            SpPFCx=tsd(t*1E4,Sp);
            
            % resample spectrum for accordance
            if length(fSp)>length(f)
                disp('WARNING: Resampling SpBO to match frequencies of SpPFCs')
                SpBO=tsd(Range(SpBO),interp1(fSp,Data(SpBO)',f)');
                fSp=f;
            elseif length(fSp)<length(f)
                disp('WARNING: Resampling SpPFCx to match frequencies of SpBO')
                SpPFCx=tsd(Range(SpPFCx),interp1(f,Data(SpPFCx)',fSp)');
                f=fSp;
            end
            
            %
            ArrLFP={lfpBO,lfpPFCx};
            ArrSp={SpBO,SpPFCx};
            for n=1:5
                
                disp(['- Evaluating all ',NamesStages{n},' epochs'])
                clear epoch
                eval(['epoch=',NamesStages{n},';'])
                
                if 0
                    %             figure('Color',[1 1 1]),
                    %             subplot(3,1,1), title('mtspectrumc')
                    %             subplot(3,1,2), title('StatsXcorr')
                    %             subplot(3,1,3), title('spectrum Xcorr')
                    
                    indS=find(Stop(epoch,'s')-Start(epoch,'s')>UnitTime);
                    h=waitbar(0,[NamesStages{n},' epochs']);
                    for s=1:length(indS)
                        sta=[Start(subset(epoch,indS(s)),'s'),Stop(subset(epoch,indS(s)),'s')];
                        sta=sta(1):UnitTime:sta(2);
                        s_epoch=intervalSet(sta(1:end-1)*1E4,sta(2:end)*1E4);
                        
                        for l=1:2
                            tempMat=nan(length(Start(s_epoch)),9);
                            tempMatS=nan(length(Start(s_epoch)),length(Fsamp));
                            
                            for se=1:length(Start(s_epoch))
                                x=Data(Restrict(ArrLFP{l},subset(s_epoch,se)))';
                                % ATTENTION
                                % pas trop de raison de refaire mtspectrumc
                                % plutot que de restrict Sp sur epoch
                                % notamment tapers sont très différent
                                
                                [S,f]=mtspectrumc(x,params);
                                %                             subplot(3,1,1),hold on, plot(f,S)
                                %                             plot(fSp,mean(Data(Restrict(ArrSp{l},subset(s_epoch,se))),1),'r')
                                %
                                [C,lag,Ptt,CPM,CPm] = StatsXcorr(x,x,Fs,50);
                                %                             subplot(3,1,2),hold on, plot(lag/Fs,C);xlim([-3 3])
                                %                             hold on, plot(lag/Fs, CPM,'r')
                                %                             hold on, plot(lag/Fs, CPm,'r')
                                
                                [Sc,fc]=mtspectrumc(C(lag>0),params);
                                Sc=Sc(fc>1); fc=fc(fc>1);
                                %                             subplot(3,1,3),hold on, plot(fc,Sc)
                                v1=fc(Sc==max(Sc));
                                v2=abs(f-fc(Sc==max(Sc))); v3=S(find(v2==min(v2)));
                                v2=diff(find(Sc-max(Sc)/2>0));v2(v2==1)=[];
                                
                                MaxEp=thresholdIntervals(tsd(fc,Sc),max(Sc)/2,'Direction','Above');
                                sta=[Start(MaxEp),Stop(MaxEp)];
                                v2=v1-sta(:,1); v2=diff(sta(find(v2==min(v2(v2>=0))),:));
                                
                                tempMat(se,:)=[man n l s Start(subset(s_epoch,se),'s'),...% #expe stage Structure #epoch Start(Epoch)
                                    v1 v3 v2 size(sta,1)];% peak by autocorr, Sp val at peak, wide, degree of noise
                                tempMatS(se,:)=interp1(f,S,Fsamp);
                                
                                keyboard
                            end
                            MAT=[MAT;tempMat];
                            MatInfo=[MatInfo;ones(length(Start(s_epoch)),1)*[man n l s]];
                            MatS=[MatS;tempMatS];
                            
                        end
                        waitbar(s/length(indS),h);
                    end
                    close(h)
                    %keyboard
                    save([res,'/AnalyseAutoCorrNREMstages.mat'],'-append','MatInfo','MAT','MatS');
                    disp('Done')
                end
                
                % <<<<<<<<<<<<<< CrossFreqCoupling <<<<<<<<<<<<<
                [r,p]=CrossFreqCoupling(Data(SpBO),Range(SpBO,'s'),fSp,Data(SpPFCx),Range(SpPFCx,'s'),fSp,epoch);
                CrossCoup{man,n}=r;
                CrossCoup{man,n+5}=p;
                if plotCrossFreqCoupling
                    set(gcf,'Unit','Normalized','Position',[0.3 0.15 0.3 0.7])
                    subplot(2,2,1); xlabel('OB Spectrum'); ylabel('PFCx Spectrum'); text(0,23,[NamesStages{n},'   ',pwd])
                    subplot(2,2,2); xlabel('PFCx Spectrum'); ylabel('PFCx Spectrum');text(0,-3,'mean spectrograms: k=raw, w=10log10')
                    subplot(2,2,3); xlabel('OB Spectrum'); ylabel('OB Spectrum');
                    subplot(2,2,4); xlabel('PFCx Spectrum'); ylabel('PFCx Spectrum');
                    saveFigure(gcf,['CrossFreqCoupling',NamesStages{n},'_',num2str(man),'_',Dir.name{man}],FolderToSave)
                end
                %keyboard
                save([res,'/AnalyseAutoCorrNREMstages.mat'],'-append','CrossCoup');
            end
        catch
            disp('Problem')    ; if ~strcmp(Dir.name{man},'Mouse161'),keyboard;end
        end
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<< display mean CrossFreqCoupling matrices <<<<<<<<<<<<<<<

FrqBands=[2,4;6,8;12,14];
for n=1:5, 
    for fi=1:size(FrqBands,1)
        SpMat1{n,fi}=nan(length(Dir.path),261); % specific frequency of OB
        SpMat2{n,fi}=nan(length(Dir.path),261);  % specific frequency of PFCx
    end
end
figure('Color',[1 1 1],'Unit','normalized','Position',[0.12 0.34 0.45 0.6]), F1=gcf;
figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.35 0.8]), F2=gcf;
for n=1:5
    temp=zeros(522,522);a=0;
    for man=1:25%length(Dir.path)
        %disp(Dir.path{man})
       
        try
            temp=temp+CrossCoup{man,n}(1:522,1:522);
            a=a+1;
        end
        for fi=1:size(FrqBands,1)
            if ~isempty(CrossCoup{man,n})
                m1=SpMat1{n,fi};
                m2=SpMat2{n,fi};
                ind=find(fSp>=FrqBands(fi,1) & fSp<FrqBands(fi,2));
                m1(man,:)=mean(CrossCoup{man,n}(ind,262:522),1);% PFCx for discrete OBfcy
                m2(man,:)=mean(CrossCoup{man,n}(261+ind,1:261),1);
                SpMat1{n,fi}=m1;
                SpMat2{n,fi}=m2;
            end
        end
    end
    
    % plot CrossFreqCoupling
    figure(F1),subplot(2,3,6-n), imagesc([fSp,2*fSp],[fSp,2*fSp],temp/a); 
    title([NamesStages{n},' CrossFreqCoupling',sprintf(' (n=%d)',a)]), 
    axis xy;caxis([0 1]);colorbar
    set(gca,'Xtick',0:2:40),set(gca,'XtickLabel',[0:2:20,2:2:20]),
    xlabel('Spectrum OB       Spectrum PFCx')
    set(gca,'Ytick',0:2:40),set(gca,'YtickLabel',[0:2:20,2:2:20]),
    ylabel('Spectrum OB        Spectrum PFCx');
    
    % plot
    for fi=1:size(FrqBands,1)
        figure(F2),subplot(3,size(FrqBands,1),fi),hold on, 
        N=sum(~isnan(nanmean(SpMat1{n,fi},2)));
        plot(fSp,nanmean(SpMat1{n,fi},1),'linewidth',2,'Color',colori(n,:))
        plot(fSp,nanmean(SpMat1{n,fi},1)+nanstd(SpMat1{n,fi})/sqrt(N),'Color',colori(n,:))
        plot(fSp,nanmean(SpMat1{n,fi},1)-nanstd(SpMat1{n,fi})/sqrt(N),'Color',colori(n,:))
        if n==1, xlabel('SpPFCx frequency (hz)'); ylabel(sprintf('at SpBO %d-%dHz',FrqBands(fi,1),FrqBands(fi,2)));end
        
        subplot(3,size(FrqBands,1),size(FrqBands,1)+fi),hold on, 
        N=sum(~isnan(nanmean(SpMat2{n,fi},2)));
        plot(fSp,nanmean(SpMat2{n,fi},1),'linewidth',2,'Color',colori(n,:))
        plot(fSp,nanmean(SpMat2{n,fi},1)+nanstd(SpMat2{n,fi})/sqrt(N),'Color',colori(n,:))
        plot(fSp,nanmean(SpMat2{n,fi},1)-nanstd(SpMat2{n,fi})/sqrt(N),'Color',colori(n,:))
        if n==1, xlabel('SpBO frequency (hz)'); ylabel(sprintf('at SpPFCx %d-%dHz',FrqBands(fi,1),FrqBands(fi,2)));end
        
        if fi==1,
        	leg{n}=[NamesStages{n},sprintf(' (n=%d)',N)];
            subplot(3,size(FrqBands,1),2*size(FrqBands,1)+fi),hold on, 
            plot(fSp,nanmean(SpMat1{n,fi},1),'linewidth',2,'Color',colori(n,:))
        end
    end
end
subplot(3,size(FrqBands,1),2*size(FrqBands,1)+1),legend(leg)



%% display individual median spectrum for OB and PFCx

if 1
    for man=1:length(Dir.path)
        leg=[];
        figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.4 0.6]),
        for n=1:5
            ind=find(MatInfo(:,1)==man & MatInfo(:,2)==n & MatInfo(:,3)==1);
            Mat1=MatS(ind,:);% OB
            Mat2=MatS(MatInfo(:,1)==man & MatInfo(:,2)==n & MatInfo(:,3)==2,:); %PFCx
            
            subplot(1,2,1), hold on, plot(Fsamp,10*log10(nanmedian(Mat1,1)),'Linewidth',3,'Color',colori(n,:))
            plot(Fsamp,10*log10(nanmedian(Mat1,1)+nanstd(Mat1)/sqrt(length(ind))),'Color',colori(n,:))
            plot(Fsamp,10*log10(nanmedian(Mat1,1)-nanstd(Mat1)/sqrt(length(ind))),'Color',colori(n,:))
            title('Spectrum OB'); xlabel('Frequency (Hz)'); ylabel('10log10(amp)')
            
            subplot(1,2,2), hold on, plot(Fsamp,10*log10(nanmedian(Mat2,1)),'Linewidth',3,'Color',colori(n,:))
            plot(Fsamp,10*log10(nanmedian(Mat2,1)+nanstd(Mat2)/sqrt(length(ind))),'Color',colori(n,:))
            plot(Fsamp,10*log10(nanmedian(Mat2,1)-nanstd(Mat2)/sqrt(length(ind))),'Color',colori(n,:))
            title('Spectrum PFCx'); xlabel('Frequency (Hz)')
            leg=[leg,{NamesStages{n},['(n=',num2str(length(ind)),')'],' '}];
        end
        legend(leg);
        subplot(1,2,1), text(0,(max(ylim)-min(ylim))*1.07+min(ylim),Dir.path{man})
    end
end


%% display individual mean spectrum for OB and PFCx, matrix with all single episods
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages';
if 1
    for man=1:length(Dir.path)
        C1=[]; C2=[];
        figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.4 0.6]),
        for n=1:5
            
            ind=find(MatInfo(:,1)==man & MatInfo(:,2)==n & MatInfo(:,3)==1);
            Mat1=MatS(ind,:);% OB
            Mat2=MatS(MatInfo(:,1)==man & MatInfo(:,2)==n & MatInfo(:,3)==2,:); %PFCx
            
            subplot(2,5,n), hold on, 
            imagesc(Fsamp,1:size(Mat1,1),10*log10(Mat1)); C1=[C1,caxis]; xlim([0 10]); ylim([0 200])
            title(['OB ',NamesStages{n}]); ylabel(['# ',NamesStages{n},' episod']);
            
            subplot(2,5,5+n), hold on, 
            imagesc(Fsamp,1:size(Mat2,1),10*log10(Mat2)); C2=[C2,caxis]; xlim([0 10]); ylim([0 200])
            title(['PFCx ',NamesStages{n}]); ylabel(['# ',NamesStages{n},' episod']); xlabel('Frequency (Hz)')
        end
        subplot(2,5,6), text(0,(max(ylim)-min(ylim))*1.2+min(ylim),Dir.path{man})
        for n=1:5
            subplot(2,5,n), caxis([min(C1) max(C1)]);
            subplot(2,5,5+n), caxis([min(C2) max(C2)]);
        end
        
    
        saveFigure(gcf,['NREMmatriceSpectrum',num2str(man),'_',Dir.name{man}],FolderToSave);
        disp('Done')
        
    end
end

%% display 
% MAT:
% #expe, stage, Structure, #episod, Start(Epoch), peak by autocorr, Sp val at peak, wide, degree of noise
opt='Criterion'; % default ='';
if strcmp(opt,'Criterion')
    MAT(:,9)=zscore(MAT(:,6),0,1)-zscore(MAT(:,7),0,1);
else
    MAT(:,9)=ones(size(MAT,1),1);
end
 
 if 1
     numMice=unique(Dir.name);
     C1=nan(length(Dir.path),length(Fsamp(1:3:end))+1); C2=C1;
     
     figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.4 0.8]),
     for n=1:5
         for man=1:length(Dir.path)
             
             ind=find(MAT(:,1)==man & MAT(:,2)==n & MAT(:,3)==1 & MAT(:,8)< 3 & MAT(:,9)>0);
             Mat1=MAT(ind,:);% OB
             Mat2=MAT(MAT(:,1)==man & MAT(:,2)==n & MAT(:,3)==2 & MAT(:,8)< 3 & MAT(:,9)>0, :); %PFCx
             
             i=find(strcmp(Dir.name{man},numMice));
             C1(man,:)=[i,hist(Mat1(:,5),Fsamp(1:3:end))];
             C2(man,:)=[i,hist(Mat2(:,5),Fsamp(1:3:end))];
             
         end
         C1=sortrows(C1,1);
         C2=sortrows(C2,1);
         ind=find(diff(C1(:,1))~=0);
         
         subplot(2,5,n), hold on,
         imagesc(Fsamp(1:3:end),1:length(Dir.path),C1(:,2:end));
         xlabel('Freq OB');
         title(NamesStages{n}), xlim([0 10]), ylim([0 length(Dir.path)+1])
         
         for i=1:length(ind)
             line([0 10],[0 0]+ind(i)+0.5,'Color',[0.5 0.5 0.5])
         end
         set(gca,'Ytick',[1;ind+1.5])
         if n==1, set(gca,'YtickLabel',numMice);else,set(gca,'YtickLabel','');end
         
         
         subplot(2,5,5+n), hold on,
         imagesc(Fsamp(1:3:end),1:length(Dir.path),C2(:,2:end));
         xlabel('Freq PFCx');
         title(NamesStages{n}), xlim([0 10]), ylim([0 length(Dir.path)+1])
         
         for i=1:length(ind)
             line([0 10],[0 0]+ind(i)+0.5,'Color',[0.5 0.5 0.5])
         end
         set(gca,'Ytick',[1;ind+1.5])
         if n==1, set(gca,'YtickLabel',numMice); else,set(gca,'YtickLabel',''); end
     end
     
      saveFigure(gcf,['NREMdistributionPeaksAutocorr',opt],FolderToSave);
        
 end
 
               