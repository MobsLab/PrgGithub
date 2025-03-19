




function [thr_1,thr_2,thr_3,thr_4]=FrequencyThresholdSpectro_BM(input1,input2,input3,input4,Spectro)

thr_1=find(Spectro>input1 & Spectro< (input1 +0.08));
thr_2=find(Spectro>input2 & Spectro<(input2 +0.08));
thr_3=find(Spectro>input3 & Spectro<(input3 +0.08));
thr_4=find(Spectro>input4 & Spectro<(input4 +0.08));

end



















