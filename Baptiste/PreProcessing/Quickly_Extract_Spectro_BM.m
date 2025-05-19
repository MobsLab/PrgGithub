
function A=Quickly_Extract_Spectro_BM(DoRef , RefChannel , Sp_chan)
%% Make spectrogram very quickly

load('ExpeInfo.mat');
ExpeInfo.PreProcessingInfo.TypeOfSystem='Intan';
save('ExpeInfo.mat','ExpeInfo')

WriteExpeInfoToXml(ExpeInfo)
InfoLFP = ExpeInfo.InfoLFP;
mkdir('LFPData')
save('LFPData/InfoLFP.mat','InfoLFP')

spk = 0;
doaccelero = 1;
dodigitalin =1;
doanalogin =0;

if DoRef ==1
    % subtract the reference
    RefChannel = ExpeInfo.ChannelToAnalyse.Ref;
    % do subtraction on all the wideband channels
    ChanToSub = Sp_chan;
    ChanToSub(ChanToSub==RefChannel) = [];
    
    ChanToSave = [0 :ExpeInfo.PreProcessingInfo.NumWideband-1];
    
    % Do the subtraction
    RefSubtraction_multi('amplifier.dat',ExpeInfo.PreProcessingInfo.NumWideband,1,['M' num2str(ExpeInfo.nmouse)],ChanToSub,RefChannel,ChanToSave);
    
    system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '.dat ' 'amplifier-wideband.dat'])
else
    system(['mv amplifier.dat ' 'amplifier-wideband.dat'])
end

system(['mv auxiliary.dat ' 'amplifier-accelero.dat'])
system(['mv digitalin.dat ' 'amplifier-digin.dat'])

if or(ExpeInfo.PreProcessingInfo.NumWideband==32 , ExpeInfo.PreProcessingInfo.NumWideband==64)
    system(['ndm_mergedat amplifier'])
end
system(['ndm_lfp amplifier'])

SetCurrentSession('amplifier')
          
load('LFPData/InfoLFP.mat')
LFP_numb = length(InfoLFP.channel);
foldername=cd;
for i=[Sp_chan LFP_numb-4:LFP_numb-2]
    LFP_temp = GetLFP(i);
    LFP = tsd(LFP_temp(:,1)*1E4, LFP_temp(:,2));
    save([foldername '/LFPData/LFP' num2str(i)], 'LFP');
end

MakeData_Accelero

load('behavResources.mat', 'MovAcctsd')
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),30));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,3.2e7,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,2*1e4);

FzTime = (sum(Stop(FreezeAccEpoch) - Start(FreezeAccEpoch)))/1e4;

for i=Sp_chan
    LowSpectrumSB([cd filesep],i,['B_' num2str(i)])
    load(['B_' num2str(i) '_Low_Spectrum.mat'])
    Sp_tsd{i} = tsd(Spectro{2}*1e4 , Spectro{1});
    Sp_tsd_Fz{i} = Restrict(Sp_tsd{i} , FreezeAccEpoch);
end

for i=Sp_chan
    figure
    subplot(311)
    imagesc(linspace(0 , round(FzTime) , size(Range(Sp_tsd_Fz{i}),1))  , Spectro{3} , Data(Sp_tsd_Fz{i})'); axis xy
    hline([2 4 6],'-k'); ylabel('Frequency (Hz)'); xlabel('time (s)'); makepretty
    caxis([0 5e5])
    subplot(212)
    plot(Spectro{3} , nanmean(Data(Sp_tsd_Fz{i})) , 'k')
    makepretty; xlim([0 10])
    [a,b] = max(nanmean(Data(Sp_tsd_Fz{i})));
    vline(Spectro{3}(b),'--k')
    xlabel('Frequency (Hz)'); ylabel('Power (a.u.)');
end




% imagesc(Data(Sp_tsd{i})'); axis xy; caxis([0 5e5])
