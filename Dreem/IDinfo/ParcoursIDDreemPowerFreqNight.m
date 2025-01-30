%%ParcoursIDDreemPowerFreqNight
%
% 02.03.2018 KJ
%
%


clear
Dir = ListOfDreemRecordsStimImpact('all');

for p=1:length(Dir.filereference)  
    
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filereference{p})
    
    clearvars -except Dir p
    
    
    %params
    freq = [0:0.5:5 6:1:25];  
    smoothing = 600;
    th=1.4;


    %% PLOT   
    for ch=1:6
          
        %name fig
        filename_fig = ['NightFreqSpectra_' num2str(Dir.filereference{p}) '_ch' num2str(ch)];
        filename_png = [filename_fig  '.png'];
        filename_png = fullfile(FolderStimImpactFigures,'IDSpectroNightFrequency', filename_png);
        if exist(filename_png,'file')==2
            continue
        end
        
        
        %spectrum
        datafile = fullfile(FolderStimImpactPreprocess,'Spectrograms',num2str(Dir.filereference{p}),['Spectro_' num2str(Dir.filereference{p}) '_ch_' num2str(ch) '.mat']);
        load(datafile)
        specg   = Spectro{1};
        sptimes = Spectro{2}/3600;
        spfreq  = Spectro{3};
        
        %plot 
        figure, hold on
        
        for f=1:length(freq)-1
            %P(f)
            Sp = specg(:, spfreq>freq(f) & spfreq<=freq(f+1));
            spectrum = mean(Sp,2);
            threshold = exp(mean(log(spectrum)) * th);
            spectrum(spectrum>threshold) = 1;
            spectrum = zscore(spectrum);
            
            y_spec = smooth(spectrum,smoothing);
            y_spec = y_spec - y_spec(1) + f+0.5;
            hold on, plot(sptimes, y_spec, 'color', 'k')
            
        end
        %title
        title_fig = [Dir.subject{p}  ' - ' Dir.date{p} ' ('  Dir.condition{p} ') - Channel ' num2str(ch) ];
        title(title_fig), hold on
        set(gca,'Ytick',1:2:length(freq),'YtickLabel',freq(1:2:length(freq)));
        set(gca,'xlim',[0 max(sptimes)], 'ylim', [0 ceil(max(y_spec))]);
        
        %% Name and title
        
        %save figure
        savefig(filename_fig)
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
        
    end

    
    
    
    
end




