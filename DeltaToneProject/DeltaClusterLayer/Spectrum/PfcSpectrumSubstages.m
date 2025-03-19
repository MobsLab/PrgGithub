%%PfcSpectrumSubstages
%
% 02.03.2018 KJ
%
%


clear
Dir = PathForExperimentsBasalSleepSpike;


%% Delay for sham
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p spectra_res
    
    spectra_res.path{p}   = Dir.path{p};
    spectra_res.manipe{p} = Dir.manipe{p};
    spectra_res.name{p}   = Dir.name{p};
    spectra_res.date{p}   = Dir.date{p};
    
    
    %load substages
    load('SleepSubstages.mat','Epoch')
    for sub=1:length(Epoch)
        Substages{p,sub} = Epoch{sub};
    end

    %PFCx channels 
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')

    for ch=1:length(channels)
        %spectrum
        load(fullfile('Spectra',['Specg_ch' num2str(channels(ch)) '.mat']), 'Spectro')
        freq = Spectro{3};
        Sp   = tsd(Spectro{2}*1E4,Spectro{1});
        
        for sub=1:length(Epoch)
            %P(f)
            spectrum{ch,sub} = [freq' mean(Data(Restrict(Sp,Epoch{sub})))'];
        end
    end
    
    
    %save
    spectra_res.channels{p} = channels;
    spectra_res.spectrum{p} = spectrum;
    
end


%% saving data
cd(FolderDeltaDataKJ)
save PfcSpectrumSubstages.mat spectra_res Substages

