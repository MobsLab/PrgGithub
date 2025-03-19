% FiguresDataCulb8juin2015




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%% Get all Data sleep Basal %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir1=PathForExperimentsBULB('SLEEPBasal');
Dir1=RestrictPathForExperiment(Dir1,'Group','CTRL');
Dir2=PathForExperimentsML('BASAL');%'BASAL','PLETHYSMO','DPCPX', 'LPS', 'CANAB';
Dir2=RestrictPathForExperiment(Dir2,'Group',{'WT','C57'});
Dir=MergePathForExperiment(Dir1,Dir2);

strains=unique(Dir.group);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%% compare Sp Gamma BULB for all mice %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
savFig=0;
%FileToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlowBulb/GammaBulbSleepML/AnalyseCompareGamma';
FileToSave='/media/DataMOBsRAID/ProjetAstro/GammaBulbSleepML/AnalyseCompareGamma';
clear MatSpHW MatSpHS MatSpHR MatSpLW MatSpLS MatSpLR MatEpochs MatInfo
% Spectrum Params
[paramsL,movingwinL]=SpectrumParametersML('low',0);
FL=paramsL.fpass(1):diff(paramsL.fpass)/200:paramsL.fpass(2);
[paramsH,movingwinH]=SpectrumParametersML('high',0);
FH=paramsH.fpass(1):diff(paramsH.fpass)/200:paramsH.fpass(2);

try
    load(FileToSave);
    MatSpHW;
    disp('Loading existing data, Dir has been reloaded')
catch
    MatEpochs={};
    MatInfo=[];
    MatSpHW=nan(length(Dir.path),length(FH));
    MatSpHS=MatSpHW; MatSpHR=MatSpHW;
    MatSpLW=nan(length(Dir.path),length(FL));
    MatSpLS=MatSpHW; MatSpLR=MatSpHW;
end

