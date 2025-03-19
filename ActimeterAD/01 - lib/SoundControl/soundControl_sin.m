function soundControl_sin( c, time )
% soundControl_sin
%   Define a function to modulate the amplitude of a sound in the
%   SoundControl() context.
%
% by antoine.delhomme@espci.fr
%

% Set parameters
% General parameters
sound = c.SOUND_NOISE;
channels = 0:11;

% The sound will be modulated by a sinus
%   ampl_min:   lowest amplitude of the modulation
%   ampl_max:   highes amplitude of the modulation
%   freq:       frequency of the modulation
%   sampling:   sampling rate of the modulation
ampl_min = 180;
ampl_max = 200;
freq = 2;
sampling = 20;

%% Transition
% Define aliases
ampl = ampl_max - ampl_min;

%% Update sound
% Compute the new volume
volume = 1 + sin(2*pi*time*freq/sampling);
volume = ampl_min + floor(ampl*volume/2);

for channel = channels
    c.setChannel(channel, sound, volume);
    %disp(volume);
end

end