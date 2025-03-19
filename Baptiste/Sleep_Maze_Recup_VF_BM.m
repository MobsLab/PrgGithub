

clear all
% preliminary variables
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Group=[22];
Session_type={'sleep_pre','sleep_post'};
States={'Sleep','Wake','NREM','REM'};
sta = [3 2 4 5];
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] =...
            MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples');
    end
end


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:2
            for state=1:length(States)
                try
                    if sess==1
                        if state==1 % sleep
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,3};
                            Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                            Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,1};
                        elseif state==2 % wake
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,2};
                            Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                            Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,1};
                            Epoch_to_use{3} = Epoch1.(Session_type{sess}){mouse,3};
                        elseif state==3 % NREM
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,4};
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,3};
                        elseif state==4 % REM
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,5};
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,3};
                        end
                    else % for sleep post, restrict to first 60 min
                        if state==1 % sleep
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,3};
                            Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                            Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                            Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,60*60e4));
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,1};
                            Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,60*60e4));
                        elseif state==2 % wake
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,2};
                            Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                            Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                            Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,60*60e4));
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,1};
                            Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,60*60e4));
                            Epoch_to_use{3} = Epoch1.(Session_type{sess}){mouse,3};
                            Epoch_to_use{3} = and(Epoch_to_use{3} , intervalSet(0,60*60e4));
                        elseif state==3 % NREM
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,4};
                            Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,60*60e4));
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,3};
                            Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,60*60e4));
                        elseif state==4 % REM
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,5};
                            Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,60*60e4));
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,3};
                            Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,60*60e4));
                        end
                    end
                    Prop.(States{state}){sess}{n}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                    MeanDur.(States{state}){sess}{n}(mouse) = nanmean(DurationEpoch(Epoch_to_use{1}))/1e4;
                    MedianDur.(States{state}){sess}{n}(mouse) = nanmedian(DurationEpoch(Epoch_to_use{1}))/1e4;
                    EpNumb.(States{state}){sess}{n}(mouse) = length(Start(Epoch_to_use{1}));
                    try
                        LatencyToState_pre.(States{state}){sess}{n}{mouse} = Start(Epoch_to_use{1})/1e4;
                        State_Duration.(States{state}){sess}{n}{mouse} = DurationEpoch(Epoch_to_use{1})/1e4;
                        LatencyToState.(States{state}){sess}{n}(mouse) = LatencyToState_pre.(States{state}){sess}{mouse}(find(State_Duration.(States{state}){sess}{mouse}>20,1));
                    end
                    TotDur.(States{state}){sess}{n}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/60e4;
                    if sess<3
                        try, SFI.(States{state}){sess}{n} = EpNumb.(States{state}){sess}{n}./(sum(DurationEpoch(Epoch_to_use{3}))/3600e4); end
                    else
                        try, SFI.(States{state}){sess}{n} = EpNumb.(States{state}){sess}{n}./(sum(DurationEpoch(Epoch_to_use{1}))/3600e4); end
                    end

                    if state==3
                        try
                            RipplesDensity{sess}{n}(mouse) = length(Data(Restrict(OutPutData.(Session_type{sess}).ripples.ts{mouse,4} , Epoch_to_use{1})))./(sum(DurationEpoch(Epoch_to_use{1}))/1e4);
                            RipplesDensity{sess}{n}(RipplesDensity{sess}{n}==0) = NaN;
                        end
                    end
                end
            end
        end
        disp(Mouse_names{mouse})
    end
    n=n+1;
end