for man=1:length(Dir.path)
    
        disp('  ')
        disp([Dir.group{man},' ',Dir.path{man}])
    if sum(isnan(MatSpLW(man,:)))==length(FL);
       
        % save InfoGroup = [group strains, nb mouse]
        MatInfo(man,1)=find(strcmp(strains,Dir.group{man}));
        MatInfo(man,2)=str2double(Dir.name{man}(strfind(Dir.name{man},'Mouse')+5:end));
                 
        % -----------------------------------------------------------------
        % --------------------------  load epochs  ------------------------
        try
            disp('...Loading epochs')
            clear MovEpoch Wake REMEpoch SWSEpoch GndNoiseEpoch WeirdNoiseEpoch NoiseEpoch TotalNoiseEpoch
            try
                eval(['load(''',Dir.path{man},'/StateEpoch.mat'',''REMEpoch'',''SWSEpoch'',',...
                    '''MovEpoch'',''NoiseEpoch'',''GndNoiseEpoch'',''WeirdNoiseEpoch'');'])
                Wake=MovEpoch;
            catch
                eval(['load(''',Dir.path{man},'/StateEpochSB.mat'',''REMEpoch'',''SWSEpoch'',',...
                    '''Wake'',''NoiseEpoch'',''GndNoiseEpoch'',''WeirdNoiseEpoch'');'])
            end
            TotalNoiseEpoch=and(GndNoiseEpoch,NoiseEpoch);
            if exist('WeirdNoiseEpoch','var'), TotalNoiseEpoch=and(TotalNoiseEpoch,WeirdNoiseEpoch);end
            
            MatEpochs{man,1}=Wake-TotalNoiseEpoch;
            MatEpochs{man,2}=SWSEpoch-TotalNoiseEpoch;
            MatEpochs{man,3}=REMEpoch-TotalNoiseEpoch;
        catch
            disp('Problem loading epochs')
            keyboard
        end
        
        % -----------------------------------------------------------------
        % ----------------------  compute Low Spec  -----------------------
        try
            disp('... Spectrum Low frequency')
            clear channel LFP Sp t f
            
            % get bulb channel
            eval(['load(''',Dir.path{man},'/ChannelsToAnalyse/Bulb_deep.mat'',''channel'');'])
            try
                % load spectrum if exists
                disp(['        Loading SpectrumDataL/Spectrum',num2str(channel),'.mat'])
                eval(['load(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(channel),'.mat'');'])
                Sp; t; f;
            catch
                % loaad LFP
                disp('        Not found. Creating')
                disp(['        Loading LFPData/LFP',num2str(channel),'.mat'])
                eval(['load(''',Dir.path{man},'/LFPData/LFP',num2str(channel),'.mat'');'])
                
                % compute spectrum
                disp('        Computing mtspectrum')
                [Sp,t,f]=mtspecgramc(Data(LFP),movingwinL,paramsL);
                
                % saving
                disp('        Saving in SpectrumDataL')
                movingwin=movingwinL;
                params=paramsL;
                fileSp=[Dir.path{man},'/SpectrumDataL'];
                if ~exist([fileSp,'dir']), mkdir(fileSp);end
                eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(channel),'.mat''',...
                    ',''-v7.3'',''Sp'',''t'',''f'',''params'',''movingwin'');']);
            end
            fL=f;
            SpL=tsd(t*1E4,Sp);
            
            % --------  Restrict on epochs  ---------
            MatSpLW(man,:)=interp1(fL,mean(Data(Restrict(SpL,MatEpochs{man,1})),1),FL);
            MatSpLS(man,:)=interp1(fL,mean(Data(Restrict(SpL,MatEpochs{man,2})),1),FL);
            MatSpLR(man,:)=interp1(fL,mean(Data(Restrict(SpL,MatEpochs{man,3})),1),FL);
             
        catch
            disp('Problem computing Low Spec')
            keyboard
        end
        
        % -----------------------------------------------------------------
        % ---------------------  compute High Spec  -----------------------
        try
            disp('... Spectrum High frequency')
            clear Sp t f
            
            try
                % load spectrum if exists
                disp(['        Loading SpectrumDataH/Spectrum',num2str(channel),'.mat'])
                eval(['load(''',Dir.path{man},'/SpectrumDataH/Spectrum',num2str(channel),'.mat'');'])
                Sp; t; f;
            catch
                % load LFP
                disp('        Not found. Creating')
                if ~exist('LFP','var')
                    disp(['        Loading LFPData/LFP',num2str(channel),'.mat'])
                    eval(['load(''',Dir.path{man},'/LFPData/LFP',num2str(channel),'.mat'');'])
                end
                % compute spectrum
                disp('        Computing mtspectrum')
                [Sp,t,f]=mtspecgramc(Data(LFP),movingwinH,paramsH);
                
                % saving
                disp('        Saving in SpectrumDataH')
                movingwin=movingwinH;
                params=paramsH;
                fileSp=[Dir.path{man},'/SpectrumDataH'];
                if ~exist([fileSp,'dir']), mkdir(fileSp);end
                eval(['save(''',Dir.path{man},'/SpectrumDataH/Spectrum',num2str(channel),'.mat''',...
                    ',''-v7.3'',''Sp'',''t'',''f'',''params'',''movingwin'');']);
            end
            fH=f;
            SpH=tsd(t*1E4,Sp);
            
            % --------  Restrict on epochs  ---------
             
            MatSpHW(man,:)=interp1(fH,mean(Data(Restrict(SpH,MatEpochs{man,1})),1),FH);
            MatSpHS(man,:)=interp1(fH,mean(Data(Restrict(SpH,MatEpochs{man,2})),1),FH);
            MatSpHR(man,:)=interp1(fH,mean(Data(Restrict(SpH,MatEpochs{man,3})),1),FH);
            
        catch
            disp('Problem computing High Spec')
            keyboard
        end
        
            % --------  temporary saving  ---------
            %if man<length(Dir.path) && ~strcmp(Dir.name{man},Dir.name{man+1})
                %disp(' -----')
                %disp(['...saving all spec from Mouse',num2str(MatInfo(man,2)),' in ', FileToSave])
                disp('saving...')
                save(FileToSave,'MatSpHW','MatSpHS','MatSpHR','MatSpLW','MatSpLS','MatSpLR','MatEpochs','MatInfo','FL','FH','Dir');
            %end
    else
        disp('Defined already for this expe. skip...')
    end
end
save(FileToSave,'MatSpHW','MatSpHS','MatSpHR','MatSpLW','MatSpLS','MatSpLR','MatEpochs','MatInfo','FL','FH','Dir');

