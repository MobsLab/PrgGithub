
function EvokedPotential_VHC_Stim_PerMouse_BM(FolderList)


chan_rip = Get_chan_numb_BM(FolderList{1} , 'rip');
chan_deep = Get_chan_numb_BM(FolderList{1} , 'hpc_deep');
chan_sup = Get_chan_numb_BM(FolderList{1} , 'hpc_sup');

for i=1:length(FolderList)
    LFP_rip{i} = ConcatenateDataFromFolders_SB(FolderList(i),'lfp','channumber',chan_rip);
    LFP_deep{i} = ConcatenateDataFromFolders_SB(FolderList(i),'lfp','channumber',chan_deep);
    LFP_sup{i} = ConcatenateDataFromFolders_SB(FolderList(i),'lfp','channumber',chan_sup);
    VHC_Stim_Epoch{i} = ConcatenateDataFromFolders_SB(FolderList(i),'epoch','epochname','vhc_stim');
    [M_rip{i} , T_rip{i}] = PlotRipRaw(LFP_rip{i} , Start(VHC_Stim_Epoch{i})/1e4, 50, 0, 0, 0); % M: time, mean, std, stdError
    [M_deep{i} , T_deep{i}] = PlotRipRaw(LFP_deep{i} , Start(VHC_Stim_Epoch{i})/1e4, 50, 0, 0, 0);
    [M_sup{i} , T_sup{i}] = PlotRipRaw(LFP_sup{i} , Start(VHC_Stim_Epoch{i})/1e4, 50, 0, 0, 0);
    load([FolderList{i} '/ExpeInfo.mat'])
    intensity(i) = ExpeInfo.StimulationInt;
    intensity_str{i} = [num2str(ExpeInfo.StimulationInt) 'V'];
end

bin_size = 3750;


% increasing voltages on rip channel
figure
for i=1:length(FolderList)
    
    if length(FolderList)<7
        subplot(2,3,i)
    else
        subplot(2,4,i)
    end
    
    plot(resample(M_rip{i}(:,2) , 30 , 1),'k')
    hold on
    plot(resample(M_deep{i}(:,2) , 30 , 1)-2e3,'b')
    plot(resample(M_sup{i}(:,2) , 30 , 1)+2e3,'r')
    xticks([0 bin_size/2 bin_size]); xticklabels({'-50 ms','0','+50 ms'})
    xlim([0 bin_size])
    vline(bin_size/2,'--r')
    if or(i==1 , i==4); ylabel('amplitude (a.u.)'); end
    if i==1; legend('HPC rip','HPC deep','HPC sup'); end
    makepretty
    title(['VHC = ' num2str(intensity(i)) 'V'])
end
a=suptitle('Evoked potentials, VHC stims'); a.FontSize = 20;

% increasing voltages on rip channel
color_map=jet;
figure
for i=1:length(FolderList)
    plot(resample(M_rip{i}(:,2) , 30 , 1),'Color',color_map(round(1+(i-1)*64/length(FolderList)),:))
    hold on
end
xticks([0 bin_size/2 bin_size]); xticklabels({'-50 ms','0','+50 ms'})
xlim([0 bin_size])
vline(bin_size/2,'--r')
ylabel('amplitude (a.u.)')
legend(intensity_str)
title('LFP rip channel around VHC stim, increasing voltages')
makepretty









