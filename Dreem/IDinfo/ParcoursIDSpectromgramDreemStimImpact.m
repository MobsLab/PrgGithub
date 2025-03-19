%%ParcoursIDSpectromgramDreemStimImpact
%
% 28.03.2018 KJ
%
%


clear
Dir = ListOfDreemRecordsStimImpact('all');

for p=1:length(Dir.filereference)  
    
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filereference{p})
    
    clearvars -except Dir p
    
    
    figure, hold on

    %% PLOT   
    for ch=1:6
        subplot(3,2,ch), hold on
        
        
        %spectrum
        datafile = fullfile(FolderStimImpactPreprocess,'Spectrograms',num2str(Dir.filereference{p}),['Spectro_' num2str(Dir.filereference{p}) '_ch_' num2str(ch) '.mat']);
        load(datafile)
        Specg   = Spectro{1};
        t_spg   = Spectro{2};
        f_spg   = Spectro{3};
        
        %plot
        imagesc(t_spg/3600, f_spg, log(Specg)'), hold on
        axis xy, ylabel('frequency'), hold on
        set(gca,'Yticklabel',5:5:35,'xlim',[0 max(t_spg/3600)]);
        colorbar, caxis([-8 8]);
        title(['channel ' num2str(ch)]),
        
    end
    
    title_fig = [Dir.subject{p}  ' - ' Dir.date{p} ' ('  Dir.condition{p} ')'];
    suplabel(title_fig, 't')

    %title
    filename_png = ['Spectrograms_' num2str(Dir.filereference{p})  '.png'];
    filename_png = fullfile(FolderStimImpactFigures,'IDSpectrogram', filename_png);
    %save figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    close all
    
    
    
end




