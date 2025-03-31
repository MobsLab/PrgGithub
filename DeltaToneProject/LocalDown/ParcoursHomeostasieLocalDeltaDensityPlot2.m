%%ParcoursHomeostasieLocalDeltaDensityPlot2
% 06.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    ParcoursHomeostasieLocalDeltaDensity ParcoursHomeostasieLocalDeltaOccupancyPlot2
%    QuantifHomeostasisPFCsupFakeDeltaPlot ParcoursHomeostasieLocalDeltaDensityPlot
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasieLocalDeltaDensity.mat'))

for p=1%:length(homeo_res.path)
    
    for tt=1:homeo_res.nb.tetrodes{p}

        figure, hold on

        %global down states
        subplot(2,3,1), hold on
        hold on, plot(homeo_res.down.global.x_intervals{p}, homeo_res.down.global.y_density{p},'b')
        hold on, plot(homeo_res.down.global.x_intervals{p}, homeo_res.down.global.reg1{p},'k.')
        hold on, scatter(homeo_res.down.global.x_peaks{p}, homeo_res.down.global.y_peaks{p},'r')
        title(['Global down states (p1= ' num2str(homeo_res.down.global.p1{p}) ')']);

        %local down states
        subplot(2,3,2), hold on
        hold on, plot(homeo_res.down.local.x_intervals{p,tt}, homeo_res.down.local.y_density{p,tt},'b')
        hold on, plot(homeo_res.down.local.x_intervals{p,tt}, homeo_res.down.local.reg1{p,tt},'k.')
        hold on, scatter(homeo_res.down.local.x_peaks{p,tt}, homeo_res.down.local.y_peaks{p,tt},'r')
        title(['local down states (p= ' num2str(homeo_res.down.local.p1{p,tt}) ')']);
        
        %table        
        textbox_str = {homeo_res.name{p}, homeo_res.date{p}, ['Tetrode ' num2str(tt)], ...
                        [num2str(homeo_res.nb.neurons_tet{p}(tt)) ' neurons'], ...
                        ['FR (SWS) = ' num2str(homeo_res.fr.nrem.local{p,tt}) ' Hz ( ' num2str(homeo_res.fr.nrem.local{p,tt}/homeo_res.nb.neurons_tet{p}(tt)) ' Hz)']};
        
        subplot(2,3,3), hold on
        textbox_dim = get(subplot(2,3,3),'position');
        delete(subplot(2,3,3))

        annotation(gcf,'textbox',...
        textbox_dim,...
        'String',textbox_str,...
        'LineWidth',1,...
        'HorizontalAlignment','center',...
        'FontWeight','bold',...
        'FitBoxToText','off');

        %global delta waves
        subplot(2,3,4), hold on
        hold on, plot(homeo_res.delta.global.x_intervals{p,tt}, homeo_res.delta.global.y_density{p,tt},'b')
        hold on, plot(homeo_res.delta.global.x_intervals{p,tt}, homeo_res.delta.global.reg1{p,tt},'k.')
        hold on, scatter(homeo_res.delta.global.x_peaks{p,tt}, homeo_res.delta.global.y_peaks{p,tt},'r')
        title(['Global delta waves (p= ' num2str(homeo_res.delta.global.p1{p,tt}) ')']);

        %local delta waves
        subplot(2,3,5), hold on
        hold on, plot(homeo_res.delta.local.x_intervals{p,tt}, homeo_res.delta.local.y_density{p,tt},'b')
        hold on, plot(homeo_res.delta.local.x_intervals{p,tt}, homeo_res.delta.local.reg1{p,tt},'k.')

        hold on, scatter(homeo_res.delta.local.x_peaks{p,tt}, homeo_res.delta.local.y_peaks{p,tt},'r')
        title(['Local delta waves (p= ' num2str(homeo_res.delta.local.p1{p,tt}) ')']);

        %local delta waves
        subplot(2,3,6), hold on
        hold on, plot(homeo_res.delta.fake.x_intervals{p,tt}, homeo_res.delta.fake.y_density{p,tt},'b')
        hold on, plot(homeo_res.delta.fake.x_intervals{p,tt}, homeo_res.delta.fake.reg1{p,tt},'k.')
        hold on, scatter(homeo_res.delta.fake.x_peaks{p,tt}, homeo_res.delta.fake.y_peaks{p,tt},'r')
        title(['Fake delta waves (p= ' num2str(homeo_res.delta.fake.p1{p,tt}) ')']);


        suplabel([homeo_res.name{p} ' - ' homeo_res.date{p}], 't');
        
    end
end

