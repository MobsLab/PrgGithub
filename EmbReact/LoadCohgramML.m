function [Coh,t,f]=LoadCohgramML(Struct1,Struct2,Dir,optionParam)
%
% [Sp,t,f]=LoadSpectrumML('PFCx_deep');
% [Sp,t,f]=LoadSpectrumML(30,pwd,'low'); % to load SpectrumDataL/Spectrum30.mat
%
% inputs :
% Struct = channel, or name of structure as stated in ChannelsToAnalyse
% Dir (optional) = path (default=pwd) 
% optionParam (optional) = see SpectrumParametersML.m (default = 'low')


%% %%%%%%%%%%%%%%%%%%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res=pwd;
if ~exist('Dir','var')
    Dir=pwd;
end
cd(Dir)

if ~exist('optionParam','var')
    optionParam='low';
end
[params,movingwin,suffix]=SpectrumParametersML(optionParam);


%% %%%%%%%%%%%%%%%%%%%%%%%%% GET CHANNELS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isnumeric(Struct1)
    chtemp(1).channel=Struct1;
else
    namech=['ChannelsToAnalyse/',num2str(Struct1),'.mat'];

    if exist(namech,'file') && ~isnumeric(Struct1)
        chtemp(1)=load(namech,'channel');
        disp(sprintf([Struct1,' : channel = %d'],chtemp(1).channel))
    else
        error(['Enable to load channel ',namech])
    end
end

if isnumeric(Struct2)
    chtemp(2).channel=Struct2;
else
        namech=['ChannelsToAnalyse/',num2str(Struct2),'.mat'];

    if exist(namech,'file') && ~isnumeric(Struct2)
        chtemp(2)=load(namech,'channel');
        disp(sprintf([Struct2,' : channel = %d'],chtemp(2).channel))
    else
        error(['Enable to load channel ',namech])
    end
end

if chtemp(2).channel>chtemp(1).channel
    chtemp = chtemp([2,1]);
end



%% %%%%%%%%%%%%%%%%%%%%%%%%% GET SPECTRUM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
namesp=(['CohgramData',suffix,'/Cohgram',num2str(chtemp(1).channel),'_',num2str(chtemp(2).channel) ,'.mat']);

if exist(namesp,'file')
    load(namesp,'Coh','t','f');
    disp([namesp,' already exists. loaded.'])
    
else
    disp([namesp,' does not exist. Computing...'])
    load(['LFPData/LFP',num2str(chtemp(1).channel)],'LFP');
    LFP_temp{1}=ResampleTSD(LFP,params.Fs);
    load(['LFPData/LFP',num2str(chtemp(2).channel)],'LFP');
    LFP_temp{2}=ResampleTSD(LFP,params.Fs);

    [Coh,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP_temp{1}),Data(LFP_temp{2}),movingwin,params);

    % saving
    if ~exist(['CohgramData',suffix],'dir'); 
        mkdir(['CohgramData',suffix]);
    end
    save(namesp,'-v7.3','S12','phi','Coh','t','f','params','movingwin');
                        
    disp('Done')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% ENDING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(res);
