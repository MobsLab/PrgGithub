%%QuantifHomeostasisPFCdeepFakeDeltaPlotAll
% 12.09.2019 KJ
%
% Infos
%   plot all
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta
%    QuantifHomeostasisPFCdeepFakeDeltaPlot
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisPFCdeepFakeDelta.mat'))


for p=1:length(homeo_res.path)
    
    for ch=1:length(homeo_res.channels{p})
    
        figure, hold on
        
        %down 1
        subplot(2,2,1), hold on
        Hstat = homeo_res.down.rescaled.Hstat{p};
        limSplit = Hstat.limSplit;

        plot(Hstat.x_intervals, Hstat.y_density, 'b');
        plot(Hstat.x_intervals, Hstat.reg0,'r.')
        idx1 = Hstat.x_intervals<limSplit;
        idx2 = Hstat.x_intervals>limSplit; 
        plot(Hstat.x_intervals(idx1), Hstat.reg1(idx1),'k.')
        plot(Hstat.x_intervals(idx2), Hstat.reg2(idx2),'k.')
        hold on, scatter(Hstat.x_peaks, Hstat.y_peaks,'r')
        
        title(['Down states - ' homeo_res.name{p} ' - ' homeo_res.date{p}])
        
        
        %diff
        subplot(2,2,3), hold on
        Hstat = homeo_res.diff.rescaled.Hstat{p};
        limSplit = Hstat.limSplit;

        plot(Hstat.x_intervals, Hstat.y_density, 'b');
        plot(Hstat.x_intervals, Hstat.reg0,'r.')
        idx1 = Hstat.x_intervals<limSplit;
        idx2 = Hstat.x_intervals>limSplit; 
        plot(Hstat.x_intervals(idx1), Hstat.reg1(idx1),'k.')
        plot(Hstat.x_intervals(idx2), Hstat.reg2(idx2),'k.')
        hold on, scatter(Hstat.x_peaks, Hstat.y_peaks,'r')
        
        title('Delta diff')
        
        
        %delta single channel
        subplot(2,2,2), hold on
        Hstat = homeo_res.delta.rescaled.Hstat{p,ch};
        limSplit = Hstat.limSplit;

        plot(Hstat.x_intervals, Hstat.y_density, 'b');
        plot(Hstat.x_intervals, Hstat.reg0,'r.')
        idx1 = Hstat.x_intervals<limSplit;
        idx2 = Hstat.x_intervals>limSplit; 
        plot(Hstat.x_intervals(idx1), Hstat.reg1(idx1),'k.')
        plot(Hstat.x_intervals(idx2), Hstat.reg2(idx2),'k.')
        hold on, scatter(Hstat.x_peaks, Hstat.y_peaks,'r')
        
        title(['Delta w down ch ' num2str(homeo_res.channels{p}(ch))])
        
        
        %fake
        subplot(2,2,4), hold on
        Hstat = homeo_res.other.rescaled.Hstat{p,ch};
        limSplit = Hstat.limSplit;

        plot(Hstat.x_intervals, Hstat.y_density, 'b');
        plot(Hstat.x_intervals, Hstat.reg0,'r.')
        idx1 = Hstat.x_intervals<limSplit;
        idx2 = Hstat.x_intervals>limSplit; 
        plot(Hstat.x_intervals(idx1), Hstat.reg1(idx1),'k.')
        plot(Hstat.x_intervals(idx2), Hstat.reg2(idx2),'k.')
        hold on, scatter(Hstat.x_peaks, Hstat.y_peaks,'r')
        
        title('Fake delta')
    
    end
end




