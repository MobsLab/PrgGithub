SessTypes = {'UMazeCond','UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock','ExtinctionBlockedShock_EyeShock','ExtinctionBlockedSafe_EyeShock'};
for ss = 1:6
Dir{ss}=PathForExperimentsEmbReact(SessTypes{ss});
end

DurMergeMin=4*1e4;


load('/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_Cond/Cond10/B_Low_Spectrum.mat')
f = Spectro{3};

for d = 1:length(Dir)
    
    for mm = 1:length(Dir{d}.path)
        
        try
            
            LinPos = ConcatenateDataFromFolders_SB(Dir{d}.path{mm},'linearposition');
            FreezeEpoch = ConcatenateDataFromFolders_SB(Dir{d}.path{mm},'epoch','epochname','freezeepoch');
            
            FreezeEpoch_Shock = and(FreezeEpoch,thresholdIntervals(LinPos,0.4,'Direction','Below'));
            FreezeEpoch_Safe = and(FreezeEpoch,thresholdIntervals(LinPos,0.6,'Direction','Above'));
            
            FreezeEpochLength_shock{d}{mm} = Stop(FreezeEpoch_Shock,'s')-Start(FreezeEpoch_Shock,'s');
            FreezeEpochLength_safe{d}{mm} = Stop(FreezeEpoch_Safe,'s')-Start(FreezeEpoch_Safe,'s');
            
            % inter freezing bouts, only relevant for blocked periods
            if d==4 | d==6
                DoorEpoch = intervalSet(0,300*1e4);
                ActEpochLength_safe{d}{mm} = Stop(DoorEpoch-FreezeEpoch_Safe,'s')-Start(DoorEpoch-FreezeEpoch_Safe,'s');
            elseif d==3 | d==5
                DoorEpoch = intervalSet(0,300*1e4);
                ActEpochLength_shock{d}{mm} = Stop(DoorEpoch-FreezeEpoch_Shock,'s')-Start(DoorEpoch-FreezeEpoch_Shock,'s');
            end
            
        end
        
    end
end



% PAG
d = 1;
AllShock.PAG = [NaN];
AllSafe.PAG = [NaN];
AllShockMbyM.PAG = [NaN];
AllSafe.PAG = [NaN];
AllSafeMbyM.PAG = [NaN];

for mm = 1:length(Dir{d}.path)
    try
        AllShock.PAG = [AllShock.PAG;FreezeEpochLength_shock{d}{mm}];
        AllShockMbyM.PAG = [AllShockMbyM.PAG;nanmean(FreezeEpochLength_shock{d}{mm})];
    end
    try
        AllSafe.PAG = [AllSafe.PAG;FreezeEpochLength_safe{d}{mm}];
        AllSafeMbyM.PAG = [AllSafeMbyM.PAG;nanmean(FreezeEpochLength_safe{d}{mm})];
    end
end

% Eyeshock - cond
AllShock.EyeSk = [NaN];
AllSafe.EyeSk = [NaN];
AllShockMbyM.EyeSk = [NaN];
AllSafeMbyM.EyeSk = [NaN];


for d = 2:4
    for mm = 1:length(Dir{d}.path)
        try
            AllShock.EyeSk = [AllShock.EyeSk;FreezeEpochLength_shock{d}{mm}];
            AllShockMbyM.EyeSk = [AllShockMbyM.EyeSk;nanmean(FreezeEpochLength_shock{d}{mm})];
        end
        try
            AllSafe.EyeSk = [AllSafe.EyeSk;FreezeEpochLength_safe{d}{mm}];
            AllSafeMbyM.EyeSk = [AllSafeMbyM.EyeSk;nanmean(FreezeEpochLength_safe{d}{mm})];
        end
    end
    
end

% Eyeshock - blocked
AllShock.EyeSkBl = [NaN];
AllSafe.EyeSkBl = [NaN];
AllShockMbyM.EyeSkBl = [NaN];
AllSafeMbyM.EyeSkBl = [NaN];

AllShockAct.EyeSkBl = [NaN];
AllSafeAct.EyeSkBl = [NaN];
AllShockActMbyM.EyeSkBl = [NaN];
AllSafeActMbyM.EyeSkBl = [NaN];

