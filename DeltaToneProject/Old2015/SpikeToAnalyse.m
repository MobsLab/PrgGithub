res=pwd;
mkdir([res,'/SpikesToAnalyse']);
load SpikeData

% >>>>>>>>>>>>>>>>>>>>>>>  PFCX   <<<<<<<<<<<<<<<<<<<<<<<<<<<<
clear number
disp('  ')
number=input('which MUA for PFCx ?   ');
disp('  ')
save SpikesToAnalyse/PFCx_MUA number
clear number
disp('  ')
number=input('which neurons for PFCx ?   ');
disp('  ')
save SpikesToAnalyse/PFCx_Neurons number

% >>>>>>>>>>>>>>>>>>>>>>>  MoCx   <<<<<<<<<<<<<<<<<<<<<<<<<<<<
clear number
disp('  ')
number=input('which MUA for MoCx ?   ');
disp('  ')
save SpikesToAnalyse/MoCx_MUA number
clear number
disp('  ')
number=input('which neurons for MoCx ?   ');
disp('  ')
save SpikesToAnalyse/MoCx_Neurons number

% >>>>>>>>>>>>>>>>>>>>>>>  dHPC   <<<<<<<<<<<<<<<<<<<<<<<<<<<<
clear number
disp('  ')
number=input('which MUA for dHPC ?   ');
disp('  ')
save SpikesToAnalyse/dHPC_MUA number
clear number
disp('  ')
number=input('which neurons for dHPC ?   ');
disp('  ')
save SpikesToAnalyse/dHPC_Neurons number

% >>>>>>>>>>>>>>>>>>>>>>>  NRT   <<<<<<<<<<<<<<<<<<<<<<<<<<<<
clear number
disp('  ')
number=input('which MUA for NRT ?   ');
disp('  ')
save SpikesToAnalyse/NRT_MUA number
clear number
disp('  ')
number=input('which neurons for NRT ?   ');
disp('  ')
save SpikesToAnalyse/NRT_Neurons number

% >>>>>>>>>>>>>>>>>>>>>>>  Bulb   <<<<<<<<<<<<<<<<<<<<<<<<<<<<
clear number
disp('  ')
number=input('which MUA for Bulb ?   ');
disp('  ')
save SpikesToAnalyse/Bulb_MUA number
clear number
disp('  ')
number=input('which neurons for Bulb ?   ');
disp('  ')
save SpikesToAnalyse/Bulb_Neurons number
