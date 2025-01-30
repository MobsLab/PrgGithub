%GetBasicInfoSB
clear

%% Initiation
warning off
res=pwd;


%% create makedataBulbeInputs

%inputdlg input 
defaultvalues={'yes', 'yes', 'yes', 'yes'};
Questions={'SpikeData (yes/no)', 'INTAN accelero', 'INTAN Digital input', 'INTAN Analog input'};

%check if makedataBulbeInputs already exists 
try
    load('makedataBulbeInputs')
    if length(defaultvalues)==length(answer)
        defaultvalues=answer;
    end
    
catch
    disp('error when loading makedataBulbeInputs')
end

%inputdlg
answer = inputdlg(Questions, 'Inputs for makeData', 1, defaultvalues);

spk=strcmp(answer{1},'yes');
doaccelero=strcmp(answer{2},'yes');
dodigitalin=strcmp(answer{3},'yes');
doanalogin=strcmp(answer{4},'yes');
%digital
if dodigitalin==1
    answerdigin = inputdlg({'Digital channel','Number of inputs'},'DigIn Info',1);
else
    answerdigin=[];
end
%analog
if doanalogin==1
    answeranalogin = inputdlg({'Analog channel','Number of inputs'},'AnalogIn Info',1);
else
    answeranalogin=[];
end

%save
save makedataBulbeInputs answer answerdigin Questions spk doaccelero dodigitalin answeranalogin doanalogin


%% create InfoLFP
%read LFP info from xls file and write it into InfoLFP
GenInfoLFPFromSpreadSheet


%% create ChannelsToAnalyse
try
    %create folder
%     if ~exist('ChannelsToAnalyse','dir')
        mkdir('ChannelsToAnalyse');
% end
    
    
    Structure = {'Bulb_sup','Bulb_deep', 'dHPC_sup','dHPC_deep','dHPC_rip','PFCx_sup','PFCx_deltasup','PFCx_deep','PFCx_deltadeep','PFCx_spindle', ...
        'Amyg','PiCx','InsCx','TaeniaTecta','EMG','EKG'};
    disp(' ');
    
    %check if some channels already exists
    dodisp=0;
    for stru=1:length(Structure)
        try
            temp = load(['ChannelsToAnalyse/',Structure{stru},'.mat']);
            if isempty(temp.channel)
                defaultansw{stru}='[ ]';
            else
                defaultansw{stru}=num2str(temp.channel);
            end
            dodisp=1;
        catch
            defaultansw{stru}='NaN';
        end
    end
    if dodisp
        disp('ChannelsToAnalyse already defined for some channels, check and add');
    end
    
    %formulary
    answer = inputdlg(['Exemple undefined','Example empty',Structure],'ChannelToAnalyse',1,['NaN','[ ]',defaultansw]);
    
    
    %save channels in ChannelsToAnalyse
    for stru=1:length(Structure)
        channel = str2double(answer{stru+2});
        
        if strcmp(answer{stru+2},'[ ]')%empty
            channel=[];
        end
        
        if (~isempty(channel) && ~isnan(channel)) || isempty(channel)
            disp(['Saving ch',answer{stru+2},' for ',Structure{stru},' in ChannelsToAnalyse'])
            save(['ChannelsToAnalyse/',Structure{stru},'.mat'],'channel');
        end
    end
    
    
catch
    error('')
end