for d = 5:6
for mm = 1:length(Dir{d}.path)
    try
        AllShock.EyeSkBl = [AllShock.EyeSkBl;FreezeEpochLength_shock{d}{mm}];
        AllShockMbyM.EyeSkBl = [AllShockMbyM.EyeSkBl;nanmean(FreezeEpochLength_shock{d}{mm})];
        
        AllShockAct.EyeSkBl = [AllShockAct.EyeSkBl;ActEpochLength_shock{d}{mm}];
        AllShockActMbyM.EyeSkBl = [AllShockActMbyM.EyeSkBl;nanmean(ActEpochLength_shock{d}{mm})];

    end
    try
        AllSafe.EyeSkBl = [AllSafe.EyeSkBl;FreezeEpochLength_safe{d}{mm}];
        AllSafeMbyM.EyeSkBl = [AllSafeMbyM.EyeSkBl;nanmean(FreezeEpochLength_safe{d}{mm})];
        
        AllSafeAct.EyeSkBl = [AllSafeAct.EyeSkBl;ActEpochLength_safe{d}{mm}];
        AllSafeActMbyM.EyeSkBl = [AllSafeActMbyM.EyeSkBl;nanmean(ActEpochLength_safe{d}{mm})];

    end
end

end

figure
Fld = fieldnames(AllSafe);
for f = 1:3
subplot(3,3,1+(f-1))
nhist({AllSafe.(Fld{f}),AllShock.(Fld{f})},'samebins','binfactor',5,'noerror')
legend({'Safe','Shock'})
title(Fld{f})
xlabel('Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
xlim([0 40])

subplot(3,3,4+(f-1))
[Y,X] = hist(AllSafe.(Fld{f}),[0:1:40]);
plot(X,cumsum(Y)/sum(Y),'b','linewidth',2), hold on
[Y,X] = hist(AllShock.(Fld{f}),[0:1:40]);
plot(X,cumsum(Y)/sum(Y),'r','linewidth',2)
xlabel('Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Cum proba')

subplot(3,3,7+(f-1))

MakeSpreadAndBoxPlot_SB({AllShockMbyM.(Fld{f}),AllSafeMbyM.(Fld{f})},{UMazeColors('Shock'),UMazeColors('Safe')},[1,2],{'Shock','Safe'})

ylabel('Mean Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

end

figure
f=3;
subplot(3,2,1)
nhist({AllSafe.(Fld{f}),AllShock.(Fld{f})},'samebins','binfactor',5,'noerror')
legend({'Safe','Shock'})
title(Fld{f})
xlabel('Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

subplot(3,2,2)
nhist({AllSafeAct.(Fld{f}),AllShockAct.(Fld{f})},'samebins','binfactor',5,'noerror')
legend({'Safe','Shock'})
title(Fld{f})
xlabel('Active Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)


subplot(3,2,3)
[Y,X] = hist(AllSafe.(Fld{f}),[0:1:40]);
plot(X,cumsum(Y)/sum(Y),'b','linewidth',2), hold on
[Y,X] = hist(AllShock.(Fld{f}),[0:1:40]);
plot(X,cumsum(Y)/sum(Y),'r','linewidth',2)
xlabel('Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Cum proba')

subplot(3,2,4)
[Y,X] = hist(AllSafeAct.(Fld{f}),[0:1:40]);
plot(X,cumsum(Y)/sum(Y),'b','linewidth',2), hold on
[Y,X] = hist(AllShockAct.(Fld{f}),[0:1:40]);
plot(X,cumsum(Y)/sum(Y),'r','linewidth',2)
xlabel('Active Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Cum proba')

subplot(3,2,5)
MakeSpreadAndBoxPlot_SB({AllShockMbyM.(Fld{f}),AllSafeMbyM.(Fld{f})},{UMazeColors('Shock'),UMazeColors('Safe')},[1,2],{'Shock','Safe'})
ylabel('Mean Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

subplot(3,2,6)
MakeSpreadAndBoxPlot_SB({AllShockActMbyM.(Fld{f}),AllSafeActMbyM.(Fld{f})},{UMazeColors('Shock'),UMazeColors('Safe')},[1,2],{'Shock','Safe'})
ylabel('Mean Act Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)


figure

clf
for d = 1:length(Dir)
    AllShock = [NaN];
    AllSafe = [NaN];
    for mm = 1:length(Dir{d}.path)
        try
            AllShock = [AllShock;FreezeEpochLength_shock{d}{mm}];
        end
        try
            AllSafe = [AllSafe;FreezeEpochLength_safe{d}{mm}];
        end
    end
    subplot(2,6,d)
    nhist({AllSafe,AllShock},'samebins','binfactor',5,'noerror')
    legend({'Safe','Shock'})
    title(SessTypes{d})
    xlabel('Freezing Bout Dur')
    box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
    
    subplot(2,6,d+6)
    [Y,X] = hist(AllSafe,[0:1:50]);
    plot(X,cumsum(Y)/sum(Y),'b','linewidth',2), hold on
    [Y,X] = hist(AllShock,[0:1:50]);
    plot(X,cumsum(Y)/sum(Y),'r','linewidth',2)
        xlabel('Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
    ylabel('Cum proba')
end

figure
d = 4;
AllSafe = [NaN];
for mm = 1:length(Dir{d}.path)
    try
    AllSafe = [AllSafe;ActEpochLength_safe{d}{mm}];
    end
end
d = 3;
AllShock = [NaN];
for mm = 1:length(Dir{d}.path)
    try
    AllShock = [AllShock;ActEpochLength_shock{d}{mm}];
    end
end
subplot(2,1,1)
nhist({AllSafe,AllShock},'samebins','binfactor',5,'noerror')
legend({'Safe','Shock'})
xlabel('Active Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

subplot(2,1,2)
[Y,X] = hist(AllSafe,[0:1:50]);
plot(X,cumsum(Y)/sum(Y),'b','linewidth',2), hold on
[Y,X] = hist(AllShock,[0:1:50]);
plot(X,cumsum(Y)/sum(Y),'r','linewidth',2)
xlabel('Active Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Cum proba')

figure
d = 6;
AllSafe = [NaN];
for mm = 1:length(Dir{d}.path)
    try
    AllSafe = [AllSafe;ActEpochLength_safe{d}{mm}];
    end
end
d = 5;
AllShock = [NaN];
for mm = 1:length(Dir{d}.path)
    try
    AllShock = [AllShock;ActEpochLength_shock{d}{mm}];
    end
end

subplot(2,2,1)
nhist({AllSafe,AllShock},'samebins','binfactor',5,'noerror')
legend({'Safe','Shock'})
xlabel('Active Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

subplot(2,2,3)
[Y,X] = hist(AllSafe,[0:1:50]);
plot(X,cumsum(Y)/sum(Y),'b','linewidth',2), hold on
[Y,X] = hist(AllShock,[0:1:50]);
plot(X,cumsum(Y)/sum(Y),'r','linewidth',2)
xlabel('Active Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Cum proba')

d=6;
AllSafe = [NaN];
for mm = 1:length(Dir{d}.path)
    try
    AllSafe = [AllSafe;FreezeEpochLength_safe{d}{mm}];
    end
end
d = 5;
AllShock = [NaN];
for mm = 1:length(Dir{d}.path)
    try
    AllShock = [AllShock;FreezeEpochLength_shock{d}{mm}];
    end
end

subplot(2,2,2)
nhist({AllSafe,AllShock},'samebins','binfactor',5,'noerror')
legend({'Safe','Shock'})
xlabel('Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)

subplot(2,2,4)
[Y,X] = hist(AllSafe,[0:1:50]);
plot(X,cumsum(Y)/sum(Y),'b','linewidth',2), hold on
[Y,X] = hist(AllShock,[0:1:50]);
plot(X,cumsum(Y)/sum(Y),'r','linewidth',2)
xlabel('Freezing Bout Dur')
box off, set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
ylabel('Cum proba')


figure


clf
AllShock = [NaN];
AllSafe = [NaN];
for d = 1:length(Dir)
    
    for mm = 1:length(Dir{d}.path)
        try
            AllShock = [AllShock;FreezeEpochLength_shock{d}{mm}];
        end
        try
            AllSafe = [AllSafe;FreezeEpochLength_safe{d}{mm}];
        end
    end
    
    
    
end
subplot(2,1,1)
nhist({AllSafe,AllShock},'samebins','binfactor',3)
legend({'Safe','Shock'})

subplot(2,1,2)
[Y,X] = hist(AllSafe,[0:1:50]);
plot(X,cumsum(Y)/sum(Y),'b'), hold on
[Y,X] = hist(AllShock,[0:1:50]);
plot(X,cumsum(Y)/sum(Y),'r')

