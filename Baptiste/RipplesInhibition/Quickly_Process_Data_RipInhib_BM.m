
function Quickly_Process_Data_RipInhib_BM(RefChannel , RipChannel)

load('ExpeInfo.mat')
WriteExpeInfoToXml(ExpeInfo)
InfoLFP = ExpeInfo.InfoLFP;
mkdir('LFPData')
save('LFPData/InfoLFP.mat','InfoLFP')

% Do the subtraction
RefSubtraction_multi('amplifier.dat',ExpeInfo.PreProcessingInfo.NumWideband,1,['M' num2str(ExpeInfo.nmouse)],[0:31],RefChannel,[]);

system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '.dat ' 'amplifier-wideband.dat'])
system(['mv auxiliary.dat ' 'amplifier-accelero.dat'])
system(['mv digitalin.dat ' 'amplifier-digin.dat'])

system(['ndm_mergedat amplifier'])
system(['ndm_lfp amplifier'])

SetCurrentSession('amplifier')

load('LFPData/InfoLFP.mat')
LFP_numb = length(InfoLFP.channel);
foldername=cd;
for i=[RefChannel RipChannel]
    LFP_temp = GetLFP(i);
    LFP = tsd(LFP_temp(:,1)*1E4, LFP_temp(:,2));
    save([foldername '/LFPData/LFP' num2str(i)], 'LFP');
end
