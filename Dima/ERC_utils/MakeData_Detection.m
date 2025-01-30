function MakeData_Detection(Dir, DetectionChannel)

%% MakeData_Stimulator

%% Check whether there is a folder to store the channels
if ~exist([Dir '/UnfilteredChans'], 'dir')
    mkdir([Dir '/UnfilteredChans']);
end

%% Parameters

if ~exist('Dir','var')
    Dir = pwd;
end

if ~exist('DetectionChannel','var')
    DetectionChannel = 0;
end

%% Do
cd(Dir);

load('ExpeInfo.mat');
flnme = ['M' num2str(ExpeInfo.nmouse) '_' num2str(ExpeInfo.date) '_' ExpeInfo.SessionType];

SetCurrentSession([flnme '.xml']);

load('LFPData/InfoLFP.mat')
load(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
Tmax=max(Range(LFP,'s'));
LongFile=Tmax>3600;

if LongFile==0 % short file --> all in one
    LFP_temp=GetWideBandData(DetectionChannel);
%     LFP_temp=LFP_temp(1:8:end,:);
    DigIN=LFP_temp(:,2);
    TimeIN=LFP_temp(:,1);
else % long file --> load progressively
    disp('progressive loading')
    DigIN=[];TimeIN=[];
    
    for tt=1:ceil(Tmax/1000)
        disp(num2str(tt/ceil(Tmax/1000)))
        % we load 1001 seconds of data
        LFP_temp=GetWideBandData(DetectionChannel,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
        % just keep 1000 seconds of data - there are sometimes problems
        % at the end
        LastToKeep =  find(LFP_temp(:,1)>min(1000*tt,Tmax),1,'first')-1;
        LFP_temp(LastToKeep:end,:)=[];
%         LFP_temp=LFP_temp(1:8:end,:);
        DigIN=[DigIN;LFP_temp(:,2)];
        TimeIN=[TimeIN;LFP_temp(:,1)];
    end
end

raw=tsd(TimeIN*1e4,DigIN);

save([Dir '/UnfilteredChans/Chan' num2str(DetectionChannel) '.mat'], 'raw', '-v7.3');

disp('Done')
end