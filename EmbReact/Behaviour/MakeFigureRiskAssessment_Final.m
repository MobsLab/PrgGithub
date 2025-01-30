clear all
clear ZoneTime
BefTime=12*1e4;
tps=[0:0.01:BefTime*2/1e4];
StepBackFromStart=0.5*1e4;

SessTypes={'Habituation24HPre_EyeShock','Habituation_EyeShock','TestPre_EyeShock','TestPost_EyeShock',...
    'UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock','Extinction_EyeShock',...
    'Habituation','TestPre','UMazeCond','TestPost','Extinction'};

for ss=1:length(SessTypes)
    Files=PathForExperimentsEmbReact(SessTypes{ss});
    MouseToAvoid=[560,117]; % mice with noisy data to exclude
    Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
    
    for mm=1:length(Files.path)
        
        RiskAsess.(SessTypes{ss}).ToSafeMov{mm}=[];RiskAsess.(SessTypes{ss}).ToSafeType{mm}=[];RiskAsess.(SessTypes{ss}).ToSafePos{mm}=[];
        RiskAsess.(SessTypes{ss}).ToShockMov{mm}=[];RiskAsess.(SessTypes{ss}).ToShockType{mm}=[];RiskAsess.(SessTypes{ss}).ToShockPos{mm}=[];
        RiskAsess.(SessTypes{ss}).ToSafeEKG{mm}=[];RiskAsess.(SessTypes{ss}).ToShockEKG{mm}=[];
        cd(Files.path{mm}{1})
        load('behavResources_SB.mat')
        if isfield(Behav,'RAEpoch')
            
            for c=1:length(Files.path{mm})
                cd(Files.path{mm}{c})
                clear Behav
                load('behavResources_SB.mat')
                
                if exist('HeartBeatInfo.mat')>0
                    load('HeartBeatInfo.mat')
                end
                DurSess = max(Range(Behav.Vtsd,'s'));
                
                RiskAsess.(SessTypes{ss}).MouseNum(mm,c) = Files.ExpeInfo{mm}{c}.nmouse;
                
                % Count the events according to how I scored them
                for type=1:3
                    RiskAsess.(SessTypes{ss}).ToSafeNumEv{type}(mm,c)=sum(Behav.RAUser.ToSafe>=type-1);
                    RiskAsess.(SessTypes{ss}).ToShockNumEv{type}(mm,c)=sum(Behav.RAUser.ToShock>=type-1);
                    RiskAsess.(SessTypes{ss}).Dur{type}(mm,c)=DurSess;
                    
                end
                
                % Shock
                if not(isempty(Start(Behav.RAEpoch.ToShock)))
                    SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
                    tpsout=FindClosestZeroCross(Start(Behav.RAEpoch.ToShock)-StepBackFromStart,SmooDiffLinDist,1);
                    for t=1:length(tpsout)
                        try
                            LitEp=intervalSet(tpsout(t)-BefTime,tpsout(t)+BefTime);
                            dattemp_V=interp1(Range(Restrict(SmooDiffLinDist,LitEp))-Start(LitEp),Data(Restrict(Behav.Vtsd,LitEp)),tps*1e4);
                            dattemp_Lin=interp1(Range(Restrict(SmooDiffLinDist,LitEp))-Start(LitEp),Data(Restrict(Behav.LinearDist,LitEp)),tps*1e4);
                            if exist('HeartBeatInfo.mat')>0
                                dattemp_HB=interp1(Range(Restrict(EKG.HBRate,LitEp))-Start(LitEp),Data(Restrict(EKG.HBRate,LitEp)),tps*1e4);
                            end
                            
                            RiskAsess.(SessTypes{ss}).ToShockMov{mm}=[RiskAsess.(SessTypes{ss}).ToShockMov{mm};dattemp_V];
                            RiskAsess.(SessTypes{ss}).ToShockPos{mm}=[RiskAsess.(SessTypes{ss}).ToShockPos{mm};dattemp_Lin];
                            RiskAsess.(SessTypes{ss}).ToShockType{mm}=[RiskAsess.(SessTypes{ss}).ToShockType{mm},Behav.RAUser.ToShock(t)];
                            
                            if exist('HeartBeatInfo.mat')>0
                                RiskAsess.(SessTypes{ss}).ToShockEKG{mm}=[RiskAsess.(SessTypes{ss}).ToShockEKG{mm};dattemp_HB];
                            else
                                RiskAsess.(SessTypes{ss}).ToShockEKG{mm}=[RiskAsess.(SessTypes{ss}).ToShockEKG{mm};nan(1,2401)];
                            end
                        catch
                            %                             disp('shock')
                            %                             keyboard
                            RiskAsess.(SessTypes{ss}).ToShockMov{mm}=[ RiskAsess.(SessTypes{ss}).ToShockMov{mm};nan(1,2401)];
                            RiskAsess.(SessTypes{ss}).ToShockPos{mm}=[RiskAsess.(SessTypes{ss}).ToShockPos{mm};nan(1,2401)];
                            RiskAsess.(SessTypes{ss}).ToShockType{mm}=[RiskAsess.(SessTypes{ss}).ToShockType{mm},NaN];
                            RiskAsess.(SessTypes{ss}).ToShockEKG{mm}=[RiskAsess.(SessTypes{ss}).ToShockEKG{mm};nan(1,2401)];
                            
                        end
                    end
                else
                    RiskAsess.(SessTypes{ss}).ToShockMov{mm}=[ RiskAsess.(SessTypes{ss}).ToShockMov{mm};nan(1,2401)];
                    RiskAsess.(SessTypes{ss}).ToShockPos{mm}=[RiskAsess.(SessTypes{ss}).ToShockPos{mm};nan(1,2401)];
                    RiskAsess.(SessTypes{ss}).ToShockType{mm}=[RiskAsess.(SessTypes{ss}).ToShockType{mm},NaN];
                    RiskAsess.(SessTypes{ss}).ToShockEKG{mm}=[RiskAsess.(SessTypes{ss}).ToShockEKG{mm};nan(1,2401)];
                end
                
                % Safe
                if not(isempty(Start(Behav.RAEpoch.ToSafe)))
                    SmooDiffLinDist=tsd(Range(Behav.LinearDist),[0;diff(runmean(Data(Behav.LinearDist),20))]);
                    tpsout=FindClosestZeroCross(Start(Behav.RAEpoch.ToSafe)-StepBackFromStart,SmooDiffLinDist,-1);
                    for t=1:length(tpsout)
                        try
                            LitEp=intervalSet(tpsout(t)-BefTime,tpsout(t)+BefTime);
                            dattemp_V=interp1(Range(Restrict(SmooDiffLinDist,LitEp))-Start(LitEp),Data(Restrict(Behav.Vtsd,LitEp)),tps*1e4);
                            dattemp_Lin=interp1(Range(Restrict(SmooDiffLinDist,LitEp))-Start(LitEp),Data(Restrict(Behav.LinearDist,LitEp)),tps*1e4);
                            if exist('HeartBeatInfo.mat')>0
                                dattemp_HB=interp1(Range(Restrict(EKG.HBRate,LitEp))-Start(LitEp),Data(Restrict(EKG.HBRate,LitEp)),tps*1e4);
                            end
                            
                            RiskAsess.(SessTypes{ss}).ToSafeMov{mm}=[ RiskAsess.(SessTypes{ss}).ToSafeMov{mm};dattemp_V];
                            RiskAsess.(SessTypes{ss}).ToSafePos{mm}=[RiskAsess.(SessTypes{ss}).ToSafePos{mm};dattemp_Lin];
                            RiskAsess.(SessTypes{ss}).ToSafeType{mm}=[RiskAsess.(SessTypes{ss}).ToSafeType{mm},Behav.RAUser.ToSafe(t)];
                            
                            if exist('HeartBeatInfo.mat')>0
                                RiskAsess.(SessTypes{ss}).ToSafeEKG{mm}=[RiskAsess.(SessTypes{ss}).ToSafeEKG{mm};dattemp_HB];
                            else
                                RiskAsess.(SessTypes{ss}).ToSafeEKG{mm}=[RiskAsess.(SessTypes{ss}).ToSafeEKG{mm};nan(1,2401)];
                                
                            end
                        catch
                            %                             disp('safe')
                            %                             keyboard
                            RiskAsess.(SessTypes{ss}).ToSafeMov{mm}=[ RiskAsess.(SessTypes{ss}).ToSafeMov{mm};nan(1,2401)];
                            RiskAsess.(SessTypes{ss}).ToSafePos{mm}=[RiskAsess.(SessTypes{ss}).ToSafePos{mm};nan(1,2401)];
                            RiskAsess.(SessTypes{ss}).ToSafeType{mm}=[RiskAsess.(SessTypes{ss}).ToSafeType{mm},NaN];
                            RiskAsess.(SessTypes{ss}).ToSafeEKG{mm}=[RiskAsess.(SessTypes{ss}).ToSafeEKG{mm};nan(1,2401)];
                            
                        end
                    end
                else
                    RiskAsess.(SessTypes{ss}).ToSafeMov{mm}=[ RiskAsess.(SessTypes{ss}).ToSafeMov{mm};nan(1,2401)];
                    RiskAsess.(SessTypes{ss}).ToSafePos{mm}=[RiskAsess.(SessTypes{ss}).ToSafePos{mm};nan(1,2401)];
                    RiskAsess.(SessTypes{ss}).ToSafeType{mm}=[RiskAsess.(SessTypes{ss}).ToSafeType{mm},NaN];
                    RiskAsess.(SessTypes{ss}).ToSafeEKG{mm}=[RiskAsess.(SessTypes{ss}).ToSafeEKG{mm};nan(1,2401)];
                    
                end
            end
        end
    end
