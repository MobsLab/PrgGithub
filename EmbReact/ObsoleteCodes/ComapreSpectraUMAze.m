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
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_Cond/Cond';
for c=1:6
    Filename{m,c}=[Base,num2str(c)];
end
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_Cond/Cond';
for c=1:8
    Filename{m,c}=[Base,num2str(c)];
end
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160749_Cond/Cond';
for c=1:10
    Filename{m,c}=[Base,num2str(c)];
end
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_Cond/Cond';
for c=1:9
    Filename{m,c}=[Base,num2str(c)];
end
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_Cond/Cond';
for c=1:9
    Filename{m,c}=[Base,num2str(c)];
end
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_Cond/Cond';
for c=1:6
    Filename{m,c}=[Base,num2str(c)];
end
m=m+1;
Base='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_Cond/Cond';
for c=1:5
    Filename{m,c}=[Base,num2str(c)];
end

if 0
    clear SaveSpec
    for mm=1:m
        mm
        for c=1:CondNums(mm)
            cd(Filename{mm,c})
            load('behavResources.mat')
            load('B_Low_Spectrum.mat')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            try StimEpoch;
                StimEpoch=intervalSet(Start(StimEpoch)-1.5*1e4,Start(StimEpoch)+1.5*1e4);
            catch
                load('LFPData/DigInfo.mat')
                StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            end
            LitEp=and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5}))-StimEpoch;
            if not(isempty(Start(LitEp)))
                if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                    SaveSpec{mm,1}(c,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
                end
            end
            LitEp=and(FreezeEpoch,ZoneEpoch{1})-StimEpoch;
            if not(isempty(Start(LitEp)))
                if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                    SaveSpec{mm,2}(c,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
                end
            end
        end
    end
    
    
    figure
    for mm=1:m
        subplot(m/2,2,mm)
        plot(Spectro{3},(mean(SaveSpec{mm,1})),'r')
        hold on
        plot(Spectro{3},(mean(SaveSpec{mm,2})),'b')
        title(Ephys{mm})
    end
    
    
    
    
    clear SaveSpecNoShck SaveSpecShck
    WndwSz=2*1e4;
    for mm=1:m
        mm
        for c=1:CondNums(mm)
            count1=1;count2=1;
            cd(Filename{mm,c})
            load('behavResources.mat')
            load('B_Low_Spectrum.mat')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            try StimEpoch;
            catch
                load('LFPData/DigInfo.mat')
                StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
                StimEpoch=intervalSet(Start(StimEpoch)-1.5*1e4,Start(StimEpoch)+1.5*1e4);
            end
            LitEp=and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5}))-StimEpoch;
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
                                SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                count1=count1+1;
                            end
                            
                        end
                    end
                end
            end
            
            LitEp=and(FreezeEpoch,ZoneEpoch{1})-StimEpoch;
            if not(isempty(Start(LitEp)))
                if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                    for s=1:length(Start(LitEp))
                        dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                        Str=Start(subset(LitEp,s));
                        if  dur<3.5*1e4 & dur>1.5*1e4
                            SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                            count2=count2+1;
                        else
                            numbins=round(dur/WndwSz);
                            epdur=dur/numbins;
                            for nn=1:numbins
                                SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                count2=count2+1;
                            end
                            
                        end
                    end
                end
            end
        end
    end
    
    
    
    
    
    figure
    f=Spectro{3};
    fShck=[];fNoShck=[];
    for mm=1:m
        mm
        for c=1:CondNums(mm)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,17:end)); ind=ind+17;
                    fNoShck=[fNoShck,f(ind)];
                end
            end
        end
        for c=1:CondNums(mm)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,17:end)); ind=ind+17;
                        fShck=[fShck,f(ind)];
                    end
                end
            end
        end
        
    end
    nhist({fShck,fNoShck},'samebins')
    
    
    figure
    clear fShck fNoShck
    f=Spectro{3};
    for mm=1:m
        fShck{mm}=[];fNoShck{mm}=[];
        subplot(m/2,2,mm)
        
        mm
        for c=1:CondNums(mm)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,10:end)); ind=ind+10;
                    fNoShck{mm}=[fNoShck{mm},f(ind)];
                end
            end
        end
        for c=1:CondNums(mm)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,10:end)); ind=ind+10;
                        fShck{mm}=[fShck{mm},f(ind)];
                    end
                end
            end
        end
        nhist({fShck{mm},fNoShck{mm}},'samebins')
        title(Ephys{mm})
        xlim([0 11])
    end
