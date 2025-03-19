function [Sp,t,f]=ComputeSpectrogramClinic(filename,varargin)
%
%   [Sp,t,f]=ComputeSpectrogramClinic('27501.h5','channel',2)
%
% INPUT
%   filename            filename of the hdf5 File to work with
%
%   channel             (optional) channel on which we compute the spectrogram
%                       (default 1) 
%   savefigure          (optional) 1 to plot and save spectrogram figure, 0 otherwise
%                       (default 0)
%   movingwin           (optional) [window winstep] i.e length of moving window and step size
%                                  Note that units here have to be consistent with units of Fs
%                       (default [3 0.2]) 
%   params              (optional) Parameters of the spectral analysis: tapers / pad / Fs / pad (cf mtspecgramc.m)
%                       (default fpass = [0.1 20] / tapers = [1 2] / Fs=250)
%
% OUTPUT
%   S       spectrum in form time x frequency x channels/trials if trialave=0; 
%               in the form time x frequency if trialave=1
%   t       times
%   f       frequencies
%
% SEE
%   LoadSpectrumML mtspecgramc 
%
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'channel',
            channel = varargin{i+1};
            if ~isvector(channel) || length(channel)~=1
                error('Incorrect value for property ''channel''.');
            end
        case 'savefigure',
            savefigure = varargin{i+1};
            if savefigure~=0 && savefigure~=1
                error('Incorrect value for property ''savefigure''.');
            end
        case 'movingwin',
            movingwin = varargin{i+1};
            if ~isvector(movingwin) || length(movingwin)~=2
                error('Incorrect value for property ''movingwin''.');
            end
        case 'params',
            params = varargin{i+1};
            if ~isstruct(params)
                error('Incorrect value for property ''params''.');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('channel','var')
    channel = 1;
end
if ~exist('savefigure','var')
    savefigure = 0;
end
if ~exist('movingwin','var')
    movingwin=[3 0.2];
end
if ~exist('params','var')
    params.fpass = [0.4 30];
end
if ~isfield(params,'fpass')
    params.fpass = [0.4 30];
end
if ~isfield(params,'tapers')
    params.tapers = [3 5];
end
if ~isfield(params,'Fs')
    params.Fs=250;
end



%% load signal
[signals, ~, ~, name_channel, ~] = GetRecordClinic(filename);
signal_data = ResampleTSD(signals{channel}, params.Fs);


%% Spectrogram
[Sp,t,f] = mtspecgramc(Data(signal_data),movingwin,params);



%% Plot
if savefigure
    %plot params
    tlim = [t(1)/3600 t(end)/3600];
    flim = [f(1) f(end)];
    
    %figure
    figure, hold on
    imagesc(t/3600, f, log(Sp)'), hold on
    axis xy, xlabel('time (h)'), ylabel('frequency'), hold on
    set(gca,'Xticklabel',0:1:floor(tlim(2)),'XLim', tlim,'Yticklabel',5:5:25, 'YLim',flim, 'FontName','Times','fontsize',12);
    title([name_channel{channel} ' Spectrogram'])
    colorbar('location','eastoutside'); hold on
    %save
    saveas(gcf,[filename(1:end-3) '_specgram_ch' num2str(channel) '.png'],'png')
    close
end

end