end

AllMice = [];
for ss=1:length(SessTypes)
    AllMice = [AllMice;unique(RiskAsess.(SessTypes{ss}).MouseNum(:))];
end
AllMice = unique(AllMice);
AllMice(1) = [];
PagMice = find(AllMice<514);
EyeshockMice = find(AllMice>514);

SessTypes={'Habituation24HPre_EyeShock','Habituation_EyeShock','TestPre_EyeShock','TestPost_EyeShock',...
    'UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock','Extinction_EyeShock',...
    'Habituation','TestPre','UMazeCond','TestPost','Extinction'};


GroupSessions{1} = {'Habituation24HPre_EyeShock','Habituation_EyeShock','Habituation','TestPre_EyeShock','TestPre'}
GroupSessions{2} = {'UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock','UMazeCond'}
GroupSessions{3} = {'TestPost_EyeShock','TestPost','Extinction','Extinction_EyeShock'};

for grp = 1:3
    for type=1:3
        for mouse = 1:length(AllMice)
            RiskAsess.ToShockNumEv{grp}{type}{mouse} = [];;
            RiskAsess.ToSafeNumEv{grp}{type}{mouse} = [];;
            RiskAsess.Dur{grp}{type}{mouse} = [];;
            RiskAsess.ToShockPos{grp}{type}{mouse} = [];
            RiskAsess.ToSafePos{grp}{type}{mouse}  = [];
            RiskAsess.ToShockHR{grp}{type}{mouse} = [];
            RiskAsess.ToSafeHR{grp}{type}{mouse} =[];
            RiskAsess.ToShockSp{grp}{type}{mouse} = [];
            RiskAsess.ToSafeSp{grp}{type}{mouse} = [];
            
        end
    end
