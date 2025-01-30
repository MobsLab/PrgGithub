% makeChannelsToAnalyse
% 09.10.2017 KJ
%
% generate ChannelsToAnalyse
%
% Info
%   see makeDataBulbeSB
%

clearvars -except Dir p

%init
Structure={'Bulb_sup','Bulb_deep','dHPC_sup','dHPC_deep','dHPC_rip','PaCx_sup','PaCx_deep','PFCx_sup','PFCx_deltasup','PFCx_deep','AuCx sup', 'AuCx deep'};
disp(' ');
dodisp=0;

%% Check if already existing
for stru=1:length(Structure)
    try
        temp=load(['ChannelsToAnalyse/',Structure{stru},'.mat']);
        if isempty(temp.channel)
            defaultansw{stru} = '[ ]';
        else
            defaultansw{stru} = num2str(temp.channel);
        end
        dodisp = 1;
    catch
        defaultansw{stru} = 'NaN';
    end
end

%existing
if dodisp
    disp('ChannelsToAnalyse already defined for some channels, check and add');
end
answer = inputdlg(['Exemple undefined','Example empty',Structure],'ChannelToAnalyse',1,['NaN','[ ]',defaultansw]);

%% create folder and file if not existing
if ~exist('ChannelsToAnalyse','dir')
    mkdir('ChannelsToAnalyse');
end

for stru=1:length(Structure)
    channel=str2double(answer{stru+2});
    if strcmp(answer{stru+2},'[ ]')
        channel=[];
    end
    if (~isempty(channel) && ~isnan(channel)) || isempty(channel)
        disp(['Saving ch',answer{stru+2},' for ',Structure{stru},' in ChannelsToAnalyse'])
        save(['ChannelsToAnalyse/',Structure{stru},'.mat'],'channel');
    end
end
    
