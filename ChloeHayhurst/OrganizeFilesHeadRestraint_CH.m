function FolderName=OrganizeFilesHeadRestraint_CH(MouseNum,HRFolder,ExpeInfo, Days)
AllFold=1;
if ~(HRFolder(end)==filesep),HRFolder=[HRFolder filesep]; end
BaseName='HeadRestraint_M';


for i = 1:length(Days)
    cd(HRFolder)
    mkdir([BaseName,num2str(ExpeInfo.nmouse),'_D',strrep(num2str(Days(i)),'.',',')]);
    cd([BaseName,num2str(ExpeInfo.nmouse),'_D',strrep(num2str(Days(i)),'.',',')]);
    ExpeInfo.SessionNumber = i;
    save makedataBulbeInputs
    WriteExpeInfoToXml(ExpeInfo)
    InfoLFP = ExpeInfo.InfoLFP;
    mkdir('LFPData')
    save('LFPData/InfoLFP.mat','InfoLFP')
    
    mkdir('ChannelsToAnalyse');
    if isfield(ExpeInfo,'ChannelToAnalyse')
        AllStructures = fieldnames(ExpeInfo.ChannelToAnalyse);
        for stru=1:length(AllStructures)
            channel = ExpeInfo.ChannelToAnalyse.(AllStructures{stru});
            save(['ChannelsToAnalyse/',AllStructures{stru},'.mat'],'channel');
        end
    end
    
    save('ExpeInfo.mat','ExpeInfo');
    FolderName{AllFold}=cd;
    AllFold=AllFold+1;
    cd ..
end
end


















