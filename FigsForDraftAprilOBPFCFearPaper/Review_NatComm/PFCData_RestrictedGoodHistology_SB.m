clear all

Dir.path{1} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC';
Dir.path{2} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB';
Dir.path{3} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150507-EXT-24h-envB';
% Dir.path{4} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015';
Dir.path{4} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC';
Dir.path{5} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse395/FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{6} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse402/FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{7} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{8} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse451/FEAR-Mouse-451-EXT-24-envB_161026_182307';
% Dir.path{10} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC';


% Dir.path{1} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC';
% Dir.path{2} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB';
% Dir.path{3} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB';
% Dir.path{4} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150507-EXT-24h-envB';
% Dir.path{5} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015';
% Dir.path{6} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC';
% Dir.path{7} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151204-EXT-24h-envC';
% Dir.path{8} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC';
% Dir.path{9} ='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151217-EXT-24h-envC';
% Dir.path{10} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse394/FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
% Dir.path{11} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse395/FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
% Dir.path{12} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse402/FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
% Dir.path{13} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse403/FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
% Dir.path{14} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-EXT-24-envB_161026_174952';
% Dir.path{15} ='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse451/FEAR-Mouse-451-EXT-24-envB_161026_182307';
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
%             for kk = 1:4
%                 for num = 1:length(S)
%                     LittleEp1 = thresholdIntervals(PhasesSpikes.Transf{num},2*pi/4*(kk-1)+1E-8,'Direction','Above');
%                     LittleEp2 = thresholdIntervals(PhasesSpikes.Transf{num},2*pi/4*(kk)-1E-8,'Direction','Below');
%                     LittleEp = and(LittleEp1,LittleEp2);
%                     AllS{kk+1}{num} = Restrict(S{num},LittleEp);
%                     %                 [M,T] = PlotRipRaw(LFP,Data(AllS{kk+1}{num})/1E4,500,0,0,0);
%                     %                 Rem{kk+1}(num,:) = M(:,2);
%                 end
%                 AllS{kk+1} = tsdArray(AllS{kk+1});
%             end
            
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
                            timebef = 5; % now use 5s always
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
                ID(neur) = k;
                neur = neur+1;
            end
        end
    end
end
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/DataKB
save('DataPFCFreezing_VeryRes2.mat','MeanFz','MeanNoFz','NormResp','StartResp','StopResp','KappaNeur','PValNeur','PhaseNeur','ID')
% save('DataPFCFreezing_AllNeur.mat','ID','-append')


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

