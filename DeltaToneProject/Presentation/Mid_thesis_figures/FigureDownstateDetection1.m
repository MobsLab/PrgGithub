% FigureDownstateDetection1
% 14.12.2016 KJ
%
% Plot the figures from the Figure2.pdf of Gaetan PhD
% - a
% 
%   see GenerateIDSleepRecord
%


a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; % Mouse 243 - Day 2
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'; % Mouse 243 - Day 5
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse244';  % 16-04-2015 > delay 200ms - Mouse 244
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice328-330/20160408/Mouse330/Breath-Mouse-330-08042016'; % Mouse 330 - Day 4
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1



for p=2:length(Dir.path)
    
    clearvars -except Dir p
    %go to record and load
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    load IdFigureData

    %Axes
    figure('units','normalized');
    RasterDown_Axes = axes('position', [0.05 0.05 0.4 0.7]);
    DistribDown_Axes = axes('position', [0.5 0.05 0.45 0.75]);
    textbox_dim = [0.05 0.76 0.3 0.2];

    %textbox
    textbox_str = {[num2str(nb_neuron) ' neurons'], [num2str(nb_pyramidal) ' pyramidal(s) / ' num2str(nb_interneuron) ' interneuron(s)'],... 
                    ['FR (SWS) = ' num2str(firingRates_sws) ' Hz ( ' num2str(round(firingRates_sws/nb_neuron,2)) ' Hz)'],...
                    ['FR (Wake) = ' num2str(firingRates_wake) ' Hz ( ' num2str(round(firingRates_wake/nb_neuron,2)) ' Hz)'],...
                    ['Pyr (SWS) = ' num2str(firingRates_sws_pyr) ' Hz ( ' num2str(round(firingRates_sws_pyr/nb_pyramidal,2)) ' Hz)'],...
                    ['Pyr (Wake) = ' num2str(firingRates_wake_pyr) ' Hz ( ' num2str(round(firingRates_wake_pyr/nb_pyramidal,2)) ' Hz)'],...
                    ['Int (SWS) = ' num2str(firingRates_sws_int) ' Hz ( ' num2str(round(firingRates_sws_int/nb_interneuron,2)) ' Hz)'],...
                    ['int (Wake) = ' num2str(firingRates_wake_int) ' Hz ( ' num2str(round(firingRates_wake_int/nb_interneuron,2)) ' Hz)']};


    annotation(gcf,'textbox',...
        textbox_dim,...
        'String',textbox_str,...
        'LineWidth',1,...
        'HorizontalAlignment','center',...
        'FontWeight','bold',...
        'FitBoxToText','off');

    %raster
    axes(RasterDown_Axes);
    if exist('raster_x','var')
        imagesc(raster_x/1E4, 1:size(raster_matrix,1), raster_matrix), hold on
        axis xy, xlabel('time (sec)'), ylabel('# down'), hold on
        colorbar, hold on
    end

    %distribution of down
    axes(DistribDown_Axes);
    if nb_neuron>0
        plot(minDurBins, nbDownSWS ,'r','Linewidth',2), hold on
        plot(minDurBins, nbDownWake ,'k','Linewidth',2), hold on
        set(gca,'xscale','log','yscale','log'), hold on
        set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
        set(gca,'xtick',[10 50 100 200 500 1500]), hold on
        legend('SWS','Wake'), xlabel('down duration (ms)'), ylabel('number of down')
        line([75 75],ylim,'color','b','Linewidth',2);
    end
    
    

    %title
    title_fig = Dir.path{p};
    filename_eps = ['DownDetection' num2str(p) '.eps'];
    % suptitle
    suplabel(title_fig,'t');
    %save figure
    cd('/home/mobsjunior/Dropbox/Mobs_member/KarimJr/Presentation/Mid-thesis/Figure/')
    saveas(gcf,filename_eps,'epsc')
    close all
end
