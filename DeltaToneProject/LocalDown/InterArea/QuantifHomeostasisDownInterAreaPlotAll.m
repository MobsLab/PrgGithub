%%QuantifHomeostasisDownInterAreaPlotAll
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%     QuantifHomeostasisDownInterArea
%    

% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisDownInterArea.mat'))


for p=1:length(local_res.path)
    

    %% Plot
    %
    figure, hold on
    
    %Intra
    %PFC
    subplot(2,4,1), hold on 
    HomeostasiePlot_KJ(local_res.intra_pfc.absolut.Dstat{p},'newfig',0);
    title(['Intra Down PFC - nb = ' num2str(local_res.intra_pfc.nb{p})]),
    ylabel('down density (per min)'),
    
    %PaCx
    subplot(2,4,2), hold on 
    HomeostasiePlot_KJ(local_res.intra_pa.absolut.Dstat{p},'newfig',0);
    title(['Intra Delta PaCx - nb = ' num2str(local_res.intra_pa.nb{p})])
    ylabel('delta density (per min)'),
    
    %MoCx
    subplot(2,4,3), hold on 
    HomeostasiePlot_KJ(local_res.intra_mo.absolut.Dstat{p},'newfig',0);
    title(['Intra Delta MoCx - nb = ' num2str(local_res.intra_mo.nb{p})])
    ylabel('delta density (per min)'),
    
    
    %Inter
    %PFC-Pa
    subplot(2,4,5), hold on 
    HomeostasiePlot_KJ(local_res.pfc_pa.absolut.Dstat{p},'newfig',0);
    title(['Inter PFC-Pa - nb = ' num2str(local_res.pfc_pa.nb{p})])
    ylabel('down density (per min)'),
    
    %PFC-Mo
    subplot(2,4,6), hold on 
    HomeostasiePlot_KJ(local_res.pfc_mo.absolut.Dstat{p},'newfig',0);
    title(['Inter PFC-Mo - nb = ' num2str(local_res.pfc_mo.nb{p})])
    ylabel('down density (per min)'),
    
    %Mo-Pa
    subplot(2,4,7), hold on 
    HomeostasiePlot_KJ(local_res.mo_pa.absolut.Dstat{p},'newfig',0);
    title(['Inter MoCx-PaCx - nb = ' num2str(local_res.mo_pa.nb{p})])
    ylabel('delta density (per min)'),
    
    %INTER ALL
    subplot(2,4,8), hold on 
    HomeostasiePlot_KJ(local_res.inter_all.absolut.Dstat{p},'newfig',0);
    title(['INTER ALL - nb = ' num2str(local_res.inter_all.nb{p})])
    ylabel('down density (per min)'),
    
    %title
    subplot(2,4,4), hold on 
    title([local_res.name{p} ' - ' local_res.date{p}]),


end

