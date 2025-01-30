res=pwd;
load([res,'/LFPData/InfoLFP']);

disp(' >>>  for information : ')
InfoLFP.structure
disp('   ')

mkdir([res,'/ChannelsToAnalyse']);

% >>> Olfactory Bulb <<<
clear channel
disp('  ')
channel=input('what channel for Bulb deep ?   ');
disp('  ')
save ChannelsToAnalyse/Bulb_deep channel
clear channel
disp('  ')
channel=input('what channel for Bulb sup ?   ');
disp('  ')
save ChannelsToAnalyse/Bulb_sup channel

% >>> Hippocampus <<<
clear channel
disp('  ')
channel=input('what channel for dHPC deep?   ');
disp('  ')
save ChannelsToAnalyse/dHPC_deep channel
clear channel
disp('  ')
channel=input('what channel for dHPC ripples?   ');
disp('  ')
save ChannelsToAnalyse/dHPC_rip channel
clear channel
disp('  ')
channel=input('what channel for dHPC sup ?   ');
disp('  ')
save ChannelsToAnalyse/dHPC_sup channel

% >>> Motor Cortex <<<
clear channel
disp('  ')
channel=input('what channel for MoCx deep ?   ');
disp('  ')
save ChannelsToAnalyse/MoCx_deep channel
clear channel
disp('  ')
channel=input('what channel for MoCx sup ?   ');
disp('  ')
save ChannelsToAnalyse/MoCx_sup channel

% >>> Parietal Cortex <<<
clear channel
disp('  ')
channel=input('what channel for PaCx deep ?   ');
save ChannelsToAnalyse/PaCx_deep channel
disp('  ')
clear channel
channel=input('what channel for PaCx sup ?   ');
disp('  ')
save ChannelsToAnalyse/PaCx_sup channel

% >>> Prefrontal Cortex <<<
clear channel
disp('  ')
channel=input('what channel for PFCx deep ?   ');
save ChannelsToAnalyse/PFCx_deep channel
disp('  ')
clear channel
channel=input('what channel for PFCx sup ?   ');
disp('  ')
save ChannelsToAnalyse/PFCx_sup channel

% >>> Reticular Thalamic Nucleus <<<
clear channel
disp('  ')
channel=input('what channel for NRT deep ?   ');
disp('  ')
save ChannelsToAnalyse/NRT_deep channel
clear channel
disp('  ')
channel=input('what channel for NRT sup ?   ');
disp('  ')
save ChannelsToAnalyse/NRT_sup channel

