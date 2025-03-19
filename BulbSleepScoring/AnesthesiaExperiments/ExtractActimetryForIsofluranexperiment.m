clear all
time=load('0008-time.dat');
ActiData=load('0008-cage01-signal.dat');
Stim=load('0008-cage01-evt.dat');
Stim(:,1)=Stim(:,1)-Stim(1,1);

save('behavResources.mat','time','ActiData','Stim','-append')