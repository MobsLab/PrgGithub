clear all
mm=0;
mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150508-EXT-48h-envC';
Filename{mm}{2}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC';
Filename{mm}{3}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB';
SleepSession{mm}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';
AllChans{mm}=[2,6,30];
MouseNum{mm}=244;

mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC';
Filename{mm}{2}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150507-EXT-24h-envB';
Filename{mm}{3}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150508-EXT-48h-envC';
SleepSession{mm}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015/';
AllChans{mm}=[2,6,30];
MouseNum{mm}=243;

mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse403/FEAR-Mouse-403-EXT-24-envB_raye_161026_171611/';
Filename{mm}{2}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse403/FEAR-Mouse-403-EXT-48-envC_blanc_161027_173548/';
SleepSession{mm}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160823/';
AllChans{mm}=[0,4,9,16,20];
MouseNum{mm}=403;

mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse394/FEAR-Mouse-394-EXT-24-envBraye_161020_163239/';
Filename{mm}{2}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse394/FEAR-Mouse-394-EXT-48_envC_blanc_161021_153620/';
SleepSession{mm}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160720/';
AllChans{mm}=[0,4];
MouseNum{mm}=394;

mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse395/FEAR-Mouse-395-EXT-24-envBraye_161020_155350/';
Filename{mm}{2}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse395/FEAR-Mouse-395-EXT-48_envC_blanc_161021_160944/';
SleepSession{mm}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160728/';
AllChans{mm}=[0,4,20,24,30];
MouseNum{mm}=395;

mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SoundTest';
for k=1:5
    Filename{mm}{1+k}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_UMazeCond/Cond',num2str(k)];
end
SleepSession{mm}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPostSound/';
AllChans{mm}=[12,16,5,20,8];
MouseNum{mm}=512;

mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SoundTest';
for k=1:5
    Filename{mm}{1+k}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_UMazeCond/Cond',num2str(k)];
end
SleepSession{mm}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPostSound/';
AllChans{mm}=[20,4,16,8,12];
MouseNum{mm}=510;

mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SoundTest';
for k=1:5
    Filename{mm}{1+k}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_UMazeCond/Cond',num2str(k)];
end
SleepSession{mm}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPostSound/';
AllChans{mm}=[8,20,12,16,32,58,40,36,60];
MouseNum{mm}=507;

mm=mm+1;
Filename{mm}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SoundTest';
for k=1:5
    Filename{mm}{1+k}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_UMazeCond/Cond',num2str(k)];
end
SleepSession{mm}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPostSound/';
AllChans{mm}=[0,4,29,25,56,41];
MouseNum{mm}=509;


mm=mm+1;
for k=1:2
    Filename{mm}{k}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondExplo_PreDrug/Cond',num2str(k)];
end
for k=1:2
    Filename{mm}{2+k}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondExplo_PostDrug/Cond',num2str(k)];
end
for k=1:2
    Filename{mm}{4+k}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedShock_PreDrug/Cond',num2str(k)];
end
for k=1:2
    Filename{mm}{6+k}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedShock_PostDrug/Cond',num2str(k)];
end
SleepSession{mm}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_SleepPost_PostDrug/';
AllChans{mm}=[0,4,28];
MouseNum{mm}=777;

mm=mm+1;
for k=1:2
    Filename{mm}{k}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondExplo_PreDrug/Cond',num2str(k)];
end
for k=1:2
    Filename{mm}{2+k}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondExplo_PostDrug/Cond',num2str(k)];
end
for k=1:2
    Filename{mm}{4+k}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondBlockedShock_PreDrug/Cond',num2str(k)];
end
for k=1:2
    Filename{mm}{6+k}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondBlockedShock_PostDrug/Cond',num2str(k)];
end
SleepSession{mm}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_SleepPost_PostDrug/';
AllChans{mm}=[1,5,8];
MouseNum{mm}=849;


