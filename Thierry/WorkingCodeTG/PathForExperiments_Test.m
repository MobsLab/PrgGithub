function Dir=PathForExperiments_Test

%% Path
a=0;
I_CA=[];

if strcmp(experiment,'Baseline_20Hz')   

elseif strcmp(experiment,'Sham_20Hz')

strcmp(experiment,'Stim_20Hz')
     
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/20180216/M648-opto20Hz_180216_094032/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M675_processed/20180219/M675_Optostim20Hz_180219/VLPO-675-Optostim20Hz_180219_102539/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M733_processed/20180511/M733_Stim_ProtoSleep_1min_180511_103535/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
   
    %Mouse1074
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1074_processed/20200630/Opto_PFC_VLPO_1074_OptoSleep_200630_091210/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    
    %Mouse1076
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1076_processed/20200702/Opto_PFC_VLPO_1076_OptoSleep_200702_094338/';
    load([Dir.path{a}{1},'ExpeInfo.mat']);
    Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse  

end