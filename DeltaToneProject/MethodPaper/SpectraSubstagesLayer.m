%%SpectraSubstagesLayer
% 01.03.2018 KJ
%
% Compare spectrum for many PFCx Layers, in different substages
%
%   see 
%       LFPonDownStatesLayer
%


Dir = PathForExperimentsBasalSleepRhythms;
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color

%% 
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    %Substages
    load('SleepSubstages.mat')
    
    %PFCx channels 
    channels = GetDifferentLocationStructure('PFCx');

    for ch=1:length(channels)
        %spectrum
        load(fullfile('Spectra',['Specg_ch' num2str(channels(ch)) '.mat']), 'Spectro')
        freq = Spectro{3};
        Sp   = tsd(Spectro{2}*1E4,Spectro{1});


        %% PLOT
        figure, hold on
        
        %f*P(f)
        subplot(1,2,1), hold on
        for sub=1:4
            norm_spectrum = freq.*mean(Data(Restrict(Sp,Epoch{sub})));
            hold on, plot(freq, norm_spectrum, 'color',colori{sub})
        end
        legend(NameEpoch(1:4))

        %10*log10(P(f))
        subplot(1,2,1), hold on
        for sub=1:4
            norm_spectrum = 10*log10(mean(Data(Restrict(Sp,Epoch{sub}))));
            hold on, plot(freq, norm_spectrum, 'color',colori{sub})
        end
        legend(NameEpoch(1:4))    
    end
    
end





