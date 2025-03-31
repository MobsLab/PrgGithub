
clear all

LineHeight = 9.5;
Colors.N1 = [.8 .5 .2];
Colors.N2 = [1 0 0];
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = 'k';

smootime = 10;

%%
cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241130_LSP/')
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'Sleep', 'SmoothTheta', 'SmoothGamma')

REMEpoch = mergeCloseIntervals(REMEpoch,60e4);
REMEpoch = dropShortIntervals(REMEpoch,35e4);

load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP = tsd(Range(LFP) , Data(LFP));
Fil_Delta = FilterLFP(LFP,[.5 4],1024);
tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
SmoothDelta_OB  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));

figure
gamma_thresh = GetGaussianThresh_BM(log10(Data(Restrict(SmoothDelta_OB , SWSEpoch))), 0, 1);
makepretty


N2 = thresholdIntervals(SmoothDelta_OB , 10^gamma_thresh , 'Direction' , 'Above');
N2 = mergeCloseIntervals(N2,5e4);
N2 = dropShortIntervals(N2,10e4);
N1 = SWSEpoch-N2;

H = load('H_Low_Spectrum.mat');
H_Sptsd = tsd(H.Spectro{2}*1e4 , H.Spectro{1});

B = load('B_Low_Spectrum.mat');
B_Sptsd = tsd(B.Spectro{2}*1e4 , B.Spectro{1});


