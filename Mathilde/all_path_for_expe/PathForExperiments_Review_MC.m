function Dir = PathForExperiments_Review_MC(experiment)

% OUTPUT
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)


%% Path
a=0;
I_CA=[];

%%    
%==========================================================================
%                       Saline Injection at 10am
% 
% 9am Mice are plugged
% 10am Saline injection - Start of the day recording
% 6:30pm End of the day recording - Start of the night recording
% 8am End of the night recording
%==========================================================================

if strcmp(experiment,'SalineInjection_10am_day')
    %mouse 1693
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1694
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1695
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1696
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1697
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1698
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %mouse 1705
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1706
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1707
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1708
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1709
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1710
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    

elseif strcmp(experiment,'SalineInjection_10am_night')
    %mouse 1693
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1694
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1695
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1696
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1697
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1698
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %mouse 1705
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1706
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1707
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1708
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1709
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1710
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
%==========================================================================
%          Sleep With the partition and Saline Injection at 10am
% 
% 9am Mice are plugged
% 10am Saline injection - Start of recording
% 6:30pm End of the recording
%==========================================================================

elseif strcmp(experiment,'SleepWithPartition_SalineInjection_10am')
    %mouse 1693
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1694
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1695
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1696
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1697
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1698
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %mouse 1705
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1706
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1707
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1708
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1709
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1710
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
%==========================================================================
%            Sleep With the Odour and Saline Injection at 10am
% 
% 9am Mice are plugged
% 10am Saline injection - Start of recording
% 6:30pm End of the recording
%==========================================================================

elseif strcmp(experiment,'SleepWithOdour_SalineInjection_10am')
    %mouse 1705
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1706
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1707
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1708
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1709
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1710
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
%==========================================================================
%                      THE SOCIAL DEFEAT PROTOCOL
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat - day (10am to 6:30pm)
% sleep post social defeat - night (6:30pm to 8am)
%==========================================================================

elseif strcmp(experiment,'SensoryExposureCD1cage')
    %mouse 1693
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1694
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1695
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1696
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1697
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1698
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %mouse 1705
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1706
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1707
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1708
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1709
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1710
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    

elseif strcmp(experiment,'SensoryExposureC57cage')
    %mouse 1693
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1694
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1695
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1696
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1697
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1698
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %mouse 1705
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1706
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1707
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1708
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1709
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1710
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SleepPostSD_SalineInjection_10am_day')
    %mouse 1693
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1694
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1695
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1696
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1697
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1698
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %mouse 1705
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1706
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1707
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1708
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1709
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1710
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SleepPostSD_SalineInjection_10am_night')
    %mouse 1693
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1694
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1695
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1696
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1697
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1698
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %mouse 1705
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1706
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1707
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1708
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1709
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1710
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

            
else
    error('Invalid name of experiment')
end

%% Get mice names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i}{1},'M');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
    else
        Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+4)];
        if sum(isstrprop(Dir.path{i}{1}(temp+1:temp+4),'alphanum'))<4
            Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+3)];
        end
    end
end