%% ------------------ pool same mice -----------
nameEpochs={'Wake','SWSEpoch','REMEpoch'};
mice=unique(MatInfo(:,2));
mice([find(mice==147),find(mice==148),find(mice==161)])=[];

MATHW=nan(length(mice),length(FH)); MATHS=MATHW;MATHR=MATHW;
MATLW=nan(length(mice),length(FL)); MATLS=MATLW;MATLR=MATLW;
figure('Color',[1 1 1])
colori=colormap('jet');
for nn=1:length(nameEpochs)
    for mi=1:length(mice)
        index=find(MatInfo(:,2)==mice(mi));
        MATHW(mi,:)=nanmean(MatSpHW(index,:)); 
        
        %colori=[min(1,2-2.3*(mi-1)/length(mice))/1.1 min(1,2.3*mi/length(mice))/1.1 0];
        subplot(2,3,1), hold on, 
        plot(FH,10*log10(FH.*nanmean(MatSpHW(index,:))),'Color',colori(floor(64*mi/length(mice)),:)) 
        title('WAKE  - High frequency mean spectrum'); ylabel('Amplitude'), ylim([35 70])
        
        MATHS(mi,:)=nanmean(MatSpHS(index,:));
        subplot(2,3,2), hold on, 
        plot(FH,10*log10(FH.*nanmean(MatSpHS(index,:))),'Color',colori(floor(64*mi/length(mice)),:)) 
        title('SWS  - High frequency mean spectrum'), ylim([35 70])
        
        MATHR(mi,:)=nanmean(MatSpHR(index,:));
        subplot(2,3,3), hold on, 
        plot(FH,10*log10(FH.*nanmean(MatSpHR(index,:))),'Color',colori(floor(64*mi/length(mice)),:)) 
        title('REM  - High frequency mean spectrum'), ylim([35 70])
        
        MATLW(mi,:)=nanmean(MatSpLW(index,:));
        subplot(2,3,4), hold on, 
        plot(FL,10*log10(nanmean(MatSpLW(index,:))),'Color',colori(floor(64*mi/length(mice)),:)) 
        title('WAKE  - Low frequency mean spectrum'); ylabel('Amplitude'), ylim([30 70])
        
        MATLS(mi,:)=nanmean(MatSpLS(index,:));
        subplot(2,3,5), hold on, 
        plot(FL,10*log10(nanmean(MatSpLS(index,:))),'Color',colori(floor(64*mi/length(mice)),:))  
        title('SWS  - Low frequency mean spectrum'); xlabel('Frequency (Hz)'), ylim([30 70])
        
        MATLR(mi,:)=nanmean(MatSpLR(index,:));
        subplot(2,3,6), hold on, 
        plot(FL,10*log10(nanmean(MatSpLR(index,:))),'Color',colori(floor(64*mi/length(mice)),:)) 
        title('REM  - Low frequency mean spectrum'), ylim([30 70])
        
        % Wakefulness - Sommeil
%         
%         Lsws=0; Lrem=0;
%         for man=1:length(index)
%             Lsws=Lsws+tot_length(MatEpochs{index(man),2},'s');
%             Lrem=Lrem+tot_length(MatEpochs{index(man),3},'s');
%         end
        
    end
end
legend(num2str(mice))

if savFig
   saveFigure(gcf,'MeanOBspecHandL_allmice','/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlowBulb/GammaBulbSleepML')
end

