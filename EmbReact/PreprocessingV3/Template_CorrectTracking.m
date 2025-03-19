%% Umaze
clear all, close all
disp('1001')
FileNames=GetAllMouseTaskSessions(XXXXX);

%%
n=1;
AllDat=[];
th_immob=0.005;
thtps_immob=2;
smoofact=10;
smoofact_Acc = 30;
th_immob_Acc = 10000000;
figure(1),clf

DoSave=0; % set to one when you're sure everything is OK
DoPosition=0; % set to one or zero to see different figure
GlobalFigure=1;

CreateFinalBehavVariables_EmbReact_SB

%% Add drug treatment to ExpeInfo

disp('adding drug treatment')
for k = 1:length(FileNames)
    cd(FileNames{k})
    load('ExpeInfo.mat')
    ExpeInfo.DrugInjected = 'FLXCHRONIC'; % FLXCHRONIC MDZ FLX SALINE
    save('ExpeInfo.mat','ExpeInfo')
end

