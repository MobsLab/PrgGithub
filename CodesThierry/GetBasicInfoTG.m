%makeDataBulbe
clear all

%% Initiation
warning off
res=pwd;

defaultvalues={'yes','yes','yes','yes'};
try
    load('makedataBulbeInputs')
    if length(defaultvalues)==length(answer),defaultvalues=answer;end
end
Questions={'SpikeData (yes/no)','INTAN accelero',...
    'INTAN Digital input'};
answer = inputdlg(Questions,'Inputs for makeData',1,defaultvalues);

spk=strcmp(answer{1},'yes');
doaccelero=strcmp(answer{2},'yes');
dodigitalin=strcmp(answer{3},'yes');
if dodigitalin==1
    answerdigin = inputdlg({'Digital channel','Number of inputs'},'DigIn Info',1);
else
    answerdigin=[];
end

save makedataBulbeInputs answer answerdigin Questions spk doaccelero dodigitalin

GenInfoLFPFromSpreadSheet

try
    Structure={'Bulb_sup','Bulb_deep','dHPC_sup','dHPC_deep','dHPC_rip','PaCx_sup','PaCx_deep','PFCx_sup','PFCx_deltasup','PFCx_deep','Amyg','PiCx','InsCx','TaeniaTecta','EMG','EKG'};
    disp(' ');
    dodisp=0;
    for stru=1:length(Structure)
        try
            temp=load(['ChannelsToAnalyse/',Structure{stru},'.mat']);
            if isempty(temp.channel), defaultansw{stru}='[ ]';else, defaultansw{stru}=num2str(temp.channel);end
            dodisp=1;
        catch
            defaultansw{stru}='NaN';
        end
    end
    if dodisp, disp('ChannelsToAnalyse already defined for some channels, check and add');end
    answer = inputdlg(['Exemple undefined','Example empty',Structure],'ChannelToAnalyse',1,['NaN','[ ]',defaultansw]);
    
    if ~exist('ChannelsToAnalyse','dir'), mkdir('ChannelsToAnalyse');end
    for stru=1:length(Structure)
        channel=str2double(answer{stru+2});
        if strcmp(answer{stru+2},'[ ]'), channel=[];end
        if (~isempty(channel) && ~isnan(channel)) || isempty(channel)
            disp(['Saving ch',answer{stru+2},' for ',Structure{stru},' in ChannelsToAnalyse'])
            save(['ChannelsToAnalyse/',Structure{stru},'.mat'],'channel');
        end
    end
end

Response = inputdlg({'Mouse Number','MouseStrain','Stim Type (PAG,Eyeshock,MFB)','ExperimentDay',...
    'Ripples','DeltaPF [sup (delta down) deep (delta up)]','SpindlePF','Virus Injected','OptoStim (1/0)',},...
    'ExpeInfo',1,{'999','C57Bl6','None','20170101','','','','CHR2',''});
% Mouse and date info
ExpeInfo.nmouse=eval(Response{1});
ExpeInfo.MouseStrain=(Response{2});
ExpeInfo.StimElecs=Response{3}; % PAG or MFB or Eyeshock
ExpeInfo.date=eval(Response{4});
% Ephys info
ExpeInfo.Ripples=eval(Response{5}); % give channel
ExpeInfo.DeltaPF=eval(Response{6}); % give sup (delta down) the deep (delta up)
ExpeInfo.SpindlePF=eval(Response{7}); % give channel
% Implantation info
ExpeInfo.RecordElecs=InfoLFP;
% Mouse characteristics
ExpeInfo.VirusInjected=(Response{8});
ExpeInfo.OptoStimulation=eval(Response{9});
ExpeInfo.SessionNumber=0;
ExpeInfo.SleepSession=1;



save('ExpeInfo.mat','ExpeInfo');
