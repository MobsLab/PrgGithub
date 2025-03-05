

clear all

Dir1 = PathForExperimentsOB({'Labneh'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Labneh'}, 'freely-moving','none');
Dir{1} = MergePathForExperiment(Dir1,Dir2);

Dir1 = PathForExperimentsOB({'Brynza'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Brynza'}, 'freely-moving','none');
Dir{2} = MergePathForExperiment(Dir1,Dir2);

Dir1 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','none');
Dir{3} = MergePathForExperiment(Dir1,Dir2);


%% transitions
for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        clear Epoch TotalNoiseEpoch Sleep Wake SWSEpoch REMEpoch Epoch_01_05
        load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'],'Epoch','TotalNoiseEpoch','Sleep',...
            'Wake', 'SWSEpoch', 'REMEpoch', 'Epoch_01_05')
        if sum(DurationEpoch(SWSEpoch))/3600e4>1
            
            Wake = or(Wake , TotalNoiseEpoch);
            Wake = mergeCloseIntervals(Wake,3e4);
            Wake = dropShortIntervals(Wake,3e4);
            REMEpoch = mergeCloseIntervals(REMEpoch,3e4);
            REMEpoch = dropShortIntervals(REMEpoch,3e4);
            NREM2 = and(Epoch_01_05 , SWSEpoch);
            NREM2 = mergeCloseIntervals(NREM2,3e4);
            NREM2 = dropShortIntervals(NREM2,3e4);
            NREM1 = SWSEpoch-Epoch_01_05;
            NREM1 = mergeCloseIntervals(NREM1,3e4);
            NREM1 = dropShortIntervals(NREM1,3e4);
            TotDur = sum(DurationEpoch(or(Epoch,TotalNoiseEpoch)))./3.6e7;
            
            for states=1:4
                if states==1
                    State = Wake;
                elseif states==2
                    State = NREM1;
                elseif states==3
                    State = NREM2;
                elseif states==4
                    State = REMEpoch;
                end
                if states<2
                    State_Prop{ferret}(sess,states) = sum(DurationEpoch(and(State , Epoch)))./sum(DurationEpoch(Epoch));
                    State_Number{ferret}(sess,states) = length(Start(and(State , Epoch)))./(sum(DurationEpoch(Epoch))/3600e4);
                else
                    State_Prop{ferret}(sess,states) = sum(DurationEpoch(and(State , Epoch)))./sum(DurationEpoch(Sleep));
                    State_Number{ferret}(sess,states) = length(Start(and(State , Epoch)))./(sum(DurationEpoch(Sleep))/3600e4);
                end
                State_MeanDur{ferret}(sess,states) = nanmedian(DurationEpoch(and(State , Epoch)))/1e4;
                
                try
                    State = dropShortIntervals(State , 30e4);
                    clear St, St = Start(and(State , Epoch))/1e4;
                    State_FirstOnset{ferret}(sess,states) = St(1);
                end
            end
            
            clear Trans_Wake_NREM1 Trans_NREM1_Wake
            [aft_cell,bef_cell]=transEpoch(NREM1,Wake);
            Trans_Wake_NREM1 = Start(bef_cell{1,2}); % beginning of all NREM1 that is preceded by Wake
            Trans_NREM1_Wake = Start(bef_cell{2,1}); % beginning of all Wake  that is preceded by NREM1
            TRANSITIONS{ferret}(sess,1) = length(Trans_Wake_NREM1)./TotDur;
            TRANSITIONS{ferret}(sess,2) = length(Trans_NREM1_Wake)./TotDur;
            
            clear Trans_Wake_NREM2 Trans_NREM2_Wake
            [aft_cell,bef_cell]=transEpoch(NREM2,Wake);
            Trans_Wake_NREM2 = Start(bef_cell{1,2}); % beginning of all NREM2 that is preceded by Wake
            Trans_NREM2_Wake = Start(bef_cell{2,1}); % beginning of all Wake  that is preceded by NREM2
            TRANSITIONS{ferret}(sess,3) = length(Trans_Wake_NREM2)./TotDur;
            TRANSITIONS{ferret}(sess,4) = length(Trans_NREM2_Wake)./TotDur;
            
            clear Trans_Wake_REM Trans_REM_Wake
            [aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
            Trans_Wake_REM = Start(bef_cell{1,2}); % beginning of all REM that is preceded by Wake
            Trans_REM_Wake = Start(bef_cell{2,1}); % beginning of all Wake  that is preceded by REM
            TRANSITIONS{ferret}(sess,5) = length(Trans_Wake_REM)./TotDur;
            TRANSITIONS{ferret}(sess,6) = length(Trans_REM_Wake)./TotDur;
            
            clear Trans_REM_NREM1 Trans_NREM1_REM
            [aft_cell,bef_cell]=transEpoch(NREM1,REMEpoch);
            Trans_REM_NREM1 = Start(bef_cell{1,2}); % beginning of all NREM1 that is preceded by REM
            Trans_NREM1_REM = Start(bef_cell{2,1}); % beginning of all REM  that is preceded by NREM1
            TRANSITIONS{ferret}(sess,7) = length(Trans_REM_NREM1)./TotDur;
            TRANSITIONS{ferret}(sess,8) = length(Trans_NREM1_REM)./TotDur;
            
            clear Trans_REM_NREM2 Trans_NREM2_REM
            [aft_cell,bef_cell]=transEpoch(NREM2,REMEpoch);
            Trans_REM_NREM2 = Start(bef_cell{1,2}); % beginning of all NREM2 that is preceded by REM
            Trans_NREM2_REM = Start(bef_cell{2,1}); % beginning of all REM  that is preceded by NREM2
            TRANSITIONS{ferret}(sess,9) = length(Trans_REM_NREM2)./TotDur;
            TRANSITIONS{ferret}(sess,10) = length(Trans_NREM2_REM)./TotDur;
            
            clear Trans_NREM1_NREM2 Trans_NREM2_NREM1
            [aft_cell,bef_cell]=transEpoch(NREM2,NREM1);
            Trans_NREM1_NREM2 = Start(bef_cell{1,2}); % beginning of all NREM2 that is preceded by NREM1
            Trans_NREM2_NREM1 = Start(bef_cell{2,1}); % beginning of all NREM1  that is preceded by NREM2
            TRANSITIONS{ferret}(sess,11) = length(Trans_NREM1_NREM2)./TotDur;
            TRANSITIONS{ferret}(sess,12) = length(Trans_NREM2_NREM1)./TotDur;
            
            disp(sess)
        end
    end
    TRANSITIONS{ferret}(TRANSITIONS{ferret}(:,1)==0,:) = NaN;
    State_Prop{ferret}(State_Prop{ferret}==0)=NaN;
    State_MeanDur{ferret}(State_MeanDur{ferret}==0)=NaN;
    State_Number{ferret}(State_Number{ferret}==0)=NaN;
    State_FirstOnset{ferret}(State_FirstOnset{ferret}==0)=NaN;
end



%% figures
Cols={[0 0 1],[.8 .5 .2],[1 0 0],[0 1 0]};
X = 1:4;
Legends = {'Wake','N1','N2','REM'};
NoLegends = {'','','',''};

ferret=2;
figure
subplot(141)
MakeSpreadAndBoxPlot3_SB({State_Prop{ferret}(:,1) State_Prop{ferret}(:,2) State_Prop{ferret}(:,3)...
    State_Prop{ferret}(:,4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('proportion')
makepretty_BM2

subplot(142)
MakeSpreadAndBoxPlot3_SB({State_MeanDur{ferret}(:,1) State_MeanDur{ferret}(:,2) State_MeanDur{ferret}(:,3)...
    State_MeanDur{ferret}(:,4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('mean dur (s)')
makepretty_BM2

subplot(143)
MakeSpreadAndBoxPlot3_SB({State_Number{ferret}(:,1) State_Number{ferret}(:,2) State_Number{ferret}(:,3)...
    State_Number{ferret}(:,4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('ep occurence')
makepretty_BM2

subplot(144)
MakeSpreadAndBoxPlot3_SB({State_FirstOnset{ferret}(:,1) State_FirstOnset{ferret}(:,2) State_FirstOnset{ferret}(:,3)...
    State_FirstOnset{ferret}(:,4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('first onset (s)')
makepretty_BM2




Cols2 = {[.3 .3 .3],[.3 .3 .3],[.3 .3 .3],[.3 .3 .3],[.3 .3 .3],[.3 .3 .3],[.3 .3 .3],...
    [.3 .3 .3],[.3 .3 .3],[.3 .3 .3],[.3 .3 .3],[.3 .3 .3]};
X2 = 1:12;
Legends2 = {'Wake-NREM1','NREM1-Wake','Wake-NREM2','NREM2-Wake','Wake-REM','REM-Wake','REM-NREM1',...
    'NREM1-REM','REM-NREM2','NREM2-REM','NREM1-NREM2','NREM2-NREM1'};

figure, n=1;
for ferret=2:3
    subplot(1,2,n)
    MakeSpreadAndBoxPlot3_SB({TRANSITIONS{ferret}(:,1) TRANSITIONS{ferret}(:,2) TRANSITIONS{ferret}(:,3)...
        TRANSITIONS{ferret}(:,4) TRANSITIONS{ferret}(:,5) TRANSITIONS{ferret}(:,6) TRANSITIONS{ferret}(:,7)...
        TRANSITIONS{ferret}(:,8) TRANSITIONS{ferret}(:,9) TRANSITIONS{ferret}(:,10) TRANSITIONS{ferret}(:,11)...
        TRANSITIONS{ferret}(:,12)}...
        ,Cols2,X2,Legends2,'showpoints',1,'paired',0,'showsigstar','none');
    if ferret==2, ylabel('transitions (#/recording hour)'), end
    title(['Ferret ' num2str(ferret)])
    ylim([0 16])
    n = n+1;
    makepretty_BM2
end



draw_curved_arrows(round(nanmedian(State_Prop{3})*100), Cols, nanmedian(TRANSITIONS{3}), Cols2)









for sp=1:2
    if sp==1
        Sleep_Path = SleepInfo_mouse.path{1};
    else
        Sleep_Path = SleepInfo_ferret.path{3};
    end
    for f=1:length(Sleep_Path)
        load([Sleep_Path{f} '/SleepScoring_OBGamma.mat'],'Epoch','Sleep','Wake','SWSEpoch','REMEpoch')
        disp(Sleep_Path{f})
    end
end






