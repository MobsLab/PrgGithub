clear all, close all
%% Average spectra for all three states + levels of anesthesia

ExperimentNames{1} = 'Isoflurane_WakeUp';
ExperimentNames{2} = 'Isoflurane_08';
ExperimentNames{3} = 'Isoflurane_10';
ExperimentNames{4} = 'Isoflurane_12';
ExperimentNames{5} = 'Isoflurane_15';
ExperimentNames{6} = 'Isoflurane_18';

TimesToTest = [-100:10:-20,-10:1:-1;-110:10:-30,-11:1:-2]-0.5;
for exp = 1:length(ExperimentNames)
    Dir = PathForExperimentsAnesthesia(ExperimentNames{exp});
    
    for k = 1 : length(Dir.path)
        
        if Dir.ExpeInfo{k}{1}.WithStims == 1
            cd(Dir.path{k}{1})
        else
            cd(Dir.path{k}{2})
        end
        
        % load the stimulation info
        clear StimVolt StimEpoch smooth_ghi MovAcctsd EKG Spectro StimVolt
        load('behavResources.mat')
        UniqueVoltage = unique(StimVolt);
        StartTimes = Start(StimEpoch,'s');
        
        load('StateEpochSB.mat','smooth_ghi')
        
        load('HeartBeatInfo.mat')
        
        load('B_High_Spectrum.mat')
        fband = [find(Spectro{3}>50,1,'first'):find(Spectro{3}>70,1,'first')];
        Sptsd=tsd(Spectro{2}*1e4,nanmean(Spectro{1}(:,fband)')');
        
        for volt = 1:length(UniqueVoltage)
            
            St_times = StartTimes(find(StimVolt==UniqueVoltage(volt)));
            
            [M,T.Mov{exp,k,volt}]=PlotRipRaw(MovAcctsd,St_times,1000,0,0);
            Time.Mov = M(:,1);
            
            for st = 1:length(St_times)
                for TtoT = 1 :size(TimesToTest,2)
                    LitEpoch = intervalSet(St_times(st)*1e4-TimesToTest(1,TtoT)*1e4,St_times(st)*1e4-TimesToTest(2,TtoT)*1e4);
                    T.GammaOB{exp,k,volt}(TtoT,st) = nanmean(Data(Restrict(smooth_ghi,LitEpoch)));
                    T.EKG{exp,k,volt}(TtoT,st) = nanmean(Data(Restrict(EKG.HBRate,LitEpoch)));
                    T.GammaOB_Spec{exp,k,volt}(TtoT,st) = nanmean(Data(Restrict(Sptsd,LitEpoch)));
                end
            end
        end
        
    end
end

Dir = PathForExperimentsAnesthesia('Sleep_Pre_Ketamine');
for k = 1 : length(Dir.path)
    cd(Dir.path{k}{1})
    load('StateEpochSB.mat','smooth_ghi','sleepper','Epoch','gamma_thresh')
    MeannGamSleep(k,:) = nanmean(Data(Restrict(smooth_ghi,sleepper)));
    MeannGamWake(k,:) = nanmean(Data(Restrict(smooth_ghi,Epoch-sleepper)));
    GammaThresh(k) = gamma_thresh;
end

cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview
save('Gamma_HR_Corr_Response_1,5to3,5.mat','T','Time','GammaThresh','MeannGamSleep','MeannGamWake')