%%
figure('Color',[1 1 1]), hold on, 
plot(FH,10*log10(FH.*nanmean(MATHW)),'b','Linewidth',2)
plot(FH,10*log10(FH.*nanmean(MATHS)),'r','Linewidth',2) 
plot(FH,10*log10(FH.*nanmean(MATHR)),'g','Linewidth',2) 
legend({'Wake','SWS','REM'})
plot(FH,10*log10(FH.*nanmean(MATHW)+FH.*stdError(MATHW)),'b')
plot(FH,10*log10(FH.*nanmean(MATHW)-FH.*stdError(MATHW)),'b')
plot(FH,10*log10(FH.*nanmean(MATHS)+FH.*stdError(MATHS)),'r')
plot(FH,10*log10(FH.*nanmean(MATHS)-FH.*stdError(MATHS)),'r')
plot(FH,10*log10(FH.*nanmean(MATHR)+FH.*stdError(MATHR)),'g')
plot(FH,10*log10(FH.*nanmean(MATHR)-FH.*stdError(MATHR)),'g')
xlabel('Frequency(Hz)'); ylabel('FT Amplitude')
title(['n = ',num2str(length(mice)),', High spectrum of Bulb_deep (FiguresDataClub8juin2015.m)'])
if savFig
    saveFigure(gcf,'MeanOBspecH_avStd','/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlowBulb/GammaBulbSleepML')
    saveFigure(gcf,'MeanOBspecH_avStd','/home/vador/Dropbox/MOBsPrjetBULB/FiguresDataClub_8juin2015')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % Find representative example of Gamma by Respi depending on SWS/Wake %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd /media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse241-newwifi/20150228/RESPI-Mouse-241-28022015
load('ChannelsToAnalyse/Bulb_deep.mat','channel')
load(['LFPData/LFP',num2str(channel),'.mat'])
load('Respiration.mat','NormRespiTSD');
FilRespi=NormRespiTSD;
FilBO=FilterLFP(LFP,[1 10],1024);
lfpBO=LFP;
FilGamBO=FilterLFP(LFP,[30 90],96);

load StateEpoch REMEpoch SWSEpoch MovEpoch Mmov NoiseEpoch
epoch=intervalSet([0 340]*1E4,[315 1830]*1E4);
FilRespi=Restrict(FilRespi,epoch);
lfpBO=Restrict(lfpBO,epoch);
FilBO=Restrict(FilBO,epoch);
FilGamBO=Restrict(FilGamBO,epoch);

figure('Color',[1 1 1]),
plot(Range(FilRespi,'s'),rescale(-Data(FilRespi),1,2),'Color',[0.5 0.5 0.5])
hold on, plot(Range(lfpBO,'s'),rescale(Data(lfpBO),0.3,1.3),'k')
hold on, plot(Range(FilGamBO,'s'),rescale(Data(FilGamBO),0,0.5),'k')
hold on, plot(Range(Mmov,'s'),rescale(Data(Mmov),-0.5,0),'b')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % Find representative example of Low freq spectrum in OB %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /media/DataMOBsRAID/ProjetAstro/Mouse160/20141219/BULB-Mouse-160-19122014

load('ChannelsToAnalyse/Bulb_deep.mat','channel')
load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
load('StateEpoch.mat','SWSEpoch','REMEpoch','Mmov')

load('LFPData/InfoLFP.mat','InfoLFP');
emg=InfoLFP.channel(strcmp(InfoLFP.structure,'EMG'));
emgtemp=load(['LFPData/LFP',num2str(emg),'.mat']);
EMG=Restrict(emgtemp.LFP,ts(Range(Mmov))); % downsampling

sta=Start(SWSEpoch,'s');
sto=Stop(SWSEpoch,'s');

