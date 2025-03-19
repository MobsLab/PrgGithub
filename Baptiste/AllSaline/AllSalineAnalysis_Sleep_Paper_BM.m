
clear all

SessNames={'TestPre'};
Dir1=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPreNight'};
Dir2=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_EyeShockTempProt'};
Dir3=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_EyeShock'};
Dir4=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_PreDrug_TempProt'};
Dir5=PathForExperimentsEmbReact(SessNames{1});

SessNames={'TestPre_PreDrug'};
Dir6=PathForExperimentsEmbReact(SessNames{1});

Dir7=MergePathForExperiment(Dir1,Dir2);
Dir8=MergePathForExperiment(Dir3,Dir4);
Dir9=MergePathForExperiment(Dir5,Dir6);

Dir10=MergePathForExperiment(Dir7,Dir8);
Dir=MergePathForExperiment(Dir10,Dir9);


for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end

load('/media/nas6/ProjetEmbReact/transfer/Sess.mat')


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    if isempty(Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPre/'))))))
        UMazeSleepSess.(Mouse_names{mouse}){1} = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPre')))));
    else
        UMazeSleepSess.(Mouse_names{mouse}){1} = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPre/')))));
    end
    if isempty(Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost/'))))))
        if size(Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost'))))),2)==2
            clear A; A = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost')))));
            UMazeSleepSess.(Mouse_names{mouse}){2} = A(2);
        else
            UMazeSleepSess.(Mouse_names{mouse}){2} = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost')))));
        end
    else
        UMazeSleepSess.(Mouse_names{mouse}){2} = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'SleepPost/')))));
    end
end

%%
Mouse=[117 404 425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568 569 566 666 667 668 669 688 739 777 779 849 1144 1146 1147  1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];

%% generate sleep data
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:2
        try
            cd(UMazeSleepSess.(Mouse_names{mouse}){sess}{1})
            
            clear Wake SWSEpoch REMEpoch Sleep Epoch tRipples
            clear Sleep_ep Sto GoodEpoch
            load('StateEpochSB.mat', 'Wake' , 'SWSEpoch' , 'REMEpoch' , 'Sleep' , 'Epoch');
            
%             Sleep_ep = DurationEpoch(Sleep)/60e4;
%             Sto = Stop(Sleep);
%             i=1;
%             while sum(Sleep_ep(1:i))<40
%                 dur = sum(Sleep_ep(1:i))-40;
%                 GoodEpoch = intervalSet(0,Sto(i)-dur*60e4);
%                 i=i+1;
%             end
%             Sleep = and(Sleep , GoodEpoch);
%             try; tRipples = Restrict(tRipples , GoodEpoch); end
%             REMEpoch = and(REMEpoch , GoodEpoch);
%             SWSEpoch = and(SWSEpoch , GoodEpoch);
            
            try; load('SWR.mat','tRipples'); end
            Sleep_dur.(Mouse_names{mouse})(sess) = sum(Stop(Sleep)-Start(Sleep))/60e4;
            Sleep_prop.(Mouse_names{mouse})(sess) = sum(Stop(Sleep)-Start(Sleep))/(sum(Stop(Epoch)-Start(Epoch)) + sum(Stop(Wake)-Start(Wake)));
            Sleep_Dur.(Mouse_names{mouse}){sess} = DurationEpoch(Sleep)/60e4;
            Sleep_Dur.(Mouse_names{mouse}){sess}(Sleep_Dur.(Mouse_names{mouse}){sess}<1)==0;
            REM_Dur.(Mouse_names{mouse}){sess} = DurationEpoch(REMEpoch)/60e4;
            REM_prop.(Mouse_names{mouse})(sess) = sum(Stop(REMEpoch)-Start(REMEpoch))/sum(Stop(Sleep)-Start(Sleep));
            try
                Ripples_density.(Mouse_names{mouse})(sess) = length(Range(Restrict(tRipples,SWSEpoch)))/(sum(Stop(SWSEpoch)-Start(SWSEpoch))/1e4);
            catch
                Ripples_density.(Mouse_names{mouse})(sess) = NaN;
            end
            
        end
    end
    disp(Mouse_names{mouse})
end




