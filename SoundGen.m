cf = 20000;                  % carrier frequency (Hz)
dur = 1.0;                    % duration (s)

%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------

% prepare tone 1
sf1 = 5000;                  % sample frequency (Hz)
n1 = sf1 * dur;              % number of samples
s1 = (1:n1) / sf1;           % sound data preparation
s1 = sin(2 * pi * cf * s1);  % sinusoidal modulation

% prepare tone 2
sf2 = 10000;                 % sample frequency (Hz)
n2 = sf2 * dur;              % number of samples
s2 = (1:n2) / sf2;           % sound data preparation
s2 = sin(2 * pi * cf * s2);  % sinusoidal modulation

% prepare tone 3
sf3 = 15000;                 % sample frequency (Hz)
n3 = sf3 * dur;              % number of samples
s3 = (1:n3) / sf3;           % sound data preparation
s3 = sin(2 * pi * cf * s3);  % sinusoidal modulation


% prepare tone 4
sf4 = 20000;                 % sample frequency (Hz)
n4 = sf4 * dur;              % number of samples
s4 = (1:n4) / sf1;           % sound data preparation
s4 = sin(2 * pi * cf * s4);  % sinusoidal modulation


%--------------------------------------------------------------------------
%----------------------------- Sound Generation ---------------------------
%--------------------------------------------------------------------------


% make ramped sound
sound(s1,sf1);
pause(0.1);
figure
plot(s1,'b')

sound(s2,sf2);
pause(0.1);               % waiting for sound end
hold on, plot(s2,'g')

sound(s3,sf3);
pause(0.1);                 % waiting for sound end
hold on; plot(s3,'r')

sound(s4,sf4);
pause(0.1);              % waiting for sound end
hold on; plot(s4,'c')
