%%ParcoursIDSpectraSubstagesPFCx
%
% 02.03.2018 KJ
%
%


clear
Dir = PathForExperimentsBasalSleepRhythms;


%% Delay for sham
for p=16:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    

    %load substages
    load('SleepSubstages.mat','Epoch')
    NameEpoch = {'N1', 'N2', 'N3', 'REM', 'Wake'};
    colori_sub = {'k', [1 0.5 1], 'r', [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
    
    %PFCx channels 
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')

    %% PLOT
    figure, hold on 
    [nx,nsp] = numSubplots(2*length(channels));
    ny=nx(1); nx=nx(2);
    
    for ch=1:length(channels)
        %spectrum
        load(fullfile('Spectra',['Specg_ch' num2str(channels(ch)) '.mat']), 'Spectro')
        freq = Spectro{3};
        Sp   = tsd(Spectro{2}*1E4,Spectro{1});
        
        subplot(nx,ny,2*ch)
        for sub=1:4
            %P(f)
            spectrum = mean(Data(Restrict(Sp,Epoch{sub})));
            
            %Spectrum f*P(f)
            subplot(nx,ny,2*ch-1), hold on
            norm_spectrum = freq.*spectrum;
            hold on, plot(freq, norm_spectrum, 'color',colori_sub{sub})
            
            %Spectrum 10*log10(P(f))
            subplot(nx,ny,2*ch), hold on
            log_spectrum = 10*log10(spectrum);
            hold on, plot(freq, log_spectrum, 'color',colori_sub{sub})
            
        end
        
        subplot(nx,ny,1), hold on
        legend(NameEpoch(1:4)),
    end

    
    
    %% Name and title
    %title
    title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ')'];
    filename_fig = ['SubstageSpectra_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    % suptitle
    suplabel(title_fig,'t');
    %save figure
    savefig(filename_fig)
    cd([FolderFigureDelta 'IDfigures/BasalDataSet/SpectraSubstagesPFCx/'])
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    close all
    
end




