%%% File with description of how I found ripples for each mose

%% Mouse 711
dir = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/PostSleep/';

if sleepsession == 1
	[ripples,stdev] = FindRipples_DB (dHPC_rip, nonrip, [2 5]); % clean = 0; rmnoise = 1;
else
 	load ([dir_rip 'Ripples.mat']);
	[ripples, stdev] = FindRipples_DB (dHPC_rip, nonrip, [2 4],'rmvnoise', 0, 'clean', 1, 'stdev', stdev);
end


%% Mouse 714

dir = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/27022018/PostSleep/';

if sleepsession == 1
	[ripples,stdev] = FindRipples_DB (dHPC_rip, nonrip, [2 4], 'clean', 1); % rmnoise = 0;
else
 	load ([dir_rip 'Ripples.mat']);
	[ripples, stdev] = FindRipples_DB (dHPC_rip, nonrip, [2 4],'rmvnoise', 0, 'clean', 1, 'stdev', stdev);
end