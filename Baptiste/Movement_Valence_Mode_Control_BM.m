
clear all

Dir_PAG=PathForExperimentsERC('UMazePAG');
Dir_MFB=PathForExperimentsERC('StimMFBWake');
Dir_Novel=PathForExperimentsERC('Novel');
Dir_Knwon=PathForExperimentsERC('Known');

%%
smoofact_Acc = 30;
th_immob_Acc = 1.7e7;
thtps_immob = 2;

%%
Par = {'Neg','Pos','Novel','Knwon'};
for par = 1:length(Par)
    if par==1
        DIR = Dir_PAG;
    elseif par==2
        DIR = Dir_MFB;
    elseif par==3
        DIR = Dir_Novel;
    elseif par==4
        DIR = Dir_Knwon;
    end
    
    for mouse=1:length(DIR.path)
        try
            clear MovAcctsd Vtsd FreezeAccEpoch SessionEpoch FreezeEpoch SafeZone
            load([DIR.path{mouse}{1} 'behavResources.mat'],'MovAcctsd','Vtsd','SessionEpoch', 'ZoneEpoch')
            
            CondEpoch{par}{mouse} =  or(or(SessionEpoch.Cond1, SessionEpoch.Cond2) , or(SessionEpoch.Cond3,SessionEpoch.Cond4));
            try
                HabEpoch{par}{mouse} = or(SessionEpoch.Hab1, SessionEpoch.Hab2);
            catch
                try
                    HabEpoch{par}{mouse} = SessionEpoch.Hab;
                catch
                    HabEpoch{par}{mouse} = or(or(SessionEpoch.TestPre1, SessionEpoch.TestPre2) , or(SessionEpoch.TestPre3,SessionEpoch.TestPre4));
                end
            end
            
            
            Epoch_to_use = CondEpoch{par}{mouse};
            try
                SafeZone = or(or(ZoneEpoch.FarNoShock , ZoneEpoch.CentreNoShock) , ZoneEpoch.NoShock);
            catch
                SafeZone = or(ZoneEpoch.CentreNoShock , ZoneEpoch.CentreNoShock);
            end
            Acc{par}{mouse} = Restrict(MovAcctsd , Epoch_to_use);
            Speed{par}{mouse} = Restrict(Vtsd , Epoch_to_use);
            R = Range(Speed{par}{mouse});
            TotDur{par}(mouse) = R(end)-R(1);
            
            NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
            FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
            FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
            FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
            FreezeSafe = and(SafeZone , FreezeAccEpoch);
            
            try
                FreezeProp{par}(mouse)= sum(DurationEpoch(and(FreezeSafe , Epoch_to_use)))./TotDur{par}(mouse);
                FreezeMedianDur{par}(mouse)= nanmedian(DurationEpoch(FreezeSafe))./1e4;
                %         catch
                %             FreezeProp{par}(mouse) = sum(DurationEpoch(and(FreezeEpoch , Epoch_to_use)))./TotDur{par}(mouse);
                disp([par mouse])
            end
            
        end
    end
end



for par = 1:length(Par)
    for mouse=1:length(Acc{par})
        
        h=histogram(log10(Data(Acc{par}{mouse})),'BinLimits',[5 9],'NumBins',20);
        HistData_Acc{par}(mouse,:) = h.Values;
        
        h=histogram(log10(Data(Speed{par}{mouse})),'BinLimits',[-2.2 1.7],'NumBins',20);
        HistData_Speed{par}(mouse,:) = h.Values;
        
        Mean_Acc{par}(mouse) = nanmean(log10(Data(Acc{par}{mouse})));
        Std_Acc{par}(mouse) = nanstd(log10(Data(Acc{par}{mouse})));
        D = Data(Speed{par}{mouse}); D(D==0) = NaN;
        Mean_Speed{par}(mouse) = nanmean(log10(D));
        Mean_Speednolog{par}(mouse) = nanmean(D);
        Std_Speed{par}(mouse) = nanstd(log10(D));
        
    end
end


figure
for par=1:4
    subplot(2,2,par)
    bar(nanmean(HistData_Acc{par}))
    vline(75,'--k')
end

figure
for par=1:4
    subplot(2,2,par)
    bar(nanmean(HistData_Speed{par}))
    vline(15,'--k')
end



Cols={[.89 .5 .5],[.5 .89 .5],[.5 .5 .89],[.7 .5 .89]};
X=[1:4];
Legends=Par;

figure
MakeSpreadAndBoxPlot3_SB(Mean_Speed,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Speed (log scale)')
makepretty_BM2


figure
MakeSpreadAndBoxPlot3_SB(FreezeProp,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Immobility (proportion)')
makepretty_BM2


figure
MakeSpreadAndBoxPlot3_SB(Mean_Speednolog,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Speed (cm/s)')
makepretty_BM2

%% Occupancy along linear distance

clear all
GetAllSalineSessions_BM
Session_type={'TestPre','TestPost'};
Mouse=Drugs_Groups_UMaze_BM(11);

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
%         LinearDistance{sess}{mouse} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'LinearPosition');
        h=histogram(Data(LinearDistance{sess}{mouse} ),'BinLimits',[0 1],'NumBins',20);
        HistData_LinPos{sess}(mouse,:)= h.Values./sum(h.Values);
        
    end
end


figure
Data_to_use = runmean(HistData_LinPos{1}',5)';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Data_to_use = runmean(HistData_LinPos{2}',5)';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
color= [.85, .325, .1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlabel('linear ditance (a.u.)'), ylabel('occupancy (a.u.)')
f=get(gca,'Children'); legend([f([5 1])],'Habituation','Conditioning');
vline(.3,'--k')
makepretty_BM


figure
subplot(211)
DATA = HistData_LinPos{1};
txt = 'occupancy';
val = .35;
smootime = .1;
bin_size = 20;
x =linspace(0,1,bin_size);

area([-.1 .29] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
hold on
area([.29 .447] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [.8 .8] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

errhigh = nanstd(DATA)/sqrt(size(DATA,1));
errlow  = zeros(1,bin_size);

b=bar(x,nanmean(DATA));
b.FaceColor=[.3 .3 .3];

box off

er = errorbar(x,nanmean(DATA),errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
ylabel(txt)
xlim([-.05 1.05]), ylim([0 val])


subplot(212)
DATA = HistData_LinPos{2};

area([-.1 .29] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
hold on
area([.29 .447] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
area([.447 .552] , [.8 .8] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
area([.552 .71] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
area([.71 1.1] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)

errhigh = nanstd(DATA)/sqrt(size(DATA,1));
errlow  = zeros(1,bin_size);

b=bar(x,nanmean(DATA));
b.FaceColor=[.3 .3 .3];

box off

er = errorbar(x,nanmean(DATA),errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
xlabel('linear distance'), ylabel(txt)
xlim([-.05 1.05]), ylim([0 val])