end


%%% Ripples
clear SaveSpecH ripNum
for mm=1:m-2
    mm
    for c=1:CondNums(mm)
        c
        cd(Filename{mm,c})
        load('behavResources.mat')
        load('H_VHigh_Spectrum.mat')
        load('Ripples.mat')
        Riptsd=ts(Rip(:,1)*1e4);
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        TotEpoch=intervalSet(0,max(Range(Sptsd)));
        dt=median(diff(Range(Sptsd,'s')));
        try
        load('LFPData/DigInfo.mat')
        StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
        StimEpoch=intervalSet(Start(StimEpoch)-1*1e4,Start(StimEpoch)+2*1e4);
        catch
            StimEpoch=intervalSet(Start(StimEpoch)-1*1e4,Start(StimEpoch)+2*1e4);
        end
        
        LitEp=and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5}))-StimEpoch;
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
        
        LitEp=and(FreezeEpoch,ZoneEpoch{1})-StimEpoch;
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
        
        LitEp=TotEpoch-FreezeEpoch;LitEp=LitEp-StimEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveSpecH{mm,3}(c,:)=log(nanmean(Data(Restrict(Sptsd,LitEp))));
                  ripNum{3,mm}(c)=length(Range(Restrict(Riptsd,LitEp)))./(length(Range(Restrict(Sptsd,LitEp)))*dt);
            else
                SaveSpecH{mm,3}(c,:)=nan(1,length(Spectro{3}));
            ripNum{3,mm}(c)=nan;
            end
        else
            SaveSpecH{mm,3}(c,:)=nan(1,length(Spectro{3}));
            ripNum{3,mm}(c)=nan;
        end
        
        LitEp=FreezeEpoch-StimEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveSpecH{mm,4}(c,:)=log(nanmean(Data(Restrict(Sptsd,LitEp))));
                  ripNum{4,mm}(c)=length(Range(Restrict(Riptsd,LitEp)))./(length(Range(Restrict(Sptsd,LitEp)))*dt);
            else
                SaveSpecH{mm,4}(c,:)=nan(1,length(Spectro{3}));
            ripNum{4,mm}(c)=nan;
            end
        else
            SaveSpecH{mm,4}(c,:)=nan(1,length(Spectro{3}));
            ripNum{4,mm}(c)=nan;
        end
        
        %         load('ChannelsToAnalyse/dHPC_rip.mat')
        %         load(['LFPData/LFP',num2str(channel),'.mat'])
        %         rg=Range(LFP);
        %         Epoch=intervalSet(rg(1),rg(end))-StimEpoch;
        %         [Rip,usedEpoch]=FindRipplesKarimSB(LFP,Epoch,[5,9],[30 20 200]);
        %         if c==1
        %             [M,T]=PlotRipRaw(LFP,Rip,30,1);
        %             keyboard
        %             close all
    end
    
end


% More ripples during freezing

figure
NumToUse=[4,3];
temp1=[];temp2=[];
for mm=1:m-2
    subplot((m-2)/2,2,mm)
    TotPow=nanmean((nanmean((SaveSpecH{mm,NumToUse(1)}))+nanmean((SaveSpecH{mm,NumToUse(2)}))));
    g=shadedErrorBar(Spectro{3},runmean(nanmean((SaveSpecH{mm,NumToUse(1)})),3),[stdError((SaveSpecH{mm,NumToUse(1)}));stdError((SaveSpecH{mm,NumToUse(1)}))],'k')
    temp1=[temp1;nanmean((SaveSpecH{mm,NumToUse(1)}))./TotPow];
    hold on
    g=shadedErrorBar(Spectro{3},runmean(nanmean((SaveSpecH{mm,NumToUse(2)})),3),[stdError((SaveSpecH{mm,NumToUse(2)}));stdError((SaveSpecH{mm,NumToUse(2)}))],'r')
    temp2=[temp2;nanmean((SaveSpecH{mm,NumToUse(2)}))./TotPow];
    title(Ephys{mm})
    xlabel('Freq')