%% pharmacological confirmation
figure
subplot(6,1,1:2)
imagesc(Range(H_Sptsd)/3.6e7 , H.Spectro{3} , runmean(runmean(log10(Data(H_Sptsd)'),5)',50)'), axis xy
ylabel('HPC frequency (Hz)'), ylim([0 10]), caxis([3.5 5]), xticklabels({''}), makepretty
colormap viridis

PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
PlotPerAsLine(N1,LineHeight,Colors.N1,'timescaling',3.6e7);
PlotPerAsLine(N2,LineHeight,Colors.N2,'timescaling',3.6e7);

subplot(613)
plot(Range(SmoothTheta,'s')/3.6e3 , runmean(Data(SmoothTheta),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothTheta,'s')/3.6e3)]), ylim([0 12]), xticklabels({''}), ylabel('Theta/Delta')
makepretty
vline(2,'--r'), text(2.1,12,'Atropine injection','FontSize',15,'Color','r')


subplot(6,1,4:5)
imagesc(Range(B_Sptsd)/3.6e7 , B.Spectro{3} , runmean(runmean(log10(Data(B_Sptsd)'),5)',50)'), axis xy
ylabel('OB frequency (Hz)'), ylim([0 10]), caxis([3.5 5]), makepretty

PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
PlotPerAsLine(N1,LineHeight,Colors.N1,'timescaling',3.6e7);
PlotPerAsLine(N2,LineHeight,Colors.N2,'timescaling',3.6e7);

subplot(616)
plot(Range(SmoothDelta_OB,'s')/3.6e3 , runmean(Data(SmoothDelta_OB),1e4) , 'k' , 'LineWidth',1)
xlim([0 max(Range(SmoothDelta_OB,'s')/3.6e3)]), ylim([0 1e3])
xlabel('time (hours)'), ylabel('Delta power')
makepretty




%% all
clear all

Dir{1} = PathForExperimentsOB({'Labneh'}, 'freely-moving','atropine');
Dir{2} = PathForExperimentsOB({'Brynza'}, 'freely-moving','atropine');
Dir{3} = PathForExperimentsOB({'Shropshire'}, 'freely-moving','atropine');

% Dir{1} = PathForExperimentsOB({'Shropshire'}, 'freely-moving','saline');
% Dir{2} = PathForExperimentsOB({'Shropshire'}, 'freely-moving', 'atropine');


for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        
        clear inj_time Sleep REMEpoch smooth_01_05 SWSEpoch
        load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'Wake','Sleep','REMEpoch','SWSEpoch','Epoch', 'smooth_01_05', 'inj_time')
        load([Dir{ferret}.path{sess} filesep 'H_Low_Spectrum.mat'])
        H_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
        load([Dir{ferret}.path{sess} filesep 'B_Low_Spectrum.mat'])
        B_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
        
        try
            inj_time;
        catch
            inj_time = max(Range(smooth_01_05))/2;
        end
        
                % epochs
        Before_Injection = intervalSet(inj_time-2.2*3600e4 , -600e4+inj_time);
        After_Injection = intervalSet(inj_time+600e4 , inj_time+2.2*3600e4);
        
        % spectro
        HPC_Sp_Bef_NREM = Restrict(B_Sptsd,and(Before_Injection , SWSEpoch));
        HPC_Sp_Bef_REM = Restrict(B_Sptsd,and(Before_Injection , REMEpoch));
        HPC_Sp_Aft = Restrict(B_Sptsd,and(After_Injection , Sleep));
        OB_Sp_Bef_NREM = Restrict(H_Sptsd,and(Before_Injection , SWSEpoch));
        OB_Sp_Bef_REM = Restrict(H_Sptsd,and(Before_Injection , REMEpoch));
        OB_Sp_Aft = Restrict(H_Sptsd,and(After_Injection , Sleep));
        
        % mean sp
        HPC_MeanSp_Bef_NREM{ferret}(sess,:) = nanmean(Data(HPC_Sp_Bef_NREM));
        HPC_MeanSp_Bef_REM{ferret}(sess,:) = nanmean(Data(HPC_Sp_Bef_REM));
        HPC_MeanSp_Aft{ferret}(sess,:) = nanmean(Data(HPC_Sp_Aft));
        OB_MeanSp_Bef_NREM{ferret}(sess,:) = nanmean(Data(OB_Sp_Bef_NREM));
        OB_MeanSp_Bef_REM{ferret}(sess,:) = nanmean(Data(OB_Sp_Bef_REM));
        OB_MeanSp_Aft{ferret}(sess,:) = nanmean(Data(OB_Sp_Aft));
        
        % states prop
        for states=1:3
            if states==1
                State = Wake;
            elseif states==2
                State = SWSEpoch;
            elseif states==3
                State = REMEpoch;
            end
            if states<2
                State_Prop_Pre{states}{ferret}(sess) = sum(DurationEpoch(and(State , Before_Injection)))./sum(DurationEpoch(Before_Injection));
                State_Prop_Post{states}{ferret}(sess) = sum(DurationEpoch(and(State , After_Injection)))./sum(DurationEpoch(After_Injection));
            else
                State_Prop_Pre{states}{ferret}(sess) = sum(DurationEpoch(and(State , Before_Injection)))./sum(DurationEpoch(and(Before_Injection,Sleep)));
                State_Prop_Post{states}{ferret}(sess) = sum(DurationEpoch(and(State , After_Injection)))./sum(DurationEpoch(and(Before_Injection,Sleep)));
            end
        end
        
        disp([ferret sess])
    end
end

REM_pre_all = []; REM_post_all = []; 
MeanSp_HPC_Bef_NREM_all = []; MeanSp_HPC_Bef_REM_all = []; MeanSp_HPC_Aft_all = [];
MeanSp_OB_Bef_NREM_all = []; MeanSp_OB_Bef_REM_all = []; MeanSp_OB_Aft_all = [];
for ferret=1:3
    REM_pre_all = [REM_pre_all State_Prop_Pre{3}{ferret}];
    REM_post_all = [REM_post_all State_Prop_Post{3}{ferret}];
    
        MeanSp_HPC_Bef_NREM_all = [MeanSp_HPC_Bef_NREM_all ; HPC_MeanSp_Bef_NREM{ferret}(sess,:)];

end
REM_post_all(REM_post_all>.1)=NaN; % waiting to be corrected


Cols = {[.3 .3 .3],[.2 .8 .2]};
X = 1:2;
Legends = {'Pre-atrop','Post-atrop'};

figure
MakeSpreadAndBoxPlot3_SB({REM_pre_all REM_post_all},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('REM prop')
makepretty_BM2


figure
Data_to_use = HPC_MeanSp_Bef_NREM{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , nanmean(Data_to_use) , Conf_Inter ,'-r',1); hold on;
Data_to_use = HPC_MeanSp_Bef_REM{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , nanmean(Data_to_use) , Conf_Inter ,'-g',1); hold on;
Data_to_use = HPC_MeanSp_Aft{3};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , nanmean(Data_to_use) , Conf_Inter ,'-g',1); hold on;
col = [.6 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([0 10])
f=get(gca,'Children'); l=legend([f([9 5 1])],'REM bef','NREM bef','Sleep aft');
makepretty




