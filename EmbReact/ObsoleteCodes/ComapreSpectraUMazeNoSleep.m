clear all
% Some setup parameters
LimFreq= 1.5; %limit frequency to avoid contamination by low frequenciest
MouseToAvoid=[431]; % mice with noisy data to exclude


% Get the correct folders
Dir=PathForExperimentsEmbReact('UMazeCond');
Dir=RemoveElementsFromDir(Dir,'nmouse',431);
m=length(Dir.path); % number of mice


% load spectra, removing stimulations and sleepy epoch
clear SaveSpec
for mm=1:m
    mm
    for c=1:length(Dir.path{mm})
        clear StimEpoch SleepyEpoch
        cd( Dir.path{mm}{c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        RemovEpoch=or(StimEpoch,SleepyEpoch);
        
        LitEp=and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5}));
        LitEp=LitEp-RemovEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveSpec{mm,1}(c,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
            end
        end
        LitEp=and(FreezeEpoch,ZoneEpoch{1});
        LitEp=LitEp-RemovEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveSpec{mm,2}(c,:)=nanmean(Data(Restrict(Sptsd,LitEp)));
            end
        end
    end
end
LimF= find(Spectro{3}>LimFreq,1,'first'); %limit frequency index

% plot spectra mouse by mouse
figure
for mm=1:m
    subplot(ceil(m/2),2,mm)
    plot(Spectro{3},(mean(SaveSpec{mm,1})),'r')
    hold on
    plot(Spectro{3},(mean(SaveSpec{mm,2})),'b')
    %title(Ephys{mm})
    title(num2str(Dir.ExpeInfo{mm}{c}.nmouse))
end

% plot global spectra normalized by total power
figure
subplot(211)
LeftAll=zeros(1,length(Spectro{3}));RightAll=zeros(1,length(Spectro{3}));
for mm=1:m
    LeftAll(mm,:)=mean(SaveSpec{mm,1})./mean(mean(SaveSpec{mm,1}(:,LimF:end)));
    RightAll(mm,:)=mean(SaveSpec{mm,2})./mean(mean(SaveSpec{mm,2}(:,LimF:end)));
end
plot(Spectro{3},nanmean(RightAll),'b','linewidth',5)
hold on, plot(Spectro{3},nanmean(LeftAll),'r','linewidth',5)
legend('Shock','NoShock')
plot(Spectro{3},RightAll','b')
plot(Spectro{3},LeftAll','r')
xlabel('freq')
title('All mice - norm by total power')
subplot(212)
shadedErrorBar(Spectro{3},nanmean(RightAll),[stdError(RightAll);stdError(RightAll)],'b'); hold on
shadedErrorBar(Spectro{3},nanmean(LeftAll),[stdError(LeftAll);stdError(LeftAll)],'r');
xlabel('freq')


% Look at distributions of max frequencies by taking bite sized periods of
% freezing
clear SaveSpecNoShck SaveSpecShck
WndwSz=2*1e4;
for mm=1:m
    mm
    for c=1:length(Dir.path{mm})
        clear StimEpoch SleepyEpoch
        count1=1;count2=1;
        cd( Dir.path{mm}{c})
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        RemovEpoch=or(StimEpoch,SleepyEpoch);
        
        LitEp=and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5}))-RemovEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>WndwSz
                for s=1:length(Start(LitEp))
                    dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                    Str=Start(subset(LitEp,s));
                    if  dur<WndwSz*1.75 & dur>WndwSz*0.75
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
        
        LitEp=and(FreezeEpoch,ZoneEpoch{1})-RemovEpoch;
        if not(isempty(Start(LitEp)))
            if sum(Stop(LitEp)-Start(LitEp))>WndwSz
                for s=1:length(Start(LitEp))
                    dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                    Str=Start(subset(LitEp,s));
                    if  dur<WndwSz*1.75 & dur>WndwSz*0.75
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



