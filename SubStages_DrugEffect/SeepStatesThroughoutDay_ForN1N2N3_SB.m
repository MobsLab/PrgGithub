clear all
Dir = PathForExperimentsEmbReact('BaselineSleep');
% count = 0;
% for d = 1:length(Dir.path)
%     for dd = 1:length(Dir.path{d})
%         cd(Dir.path{d}{dd})
%         clear NewtsdZT
%         try
%             load('behavResources.mat','NewtsdZT')
%             (min(Data(NewtsdZT))/3600)/10000
%             (max(Data(NewtsdZT))/3600)/10000
%
%             %         pause
%             count = count+1;
%         catch
%             keyboard
%         end
%     end
% end

ZTh=[8 :1/6: 20]*3600; % time of the day (s), step of 10min
mouse = 1;
clear DataPts
for d = 14:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        
        clear SWSEpoch REMEpoch Wake NewtsdZT
        load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake')
        load('behavResources.mat','NewtsdZT')
        dat = Data(NewtsdZT);
        rg = Range(NewtsdZT);
        for z = 1:length(ZTh)-1
            z
            A = find(dat>ZTh(z)*1e4 & dat<ZTh(z+1)*1e4);
            
            if not(isempty(A))
                LittleEpoch = intervalSet(rg(A(1)),rg(A(end)));
                
                DataPts.All(mouse,z) = sum(Stop(LittleEpoch)-Start(LittleEpoch));
                DataPts.REM(mouse,z) = sum(Stop(and(REMEpoch,LittleEpoch))-Start(and(REMEpoch,LittleEpoch)));
                DataPts.SWS(mouse,z) = sum(Stop(and(SWSEpoch,LittleEpoch))-Start(and(SWSEpoch,LittleEpoch)));
                DataPts.Wake(mouse,z) = sum(Stop(and(Wake,LittleEpoch))-Start(and(Wake,LittleEpoch)));
            else
                DataPts.All(mouse,z) = 0;
                DataPts.REM(mouse,z) = 0;
                DataPts.SWS(mouse,z) = 0;
                DataPts.Wake(mouse,z) = 0;
            end
        end
        
        MouseNum(mouse) = Dir.ExpeInfo{d}{1}.nmouse
        mouse = mouse+1;
        
        
    end
end


UniqueMiceNumbers = unique(MouseNum);
WakeProp = DataPts.Wake./DataPts.All;
REMProp = DataPts.REM./(DataPts.SWS+DataPts.REM);
REMTime = DataPts.REM./DataPts.All;
SWSTime = DataPts.SWS./DataPts.All;


for mm = 1:length(UniqueMiceNumbers)
    
    SleepTime(mm,:) = nanmean(WakeProp(find(MouseNum == UniqueMiceNumbers(mm)),:));
    REMTimeSWS(mm,:) =  nanmean(REMProp(find(MouseNum == UniqueMiceNumbers(mm)),:));
    
    REMTimeAll(mm,:) =  nanmean(REMTime(find(MouseNum == UniqueMiceNumbers(mm)),:));
    SWSTimeAll(mm,:) =  nanmean(SWSTime(find(MouseNum == UniqueMiceNumbers(mm)),:));
    
end


clf
subplot(3,1,1)
plot(ZTh(1:end-1)/3600,nansum(DataPts.All./nanmax(nanmax(DataPts.All))),'k')
xlabel('ZT (h)')
ylabel('number of sessions with data')
box off
title('32 mice, 63 sessions')

subplot(3,1,2)
errorbar(ZTh(1:end-1)/3600,nanmean(SleepTime),stdError(SleepTime),'k'), hold on
errorbar(ZTh(1:end-1)/3600,nanmean(SWSTimeAll),stdError(SWSTimeAll),'b')
errorbar(ZTh(1:end-1)/3600,nanmean(REMTime),stdError(REMTime),'r')
legend('Wake','SWS','REM')
ylim([0 1])
ylabel('Prop total time in state')
xlabel('ZT (h)')

subplot(3,1,3)
errorbar(ZTh(1:end-1)/3600,nanmean(REMTimeSWS),stdError(REMTimeSWS),'k')
box off
ylabel('Prop of sleep in REM')
xlabel('ZT (h)')