Prop.Wake{2}{1}(Prop.Wake{2}{1}==0)=NaN;
Prop.REM{2}{1}(Prop.REM{2}{1}==0)=NaN;

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        
        clear D, D = Data(L.OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
        Prop_shock(n,mouse) = sum(D>4.5)/length(D);
        Prop_safe(n,mouse) = sum(D<4.5)/length(D);
        Length_shock(n,mouse) = sum(D>4.5)*.2;
        
        clear D_shock, D_shock = Data(L.OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
        Prop_shockShock(n,mouse) = sum(D_shock>4.5)/length(D);
        Prop_safeShock(n,mouse) = sum(D_shock<4.5)/length(D);
        clear D_safe, D_safe = Data(L.OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
        Prop_shockSafe(n,mouse) = sum(D_safe>4.5)/length(D);
        Prop_safeSafe(n,mouse) = sum(D_safe<4.5)/length(D);
        
    end
    n=n+1;
end



figure
subplot(223)
PlotCorrelations_BM(L.DATA_SAL(1,30:58) , Prop.Wake{2}{1})
xlabel('Breathing safe, Cond'), ylabel('Wake proportion, Sleep Post')
axis square
subplot(224)
PlotCorrelations_BM(L.DATA_SAL(1,30:58) , Prop.REM{2}{1})
xlabel('Breathing safe, Cond'), ylabel('REM proportion, Sleep Post')
axis square

figure
subplot(221)
PlotCorrelations_BM(L.DATA_SAL(1,1:29) , Prop.Wake{2}{1})
xlabel('Breathing shock, Cond'), ylabel('Wake proportion, Sleep Post')
axis square
subplot(222)
PlotCorrelations_BM(L.DATA_SAL(1,1:29) , Prop.REM{2}{1})
xlabel('Breathing shock, Cond'), ylabel('REM proportion, Sleep Post')
axis square

figure
subplot(121)
PlotCorrelations_BM(Prop_shock , Prop.Wake{2}{1})
xlabel('Breathing > 4.5Hz, Cond'), ylabel('Wake proportion, Sleep Post')
axis square
subplot(122)
PlotCorrelations_BM(Prop_shock , Prop.REM{2}{1})
xlabel('Breathing > 4.5Hz, Cond'), ylabel('REM proportion, Sleep Post')
axis square




figure
subplot(121)
PlotCorrelations_BM(log10(Length_shock) , Prop.Wake{2}{1})
subplot(122)
PlotCorrelations_BM(log10(Length_shock) , Prop.REM{2}{1})





%% ANR figures 2024
Cols = {[.3 .3 .3],[.5 .5 .5]};
X = 1:2;
Legends = {'Sleep Pre','Sleep Post'};


figure
subplot(241)
MakeSpreadAndBoxPlot3_SB({Prop.Wake{1}{1} Prop.Wake{2}{1}},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Wake prop')
ylim([0 1.1])
title('Saline')

subplot(245)
MakeSpreadAndBoxPlot3_SB({Prop.REM{1}{1} Prop.REM{2}{1}},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('REM prop')
ylim([0 .27])


DZP = load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_DZP_Sleep.mat','Prop');
DZP.Prop.REM{2}{1}([1:2 5 9])=NaN;
DZP.Prop.Wake{2}{1}([1:2 5 9])=NaN;

Cols = {[.3, .745, .93],[.85, .325, .098]};
X = 1:2;
Legends = {'Saline','Diazepam'};

subplot(242)
MakeSpreadAndBoxPlot3_SB({DZP.Prop.Wake{2}{1} DZP.Prop.Wake{2}{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.1])
title('Sleep Post')

subplot(246)
MakeSpreadAndBoxPlot3_SB({DZP.Prop.REM{2}{1} DZP.Prop.REM{2}{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM prop')
ylim([0 .27])


RIP = load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Sleep.mat','MnWk','REM_1hr');

Cols = {[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X = [1:2];
Legends = {'RipControl','RipInhib'};

subplot(243)
MakeSpreadAndBoxPlot3_SB({RIP.MnWk.sleep_post(1,:) RIP.MnWk.sleep_post(2,:)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.1])
title('Sleep Post')

subplot(247)
MakeSpreadAndBoxPlot3_SB({RIP.REM_1hr.sleep_post(1,:) RIP.REM_1hr.sleep_post(2,:)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .27])


SDS = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/SD_Sleep.mat','Prop');

Cols = {[.3 .3 .3],[.8 .3 .3]};
X = [1:2];
Legends = {'Ctrl','SDS'};

subplot(244)
MakeSpreadAndBoxPlot3_SB(SDS.Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.1])
title('Sleep Post')

subplot(248)
MakeSpreadAndBoxPlot3_SB(SDS.Prop.REM,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .27])



