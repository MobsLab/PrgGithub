function [LocalFreq,LocalPhase,AllPeaks,Wavelet] = GetFreq_PT_WV_CH(struct,varargin)

Options.Fs = 1250; % Hz
Options.FilBand = [1 15];
Options.std = [0.4 0.1];
Options.TimeLim = 0.08;
Options.NumOctaves = 8;
Options.VoicesPerOctave = 48;
Options.VoicesPerOctaveCoherence = 32;
Options.FreqLim = [1.5, 30];
Options.WVDownsample = 10;
Options.TimeBandWidth = 15;
Options1 = Options;
Options1.Fs = Options.Fs / Options.WVDownsample;
AllCombi=combnk(1:3,2);

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch lower(varargin{i})
        case 'freqlim'
            Options.FreqLim = varargin{i+1};
        otherwise
            warning(['Unknown parameter: ' varargin{i}]);
    end
end



%% Load relevant LFPs

switch lower(struct)
    case 'hpc'
        try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
            try,
                load('ChannelsToAnalyse/dHPC_deep.mat'),
            catch
                load('ChannelsToAnalyse/dHPC_sup.mat'),
            end
        end
        
    case 'ob'
        load('ChannelsToAnalyse/Bulb_deep.mat')
        
    case 'pfc'
        
        load('ChannelsToAnalyse/PFCx_deep.mat')
        
    otherwise
        error('Unknown structure, chose between HPC, OB or PFC');
end

load(['LFPData/LFP',num2str(channel),'.mat'])
tps=Range((LFP));
vals=Data((LFP));
LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));

rmpath('/home/greta/PrgGithub/chronux2/spectral_analysis/continuous')

%%Get local phase and amplitude with two methods

% Wavelet method

[Wavelet.spec,Wavelet.freq,Wavelet.coi,Wavelet.OutParams]=cwt_SB(Data(LFPdowns),Options.Fs/Options.WVDownsample,'NumOctaves',Options.NumOctaves,...
    'VoicesPerOctave',Options.VoicesPerOctave,'TimeBandwidth',Options.TimeBandWidth);
Wavelet.spec=Wavelet.spec(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'),:);
Wavelet.freq=Wavelet.freq(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'));
[val,ind]=max(abs(Wavelet.spec));
LocalFreq.WV=tsd(Wavelet.OutParams.t*1e4,Wavelet.freq(ind));
idx=sub2ind(size(Wavelet.spec),ind,1:length(ind));
LocalPhase.WV=tsd(Wavelet.OutParams.t*1e4,angle(Wavelet.spec(idx))');

% Peak-Trough method

AllPeaks=FindPeaksForFrequency(LFPdowns,Options1,0);
AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFPdowns,'s'));
if AllPeaks(1,2)==1
    LocalPhase.PT=tsd(Range(LFPdowns),mod(Y,2*pi));
else
    LocalPhase.PT=tsd(LFPdowns,mod(Y+pi,2*pi));
end
tpstemp=AllPeaks(2:2:end,1);
LocalFreq.PT=tsd(tpstemp(1:end-1)*1e4,1./diff(AllPeaks(2:2:end,1)));


end

