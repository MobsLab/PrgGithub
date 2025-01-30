function InfoLFP=listLFP_to_InfoLFP_ML(Pathway,dispAllInfo)

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

NameStructures={'Bulb','PFCx','IL','PaCx','MoCx','AuCx','PiCx','Amyg','dHPC','DenG','NRT','VLPO','AuTh','Ref','Accelero','Respi','EMG','LaserInput','EKG'};


%% compute InfoLFP.channel
try
    load([Pathway,'/LFPData/InfoLFP.mat']);
    InfoLFP.channel(1);
    
    if dispAllInfo
        for i=1:length(InfoLFP.channel)
            try
                disp([num2str(i),'- Channel ',num2str(InfoLFP.channel(i)),': ',InfoLFP.structure{i},' (',num2str(InfoLFP.depth(i)),') ', InfoLFP.hemisphere{i}])
            catch
                disp([num2str(i),'- Channel ',num2str(InfoLFP.channel(i)),': ',InfoLFP.structure{i},' (',num2str(InfoLFP.depth(i)),') '])
            end
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
        disp('For depth: -1=EEG 0=EcoG 1=LFPsup 2=LFPmid 3=LFPdeep, NaN=undefined, etc..');
        disp('For hemisphere: enter Right or Left...');
        disp('------------------------------------------------');
        
        ButtonName=questdlg('In which case are you ?','Choose how to fill InfoLFP','Lots of structures','Lots of tetrodes in same structure','Lots of structures');
        switch ButtonName
            case 'Lots of structures'
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
                
            case 'Lots of tetrodes in same structure'
                Hemisph=questdlg('Implantation are in which hemisphere?','InfoLFP.hemisphere','Right','Left and Right','Left','Right');
                nameH={'Right','Left'};
                switch Hemisph
                    case 'Left and Right'
                        numH=1:2;
                    case 'Right'
                        numH=1;
                    case 'Left'
                        numH=2;
                end
                a=0;
                for nH=1:length(numH)
                    prompt = NameStructures;
                    disp(['Hemisphere ',nameH{numH(nH)},': enter channels and depth in Neuroscope'])
                    answer = inputdlg(prompt,nameH{numH(nH)},1,...
                        {'[0 1 2 ; 1 1 1]','[0:7;ones(1,8)]','[ ; ]','[ ; ]','[ ; ]','[ ; ]','[ ; ]','[ ; ]','[ ; ]','[ ; ]','[ ; ]','[ ; ]','[ ; ]','[0;nan]','[32 33 34 ;nan(1,3)]','[ ; ]','[ ; ]','[ ; ]','[ ; ]'});
                    
                    for pp=1:length(prompt)
                        temp=str2num(answer{pp});
                        if ~isempty(temp)
                            chs=temp(1,:);
                            dep=temp(2,:);
                            for cc=1:length(chs)
                                a=a+1;
                                InfoLFP.channel(a)=chs(cc);
                                InfoLFP.structure{a}=prompt{pp};
                                InfoLFP.hemisphere{a}=nameH{numH(nH)};
                                InfoLFP.depth(a)=dep(cc);
                            end
                        end
                    end
                end
        end
        askCheck=1;
    end
    
    
    for i=1:length(InfoLFP.channel)
        disp([num2str(i),'- Channel ',num2str(InfoLFP.channel(i)),': ',InfoLFP.structure{i},' (',num2str(InfoLFP.depth(i)),') ', InfoLFP.hemisphere{i}])
    end
    
    if askCheck
        disp('Keyboard for manual change of listLFP, if needed. Else type ''return''.');
        keyboard;
    end
    
    if ~exist([Pathway,'/LFPData'],'dir'), mkdir([Pathway,'/LFPData']);end
    save([Pathway,'/LFPData/InfoLFP'],'InfoLFP')
end