for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        try; Sleep_dur_all(mouse,sess) = Sleep_dur.(Mouse_names{mouse})(sess); end
        try; Sleep_prop_all(mouse,sess) = Sleep_prop.(Mouse_names{mouse})(sess); end
        try; Sleep_EpNumb_all(mouse,sess) = size(Sleep_Dur.(Mouse_names{mouse}){sess},1); end
        try; Sleep_EpMeanDur_all(mouse,sess) = nanmean(Sleep_Dur.(Mouse_names{mouse}){sess}); end
        try; REM_EpNumb_all(mouse,sess) = size(REM_Dur.(Mouse_names{mouse}){sess},1); end
        try; REM_EpMeanDur_all(mouse,sess) = nanmean(REM_Dur.(Mouse_names{mouse}){sess}); end
        try; REM_prop_all(mouse,sess) = REM_prop.(Mouse_names{mouse})(sess); end
        try; Ripples_density_all(mouse,sess) = Ripples_density.(Mouse_names{mouse})(sess); end
        
    end
end
Sleep_EpNumb_all(Sleep_EpNumb_all==0)=NaN;
Sleep_EpMeanDur_all(Sleep_EpMeanDur_all==0)=NaN;
REM_EpNumb_all(REM_EpNumb_all==0)=NaN;
REM_EpMeanDur_all(REM_EpMeanDur_all==0)=NaN;
REM_EpMeanDur_all(REM_EpMeanDur_all>1.5)=NaN;




%% ripples
Ripples_Safe_Fz.Cond(Ripples_Safe_Fz.Cond==0) = NaN;
Ripples_Safe_Fz.Ext(Ripples_Safe_Fz.Ext==0) = NaN;
Ripples_Safe_Fz.Fear(Ripples_Safe_Fz.Fear==0) = NaN;

Ripples_Shock_Fz.Cond(Ripples_Safe_Fz.Cond==0) = NaN;
Ripples_Shock_Fz.Ext(Ripples_Safe_Fz.Ext==0) = NaN;
Ripples_Shock_Fz.Fear(Ripples_Safe_Fz.Fear==0) = NaN;


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Ripples_Shock_Fz.Cond Ripples_Safe_Fz.Cond},Cols,X,Legends,'showpoints',1,'paired',0);
subplot(132)
MakeSpreadAndBoxPlot2_SB({Ripples_Shock_Fz.Ext Ripples_Safe_Fz.Ext},Cols,X,Legends,'showpoints',1,'paired',0);
subplot(133)
MakeSpreadAndBoxPlot2_SB({Ripples_Shock_Fz.Fear Ripples_Safe_Fz.Fear},Cols,X,Legends,'showpoints',1,'paired',0);



%% Sleep
Cols2={[.6 .1 .2],[.6 .3 .5]};
X2=[1:2];
Legends2={'Sleep Pre','Sleep Post'};

