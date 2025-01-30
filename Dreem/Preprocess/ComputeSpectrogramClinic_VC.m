function [Sp_dreem,t_dreem,f_dreem,Sp_psg,t_psg,f_psg]=ComputeSpectrogramClinic_VC(filename, filereference, varargin)
%
%   [Sp_dreem,t_dreem,f_dreem,Sp_psg,t_psg,f_psg]=ComputeSpectrogramClinic_VC('27501.h5', 27051)
%
% INPUT
%   filename            filename of the hdf5 File to work with
% 
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

if nargin < 2 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
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
[signals, ~, ~, ~, ~] = GetRecordClinic(filename);
[index_dreem, index_psg, ~, ~] = GetVirtualChannels(filereference);

%% VIRTUAL CHANNEL SIGNAL
% Dreem 
dreem_ch1 = strcmpi(infos.name_channel,'FP1-M1');
dreem_ch2 = strcmpi(infos.name_channel,'FP2-M2');

sig_f1 = Data(signals{dreem_ch1}) .* (index_dreem==0);
sig_f2 = Data(signals{dreem_ch2}) .* (index_dreem==1);

signals_dreem_vc = sig_f1 + sig_f2;
signals_dreem_vc = tsd(Range(signals{dreem_ch1}), signals_dreem_vc);

% Actiwave
psg_ch1 = strcmpi(infos.name_channel,'REF F3');
psg_ch2 = strcmpi(infos.name_channel,'REF F4');

sig_f3 = Data(signals{psg_ch1}) .* (index_psg==0);
sig_f4 = Data(signals{psg_ch2}) .* (index_psg==1);

signals_psg_vc = sig_f3 + sig_f4;
signals_psg_vc = tsd(Range(signals{psg_ch1}), signals_psg_vc);

%Resample
signals_dreem_vc = ResampleTSD(signals_dreem_vc, params.Fs);
signals_psg_vc = ResampleTSD(signals_psg_vc, params.Fs);


%% Spectrogram
[Sp_dreem,t_dreem,f_dreem] = mtspecgramc(Data(signals_dreem_vc),movingwin,params);
[Sp_psg,t_psg,f_psg] = mtspecgramc(Data(signals_psg_vc),movingwin,params);


end


