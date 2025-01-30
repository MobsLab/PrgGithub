Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz')
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz')

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
[SpREM_start,SpSWS,SpWake, temps] = PlotThetaPowerAtTransitions_SingleMouse_MC('start');
    SpectroREMstart{i}=SpREM_start; %cell array with the spectro for each mouse

[SpREM_end,SpSWS,SpWake, temps] = PlotThetaPowerAtTransitions_SingleMouse_MC('end');
    SpectroREMend{i}=SpREM_end;

    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end



%% average accross mice
dataSpREMstart=cat(3,SpectroREMstart{:});
avdataSpREMstart=nanmean(dataSpREMstart,3);

dataSpREMend=cat(3,SpectroREMend{:}); 
avdataSpREMend=nanmean(dataSpREMend,3);

%% plot

freq=[1:20];
figure
subplot(411)
imagesc(temps,freq, avdataSpREMstart),axis xy, colormap(jet), caxis([0 5])
% caxis([7 9.5])
colorbar
% ylim([10 30])
xlim([-60 +60])
line([0 0],ylim,'color','w','linestyle','-')
title('start (n=5)')
subplot(412)
imagesc(temps,freq, log(avdataSpREMend)),axis xy
% caxis([7 9.5])
colorbar
% ylim([10 30])
xlim([-60 +60])
line([0 0],ylim,'color','w','linestyle','-')
title('end (n=5)')
