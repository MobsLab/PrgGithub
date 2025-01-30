Dir=PathForExperimentFEAR('Fear-electrophy-opto-for-paper');


RefChans = [498,3;499,19;504,19;505,15;506,15;537,27;610,11;496,31;497,19;540,11;542,11;543,27;613,18;614,11];

for dd = 19 : 3 : length(Dir.path)
    cd(Dir.path{dd})
    disp(Dir.path{dd})

    copyfile([Dir.path{dd+2} filesep 'ChannelsToAnalyse'],[Dir.path{dd} filesep 'ChannelsToAnalyse'])
    mkdir('LFPData')
    copyfile([Dir.path{dd+2} filesep 'LFPData' filesep 'InfoLFP.mat'],...
        [Dir.path{dd} filesep 'LFPData' filesep 'InfoLFP.mat'])
    
    load('LFPData/InfoLFP.mat','InfoLFP')
    InfoLFP.channel(end+1) = 36;
    InfoLFP.structure{end+1} = 'Digin';
    InfoLFP.depth(end+1) = NaN;
    InfoLFP.hemisphere{end+1} = NaN;
    save('LFPData/InfoLFP.mat','InfoLFP')
    
    clear ExpeInfo
    h = GUI_StepOne_ExperimentInfo;
    waitfor(h)
    
    
    load('ExpeInfo.mat')
    load('LFPData/InfoLFP.mat')
    ExpeInfo.InfoLFP = InfoLFP;
    
    cd('ChannelsToAnalyse/')
    FileInfo=dir('*.mat');
    for f=1:size(FileInfo,1)
        load(FileInfo(f).name)
        eval(['ExpeInfo.ChannelsToAnalyse.',FileInfo(f).name(1:end-4),'=channel;'])
    end
    cd ..
    
    ExpeInfo.PreProcessingInfo.NumWideband= 32;
    ExpeInfo.PreProcessingInfo.NumAccelero= 3;
    ExpeInfo.PreProcessingInfo.NumDigChan= 1;
    ExpeInfo.PreProcessingInfo.NumDigInput= 16;
    ExpeInfo.PreProcessingInfo.NumAnalog= 1;
    ExpeInfo.PreProcessingInfo.DoSpikes= 0;
    ExpeInfo.DigID{2} = 'Laser';
    ExpeInfo.DigID{3} = 'Laser';
    ExpeInfo.DigID{7} = 'ONOFF';
    
    if ismember(ExpeInfo.nmouse,[498,499,504,505,506,537,611])
        ExpeInfo.group = 'GFP';
    else
        ExpeInfo.group = 'CHR2';
    end
    
    ExpeInfo.ChannelsToAnalyse.Ref = RefChans(find(RefChans(:,1)==ExpeInfo.nmouse),2);
    
    save('ExpeInfo.mat','ExpeInfo')
    
    copyfile('/media/DataMOBsRAIDN/amplifier.xml',[Dir.path{dd} filesep 'amplifier.xml'])
    
    % To do
    
    RefChannel = ExpeInfo.ChannelToAnalyse.Ref;
    RefSubtraction_multi('amplifier.dat',32,1,'RefSub',[0:31],RefChannel,[]);
    
    movefile('amplifier_RefSub.dat',['FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-wideband.dat'])
    movefile('auxiliary.dat',['FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-accelero.dat'])
    movefile('analogin.dat',['FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-lasersti.dat'])
    movefile('digitalin.dat',['FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-digin.dat'])
    movefile('amplifier.xml',['FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '.xml'])
    
    system(['ndm_mergedat FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date)])
    
    system(['ndm_lfp FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date)])
    
    SetCurrentSession(['FEAR-Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '.xml'])
    
    MakeData_LFP([cd filesep])
    
    MakeData_Accelero([cd filesep])
    
    MakeData_DigitalChannels([cd filesep])
    
end