end
figure
plot(Spectro{3},nanmean(temp1),'k')
hold on
plot(Spectro{3},nanmean(temp2),'r')
g=shadedErrorBar(Spectro{3},runmean(nanmean(temp1),3),[stdError(temp1);stdError(temp1)],'k')
g=shadedErrorBar(Spectro{3},runmean(nanmean(temp2),3),[stdError(temp2);stdError(temp2)],'r')
legend('Fz','NoFz')
xlabel('Freq')

for mm=1:m-2
    RipNum1(mm)=nanmean(ripNum{NumToUse(1),mm});
    RipNum2(mm)=nanmean(ripNum{NumToUse(2),mm});
end
PlotErrorBar2(RipNum1,RipNum2)
set(gca,'XTick',[1,2],'XTickLabel',{'FZ','NoFz'}),title('p=0.02')
ylabel('ripples per s')



%% different freezing states

figure
NumToUse=[1,2];
temp1=[];temp2=[];
for mm=1:m-2
    subplot((m-2)/2,2,mm)
    TotPow=nanmean((nanmean((SaveSpecH{mm,NumToUse(1)}))+nanmean((SaveSpecH{mm,NumToUse(2)}))));
    g=shadedErrorBar(Spectro{3},runmean(nanmean((SaveSpecH{mm,NumToUse(1)})),3),[stdError((SaveSpecH{mm,NumToUse(1)}));stdError((SaveSpecH{mm,NumToUse(1)}))],'k')
    temp1=[temp1;nanmean((SaveSpecH{mm,NumToUse(1)}))./TotPow];
    hold on
    try
    g=shadedErrorBar(Spectro{3},runmean(nanmean((SaveSpecH{mm,NumToUse(2)})),3),[stdError((SaveSpecH{mm,NumToUse(2)}));stdError((SaveSpecH{mm,NumToUse(2)}))],'r')
    temp2=[temp2;nanmean((SaveSpecH{mm,NumToUse(2)}))./TotPow];
    end
    title(Ephys{mm})
    xlabel('Freq')
end
temp1=temp1([1,5,6],:);
figure
plot(Spectro{3},nanmean(temp1),'k')
hold on
plot(Spectro{3},nanmean(temp2),'r')
g=shadedErrorBar(Spectro{3},runmean(nanmean(temp1),3),[stdError(temp1);stdError(temp1)],'k')
g=shadedErrorBar(Spectro{3},runmean(nanmean(temp2),3),[stdError(temp2);stdError(temp2)],'r')
legend('safe','shock')
xlabel('Freq')

for mm=1:m-2
    RipNum1(mm)=nanmean(ripNum{NumToUse(1),mm});
    RipNum2(mm)=nanmean(ripNum{NumToUse(2),mm});
end
PlotErrorBar2(RipNum1,RipNum2)
set(gca,'XTick',[1,2],'XTickLabel',{'safe','shock'}),title('p=0.1')
ylabel('ripples per s')




clear SpecVal
for mm=1:m-2
    mm
    for c=1:CondNums(mm)
        c
        cd(Filename{mm,c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        load('Ripples.mat')
        try
            load('LFPData/DigInfo.mat')
            StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            StimEpoch=intervalSet(Start(StimEpoch)-1*1e4,Start(StimEpoch)+2*1e4);
        catch
            StimEpoch=intervalSet(Start(StimEpoch)-1*1e4,Start(StimEpoch)+2*1e4);
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
    for c=1:CondNums(mm)
        All=[All;SpecVal{mm,c}(:)];
    end
end


%% Shuffle to compare
clear SpecValRand
for mm=1:m-2
    mm
    for c=1:CondNums(mm)
        c
        cd(Filename{mm,c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        TotEpoch=intervalSet(0,max(Range(Sptsd)));
        dt=median(diff(Range(Sptsd,'s')));

        load('Ripples.mat')
        try
            load('LFPData/DigInfo.mat')
            StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
            StimEpoch=intervalSet(Start(StimEpoch)-1*1e4,Start(StimEpoch)+2*1e4);
        catch
            StimEpoch=intervalSet(Start(StimEpoch)-1*1e4,Start(StimEpoch)+2*1e4);
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
    for c=1:CondNums(mm)
        All=[All;SpecVal{mm,c}(:)];
        AllRand=[AllRand;SpecValRand{mm,c}(:)];
    end
end
figure
nhist({All,AllRand},'legend',{'data','rand'},'samebins')