f=Spectro{3};
fShck=[];fNoShck=[];
for mm=1:m
    mm
    for c=1:length(Dir.path{mm}) 
        try
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,LimF:end)); ind=ind+LimF;
                    fNoShck=[fNoShck,f(ind)];
                end
            end
        end
        for c=1:length(Dir.path{mm}) 
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,LimF:end)); ind=ind+LimF;
                        fShck=[fShck,f(ind)];
                    end
                end
            end
        end
    end
    
end
figure
nhist({fShck,fNoShck},'binfactor',1,'samebins','noerror','pdf')
xlabel('frequency'), title('all bites, all mice')

figure
clear fShck fNoShck
f=Spectro{3};
for mm=1:m
    fShck{mm}=[];fNoShck{mm}=[];
    subplot(ceil(m/2),2,mm)
    
    mm
    for c=1:length(Dir.path{mm})
        try
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,LimF:end)); ind=ind+LimF;
                    fNoShck{mm}=[fNoShck{mm},f(ind)];
                end
            end
        end
    end
    for c=1:length(Dir.path{mm})
        try
            if not(isempty(SaveSpecShck{mm,c}))
                for k=1:size(SaveSpecShck{mm,c},1)
                    [val,ind]=max(SaveSpecShck{mm,c}(k,LimF:end)); ind=ind+LimF;
                    fShck{mm}=[fShck{mm},f(ind)];
                end
            end
        end
    end
    
    nhist({fShck{mm},fNoShck{mm}},'samebins','noerror')
    title(num2str(Dir.ExpeInfo{mm}{c}.nmouse))
    xlim([0 11])
end



%%% Ripples
clear SaveSpecH ripNum
for mm=1:m-2
    mm
    for c=1:length(Dir.path{mm}) 
        c
        clear StimEpoch SleepyEpoch
        cd(Filename{mm,c})
        load('behavResources.mat')
        try,load('H_VHigh_Spectrum.mat')
        catch
            load('H_High_Spectrum.mat','ch')
            VeryHighSpectrum([cd '/'],ch,'H')
        end
        try
        load('Ripples.mat')
        Riptsd=ts(Rip(:,1)*1e4);
        catch
          Riptsd=ts(0);  
        end
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        TotEpoch=intervalSet(0,max(Range(Sptsd)));
        dt=median(diff(Range(Sptsd,'s')));
        RemovEpoch=or(StimEpoch,SleepyEpoch);
        
        LitEp=and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5}))-RemovEpoch;
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
        
        LitEp=and(FreezeEpoch,ZoneEpoch{1})-RemovEpoch;
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
        
        LitEp=TotEpoch-FreezeEpoch;LitEp=LitEp-RemovEpoch;
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
        
        LitEp=FreezeEpoch-RemovEpoch;
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
        
    end
    
end


% More ripples during freezing

figure
NumToUse=[4,3];
temp1=[];temp2=[];
for mm=1:m-2
    subplot(ceil(m/2),2,mm) 
    TotPow=nanmean((nanmean((SaveSpecH{mm,NumToUse(1)}))+nanmean((SaveSpecH{mm,NumToUse(2)}))));
    g=shadedErrorBar(Spectro{3},runmean(nanmean((SaveSpecH{mm,NumToUse(1)})),3),[stdError((SaveSpecH{mm,NumToUse(1)}));stdError((SaveSpecH{mm,NumToUse(1)}))],'k')
    temp1=[temp1;nanmean((SaveSpecH{mm,NumToUse(1)}))./TotPow];
    hold on
    g=shadedErrorBar(Spectro{3},runmean(nanmean((SaveSpecH{mm,NumToUse(2)})),3),[stdError((SaveSpecH{mm,NumToUse(2)}));stdError((SaveSpecH{mm,NumToUse(2)}))],'r')
    temp2=[temp2;nanmean((SaveSpecH{mm,NumToUse(2)}))./TotPow];
title(num2str(Dir.ExpeInfo{mm}{c}.nmouse))
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
clear RipNum1 RipNum2
for mm=1:m-2
    RipNum1(mm)=nanmean(ripNum{NumToUse(1),mm});
    RipNum2(mm)=nanmean(ripNum{NumToUse(2),mm});
