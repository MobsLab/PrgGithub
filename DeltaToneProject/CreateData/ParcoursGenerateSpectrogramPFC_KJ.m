%%ParcoursGenerateSpectrogramPFC_KJ
%
% 12.03.2018 KJ
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
    
    clearvars -except Dir p
    
    %PFCx channels 
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    
    %loop
    for ch=1:length(channels)
        if exist(['Spectra/Specg_ch' num2str(channels(ch)) '.mat'],'file')==2
            continue
        end
        
        %init
        mkdir('Spectra')
        params.fpass  = [0.1 48];
        params.tapers = [3 5];
        movingwin     = [3 0.2];
        params.Fs     = 1250;
        
        %load
        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
        PFC_sig = LFP; clear LFP
        
        %compute
        [Sp,t,f] = mtspecgramc(Data(PFC_sig),movingwin,params);
        Spectro  = {Sp,t,f};
        
        %save
        savename = fullfile('Spectra', ['Specg_ch' num2str(channels(ch))]);
        channel =  channels(ch);
        save(savename,'Spectro','params','movingwin', 'channel', '-v7.3')
        
    end
    
end
    







