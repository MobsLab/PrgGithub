%% change channels to analyse
%% mouse 876 baseline
cd('/media/mobschapeau/2D373EF5372BA96B/M877/sleepD11-12')
%expeinfo
load('ExpeInfo.mat')
ExpeInfo.ChannelToAnalyse.dHPC_deep=2;

%remove
% 
%ExpeInfo.ChannelToAnalyse=rmfield(ExpeInfo.ChannelToAnalyse,'EKG');


%save
save('ExpeInfo.mat','ExpeInfo')

%chantoanalyse
cd('/media/mobschapeau/2D373EF5372BA96B/M877/sleepD11-12/ChannelsToAnalyse/')
%channel=9; save('Ref.mat','channel');
%channel=13; save('Bulb_deep.mat','channel');
%channel=10; save('dHPC_sup.mat','channel');
channel=2; save('dHPC_deep.mat','channel');
%channel=0; save('PFCx_deep.mat','channel');
%channel=0; save('PFCx_spindle.mat','channel');

%delete
%delete('EKG.mat');



%% mouse 875 Umaze
cd('/media/mobschapeau/2D373EF5372BA96B/M893/Umaze')
load('ExpeInfo.mat')

FileNames=GetAllMouseTaskSessions(893);

for k = 1:length(FileNames)
    cd(FileNames{k})
    load('ExpeInfo.mat')
ExpeInfo.ChannelToAnalyse.Ref=9;
ExpeInfo.ChannelToAnalyse.Bulb_deep=13;
ExpeInfo.ChannelToAnalyse.dHPC_sup=10;
ExpeInfo.ChannelToAnalyse.PFCx_sup=27;
ExpeInfo.ChannelToAnalyse.PFCx_deep=0;
ExpeInfo.ChannelToAnalyse.PFCx_spindle=0;
%remove
% 
if k>16
ExpeInfo.ChannelToAnalyse=rmfield(ExpeInfo.ChannelToAnalyse,'EKG');
end


%ExpeInfo.ChannelToAnalyse=rmfield(ExpeInfo.ChannelToAnalyse,'PFCx_spindle');
%save
save('ExpeInfo.mat','ExpeInfo')

    %chantoanalyse
    cd(strcat(FileNames{k},'ChannelsToAnalyse/'))
    channel=9; save('Ref.mat','channel');
channel=13; save('Bulb_deep.mat','channel');
channel=10; save('dHPC_sup.mat','channel');
channel=27; save('PFCx_sup.mat','channel');
channel=0; save('PFCx_deep.mat','channel');
channel=0; save('PFCx_spindle.mat','channel');

%delete

delete('EKG.mat');
end