end

for grp = 1:3
    tempsafe = [];
    tempshock = [];
    temptime = [];
    for sess = 1:length(GroupSessions{grp})
        for type=1:3
            temptime = RiskAsess.(GroupSessions{grp}{sess}).Dur{type};
            tempSk = RiskAsess.(GroupSessions{grp}{sess}).ToShockNumEv{type};
            tempSf = RiskAsess.(GroupSessions{grp}{sess}).ToSafeNumEv{type};
            
            
            for mm = 1 :length(RiskAsess.(GroupSessions{grp}{sess}).MouseNum)
                mouse = find(AllMice == RiskAsess.(GroupSessions{grp}{sess}).MouseNum(mm));
                if not(isempty(mouse))
                    RiskAsess.ToShockNumEv{grp}{type}{mouse} = [RiskAsess.ToShockNumEv{grp}{type}{mouse};(tempSk(mm,:))'];
                    RiskAsess.ToSafeNumEv{grp}{type}{mouse} = [RiskAsess.ToSafeNumEv{grp}{type}{mouse};(tempSf(mm,:))'];
                    RiskAsess.Dur{grp}{type}{mouse} = [RiskAsess.Dur{grp}{type}{mouse};(temptime(mm,:))'];
                    
                    tempSkPos = RiskAsess.(GroupSessions{grp}{sess}).ToShockPos{mm};
                    tempSfPos = RiskAsess.(GroupSessions{grp}{sess}).ToSafePos{mm};
                    tempSkPos = tempSkPos(RiskAsess.(GroupSessions{grp}{sess}).ToShockType{mm}>=(type-1),:);
                    tempSfPos = tempSfPos(RiskAsess.(GroupSessions{grp}{sess}).ToSafeType{mm}>=(type-1),:);
                    
                    RiskAsess.ToShockPos{grp}{type}{mouse} = [RiskAsess.ToShockPos{grp}{type}{mouse},(tempSkPos)'];
                    RiskAsess.ToSafePos{grp}{type}{mouse} = [RiskAsess.ToSafePos{grp}{type}{mouse},(tempSfPos)'];
                    
                    tempSkPos = RiskAsess.(GroupSessions{grp}{sess}).ToShockMov{mm};
                    tempSfPos = RiskAsess.(GroupSessions{grp}{sess}).ToSafeMov{mm};
                    tempSkPos = tempSkPos(RiskAsess.(GroupSessions{grp}{sess}).ToShockType{mm}>=(type-1),:);
                    tempSfPos = tempSfPos(RiskAsess.(GroupSessions{grp}{sess}).ToSafeType{mm}>=(type-1),:);
                    
                    RiskAsess.ToShockSp{grp}{type}{mouse} = [RiskAsess.ToShockSp{grp}{type}{mouse},(tempSkPos)'];
                    RiskAsess.ToSafeSp{grp}{type}{mouse} = [RiskAsess.ToSafeSp{grp}{type}{mouse},(tempSfPos)'];
                    
                    tempSkPos = RiskAsess.(GroupSessions{grp}{sess}).ToShockEKG{mm};
                    tempSfPos = RiskAsess.(GroupSessions{grp}{sess}).ToSafeEKG{mm};
                    tempSkPos = tempSkPos(RiskAsess.(GroupSessions{grp}{sess}).ToShockType{mm}>=(type-1),:);
                    tempSfPos = tempSfPos(RiskAsess.(GroupSessions{grp}{sess}).ToSafeType{mm}>=(type-1),:);
                    
                    RiskAsess.ToShockHR{grp}{type}{mouse} = [RiskAsess.ToShockHR{grp}{type}{mouse},(tempSkPos)'];
                    RiskAsess.ToSafeHR{grp}{type}{mouse} = [RiskAsess.ToSafeHR{grp}{type}{mouse},(tempSfPos)'];
                    
                    
                end
                
            end
        end
    end
end

clear MeanNumSk MeanNumSf
for grp = 1:3
    for type=1:3
        
        for mouse = 1:length(AllMice)
            ToDel = find(RiskAsess.Dur{grp}{type}{mouse}==0);
            tempdat = RiskAsess.ToShockNumEv{grp}{type}{mouse};
            temptps = RiskAsess.Dur{grp}{type}{mouse};
            tempdat(ToDel) = [];
            temptps(ToDel) = [];
            MeanNumSk{type}{grp}(mouse,:) = sum(tempdat)./sum(temptps);
            
            ToDel = find(RiskAsess.Dur{grp}{type}{mouse}==0);
            tempdat = RiskAsess.ToSafeNumEv{grp}{type}{mouse};
            temptps = RiskAsess.Dur{grp}{type}{mouse};
            tempdat(ToDel) = [];
            temptps(ToDel) = [];
            MeanNumSf{type}{grp}(mouse,:) = sum(tempdat)./sum(temptps);
        end
    end
end

clf
subplot(121)
type = 3;
A = {MeanNumSk{type}{1}(PagMice),MeanNumSf{type}{1}(PagMice),...
    MeanNumSk{type}{2}(PagMice),MeanNumSf{type}{2}(PagMice),...
    MeanNumSk{type}{3}(PagMice),MeanNumSf{type}{3}(PagMice)};
Cols2 = {UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe')}
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,4,5,7,8])
ylabel('Frequency of event (/s)')
set(gca,'XTick',[1.5 4.5 7.8],'XTickLabel',{'PreCond','Cond','PostCond'},'Linewidth',2,'FontSize',10)
ylim([0 3e-3])

subplot(122)
type = 3;
A = {MeanNumSk{type}{1}(EyeshockMice),MeanNumSf{type}{1}(EyeshockMice),...
    MeanNumSk{type}{2}(EyeshockMice),MeanNumSf{type}{2}(EyeshockMice),...
    MeanNumSk{type}{3}(EyeshockMice),MeanNumSf{type}{3}(EyeshockMice)};
Cols2 = {UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe')}
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,4,5,7,8])
set(gca,'XTick',[1.5 4.5 7.8],'XTickLabel',{'PreCond','Cond','PostCond'},'Linewidth',2,'FontSize',10)
ylabel('Frequency of event (/s)')
ylim([0 3e-3])





for grp = 1:3
    for type=1:3
        AllPosSk{type}{grp} = [];
        AllPosSf{type}{grp} = [];
        AllSpSk{type}{grp} = [];
        AllSpSf{type}{grp} = [];
        AllHRSk{type}{grp} = [];
                AllHRSf{type}{grp} = [];

        for mouse = 1:length(AllMice)
            
            AllPosSk{type}{grp} = [AllPosSk{type}{grp},RiskAsess.ToShockPos{grp}{type}{mouse}];
            AllPosSf{type}{grp} = [AllPosSf{type}{grp},RiskAsess.ToSafePos{grp}{type}{mouse}];
            AllPosSfQuantif{type}{grp}(mouse) = nanmean(1-max(RiskAsess.ToSafePos{grp}{type}{mouse}));
            AllPosSkQuantif{type}{grp}(mouse) = nanmean(min(RiskAsess.ToShockPos{grp}{type}{mouse}));

            
            AllSpSk{type}{grp} = [AllSpSk{type}{grp},RiskAsess.ToShockSp{grp}{type}{mouse}];
            AllSpSf{type}{grp} = [AllSpSf{type}{grp},RiskAsess.ToSafeSp{grp}{type}{mouse}];
            AllSpSkAssym{type}{grp}(mouse) = nanmean(nanmean(RiskAsess.ToShockSp{grp}{type}{mouse}(700:end,:)))./nanmean(nanmean(RiskAsess.ToShockSp{grp}{type}{mouse}(1:500,:)));
            AllSpSfAssym{type}{grp}(mouse) = nanmean(nanmean(RiskAsess.ToSafeSp{grp}{type}{mouse}(700:end,:)))./nanmean(nanmean(RiskAsess.ToSafeSp{grp}{type}{mouse}(1:500,:)));

            
            AllHRSk{type}{grp} = [AllHRSk{type}{grp},RiskAsess.ToShockHR{grp}{type}{mouse}];
            AllHRSf{type}{grp} = [AllHRSf{type}{grp},RiskAsess.ToSafeHR{grp}{type}{mouse}];

        end
    end
end

type = 3;
tps = [-12:0.01:12];
tps(1:20) = [];
tps(end-19:end) = [];

Cols= {UMazeColors('Shock'),UMazeColors('Safe')}
figure
for grp = 1:3
    subplot(1,3,grp)
    hold on
    AllSpSk{type}{grp}(1:20,:) = [];
    AllSpSk{type}{grp}(end-19:end,:) = [];
    ToDel = find(sum(isnan(AllSpSk{type}{grp}))');
    AllSpSk{type}{grp}(:,ToDel) = [];
    AllSpSk{type}{grp} = (SmoothDec(AllSpSk{type}{grp}',[0.1 5]));
    
    g = shadedErrorBar(tps,(nanmean(AllSpSk{type}{grp})),stdError(AllSpSk{type}{grp}));
    set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
    
    AllSpSf{type}{grp}(1:20,:) = [];
    AllSpSf{type}{grp}(end-19:end,:) = [];
    ToDel = find(sum(isnan(AllSpSf{type}{grp}))');
    AllSpSf{type}{grp}(:,ToDel) = [];
    
    AllSpSf{type}{grp} = (SmoothDec(AllSpSf{type}{grp}',[0.1 5]));
    
    g = shadedErrorBar(tps,nanmean(AllSpSf{type}{grp}),stdError(AllSpSf{type}{grp}));
    set(g.patch,'FaceColor',Cols{2},'FaceAlpha',0.3)
    set(g.mainLine,'Color',Cols{2},'linewidth',2)
    xlim([-5 5])
    ylim([1 11])
        set(gca,'Linewidth',2,'FontSize',16)
xlabel('Time to turn (s)')
ylabel('Speed (cm/s)')
line([0 0],ylim,'color','k','linewidth',2)

end

figure
A = {AllPosSkQuantif{type}{1},AllPosSfQuantif{type}{1},...
    AllPosSkQuantif{type}{2},AllPosSfQuantif{type}{2},...
    AllPosSkQuantif{type}{3},AllPosSfQuantif{type}{3}};
Cols2 = {UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe')}
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,4,5,7,8])
set(gca,'XTick',[1.5 4.5 7.8],'XTickLabel',{'PreCond','Cond','PostCond'},'Linewidth',2,'FontSize',15)
ylabel('Distance to zone at turn')
for grp = 1:3
[p(grp),h,stats] = signrank(AllPosSkQuantif{type}{grp},AllPosSfQuantif{type}{grp});
stats
end
sigstar({{1,2},{4,5},{7,8}},p)

figure
A = {AllSpSkAssym{type}{1},AllSpSfAssym{type}{1},...
    AllSpSkAssym{type}{2},AllSpSfAssym{type}{2},...
    AllSpSkAssym{type}{3},AllSpSfAssym{type}{3}};
Cols2 = {UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Shock'),UMazeColors('Safe')}
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,4,5,7,8])
set(gca,'XTick',[1.5 4.5 7.8],'XTickLabel',{'PreCond','Cond','PostCond'},'Linewidth',2,'FontSize',15)
ylabel('Speed ratio (bef vs after turn)')
for grp = 1:3
[p(grp),h,stats] = signrank(AllSpSkAssym{type}{grp},AllSpSfAssym{type}{grp});
stats
end
sigstar({{1,2},{4,5},{7,8}},p)


figure
for grp = 1:3
    subplot(1,3,grp)
    hold on
    AllPosSk{type}{grp}(1:20,:) = [];
    AllPosSk{type}{grp}(end-19:end,:) = [];
    ToDel = find(sum(isnan(AllPosSk{type}{grp}))');
    AllPosSk{type}{grp}(:,ToDel) = [];
    AllPosSk{type}{grp} = (SmoothDec(AllPosSk{type}{grp}',[0.1 5]));
    
    g = shadedErrorBar(tps,(nanmean(AllPosSk{type}{grp})),stdError(AllPosSk{type}{grp}));
    set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
    set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
    set(gca,'Linewidth',2,'FontSize',16)

    AllPosSf{type}{grp}(1:20,:) = [];
    AllPosSf{type}{grp}(end-19:end,:) = [];
    ToDel = find(sum(isnan(AllPosSf{type}{grp}))');
    AllPosSf{type}{grp}(:,ToDel) = [];
    
    AllPosSf{type}{grp} = (SmoothDec(AllPosSf{type}{grp}',[0.1 5]));
    
    g = shadedErrorBar(tps,nanmean(AllPosSf{type}{grp}),stdError(AllPosSf{type}{grp}));
    set(g.patch,'FaceColor',Cols{2},'FaceAlpha',0.3)
    set(g.mainLine,'Color',Cols{2},'linewidth',2)
    xlim([-5 5])
    ylim([-0.1 1.1])


    set(gca,'Linewidth',2,'FontSize',16)
xlabel('Time to turn (s)')
ylabel('Linearized position')
line([0 0],ylim,'color','k','linewidth',2)
line(xlim,[1 1],'color','k','linewidth',1,'linestyle',':')
line(xlim,[0 0],'color','k','linewidth',1,'linestyle',':')

end


type = 3;
grp = 2;
subplot(311)
AllPosSk{type}{grp}(1:20,:) = [];
AllPosSk{type}{grp}(end-19:end,:) = [];
ToDel = find(sum(isnan(AllPosSk{type}{grp}))');
AllPosSk{type}{grp}(:,ToDel) = [];
AllPosSk{type}{grp} = (SmoothDec(AllPosSk{type}{grp}',[0.1 5]));
ylim([0.2 0.8])
hold on
line([0 0],ylim,'color','k','linewidth',2)
g = shadedErrorBar(tps,(nanmean(AllPosSk{type}{grp})),stdError(AllPosSk{type}{grp}));
set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
xlim([-5 5])
        set(gca,'Linewidth',2,'FontSize',16)
xlabel('Time to turn (s)')
ylabel('Linearized position')
box off


subplot(312)
AllSpSk{type}{grp}(1:20,:) = [];
AllSpSk{type}{grp}(end-19:end,:) = [];
ToDel = find(sum(isnan(AllSpSk{type}{grp}))');
AllSpSk{type}{grp}(:,ToDel) = [];
AllSpSk{type}{grp} = (SmoothDec(AllSpSk{type}{grp}',[0.1 5]));
hold on
ylim([0 15])
line([0 0],ylim,'color','k','linewidth',2)
g = shadedErrorBar(tps,(nanmean(AllSpSk{type}{grp})),stdError(AllSpSk{type}{grp}));
set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
xlim([-5 5])
set(gca,'Linewidth',2,'FontSize',16)
xlabel('Time to turn (s)')
ylabel('Speed (cm/s)')
box off

subplot(313)
AllHRSk{type}{grp}(1:20,:) = [];
AllHRSk{type}{grp}(end-19:end,:) = [];
ToDel = find(sum(isnan(AllHRSk{type}{grp}))');
AllHRSk{type}{grp}(:,ToDel) = [];
AllHRSk{type}{grp} = (SmoothDec(AllHRSk{type}{grp}',[0.1 5]));
ylim([12 14])
hold on
line([0 0],ylim,'color','k','linewidth',2)
g = shadedErrorBar(tps,(nanmean(AllHRSk{type}{grp})),stdError(AllHRSk{type}{grp}));
set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
xlim([-5 5])
        set(gca,'Linewidth',2,'FontSize',16)
xlabel('Time to turn (s)')
ylabel('Heart rate (Hz)')
box off

g = 3;
AllPos = [];
for k = 1:length(RiskAsess.ToShockPos{2}{2})
    AllPos = [AllPos,(min(RiskAsess.ToShockPos{g}{3}{k}))];
    AllPos = [AllPos,(min(RiskAsess.ToShockPos{g}{2}{k}))];

end
[Y,X] = hist(AllPos,[0:0.05:1]);
bar(X,Y/sum(Y),'FaceColor','k')
set(gca,'LineWidth',2,'FontSize',15,'XTick',0:0.2:1)
ylabel('Proportion of turning events')