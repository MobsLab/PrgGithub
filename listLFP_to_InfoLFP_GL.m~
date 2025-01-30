function InfoLFP=listLFP_to_InfoLFP_GL(Pathway,dispAllInfo)

% function InfoLFP=listLFP_to_InfoLFP_ML(Pathway,dispAllInfo)
% Pathway = directory where .lfp exists and where InfoLFP should be saved
% dispAllInfo = 1 if print of InfoLFP is wanted

%% check inputs

if ~exist('Pathway','var')
    Pathway=pwd;
end
if ~exist('dispAllInfo','var')
    dispAllInfo=0;
end

%% compute InfoLFP.channel
try
    load([Pathway,'/LFPData/InfoLFP.mat']);
    InfoLFP.channel(1);
    
    if dispAllInfo
        for i=1:length(InfoLFP.channel)
        disp([num2str(i),'- Channel ',num2str(InfoLFP.channel(i)),': ',InfoLFP.structure{i},' (',num2str(InfoLFP.depth(i)),') '])
        end
    end
catch
    try
        load([Pathway,'/listLFP.mat']);
        listLFP.name;
        disp(' '); disp('...Converting listLFP.mat into InfoLFP.mat')
        
        listLFP.name;
        disp(' '); disp('...Converting listLFP.mat into InfoLFP.mat')
        
        InfoLFP.channel=[];
        InfoLFP.depth=[];
        InfoLFP.structure={};
        
        for i=1:length(listLFP.name)
            InfoLFP.channel=[InfoLFP.channel listLFP.channels{i}];
            InfoLFP.depth=[InfoLFP.depth listLFP.depth{i}];
            for ii=1:length(listLFP.channels{i})
                InfoLFP.structure=[InfoLFP.structure listLFP.name{i}];
            end
        end
        
        [InfoLFP.channel, Index]=sort(InfoLFP.channel);
        InfoLFP.depth=InfoLFP.depth(Index);
        InfoLFP.structure=InfoLFP.structure(Index);
        askCheck=0;
    catch
        
        disp('------------------------------------------------');
        disp('Enter for good channels, number (in neuroscope), depth and structure')
        disp('For structure: enter Bulb, PiCx PFCx, S1Cx, PaCx, AuCx, AuTh, or dHPC...');
        disp('For depth: -1=EEG 0=EcoG 1=LFPsup/undefined 2=LFPmid 3=LFPdeep, etc..');
        disp('For hemisphere: enter Right or Left...');
        disp('------------------------------------------------');
        
        InfoLFP.channel=input('Enter list of good channels (num in neuroscope, e.g. [0:15]): ');
        
        for i=1:length(InfoLFP.channel)
            ok=0;
            while ok==0
                try
                    InfoLFP.structure{i}=input([' Channel ',num2str(InfoLFP.channel(i)),':  - structure = '],'s');
                    InfoLFP.depth(i)=input('             - depth = ');
                    InfoLFP.hemisphere{i}=input('             - hemisphere = ','s');
                    ok=1;
                end
            end
        end
        askCheck=1;
    end
    
    
    for i=1:length(InfoLFP.channel)
        disp([num2str(i),'- Channel ',num2str(InfoLFP.channel(i)),': ',InfoLFP.structure{i},' (',num2str(InfoLFP.depth(i)),') '])
    end
    
    if askCheck
        disp('Keyboard for manual change of listLFP, if needed. Else type ''return''.');
        keyboard;
    end
    
    %if ~exist([Pathway,'/LFPData'],'dir'), mkdir([Pathway,'/LFPData']);end
    %save([Pathway,'/LFPData/InfoLFP'],'InfoLFP')
end
