

load('ExpeInfo.mat')
InfoLFP.channel = ExpeInfo.InfoLFP.channel;
BaseFileName = ['M' num2str(ExpeInfo.nmouse) '_' ExpeInfo.date '_' ExpeInfo.SessionType];


for chan=[25:30] %change back to 25:30
%     if exist(['LFPData/LFP' num2str(InfoLFP.channel(chan)) '.mat'],'file') %only LFP signals
        
        disp(['loading and saving LFP' num2str(InfoLFP.channel(chan)) ' in LFPData...']);
        % FMA toolbox function to load LFP
        
        SetCurrentSession([BaseFileName '.xml'])
        
        
        %% GetLFP.mat part
        intervals = [0 Inf];
        select = 'id';
        frequency = 1250*1.5;
        
        filename = [BaseFileName '.lfp'];
        nChannels = length(ExpeInfo.InfoLFP.channel);
        channels=chan;
        
        nIntervals = size(intervals,1);
        lfp = [];
        indices = [];
        for i = 1:nIntervals
            duration = (intervals(i,2)-intervals(i,1));
            start = intervals(i,1);
            % Load data
            data = LoadBinary(filename,'duration',duration,'frequency',frequency,'nchannels',nChannels,'start',start,'channels',channels);
            t = start:(1/frequency):(start+(length(data)-1)/frequency);t=t';
            lfp = [lfp ; t data];
            indices = [indices ; i*ones(size(t))];
        end
        
        LFP_temp = lfp;
        %% -----------------------------------------------------
        
        %data to tsd
        LFP = tsd(LFP_temp(:,1)*1E4, LFP_temp(:,2));
        SessLength = max(LFP_temp(:,1));
        %save
        save([pwd '/LFPData/LFP' num2str(InfoLFP.channel(chan))], 'LFP');
        clear LFP LFP_temp
%     end
end



