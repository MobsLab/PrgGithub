clear all
close all

% cingular cortex
Dir.path{1} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB';
Dir.path{2} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150507-EXT-24h-envB';
% 
% % prelimbic
% Dir.path{1} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC';
% Dir.path{2} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-EXT-24-envB_161026_174952';
% Dir.path{3} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse451/FEAR-Mouse-451-EXT-24-envB_161026_182307';
% Dir.path{4} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC';
addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra'));


%
neur = 1;
MeanSpecWk = [];
MeanSpecStr = [];
AllDur = [];
AllPow = [];
tps=[0.05:0.05:1];
timeatTransition=3;

if 1
    for k = 1:length(Dir.path)
        cd(Dir.path{k})
        
        if exist('SpikeData.mat')>-1
            clear FreezeAccEpoch Kappa mu pval S PhasesSpikes AllS
            [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
            load('SpikeData.mat')
            S = S(numNeurons);
            load('behavResources.mat')
            if exist('FreezeAccEpoch')
                FreezeEpoch = FreezeAccEpoch;
            end
            TotEpoch = intervalSet(0,max(Range(Movtsd)));
            load('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
            
            
            % Create S at different phases
            AllS{1} = S;
            for kk = 1:4
                for num = 1:length(S)
                    LittleEp1 = thresholdIntervals(PhasesSpikes.Transf{num},2*pi/4*(kk-1)+1E-8,'Direction','Above');
                    LittleEp2 = thresholdIntervals(PhasesSpikes.Transf{num},2*pi/4*(kk)-1E-8,'Direction','Below');
                    LittleEp = and(LittleEp1,LittleEp2);
                    AllS{kk+1}{num} = Restrict(S{num},LittleEp);
                    %                 [M,T] = PlotRipRaw(LFP,Data(AllS{kk+1}{num})/1E4,500,0,0,0);
                    %                 Rem{kk+1}(num,:) = M(:,2);
                end
                AllS{kk+1} = tsdArray(AllS{kk+1});
            end
            
            for num = 1:length(S)
                for type = 1
                    [StartResp{type}(neur,:), B] = CrossCorr(Start(FreezeEpoch),Range(AllS{type}{num}),40,125);
                    [StopResp{type}(neur,:), B] = CrossCorr(Stop(FreezeEpoch),Range(AllS{type}{num}),40,125);
                    
                    
                    [~,MeanNoFz(neur)] = FiringRateEpoch(S{num},TotEpoch-FreezeEpoch);
                    [~,MeanFz(neur)] = FiringRateEpoch(S{num},FreezeEpoch);
                    Q = MakeQfromS(AllS{type}(num),0.04*1E4);
                    StdNeur(neur) = std(Data(Restrict(Q,TotEpoch-FreezeEpoch)));
                    KappaNeur(neur) = Kappa{num};
                    PhaseNeur(neur) = mu{num};
                    PValNeur(neur) = pval{num};
                    
                    
                    %% Look at Normalized periods
                    Q = MakeQfromS(AllS{type}(num),0.2*1E4,'T_start',min(Range(MovAcctsd)),'T_end',max(Range(MovAcctsd)));
                    clear CorrRem
                    for fzep = 1:length(Start(FreezeEpoch))-1
                        ActualEpoch = subset(FreezeEpoch,fzep);
                        if max(Range(Q))>Stop(ActualEpoch)+3*1E4
                            
                            % define epoch
                            timebef = 4; % now use 5s always
                            % timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
                            LittleEpoch=intervalSet(Start(ActualEpoch),Stop(ActualEpoch));
                            LittleEpochPre=intervalSet(Start(ActualEpoch)-timebef*1e4,Start(ActualEpoch));
                            LittleEpochPost=intervalSet(Stop(ActualEpoch),Stop(ActualEpoch)+timebef*1e4);
                            
                            TempData = full(Data(Restrict(Q,LittleEpoch)));
                            TempData = interp1([0:1/(size(TempData,1)-1):1],TempData,tps);
                            % Original version                        TempData = interp1([1/(size(TempData,1):1/(size(TempData,1)):1],TempData,tps);
                            
                            TempDataPre=full(Data(Restrict(Q,LittleEpochPre)));
                            TempDataPre = interp1([1/size(TempDataPre,1):1/size(TempDataPre,1):1],TempDataPre,[0.1:0.1:1]);
                            
                            TempDataPost=full(Data(Restrict(Q,LittleEpochPost)));
                            TempDataPost = interp1([1/size(TempDataPost,1):1/size(TempDataPost,1):1],TempDataPost,[0.1:0.1:1]);
                            
                            CorrRem(fzep,:) = ([TempDataPre,TempData,TempDataPost]);
                        end
                    end
                    
                    NormResp{type}(neur,:) = (nanmean(CorrRem,1));
                    
                end
                neur = neur+1;
            end
        end
    end
end
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/DataKB
load('DataPFCFreezing.mat','TimeStartStop')
PValNeur = [PValNeur(:).Transf];
rmpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra'));

%% Description variables
% TimeStartStop = B;
% PhaseNeur = [PhaseNeur.Transf];
% PValNeur = [PValNeur.Transf];
% KappaNeur = [KappaNeur.Transf];
% % Variables
% NormResp = p�riode de freezing normalis�, pas de zscore
% StartResp / StopResp = R�ponse trigg� sur onset ou offset du freezing, pas de zscore (time in TimeStartStop, ms)
% TimeStartStop = temps en ms
% Ces deux variables sont des cellules et j'ai mis dans chaque cellule l'activit� avec:
% 1 --> tous les spikes
% 2 --> spikes entre 0 et pi/2
% 3 --> spikes entre pi/2 et pi
% 4 --> spikes entre pi et 3*pi/2
% 5 --> spikes entre 3*pi/2 et 2*pi
%
% MeanNoFz / MeanFz = taux de d�charge moyen pour chaque neurone en dehors et pendant le freezing
% KappaNeur / PhaseNeur/ PValNeur =  Kappa, Phase et PVal par rapport au OB



%% Get PFC figure

Thresh = 0.3;
DatMat = zscore([StartResp{1},StopResp{1}]')';
Temp = zscore(NormResp{1}')';
SustValNorm = nanmean(Temp(:,13:28)');
SustVal = nanmean(DatMat(:,75:125)');

clear DatMatCl
for neur = 1:size(DatMat,1)
    MeanNoFzNew(neur) = nanmean(DatMat(neur,[1:40,210:250]));
    MeanFzNew(neur) = nanmean(DatMat(neur,[75:125]));
    Skeletton = [ones(1,62)*MeanNoFzNew(neur),ones(1,126)*MeanFzNew(neur),ones(1,62)*MeanNoFzNew(neur)];
    DatMatCl(neur,:) =  DatMat(neur,:)-Skeletton;
end
% DatMatCl = zscore(DatMatCl')';
OnsetVal = nanmean(DatMatCl(:,63:88)');
OffsetVal = nanmean(DatMatCl(:,[63:88]+125)');
OnsetValrg = range(DatMatCl(:,63:88)');
OffsetValrg = range(DatMatCl(:,[63:88]+125)');

DatNormZ = zscore(NormResp{1}')';

UseForTresh = SustVal;
% figure
[~,ind] = sort(UseForTresh);
% imagesc(TpsNorm,1:size(DatNormZ,1),DatNormZ(ind,:))
% caxis([-3 3])

figure
pie([nanmean(PValNeur<0.05),nanmean(PValNeur>0.05)])
colormap gray


for neur = 1:size(DatMat,1)
    DatMatNormt(neur,:) = -DatNormZ(neur,:)*sign(SustVal(neur));
end

figure
errorbar(1:40,runmean(nanmean(DatMatNormt(PValNeur>0,:)),1),stdError(runmean(DatMatNormt(PValNeur>0,:)',1)'),'LineWidth',2,'color','k')
xlabel('Norm. Time')    
ylabel('Fr (zscore)')
set(gca,'XTick',[5:5:35],'XTickLabel',{'-0.25','0','0.25','0.5','0.75','1','1.25'})
makepretty

Offsett = nanmean(DatMatNormt(:,31:34)')';
Onsett = nanmean(DatMatNormt(:,10:13)')';
figure
A = {abs(Onsett),abs(Offsett)};
% [p,~,s] = PlotErrorBarN_KJ(A,'paired',0,'Newfig',0,'showpoints',0,'barcolors',{[255 153 51]/255,[76 0 153]/255},'x_data',[3,4])
MakeSpreadAndBoxPlot_SB(A,{[255 153 51]/255,[76 0 153]/255},[1,2],{'Onset','Offset'},0,0)
ylim([0 1.1])
xtickangle(45)
makepretty
    
% figure
% A = {abs(Onsett(PvalNeur<0.05)),abs(Offsett(PvalNeur<0.05)),abs(Onsett(PvalNeur>0.05)),abs(Offsett(PvalNeur>0.05))};
% [p,~,s] = PlotErrorBarN_KJ(A,'paired',0,'Newfig',0,'showpoints',0,'barcolors',{[255 153 51]/255,[76 0 153]/255})
% % MakeSpreadAndBoxPlot_SB(A,{[0.4 0.4 0.4],[0.8 0.8 0.8],[0.8 0.2 0.2]},[1,3,5],{'CTRL-Mod','CTRL-NonMod','OBX'},0)
% set(gca,'XTick',[1,2],'XTickLabel',{'Onset','Offset'})
% ylim([0 1.1])
% xtickangle(45)
% makepretty
    