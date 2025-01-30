% %M507
% clear all
% MouseNum=507;
% FileNames=GetAllMouseTaskSessions(MouseNum);
% CurrSessName='M507-20170201-SpikesAllTogether.xml';
% FolderName='M507-20170201-SpikesAllTogether';
% GoTo='/media/sophie/My Passport1/ProjectEmbReac/Mouse507/20170201/SpikeSortAllTogether';
% NumSessions=23;
% LoafingAndSplittingSpikes


% M508
clear all
MouseNum=508;
FileNames=GetAllMouseTaskSessions(MouseNum);
CurrSessName='M508-20170203-SpikesAllTogether.xml';
FolderName='M508-20170203-SpikesAllTogether';
GoTo='/media/sophie/My Passport1/ProjectEmbReac/Mouse508/20170203/SpikeSortAllTogether';
NumSessions=23;
LoafingAndSplittingSpikes


%% M510
clear all
MouseNum=510;
FileNames=GetAllMouseTaskSessions(MouseNum);
CurrSessName='M510-20170209-SpikesAllTogether.xml';
FolderName='M510-20170209-SpikesAllTogether';
GoTo='/media/sophie/My Passport1/ProjectEmbReac/Mouse510/20170209/SpikeSortAllTogether';
NumSessions=23;
LoafingAndSplittingSpikes

%% M490
clear all
MouseNum=490;
FileNames=GetAllMouseTaskSessions(MouseNum);
CurrSessName='ProjectEmbReact_M490.xml';
FolderName='ProjectEmbReact_M490';
GoTo='/media/sophie/My Passport/ProjectEmbReac/Mouse490/20161201/SpikeSortingAllTogether';
NumSessions=23;
LoafingAndSplittingSpikes

% %% M512
% clear all
% CurrSessName='M512-20170208-SpikesAllTogether.xml';
% FolderName='M512-20170208-SpikesAllTogether';
% GoTo='/media/sophie/My Passport/ProjectEmbReac/Mouse512/SpikeSorting';
% NumSessions=23;
% LoafingAndSplittingSpikes

%M514
clear all
MouseNum=514;
FileNames=GetAllMouseTaskSessions(MouseNum);
CurrSessName='ProjectEmbReact_M514.xml';
FolderName='ProjectEmbReact_M514';
GoTo='/media/sophie/My Passport/ProjectEmbReac/Mouse514/SpikeSorting';
NumSessions=23;
LoafingAndSplittingSpikes


%M514
clear all
MouseNum=514;
FileNames=GetAllMouseTaskSessions(MouseNum);
CurrSessName='ProjectEmbReact_M514.xml';
FolderName='ProjectEmbReact_M514';
GoTo='/media/sophie/My Passport/ProjectEmbReac/Mouse514/SpikeSorting';
NumSessions=23;
LoafingAndSplittingSpikes
 
%% spike connectivity
% clear all
% Options.Window=[1.5,4]; 
% Options.ExcitLim=2;     
% Options.InhibLim=1;
% cd('/media/sophie/My Passport1/ProjectEmbReac/Mouse507/20170201/SpikeSortAllTogether')
% load('SpikeData.mat')
% [SpikeConn,SpikeConnStr]=MonoSynapticConnectivity(S,Options);
% save('NeurConnectivity.mat','SpikeConn','SpikeConnStr','Options') 

clear all
Options.Window=[1.5,4]; 
Options.ExcitLim=2;     
Options.InhibLim=1;
cd('/media/sophie/My Passport1/ProjectEmbReac/Mouse508/20170203/SpikeSortAllTogether')
load('SpikeData.mat')
[SpikeConn,SpikeConnStr]=MonoSynapticConnectivity(S,Options);
save('NeurConnectivity.mat','SpikeConn','SpikeConnStr','Options') 


clear all
Options.Window=[1.5,4]; 
Options.ExcitLim=2;     
Options.InhibLim=1;
cd('/media/sophie/My Passport1/ProjectEmbReac/Mouse510/20170209/SpikeSortAllTogether')
load('SpikeData.mat')
[SpikeConn,SpikeConnStr]=MonoSynapticConnectivity(S,Options);
save('NeurConnectivity.mat','SpikeConn','SpikeConnStr','Options') 

clear all
Options.Window=[1.5,4]; 
Options.ExcitLim=2;     
Options.InhibLim=1;
cd('/media/sophie/My Passport/ProjectEmbReac/Mouse490/20161201/SpikeSortingAllTogether')
load('SpikeData.mat')
[SpikeConn,SpikeConnStr]=MonoSynapticConnectivity(S,Options);
save('NeurConnectivity.mat','SpikeConn','SpikeConnStr','Options')

clear all
Options.Window=[1.5,4]; 
Options.ExcitLim=2;     
Options.InhibLim=1;
cd('/media/sophie/My Passport/ProjectEmbReac/Mouse514/SpikeSorting')
load('SpikeData.mat')
[SpikeConn,SpikeConnStr]=MonoSynapticConnectivity(S,Options);
save('NeurConnectivity.mat','SpikeConn','SpikeConnStr','Options') 


clear all
Options.Window=[1.5,4]; 
Options.ExcitLim=2;     
Options.InhibLim=1;
cd('/media/sophie/My Passport1/ProjectEmbReac/Mouse509/20170204/SpikeSortingAllTogether')
load('SpikeData.mat')
[SpikeConn,SpikeConnStr]=MonoSynapticConnectivity(S,Options);
save('NeurConnectivity.mat','SpikeConn','SpikeConnStr','Options') 