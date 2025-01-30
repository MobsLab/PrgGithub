close all, clear all,
m=0;
Ephys={'Mouse431' 'Mouse436' 'Mouse437' 'Mouse438' 'Mouse439' };
CondNums=[15,6,8,10,9,9,6,5];
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160749_SoundCond';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160749_SoundTest';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundCond';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundTest';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundCond';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundTest';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundCond';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundTest';
m=m+1;
Filename{m,1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundCond';
Filename{m,2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundTest';

if 0
clear SaveSpec
for mm=1:m
    mm
    for c=1:2
        cd(Filename{mm,c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        if c==1
            load('LFPData/DigInfo.mat')
            StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            StimEpoch=intervalSet(Start(StimEpoch)-1.5*1e4,Start(StimEpoch)+1.5*1e4);
        else
            StimEpoch=intervalSet(0,0.1);
            FreezeEpoch=and(FreezeEpoch,intervalSet(0,CSPlusTimes(4)+60*1e4));
            
        end
        LitEp=FreezeEpoch-StimEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveSpec{mm,1}(c,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
            end
        end
    end
end


figure
for mm=1:m
    mm
    subplot(m,1,mm)
    plot(Spectro{3},SaveSpec{mm,1}(1,:),'r')
    hold on
    plot(Spectro{3},SaveSpec{mm,1}(2,:),'b')
    title(Ephys{mm})
    legend('cond','test')
end


WndwSz=2*1e4;
for mm=1:m
    mm
    for c=1:2
        count1=1;count2=1;
        cd(Filename{mm,c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        if c==1
            load('LFPData/DigInfo.mat')
            StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            StimEpoch=intervalSet(Start(StimEpoch)-2*1e4,Start(StimEpoch)+2*1e4);
        else
            StimEpoch=intervalSet(0,0.1);
            FreezeEpoch=and(FreezeEpoch,intervalSet(0,CSPlusTimes(4)+60*1e4));
        end
        LitEp=FreezeEpoch-StimEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                for s=1:length(Start(LitEp))
                    dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                    Str=Start(subset(LitEp,s));
                    if  dur<3.5*1e4 & dur>1.5*1e4
                        SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                        count1=count1+1;
                    else
                        numbins=round(dur/WndwSz);
                        epdur=dur/numbins;
                        for nn=1:numbins
                            SaveSpecBis{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                            count1=count1+1;
                        end
                        
                    end
                end
            end
        end
    end
end






figure
f=Spectro{3};
fCond=[];fTest=[];
for mm=1:m
    mm
    for c=1
        if not(isempty(SaveSpecBis{mm,c}))
            for k=1:size(SaveSpecBis{mm,c},1)
                [val,ind]=max(SaveSpecBis{mm,c}(k,20:end)); ind=ind+20;
                fCond=[fCond,f(ind)];
            end
        end
    end
    for c=2
        try
            if not(isempty(SaveSpecBis{mm,c}))
                for k=1:size(SaveSpecBis{mm,c},1)
                    [val,ind]=max(SaveSpecBis{mm,c}(k,20:end)); ind=ind+20;
                    fTest=[fTest,f(ind)];
                end
            end
        end
    end
    
end
nhist({fTest,fCond},'samebins','legend',{'test','cond'})


figure
f=Spectro{3};
for mm=1:m
    mm
    fCond=[];fTest=[];
    subplot(m,1,mm)
    
    for c=1
        if not(isempty(SaveSpecBis{mm,c}))
            for k=1:size(SaveSpecBis{mm,c},1)
                [val,ind]=max(SaveSpecBis{mm,c}(k,20:end)); ind=ind+20;
                fCond=[fCond,f(ind)];
            end
        end
    end
    for c=2
        try
            if not(isempty(SaveSpecBis{mm,c}))
                for k=1:size(SaveSpecBis{mm,c},1)
                    [val,ind]=max(SaveSpecBis{mm,c}(k,20:end)); ind=ind+20;
                    fTest=[fTest,f(ind)];
                end
            end
        end
    end
    nhist({fTest,fCond},'samebins','legend',{'test','cond'})
    title(Ephys{mm})
end


%% Trigger on CS+



clear SaveSpec
for mm=1:m
    mm
    for c=1:2
        cd(Filename{mm,c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        
        Sp=Data(Sptsd);
        if c==2
            CSPlusTimes=CSPlusTimes(1:4);
        end
        x=CSPlusTimes;
        f=Spectro{3};
        num1=1;
        for k=1:length(x)
            for i=1:length(f)
                [M1{num1}(i,:),S1{num1}(i,:),t]=mETAverage(x(k),Range(Sptsd),Sp(:,i),2000,100);
            end
            num1=num1+1;
        end
        
        TriggeredSpec{mm,c}=M1;
        clear M1 CSPlusTimes
        
    end
end


PeakFzVals=[NaN,NaN;2.56,3.85;3.6,5.3;3.2,6.1;2.2,NaN];
figure
clf
load('UMazeSpectra.mat')
for mm=1:m
    mm
    subplot(m,6,mm*6-5:mm*6-4)
    temp=TriggeredSpec{mm,1}{1};
    for k=1:length(TriggeredSpec{mm,1})
        temp=temp+ TriggeredSpec{mm,1}{k};
    end
    temp=temp/k;
    imagesc(t/1000,f,log(temp)),axis xy
    title(Ephys{mm})
    line([0 0],ylim,'color','k','linewidth',2)
    line(xlim,[5 5],'color','k','linestyle','--')
    ylim([0 8])
    subplot(m,6,mm*6-3)
    [theText, rawN, x] =nhist({fShck{mm+3},fNoShck{mm+3}},'noerror','samebins','ylabel',{}); axis xy
    view(90,-90)
    xlim([0 8])
    line([5 5],ylim,'color','k','linestyle','--')
    
    clear temp
    subplot(m,6,mm*6-2:mm*6-1)
    temp=TriggeredSpec{mm,2}{2};
    for k=1:length(TriggeredSpec{mm,2})
        temp=temp+TriggeredSpec{mm,2}{k};
    end
    temp=temp/k;
    imagesc(t/1000,f,log(temp)),axis xy
    title(Ephys{mm})
    line([0 0],ylim,'color','k','linewidth',2)
    line(xlim,[5 5],'color','k','linestyle','--')
    ylim([0 8])
    subplot(m,6,mm*6)
    [theText, rawN, x] =nhist({fShck{mm+3},fNoShck{mm+3}},'noerror','samebins','ylabel',{}); axis xy
    view(90,-90)
    xlim([0 8])
    line([5 5],ylim,'color','k','linestyle','--')
    
end







end

%% Ripples


clear SaveSpec
for mm=1:m-2
    mm
    for c=1:2
        cd(Filename{mm,c})
        load('behavResources.mat')
%                 load('ChannelsToAnalyse/dHPC_rip.mat')
% VeryHighSpectrum([Filename{mm,c},'/'],channel,'H');
        load('H_VHigh_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        TotEpoch=intervalSet(0,max(Range(Sptsd)));
                dt=median(diff(Range(Sptsd,'s')));

        if c==1
            load('LFPData/DigInfo.mat')
            StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            StimEpoch=mergeCloseIntervals(StimEpoch,3*1e4);
            StimEpoch=intervalSet(Start(StimEpoch)-1.5*1e4,Start(StimEpoch)+5*1e4);
        else
            StimEpoch=intervalSet(0,0.1);
            FreezeEpoch=and(FreezeEpoch,intervalSet(0,CSPlusTimes(4)+60*1e4));
        end
        
        load('ChannelsToAnalyse/dHPC_rip.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        rg=Range(LFP);
        Epoch=FreezeEpoch-StimEpoch;
        [Rip,usedEpoch]=FindRipplesKarimSB(LFP,Epoch,[5,9],[30 20 200]);
        save('Ripples.mat','Rip')
        Riptsd=ts(Rip(:,1)*1e4);

        
        LitEp=FreezeEpoch-StimEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveSpecH{mm,1}(c,:)=log(nanmean(Data(Restrict(Sptsd,LitEp))));
                ripNum{1,mm}(c)=length(Range(Restrict(Riptsd,LitEp)))./(length(Range(Restrict(Sptsd,LitEp)))*dt);
            else
                SaveSpecH{mm,1}(c,:)=nan(1,length(Spectro{3}));
                ripNum{1,mm}(c)=nan;
            end
        else
            SaveSpecH{mm,1}(c,:)=nan(1,length(Spectro{3}));
            ripNum{1,mm}(c)=nan;
        end
        
        LitEp=TotEpoch-FreezeEpoch;LitEp=LitEp-StimEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveSpecH{mm,2}(c,:)=log(nanmean(Data(Restrict(Sptsd,LitEp))));
                ripNum{2,mm}(c)=length(Range(Restrict(Riptsd,LitEp)))./(length(Range(Restrict(Sptsd,LitEp)))*dt);
            else
                SaveSpecH{mm,2}(c,:)=nan(1,length(Spectro{3}));
                ripNum{2,mm}(c)=nan;
            end
        else
            SaveSpecH{mm,2}(c,:)=nan(1,length(Spectro{3}));
            ripNum{2,mm}(c)=nan;
        end
        
    end
end

figure
temp1=[];temp2=[];
for mm=1:m-2
    subplot((m-1)/2,2,mm)
    plot(Spectro{3},runmean(SaveSpecH{mm,1}(1,:),3),'k')
    hold on
    plot(Spectro{3},runmean(SaveSpecH{mm,1}(2,:),3),'k')
    plot(Spectro{3},runmean(SaveSpecH{mm,2}(1,:),3),'r')
    plot(Spectro{3},runmean(SaveSpecH{mm,2}(2,:),3),'r')
    title(Ephys{mm})
    xlabel('Freq')
end





clear SpecVal
for mm=1:m-2
    mm
    for c=1:2
        c
        cd(Filename{mm,c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        load('Ripples.mat')
        if c==1
            load('LFPData/DigInfo.mat')
            StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            StimEpoch=mergeCloseIntervals(StimEpoch,3*1e4);
            StimEpoch=intervalSet(Start(StimEpoch)-1.5*1e4,Start(StimEpoch)+5*1e4);
        else
            StimEpoch=intervalSet(0,0.1);
            FreezeEpoch=and(FreezeEpoch,intervalSet(0,CSPlusTimes(4)+60*1e4));
        end
        FreezeEpoch=FreezeEpoch-StimEpoch;
        Riptsd=ts(Rip(:,1)*1e4);Riptsd=Restrict(Riptsd,FreezeEpoch);Rp=Range(Riptsd);
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        TotEpoch=intervalSet(0,max(Range(Sptsd)));
        dt=median(diff(Range(Sptsd,'s')));        
        for r=1:length(Rp)
            LitEpoch=intervalSet(Rp(r)-2*1e4,Rp(r)+2*1e4);
            temp=nanmean(Data(Restrict(Sptsd,LitEpoch)));
            [val,ind]=max(temp(20:end));
            SpecVal{mm,c}(r)=Spectro{3}(ind+20);
        end
        
    end
end

All=[];
for mm=1:m-2
    mm
    for c=1:2
        All=[All;SpecVal{mm,c}(:)];
    end
end


%% Shuffle to compare
clear SpecValRand
for mm=1:m-2
    mm
    for c=1:2
        c
        cd(Filename{mm,c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        TotEpoch=intervalSet(0,max(Range(Sptsd)));
        dt=median(diff(Range(Sptsd,'s')));

        load('Ripples.mat')
       if c==1
            load('LFPData/DigInfo.mat')
            StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            StimEpoch=mergeCloseIntervals(StimEpoch,3*1e4);
            StimEpoch=intervalSet(Start(StimEpoch)-1.5*1e4,Start(StimEpoch)+5*1e4);
        else
            StimEpoch=intervalSet(0,0.1);
            FreezeEpoch=and(FreezeEpoch,intervalSet(0,CSPlusTimes(4)+60*1e4));
        end
        FreezeEpoch=FreezeEpoch-StimEpoch;
        Riptsd=ts(Rip(:,1)*1e4);Riptsd=Restrict(Riptsd,FreezeEpoch);Rp=Range(Riptsd);
        if length(Rp)>1
        AllDat=Range(Restrict(Sptsd,FreezeEpoch));
        Rp=AllDat(randsample(length(AllDat),length(Rp)));
        
        for r=1:length(Rp)
            LitEpoch=intervalSet(Rp(r)-2*1e4,Rp(r)+2*1e4);
            temp=nanmean(Data(Restrict(Sptsd,LitEpoch)));
            [val,ind]=max(temp(20:end));
            SpecValRand{mm,c}(r)=Spectro{3}(ind+20);
        end
        end
    end
end


All=[];AllRand=[];
for mm=1:m-2
    mm
    for c=1:2
        All=[All;SpecVal{mm,c}(:)];
        AllRand=[AllRand;SpecValRand{mm,c}(:)];
    end
end
