% GetActivityDebug
%   This script is used to debug GetActivity2. In particular, it plot the
%   result of each different tests.
%
% by antoine.delhomme@espci.fr
%

% Load data
a = Activity(36, 5);
     
% Prepare the figure
clf;

%% Test #1 : search the main frequency between 0 and 5 Hz in the last block
subplot(6, 1, 1);
a.plotForEachGroup(@test_mainFreq, 0);
title('(I) test\_mainFreq - Main freq (AWAKE)');
drawnow

%% Test #2 : look at the amplitude of the auto-correlation of the signal
subplot(6, 1, 2);
a.plotForEachGroup(@test_xcorrAmpl, 0);
title('(II) test\_xcorrAmpl - Amplitude of xcorr (SLEEP)');
drawnow

%% Test #3 : look at the amplitude of the signal
subplot(6, 1, 3);
a.plotForEachGroup(@test_sigAmpl, 0);
title('(III) test\_sigAmpl - Amplitude of the signal (SC - AWAKE)');
drawnow

%% Test #4 : look at the reccurence plot
subplot(6, 1, 4);
a.plotForEachGroup(@test_reccPlot, 0);
title('(IV) test\_reccPlot - Reccurence plot (SC - AWAKE)');
drawnow

%% Test #5: look at the picks of the autocorrelation
subplot(6, 1, 5);
a.plotForEachGroup(@test_xcorrPicks, 0);
title('(V) test\_xcorrPicks - Picks in the xcorr (SC - SLEEP)');
drawnow

%% END: plot the final grade
subplot(6, 1, 6);
a.plotForEachGroup(@GetActivity2, 1);
title('GetActivity2');
drawnow