end
pval=PlotErrorBarN([RipNum1;RipNum2]');
set(gca,'XTick',[1,2],'XTickLabel',{'NoSafe','Safe'}),title(['p=' num2str(pval(2))])
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
title(num2str(Dir.ExpeInfo{mm}{c}.nmouse))
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
clear RipNum1 RipNum2
for mm=1:m-2
    RipNum1(mm)=nanmean(ripNum{NumToUse(1),mm});
    RipNum2(mm)=nanmean(ripNum{NumToUse(2),mm});
end
pval=PlotErrorBarN([RipNum1;RipNum2]');
set(gca,'XTick',[1,2],'XTickLabel',{'FZ','NoFz'}),title(['p=' num2str(pval(2))])
ylabel('ripples per s')



% 
% clear SpecVal
% for mm=1:m-2
%     mm
%     for c=1:length(Dir.path{mm}) 
%         c
%         clear StimEpoch SleepyEpoch
%         cd(Filename{mm,c})
%         load('behavResources.mat')
%         load('B_Low_Spectrum.mat')
%         load('Ripples.mat')
%         RemovEpoch=or(StimEpoch,SleepyEpoch);
%         FreezeEpoch=FreezeEpoch-RemovEpoch;
%         Riptsd=ts(Rip(:,1)*1e4);Riptsd=Restrict(Riptsd,FreezeEpoch);Rp=Range(Riptsd);
%         Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
%         TotEpoch=intervalSet(0,max(Range(Sptsd)));
%         dt=median(diff(Range(Sptsd,'s')));
%         for r=1:length(Rp)
%             LitEpoch=intervalSet(Rp(r)-2*1e4,Rp(r)+2*1e4);
%             temp=nanmean(Data(Restrict(Sptsd,LitEpoch)));
%             [val,ind]=max(temp(20:end));
%             SpecVal{mm,c}(r)=Spectro{3}(ind+20);
%         end
%         
%     end
% end
% 
% All=[];
% for mm=1:m-2
%     mm
%     for c=1:length(Dir.path{mm}) 
%         All=[All;SpecVal{mm,c}(:)];
%     end
% end
% 
% 
% %% Shuffle to compare
% clear SpecValRand
% for mm=1:m-2
%     mm
%     for c=1:length(Dir.path{mm}) 
%         c
%         clear StimEpoch SleepyEpoch
%         cd(Filename{mm,c})
%         load('behavResources.mat')
%         load('B_Low_Spectrum.mat')
%         Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
%         TotEpoch=intervalSet(0,max(Range(Sptsd)));
%         dt=median(diff(Range(Sptsd,'s')));
%         RemovEpoch=or(StimEpoch,SleepyEpoch);
%         load('Ripples.mat')
%         
%         FreezeEpoch=FreezeEpoch-RemovEpoch;
%         Riptsd=ts(Rip(:,1)*1e4);Riptsd=Restrict(Riptsd,FreezeEpoch);Rp=Range(Riptsd);
%         if length(Rp)>1
%             AllDat=Range(Restrict(Sptsd,FreezeEpoch));
%             Rp=AllDat(randsample(length(AllDat),length(Rp)));
%             
%             for r=1:length(Rp)
%                 LitEpoch=intervalSet(Rp(r)-2*1e4,Rp(r)+2*1e4);
%                 temp=nanmean(Data(Restrict(Sptsd,LitEpoch)));
%                 [val,ind]=max(temp(20:end));
%                 SpecValRand{mm,c}(r)=Spectro{3}(ind+20);
%             end
%         end
%     end
% end
% 
% 
% All=[];AllRand=[];
% for mm=1:m-2
%     mm
%     for c=1:length(Dir.path{mm}) 
%         All=[All;SpecVal{mm,c}(:)];
%         AllRand=[AllRand;SpecValRand{mm,c}(:)];
%     end
% end
% figure
% nhist({All,AllRand},'legend',{'data','rand'},'samebins')
