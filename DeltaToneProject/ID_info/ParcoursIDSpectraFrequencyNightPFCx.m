%%ParcoursIDSpectraFrequencyNightPFCx
%
% 02.03.2018 KJ
%
%


clear
Dir = PathForExperimentsBasalSleepRhythms;


%
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    %PFCx channels 
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    
    %frequency
    freq = [0:0.5:5 6:1:25];  

    %% PLOT   
    for ch=1:length(channels)
        
        %name fig
        filename_fig = ['NightFreqSpectra_' Dir.name{p}  '_' Dir.date{p} '_ch' num2str(channels(ch))];
        filename_png = [filename_fig  '.png'];
        filename_png = fullfile(FolderFigureDelta,'IDfigures','BasalDataSet','SpectraNightFrequencyPFCx', filename_png);
        if exist(filename_png,'file')==2
            continue
        end
        
        figure, hold on
        
        %spectrum
        load(fullfile('Spectra',['Specg_ch' num2str(channels(ch)) '.mat']), 'Spectro')
        specg   = Spectro{1};
        sptimes = Spectro{2}/3600;
        spfreq  = Spectro{3};
        
        %plot 
        for f=1:length(freq)-1
            %P(f)
            Sp = specg(:, spfreq>freq(f) & spfreq<=freq(f+1));
            spectrum = zscore(mean(Sp,2));
            y_spec = smooth(spectrum,1000);
            y_spec = y_spec - y_spec(1) + f+0.5;
            hold on, plot(sptimes, y_spec, 'color', 'k')
            
        end
        %title
        title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ') - Channel ' num2str(channels(ch)) ];
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




