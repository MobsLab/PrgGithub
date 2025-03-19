
cd /media/DataMOBS23/M248/20150326/FEAR-Mouse-248-26032015-EXTenvC_150326_155513/LFPData
load LFP8.mat
figure; 
plot(Range(LFP)*10E-5, Data(LFP)),hold on, 
ref_filtered=FilterLFP(LFP,[0.00001 1]);
plot(Range(ref_filtered)*10E-5, Data(ref_filtered), 'Color', 'r'),


title('FEAR-Mouse-248-26032015-EXTenvC')
load LFP20.mat % amygdala

plot(Range(LFP)*10E-5, Data(LFP), 'g'),


load LFP14.mat % piriform

plot(Range(LFP)*10E-5, Data(LFP), 'c'),