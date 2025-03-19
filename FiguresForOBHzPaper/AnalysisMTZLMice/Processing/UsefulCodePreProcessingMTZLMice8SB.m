cd /media/vador/DataMOBS95/M751_SleepPlethysmo_181022_090703/
% RefSubtraction_multi('amplifier.dat',33,1,'M751',[0:23,25:31],24,[24,32]);
system('ndm_mergedat M751_SleepPlethysmo_20181022')
AllChans=[0:36];
TotChans=length(AllChans);
TetPFC1=[12:23];
AllChans(TetPFC1+1)=[];
RefSubtraction_multi_AverageChans('M751_SleepPlethysmo_20181022.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
movefile('M751_SleepPlethysmo_20181022_original.dat','M751_SleepPlethysmo_20181022.dat')

cd /media/vador/DataMOBS95/M776_SLeepPlethysmo_181023_095314/
% RefSubtraction_multi('amplifier.dat',33,1,'M776',[0:22,24:31],23,[23,32]);
system('ndm_mergedat M776_SleepPlethysmo_20181023')
% 
cd /media/vador/DataMOBS95/M776_SLeepPlethysmo_181023_134147/
% RefSubtraction_multi('amplifier.dat',33,1,'M776',[0:22,24:31],23,[23,32]);
system('ndm_mergedat M776_SleepPlethysmo_20181023')


cd /media/vador/DataMOBS95/M775_SleepPlethysmo_181017_103647/
% RefSubtraction_multi('amplifier.dat',33,1,'M775',[0:22,24:31],23,[23,32]);
system('ndm_mergedat M775_SleepPlethysmo_20181017')
AllChans=[0:36];
TotChans=length(AllChans);
TetPFC1=[1,2,4,5,6,7,28:31];
AllChans(TetPFC1+1)=[];
RefSubtraction_multi_AverageChans('M775_SleepPlethysmo_20181017.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
movefile('M775_SleepPlethysmo_20181017_original.dat','M775_SleepPlethysmo_20181017.dat')

cd /media/vador/DataMOBS95/M777_SleepPlethysmo_181024_085534/
% RefSubtraction_multi('amplifier.dat',33,1,'M777',[0:22,24:31],23,[23,32]);
system('ndm_mergedat M777_SleepPlethysmo_20181024')
AllChans=[0:36];
TotChans=length(AllChans);
TetPFC1=[0:7,28:31];
AllChans(TetPFC1+1)=[];
RefSubtraction_multi_AverageChans('M777_SleepPlethysmo_20181024.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
movefile('M777_SleepPlethysmo_20181024_original.dat','M777_SleepPlethysmo_20181024.dat')




%%%%
cd /media/vador/DataMOBSBackup_GaetanPC/MTZLRecordings/M750/14102018/
AllChans=[0:36];
TotChans=length(AllChans);
TetPFC1=[12:22];
AllChans(TetPFC1+1)=[];
RefSubtraction_multi_AverageChans('amplifier_M750.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
movefile('amplifier_M750_original.dat','amplifier_M750.dat')
    
cd /media/vador/DataMOBSBackup_GaetanPC/MTZLRecordings/M776/14102018/
AllChans=[0:36];
TotChans=length(AllChans);
TetPFC1=[0:7,24:27];
AllChans(TetPFC1+1)=[];
RefSubtraction_multi_AverageChans('amplifier_M776.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
movefile('amplifier_M776_original.dat','amplifier_M776.dat')


cd /media/vador/DataMOBS91/MTZL_Exp/M751/15102018/
AllChans=[0:36];
TotChans=length(AllChans);
TetPFC1=[12:23];
AllChans(TetPFC1+1)=[];
RefSubtraction_multi_AverageChans('amplifier_M751.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
movefile('amplifier_M751_original.dat','amplifier_M751.dat')

cd /media/vador/DataMOBS91/MTZL_Exp/M775/15102018/
AllChans=[0:36];
TotChans=length(AllChans);
TetPFC1=[1,2,4,5,6,7,28:31];
AllChans(TetPFC1+1)=[];
RefSubtraction_multi_AverageChans('amplifier_M775.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
movefile('amplifier_M775_original.dat','amplifier_M775.dat')





clear all
AllChans=[0:36];
TotChans=length(AllChans);
TetPFC1=[0:7,24:27];
AllChans(TetPFC1+1)=[];
RefSubtraction_multi_AverageChans('M776_SleepPlethysmo_20181023.dat',TotChans,1,'SpikeRef',TetPFC1,TetPFC1,AllChans);
movefile('M776_SleepPlethysmo_20181023_original.dat','M776_SleepPlethysmo_20181023.dat')