figure('Color',[1 1 1]),
imagesc(t,f,10*log10(Sp')); axis xy
%hold on, plot(Range(Mmov,'s'),rescale(Data(Mmov),10,20),'k')
hold on, plot(Range(EMG,'s'),rescale(Data(EMG),10,12),'k')
for st=1:length(sta), line([sta(st) sta(st)],[0 20],'Color','r');end
for st=1:length(sto), line([sto(st) sto(st)],[0 20],'Color','k');end
title(pwd); xl=xlim;

[tEpoch, SpEpoch]=SpectroEpochML(Sp,t,f,or(SWSEpoch,REMEpoch));
figure('Color',[1 1 1]),
imagesc(tEpoch,f,10*log10(SpEpoch')); axis xy
title(['SWS -',pwd]); xlim(xl)

figure('Color',[1 1 1]),
imagesc(t,f,10*log10(Sp')); axis xy
hold on, plot(Range(EMG,'s'),rescale(Data(EMG),10,12),'k','Linewidth',2)
title(['SWS boot -',pwd]); xlim([14235 15077]); ylim([0 12])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % Find representative example of High freq spectrum in OB / EMG %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013
load('B_High_Spectrum.mat')

Sp=Spectro{1};
t=Spectro{2};
f=Spectro{3};
load('StateEpoch.mat','Mmov')

figure('Color',[1 1 1]),
subplot(3,1,1:2)
imagesc(t,f,10*log10(Sp')); axis xy; 
ylim([30 100]), xlim([0 7000]);caxis([5 50])
title(pwd); ylabel('Frequency (Hz)');

subplot(3,1,3)
plot(Range(Mmov,'s'),Data(Mmov),'k'); xlim([0 7000])
title('Movement'); xlabel('Time (s)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % plot  bars quantif sophie %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vals=[92 8*59/100 8*41/100;89 11*75/100 11*25/100];
figure('Color',[1 1 1]),
bar(vals,'stacked')
legend({'Commun scoring','Trasitions period or microperiod','other'},'Location','EastOutside')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % find PFCx neurons modulated by PFCx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /home/mobsyoda/Dropbox/Gaetan PhD/DeltaProjetFIgures/last/20150223/Mouse244/SpikeModulationBulb/

load('KappaValues_SWS.mat')
pval=0.05; ind=find(pvalAll<pval);
figure('Color',[1 1 1]),
plot(log10(pvalAll),KappaAll,'.k')
hold on, plot(log10(pvalAll(ind)),KappaAll(ind),'.r')
% numbers
disp([num2str(100*length(ind)/length(pvalAll)),'% of PFCx neurons are modulated by OB']) 
disp(['Kappa value: ',num2str(100*mean(KappaAll(ind))),'%, +/-',num2str(100*std(KappaAll(ind))),'%'])

figure('Color',[1 1 1]), boxplot(100*KappaAll(ind))
hold on,plot(ones(1,length(ind)),100*KappaAll(ind),'ok')
title(pwd), xlabel('SWS - PFCx neurons modulated by Bulb')
ylabel('Kappa value (%)')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % find PFCx neurons modulated by PFCx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC
%/media/DataMOBsRAID/ProjetAstro/Mouse241/20150418/EXTenvB/BULB-Mouse-241-18042015
load('StateEpochSB.mat','smooth_ghi')
load('StateEpoch.mat','Mmov')
%%
FreezeEpoch=thresholdIntervals(Mmov,2,'Direction','Below');
FreezeEpoch=mergeCloseIntervals(FreezeEpoch,1*1E4);
FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1E4);

% load('B_High_Spectrum.mat')
% Sp=Spectro{1};
% t=Spectro{2};
% f=Spectro{3};


figure('Color',[1 1 1]), 
subplot(2,1,1),plot(Range(smooth_ghi,'s'),SmoothDec(Data(smooth_ghi),300),'k'); 
title('smooth_ghi from StateEpochSB.mat')
xlabel('Time (s)'); xlim([0 1400]); ylim([0 500])

subplot(2,1,2),plot(Range(Mmov,'s'),Data(Mmov),'k'); 
title('Mmov from StateEpoch.mat')
xlabel(pwd); xlim([0 1400])

sta=Start(FreezeEpoch,'s'); sto=Stop(FreezeEpoch,'s'); 
hold on, 
for st=1:length(sta) 
    line([sta(st) sto(st)],[30 30],'Linewidth',3,'Color','b');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % find PFCx neurons modulated by PFCx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ParcoursCompVariousEpoch
namexlab={'S12 Rip vs Spindles','S34 Rip vs Spindles','S12 Rip vs Spind zoom','S34 Rip vs Spind zoom','S12 Rip vs DeltaPaCx','S34 Rip vs DeltaPaCx','S12 Rip vs DeltaPFCx','S34 Rip vs DeltaPFCx'};
figure('color',[1 1 1]),
for k=1:8
    
    if k>2&k<5
        tps=tps2;
    else
        tps=tps1;
    end
    subplot(4,2,k), hold on,
    plot(tps,mean(CrWT1z{k}),'k','linewidth',2)
    plot(tps,mean(CrWT1z{k})+stdError(CrWT1z{k}),'k')
    plot(tps,mean(CrWT1z{k})-stdError(CrWT1z{k}),'k');
    title(namexlab{k})
    ylabel(['n = ',num2str(size(CrWT1z{k},1)),' expe'])
    xlim([tps(1) tps(end)]), yl=ylim; line([0 0],yl,'color','b')
end
