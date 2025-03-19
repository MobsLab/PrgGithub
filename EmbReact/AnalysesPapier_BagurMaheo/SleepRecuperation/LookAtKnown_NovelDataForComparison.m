close all
clear all
Dir.Cond = PathForExperimentsERC('UMazePAG');
Dir.Known = PathForExperimentsERC('Known');
Dir.Novel = PathForExperimentsERC('Novel');

SessTypes = fieldnames(Dir);

for ss = 1:length(SessTypes)
    figure
    for mm = 1:length(Dir.(SessTypes{ss}).path)
        cd(Dir.(SessTypes{ss}).path{mm}{1})
        try
            load('ExpeInfo.mat')
            load('behavResources.mat', 'NewtsdZT','TTLInfo')
            load('LFPData/LFP0.mat')
            load('ExpeInfo.mat')
            load('behavResources.mat','TTLInfo','SessionEpoch')
            
            
            
            SleepPre_Epoch = SessionEpoch.PreSleep;
            SleepPost_Epoch = SessionEpoch.PostSleep;
            try
                plot(Data(NewtsdZT)/3600e4,zscore(Data(LFP))+10*mm,'k')
                hold on
                plot(Data(Restrict(NewtsdZT,SleepPre_Epoch))/3600e4,zscore(Data(Restrict(LFP,SleepPre_Epoch)))+10*mm,'r')
                plot(Data(Restrict(NewtsdZT,SleepPost_Epoch))/3600e4,zscore(Data(Restrict(LFP,SleepPost_Epoch)))+10*mm,'r')
            catch
                load('TimeRec.mat')
                StartTime = (TimeBeginRec(1)*3600 + TimeBeginRec(2)*60 + TimeBeginRec(3))*1e4;
                NewtsdZT = tsd(Range(LFP),StartTime+Range(LFP));
                plot(Data(NewtsdZT)/3600e4,zscore(Data(LFP))+10*mm,'k')
                hold on
                plot(Data(Restrict(NewtsdZT,SleepPre_Epoch))/3600e4,zscore(Data(Restrict(LFP,SleepPre_Epoch)))+10*mm,'r')
                plot(Data(Restrict(NewtsdZT,SleepPost_Epoch))/3600e4,zscore(Data(Restrict(LFP,SleepPost_Epoch)))+10*mm,'r')
            end
            CondDur{ss}(mm) = min(Data(Restrict(NewtsdZT,SleepPost_Epoch))/1e4) - max(Data(Restrict(NewtsdZT,SleepPre_Epoch))/1e4);
            SleepStart{ss}(mm) = min(Data(Restrict(NewtsdZT,SleepPost_Epoch))/3600e4);
            
        catch
            disp(Dir.(SessTypes{ss}).path{mm}{1})
            
        end
    end
    title((SessTypes{ss}))
end

figure
nhist(CondDur)


for ss = 1:length(SessTypes)
    GoodMice{ss} = find(CondDur{ss}>4000 & CondDur{ss}<8000 & SleepStart{ss}>1 & SleepStart{ss}<16)
    
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/RippleEffect
save('SessionInfo_KnownNovel.mat','CondDur','SleepStart')