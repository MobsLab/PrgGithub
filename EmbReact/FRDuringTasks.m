clear all
MiceNumber=[490,507,508,509,510,514]; % add 512 back in later
for mm=1:length(MiceNumber)
    FileNames=GetAllMouseTaskSessions(MiceNumber(mm));

    for k=1:length(FileNames)
        cd(FileNames{k})
        load('SpikeData.mat')
        load('behavResources.mat')
        load('ExpeInfo.mat')
        load('LFPData/LFP0.mat')
        if strcmp(ExpeInfo.SessionType,'Extinction') | strcmp(ExpeInfo.SessionType,'SleepPost')
            ExpeInfo.SessionNumber=1;
            save('ExpeInfo.mat','ExpeInfo')
        end
        if not(isfield(ExpeInfo,'SessionNumber'))
            ExpeInfo.SessionNumber=1;
        end
        for sp=1:length(S)
            FR.(ExpeInfo.SessionType).Wake{sp}(max(ExpeInfo.SessionNumber,1))=length(S{sp})/max(Range(LFP,'s'));
        end
        if ExpeInfo.SleepSession==1
            load('StateEpochSB.mat','Sleep','Wake')
            for sp=1:length(S)
                FR.(ExpeInfo.SessionType).Wake{sp}(max(ExpeInfo.SessionNumber,1))=length(Restrict(S{sp},Wake))/sum(Stop(Wake,'s')-Start(Wake,'s'));
                FR.(ExpeInfo.SessionType).Sleep{sp}(max(ExpeInfo.SessionNumber,1))=length(Restrict(S{sp},Sleep))/sum(Stop(Sleep,'s')-Start(Sleep,'s'));
            end

        end
    end

    allfields=fieldnames(FR);
    for k=1:length(allfields)
        for sp=1:length(S)
            frtemp(k,sp)=nanmean(FR.(allfields{k}).Wake{sp});
        end
    end
    % PlotErrorBar(frtemp')

    for sp=1:length(S)
        plot([1,2,4,5,7,8,9,11,13],frtemp([1,2,4,5,7,8,9,11,13],sp),'*')
        hold on
        plot([3,6,10,12],frtemp([3,6,10,12],sp),'*')
        set(gca,'XTick',[1:13],'XTickLabel',allfields)
        pause
        clf
    end
end

% for k=1:length(FileNames)
%     cd(FileNames{k})
%     load('SpikeData.mat')
%     load('behavResources.mat')
%     load('ExpeInfo.mat')
%     load('LFPData/LFP0.mat')
%     if not(isfield(ExpeInfo,'SessionNumber'))
%         ExpeInfo.SessionNumber=1;
%     end
%     ExpeInfo.SessionType
% sp=1
% length(S{sp})
% hist(Range(S{1}))
% pause
%
% end
