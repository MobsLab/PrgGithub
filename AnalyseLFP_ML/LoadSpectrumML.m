function [Sp,t,f]=LoadSpectrumML(Struct,Dir,optionParam)
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


%% %%%%%%%%%%%%%%%%%%%%%%%%% GET CHANNEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
namech=['ChannelsToAnalyse/',Struct,'.mat'];
if isnumeric(Struct)
    chtemp.channel=Struct;
else
    if exist(namech,'file') && ~isnumeric(Struct)
        chtemp=load(namech,'channel');
        disp(sprintf([Struct,' : channel = %d'],chtemp.channel))
    else
        error(['Enable to load channel ',namech])
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%% GET SPECTRUM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
namesp=sprintf(['SpectrumData',suffix,'/Spectrum%d.mat'],chtemp.channel);
if exist(namesp,'file')
    load(namesp,'Sp','t','f');
    disp([namesp,' already exists. loaded.'])
    
else
    disp([namesp,' does not exist. Computing...'])
    load(['LFPData/LFP',num2str(chtemp.channel)],'LFP');
    LFP_temp=ResampleTSD(LFP,params.Fs);
    [Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);
    
    % saving
    if ~exist(['SpectrumData',suffix],'dir') 
        mkdir(['SpectrumData',suffix]);
    end
    save(['SpectrumData',suffix,'/Spectrum',num2str(chtemp.channel)],'-v7.3','Sp','t','f','params','movingwin');
                        
    disp('Done')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% ENDING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(res);
