function [Spi,ti,fi,channelToAnalyse]=ComputeAllSpectrogramsML(NameDir,option,NameStructure,optionChannelStructure)

% function [Spi,ti,fi,channelToAnalyse]=ComputeAllSpectrogramsML(NameDir,option,NameStructure,optionChannelStructure)
%
% inputs:
% NameDir = see PathForExperimentsML.m
% option (optional) = 'high' for [20-200Hz], 'low' for [1-20Hz]
% nameStrucutre = see names in listLFP_to_InfoLFP_ML.m
% optionChannelStructure (optional) = 'All' or 'Unique' cf ComputeSpectrogram_newML.m
% outputs:
% [Spi,ti,fi,channelToAnalyse] (optional) = only if NameDir is a Unique path
% e.g.  ComputeAllSpectrogramsML('DPCPX','low','Bulb')

%% Verifications of inputs

if ~exist('NameDir','var')
    error('Not enough input arguments')
end

if ~exist('option','var') 
    option='low';
end

if ~exist('optionChannelStructure','var')
    optionChannelStructure='Unique';
end
%% Spectrogram parameters 

[params,movingwin,suffix]=SpectrumParametersML(option);
       
%% initialisation variables

% load paths of experiments

Dir=PathForExperimentsML(NameDir);
res=pwd;
scrsz = get(0,'ScreenSize');


%% compute spectrograms

for man=1:length(Dir.path)
       
    clear LFP InfoLFP nameMan
    nameMan_indx=strfind(Dir.path{man},'/');
    nameMan=Dir.path{man}(nameMan_indx(end)+1:end);
    disp(['           * * * ',nameMan,' * * *'])
    
    % ----------------------------------------------------
    % loading LFPData.mat / creating it if non existing   
    cd(Dir.path{man});
    try 
        load([Dir.path{man},'/LFPData/InfoLFP.mat'],'InfoLFP');
        load([Dir.path{man},'/LFPData/LFP',num2str(InfoLFP.channel(1))],'LFP'); LFP;

    catch
        
        SetCurrentSession
        SetCurrentSession('same')
    
       disp(' ');
       disp('...Creating InfoLFP.mat')
       InfoLFP=listLFP_to_InfoLFP_ML(Dir.path{man});
        
       disp(' ');
       disp('...Creating LFPData.mat')
       for i=1:length(InfoLFP.channel)
           LFP_temp=GetLFP(InfoLFP.channel(i));
           disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
           LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
           save([Dir.path{man},'/LFPData/LFP',num2str(InfoLFP.channel(i))],'LFP');
           clear LFP LFP_temp
       end
       disp('Done')
    end
    % ----------------------------------------------------
        
    
    % ------------------------------------------------------
    % -------------- ComputeSpectrogramML ------------------
    % calculate Sp for all LFP
    [Spi,ti,fi,channelToAnalyse]=ComputeSpectrogram_newML(movingwin,params,InfoLFP,NameStructure,optionChannelStructure,suffix);
    cd(res);

end
