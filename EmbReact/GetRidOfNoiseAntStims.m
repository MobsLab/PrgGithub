m=0;
Ephys={'Mouse117' 'Mouse404' 'Mouse425' 'Mouse431' 'Mouse436' 'Mouse437' 'Mouse438' 'Mouse439' };
CondNums=[15,6,8,10,9,9,6,5];
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse117/20140221/ProjectFearAnxiety_M117_20140221_Cond/Cond';
cc=0;
for c=[1:10,12:16]
    cc=cc+1;
    Filename{m,cc}=[Base,num2str(c)];
end
Filename{m,CondNums(m)+1}=[];
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_Cond/Cond';
for c=1:6
    Filename{m,c}=[Base,num2str(c)];
end
Filename{m,CondNums(m)+1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_SleepPost/'

m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_Cond/Cond';
for c=1:8
    Filename{m,c}=[Base,num2str(c)];
end
Filename{m,CondNums(m)+1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_SleepPost/';

m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160749_Cond/Cond';
for c=1:10
    Filename{m,c}=[Base,num2str(c)];
end
Filename{m,CondNums(m)+1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160749_SleepPostSound';
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_Cond/Cond';
for c=1:9
    Filename{m,c}=[Base,num2str(c)];
end
Filename{m,CondNums(m)+1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160810/Sleep/';
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_Cond/Cond';
for c=1:9
    Filename{m,c}=[Base,num2str(c)];
end
Filename{m,CondNums(m)+1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160810/Sleep/';
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_Cond/Cond';
for c=1:6
    Filename{m,c}=[Base,num2str(c)];
end
Filename{m,CondNums(m)+1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160818/Sleep/';
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_Cond/Cond';
for c=1:5
    Filename{m,c}=[Base,num2str(c)];
end
Filename{m,CondNums(m)+1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160818/Sleep/';


for mm=m-1:m
    for c=1:CondNums(mm)
        cd(Filename{mm,c})
        
        load('behavResources.mat')
        try load('StateEpochSB.mat')
        catch
            Epoch=FindNoiseEpoch([cd,'/'],6);
            load('StateEpochSB.mat')
        end
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        TotEpoch=intervalSet(0,max(Range(Sptsd)));
        clf
        subplot(311)
        imagesc(Range(Sptsd,'s'),Spectro{3},Data(Sptsd)')
        axis xy
        hold on
        try
            StimEpoch=intervalSet(Start(StimEpoch)-1*1e4,Start(StimEpoch)+2.4*1e4);
            plot(Start(StimEpoch,'s'),10,'r*')
            plot(Stop(StimEpoch,'s'),10,'k*')
            subplot(312)
            imagesc(Range(Restrict(Sptsd,TotEpoch-StimEpoch),'s'),Spectro{3},Data(Restrict(Sptsd,TotEpoch-StimEpoch))')
            axis xy
            subplot(313)
            imagesc(Range(Restrict(Sptsd,TotEpoch-or(TotalNoiseEpoch,StimEpoch)),'s'),Spectro{3},Data(Restrict(Sptsd,TotEpoch-or(TotalNoiseEpoch,StimEpoch)))')
            axis xy
        catch
            StimEpoch=intervalSet(0,0.1);
        end
        try
            load('LFPData/DigInfo.mat')
            StimTimesEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            StimTimes=Start(StimTimesEpoch);
        catch
            StimTimes=Start(StimEpoch);
            
        end
        keyboard
        save('behavResources.mat','StimEpoch','TotalNoiseEpoch','StimTimes','-append')
        
    end
end