ind_sup_twenty = and(Sleep_dur_all(:,1)>20 , Sleep_dur_all(:,2)>20);
ind_sup_fourty = and(Sleep_dur_all(:,1)>40 , Sleep_dur_all(:,2)>40);
ind_sup_hour = and(Sleep_dur_all(:,1)>39 , Sleep_dur_all(:,2)>39);
ind_sup_hour_PAG = and(Sleep_dur_all(1:26,1)>39 , Sleep_dur_all(1:26,2)>39);
ind_sup_hour_eyelid = logical(ind_sup_hour.*([zeros(1,26) ones(1,24)]'));
Ripples_density_all(Ripples_density_all>2)=NaN;
REM_prop_all(REM_prop_all>.2)=NaN;

figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Sleep_dur_all(ind_sup_twenty,1) Sleep_dur_all(ind_sup_twenty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Sleep duration')
ylabel('time (min)')
subplot(132)
clear A; A=Ripples_density_all; A(Ripples_density_all(:,1)<.3,:)=NaN;;
MakeSpreadAndBoxPlot2_SB({A(ind_sup_twenty,1) A(ind_sup_twenty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Ripples density')
ylabel('#/s')
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_prop_all(ind_sup_twenty,1) REM_prop_all(ind_sup_twenty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('REM proportion')
ylabel('prop.')

a=suptitle('Sleep time > 20 min'); a.FontSize=20;




figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Sleep_dur_all(ind_sup_hour,1) Sleep_dur_all(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Sleep duration')
ylabel('time (min)')
subplot(132)
clear A; A=Ripples_density_all; A(Ripples_density_all(:,1)<.3,:)=NaN;
MakeSpreadAndBoxPlot2_SB({A(ind_sup_hour,1) A(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
% MakeSpreadAndBoxPlot2_SB({Ripples_density_all(ind_sup_hour,1) Ripples_density_all(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Ripples density')
ylabel('#/s')
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_prop_all(ind_sup_hour,1) REM_prop_all(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('REM proportion')
ylabel('prop.')

a=suptitle('Sleep time = 50 min'); a.FontSize=20;


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Sleep_dur_all(ind_sup_fourty,1) Sleep_dur_all(ind_sup_fourty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Sleep duration')
ylabel('time (min)')
subplot(132)
clear A; A=Ripples_density_all; A(Ripples_density_all(:,1)<.3,:)=NaN;;
MakeSpreadAndBoxPlot2_SB({A(ind_sup_fourty,1) A(ind_sup_fourty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Ripples density')
ylabel('#/s')
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_prop_all(ind_sup_fourty,1) REM_prop_all(ind_sup_fourty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('REM proportion')
ylabel('prop.')

a=suptitle('Sleep time > 20 min'); a.FontSize=20;






figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Sleep_dur_all(ind_sup_fourty,1) Sleep_dur_all(ind_sup_fourty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Sleep duration')
ylabel('time (min)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({Ripples_density_all(ind_sup_fourty,1) Ripples_density_all(ind_sup_fourty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('Ripples density')
ylabel('#/s')
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_prop_all(ind_sup_fourty,1) REM_prop_all(ind_sup_fourty,2)},Cols2,X2,Legends2,'showpoints',0,'paired',1,'optiontest','ttest');
title('REM proportion')
ylabel('prop.')

a=suptitle('Sleep time > 40 min'); a.FontSize=20;


figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Sleep_dur_all(ind_sup_hour,1) Sleep_dur_all(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',1,'paired',0,'optiontest','ttest');
title('Sleep duration')
ylabel('time (min)')
subplot(132)
MakeSpreadAndBoxPlot2_SB({Ripples_density_all(ind_sup_hour,1) Ripples_density_all(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',1,'paired',0,'optiontest','ttest');
title('Ripples density')
ylabel('#/s')
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_prop_all(ind_sup_hour,1) REM_prop_all(ind_sup_hour,2)},Cols2,X2,Legends2,'showpoints',1,'paired',0,'optiontest','ttest');
title('REM proportion')
ylabel('prop.')

a=suptitle('Sleep time > 60 min'); a.FontSize=20;


%% splitting PAG eyelid
Cols={[1 .5 .5],[.5 .5 1],[1 .8 .8],[.8 .8 1]};
X=[1:4];
Legends={'Shock PAG','Safe PAG','Shock Eyelid','Safe Eyelid'};

figure; sess=2;
MakeSpreadAndBoxPlot2_SB({Ripples_Shock_Fz.(Session_type{sess})(1:21) Ripples_Safe_Fz.(Session_type{sess})(1:21) Ripples_Shock_Fz.(Session_type{sess})(22:end) Ripples_Safe_Fz.(Session_type{sess})(22:end)},Cols,X,Legends,'showpoints',1,'paired',0)



Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

figure; sess=2;
MakeSpreadAndBoxPlot3_SB({Ripples_Shock_Fz.(Session_type{sess})(22:end) Ripples_Safe_Fz.(Session_type{sess})(22:end)},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('#/s')
title('Ripples density')

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({HR_Shock_Fz.Cond(22:end) HR_Safe_Fz.Cond(22:end)},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('Frequency (Hz)')
title('Heart rate')

subplot(122)
MakeSpreadAndBoxPlot3_SB({HR_Var_Shock_Fz.Cond(22:end) HR_Var_Safe_Fz.Cond(22:end)},Cols,X,Legends,'showpoints',0,'paired',1)
title('Heart rate variability')

figure; sess=2;
MakeSpreadAndBoxPlot3_SB({Respi_Shock_Fz.(Session_type{sess})(22:end) Respi_Safe_Fz.(Session_type{sess})(22:end)},Cols,X,Legends,'showpoints',0,'paired',1)
ylabel('Frequency (Hz)')
title('Breathing')

