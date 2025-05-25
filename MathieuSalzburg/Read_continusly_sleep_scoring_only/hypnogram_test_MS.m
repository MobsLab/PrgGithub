% %Code to extract the Online Hypnogram according the github page of Adrien
% %and Baptiste. Page Saved results
% 
% fileinfo = dir('_20240503_141536/digitalout.dat');
% num_samples = fileinfo.bytes/2; %uint16 = 2 bytes
% fid = fopen('digitalout.dat', 'r');
% hypnogramOnline = fread(fid, num_samples, 'uint16')/256;
% hypnogramOnline = hypnogramOnline(1:20000:end);
% fclose(fid);
% hypnogramOnline(hypnogramOnline ==4)=3;
%%
fileinfo = dir('_20240503_141536/digitalout.dat');
num_samples = fileinfo.bytes/2; % uint16 = 2 bytes
fid = fopen('digitalout.dat', 'r');
hypnogramOnline = fread(fid, num_samples, 'uint16')/256;
hypnogramOnline=hypnogramOnline(1:20000:end);
fclose(fid);
hypnogramOnline(hypnogramOnline==4)=3;
%%
load('_20240503_141536/sleepstage.mat');
plot(allresult(:,9))