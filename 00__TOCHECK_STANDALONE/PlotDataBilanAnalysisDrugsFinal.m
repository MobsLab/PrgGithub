%PlotDataBilanAnalysisDrugsFinal

% basal 1)1 47;   2)2 51;   3)3 52;   4)4 60;    5)5 61;
% DPCPX 1)6 51;   2)7 54)   3)8 54;   4)9 60;    5)10 61;
% Veh   1)11 51;  2)15 54;  3)19 55;  4)23 56;   5)26 63;   6)30 47;  7)31 51   
% LPS   1)12 51;  2)16 54;  3)20 55;  4)24 56;   5)27 63;   
% d1    1)13 51;  2)17 54;  3)21 55;  4)28 63;
% d2    1)14 51;  2)18 54;  3)22 55;  4)25 56;   5)29 63;
% Can   1)32 47;  2)33 51;  3)34 52;  4)35 54;


% 
% C57: 55 56 63
% wt: 51p 60 61 
% dKO: 47p(pas d'Hpc) 52p 54p 65 66
% 

%wt=[2 4 6 11 19]; mice: 51 60  
%ko=[1 3 5 15];

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

basal=[1 2 3 4 5];
DPCPX=[6 7 8 9 10];
veh=[11 15 19 23 26 30 31];
LPS=[12 16 20 24 27];
d1=[13 17 21 28];
d2=[14 18 22 25 29];
Can=[32 33 34 35];

basalwt=[2 4 5];
basalko=[1 3];
DPCPXwt=[6 9 10];
DPCPXko=[7 8];
vehwtreal=[11 31];
vehC57=[19 23 26];

vehwtTotal=[11 19 23 26 31];
vehkoTotal=[15 30];

vehwt=[11 19 23 26];
vehko=[15];

% vehwt=[11]; % sans C57
% vehko=15;

LPSwt=[12 20 24 27];
LPSko=16;
d1wt=[13 21 28];
d1ko=17;
d2wt=[14 22 25 29];
d2ko=18;

vehC57=[19 23 26];
LPSC57=[20 24 27];
d1C57=[21 28];
d2C57=[22 25 29];


wt=[2 4 6 11 19 23 26 31];
ko=[1 3 5 15 30];

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%     a=a+1; R{a}=Epoch1;           %1 
%     a=a+1; R{a}=DurEpoch1;        %2  +
%     a=a+1; R{a}=MeanDurEpoch1;    %3
%     a=a+1; R{a}=Epoch2;           %4
%     a=a+1; R{a}=DurEpoch2;        %5 -
%     a=a+1; R{a}=MeanDurEpoch2;    %6
%     a=a+1; R{a}=Epoch1rem;        %7
%     a=a+1; R{a}=DurEpoch1rem;     %8  +
%     a=a+1; R{a}=MeanDurEpoch1rem; %9
%     a=a+1; R{a}=Epoch2rem;        %10
%     a=a+1; R{a}=DurEpoch2rem;     %11 -
%     a=a+1; R{a}=MeanDurEpoch2rem; %12
%     a=a+1; R{a}=sum(End(EpochT1,'s')-Start(EpochT1,'s'));  %13   +
%     a=a+1; R{a}=sum(End(EpochT2,'s')-Start(EpochT2,'s'));  %14   -
%     a=a+1; R{a}=tdelayRemRecording; %15
%     a=a+1; R{a}=tdelayRem1;         %16 
%     a=a+1; R{a}=tdelayRem2;       %17
%     a=a+1; R{a}=befR;             %18
%     a=a+1; R{a}= aftR;            %19
%     a=a+1; R{a}= befS;           %20
%     a=a+1; R{a}=aftS;            %21
%     a=a+1; R{a}=C;;              %22
%     a=a+1; R{a}=B;;              %23
%     a=a+1; R{a}=C1;;             %24
%     a=a+1; R{a}=B1;;             %25
%     a=a+1; R{a}=C2;;             %26
%     a=a+1; R{a}=B2;;             %27
%     a=a+1; R{a}=tPeaksT;         %28
%     a=a+1; R{a}=peakValue;       %29
%     a=a+1; R{a}=peakMeanValue;     %30
%     a=a+1; R{a}=zeroCrossT;        %31
%     a=a+1; R{a}=zeroMeanValue;     %32
%     a=a+1; R{a}=reliab;;           %33
%     a=a+1; R{a}=Bilan;;            %34
%     a=a+1; R{a}=ST;;               %35
%     a=a+1; R{a}=freq;;             %36
%     a=a+1; R{a}=Mh1r;;             %37
%     a=a+1; R{a}=Mh2r;    ;         %38
%     a=a+1; R{a}=Mh3r;;             %39
%     a=a+1; R{a}=Mh1s;;          %40
%     a=a+1; R{a}=Mh2s;;          %41
%     a=a+1; R{a}=Mh3s;  ;        %42
%     a=a+1; R{a}=Mp1r;;          %43
%     a=a+1; R{a}=Mp2r;    ;      %44
%     a=a+1; R{a}=Mp3r;;          %45
%     a=a+1; R{a}=Mp1s;;          %46
%     a=a+1; R{a}=Mp2s;;          %47
%     a=a+1; R{a}=Mp3s;;          %48
%     a=a+1; R{a}=Spi;;           %49
%     a=a+1; R{a}=Rip;;              %50
%     a=a+1; R{a}=num;               %51
%     a=a+1; R{a}=params;            %52    
%     a=a+1; R{a}=Spi corrected;     %53


%     a=a+1; D{a}=Filt_EEGd;;        %1
%     a=a+1; D{a}=LFPp;;             %2
%     a=a+1; D{a}=LFPh;;             %3

cd \\NASDELUXE\DataMOBs



% 
% try
%     try
%        dratioREMSWSbeforeDrug;
%     catch 
%     dload DataBilanAnalysisDrugsFinal
%     ratioREMSWSbeforeDrug;
%     end
% catch
%     
    for a=1:length(RT)

    ratioREMSWSbeforeDrug(a)=RT{a}{8}/(RT{a}{2}+RT{a}{8})*100;
    ratioREMSWSafterDrug(a)=RT{a}{11}/(RT{a}{5}+RT{a}{11})*100;
    PercSleepbeforeDrug(a)=(RT{a}{2}+RT{a}{8})/RT{a}{13}*100;
    PercSleepafterDrug(a)=(RT{a}{5}+RT{a}{11})/RT{a}{14}*100;
    meanDurationSWSbeforeDrug(a)=RT{a}{3};
    meanDurationSWSafterDrug(a)=RT{a}{6};
    meanDurationREMbeforeDrug(a)=RT{a}{9};
    meanDurationREMafterDrug(a)=RT{a}{12};

    DurationSWSbeforeDrug(a)=RT{a}{2}/RT{a}{13}*100;
    DurationSWSafterDrug(a)=RT{a}{5}/RT{a}{14}*100;
    DurationREMbeforeDrug(a)=RT{a}{8}/RT{a}{13}*100;
    DurationREMafterDrug(a)=RT{a}{11}/RT{a}{14}*100;

    DurationsleepbeforeDrug(a)=RT{a}{2}+RT{a}{8};
    DurationsleepafterDrug(a)=RT{a}{5}+RT{a}{11};

    DurationrecordingbeforeDrug(a)=RT{a}{13};
    DurationrecordingafterDrug(a)=RT{a}{14};

    DelayFirstREMafterrecording(a)=RT{a}{15};
    DelayFirstREMbeforeDrug(a)=RT{a}{16}(1);
    DelayFirstREMafterDrug(a)=RT{a}{17}(1);

    RipplesfrequencybeforeDrug(a)=RT{a}{18};
    RipplesfrequencyafterDrug(a)=RT{a}{19};

    SpindlesfrequencybeforeDrug(a)=RT{a}{20};
    SpindlesfrequencyafterDrug(a)=RT{a}{21};

SpindlesfreqbeforeDrugCor(a)=length(Range(Restrict(ts(RT{a}{53}(:,2)*1E4),RT{a}{1})))/RT{a}{2};
SpindlesfreqafterDrugCor(a)=length(Range(Restrict(ts(RT{a}{53}(:,2)*1E4),RT{a}{4})))/RT{a}{5};
SpindlesfreqCor(a)=length(Range(RT{a}{53}))/(RT{a}{2}+RT{a}{5});

     end
    
%save DataBilanAnalysisDrugsFinal
% end



% 
% list=basal;
% figure('color',[1 1 1])
% subplot(3,4,1), PlotErrorBar2(ratioREMSWSbeforeDrug(list)',ratioREMSWSafterDrug(list)',0),title('ratioREM/SWS')
% subplot(3,4,2),PlotErrorBar2(PercSleepbeforeDrug(list)',PercSleepafterDrug(list)',0),title('PrecSleep')
% subplot(3,4,3),PlotErrorBar2(meanDurationSWSbeforeDrug(list)',meanDurationSWSafterDrug(list)',0),title('mean duration SWS')
% subplot(3,4,4),PlotErrorBar2(meanDurationREMbeforeDrug(list)',meanDurationREMafterDrug(list)',0),title('mean duration REM')
% subplot(3,4,5),PlotErrorBar2(DurationSWSbeforeDrug(list)',DurationSWSafterDrug(list)',0),title('duration SWS')
% subplot(3,4,6),PlotErrorBar2(DurationREMbeforeDrug(list)',DurationREMafterDrug(list)',0),title('duration REM')
% subplot(3,4,7),PlotErrorBar2(DurationsleepbeforeDrug(list)',DurationsleepafterDrug(list)',0),title('duration sleep')
% subplot(3,4,8),PlotErrorBar2(DurationrecordingbeforeDrug(list)',DurationrecordingafterDrug(list)',0),title('duration recordings')
% subplot(3,4,9),PlotErrorBar3(DelayFirstREMafterrecording(list)',DelayFirstREMbeforeDrug(list)',DelayFirstREMafterDrug(list)',0),title('Delay first REM')
% subplot(3,4,10),PlotErrorBar2(RipplesfrequencybeforeDrug(list)',RipplesfrequencyafterDrug(list)',0),title('Ripples (Hz)')
% subplot(3,4,11),PlotErrorBar2(SpindlesfrequencybeforeDrug(list)',SpindlesfrequencyafterDrug(list)',0),title('Spindles (Hz)')
% 
% 
% 
% list=DPCPX;
% 
% figure('color',[1 1 1])
% subplot(3,4,1), PlotErrorBar2([ratioREMSWSbeforeDrug(list)',ratioREMSWSafterDrug(list)',0),title('ratioREM/SWS DPCPX')
% subplot(3,4,2),PlotErrorBar2(PercSleepbeforeDrug(list)',PercSleepafterDrug(list)',0),title('PrecSleep DPCPX')
% subplot(3,4,3),PlotErrorBar2(meanDurationSWSbeforeDrug(list)',meanDurationSWSafterDrug(list)',0),title('mean duration SWS DPCPX')
% subplot(3,4,4),PlotErrorBar2(meanDurationREMbeforeDrug(list)',meanDurationREMafterDrug(list)',0),title('mean duration REM DPCPX')
% subplot(3,4,5),PlotErrorBar2(DurationSWSbeforeDrug(list)',DurationSWSafterDrug(list)',0),title('duration SWS DPCPX')
% subplot(3,4,6),PlotErrorBar2(DurationREMbeforeDrug(list)',DurationREMafterDrug(list)',0),title('duration REM DPCPX')
% subplot(3,4,7),PlotErrorBar2(DurationsleepbeforeDrug(list)',DurationsleepafterDrug(list)',0),title('duration sleep DPCPX')
% subplot(3,4,8),PlotErrorBar2(DurationrecordingbeforeDrug(list)',DurationrecordingafterDrug(list)',0),title('duration recordings DPCPX')
% subplot(3,4,9),PlotErrorBar3(DelayFirstREMafterrecording(list)',DelayFirstREMbeforeDrug(list)',DelayFirstREMafterDrug(list)',0),title('Delay first REM DPCPX')
% subplot(3,4,10),PlotErrorBar2(RipplesfrequencybeforeDrug(list)',RipplesfrequencyafterDrug(list)',0),title('Ripples (Hz) DPCPX')
% subplot(3,4,11),PlotErrorBar2(SpindlesfrequencybeforeDrug(list)',SpindlesfrequencyafterDrug(list)',0),title('Spindles (Hz) DPCPX')
% 
% 



Mt{1,1}='ratioREMSWSbeforeDrug';
Mt{1,2}='ratioREMSWSafterDrug';
Mt{2,1}='PercSleepbeforeDrug';
Mt{2,2}='PercSleepafterDrug';
Mt{3,1}='meanDurationSWSbeforeDrug';
Mt{3,2}='meanDurationSWSafterDrug';
Mt{4,1}='meanDurationREMbeforeDrug';
Mt{4,2}='meanDurationREMafterDrug';
Mt{5,1}='DurationSWSbeforeDrug';
Mt{5,2}='DurationSWSafterDrug';
Mt{6,1}='DurationREMbeforeDrug';
Mt{6,2}='DurationREMafterDrug';
Mt{7,1}='DurationsleepbeforeDrug';
Mt{7,2}='DurationsleepafterDrug';
Mt{8,1}='DurationrecordingbeforeDrug';
Mt{8,2}='DurationrecordingafterDrug';
Mt{9,1}='DelayFirstREMbeforeDrug';
Mt{9,2}='DelayFirstREMafterDrug';
Mt{10,1}='RipplesfrequencybeforeDrug';
Mt{10,2}='RipplesfrequencyafterDrug';
Mt{11,1}='SpindlesfrequencybeforeDrug';
Mt{11,2}='SpindlesfrequencyafterDrug';

Mt{12,1}='SpindlesfreqbeforeDrugCor';
Mt{12,2}='SpindlesfreqafterDrugCor';
Mt{12,3}='SpindlesfreqCor';

if 0
for i=1:12
    

    eval([Mt{eval(num2str(i)),1},'(isnan(',Mt{eval(num2str(i)),1},'))=0;'])
    eval([Mt{eval(num2str(i)),1},'(isnan(',Mt{eval(num2str(i)),1},'))=0;'])
    
end
end

% 
%  figure('color',[1 1 1])
% for i=1:11
%     
%  subplot(4,3,i)
%     m=Mt{i,2};
%     eval(['PlotErrorBar4(',m,'(veh)'',',m,'(LPS)'',',m,'(d1)'',',m,'(d2)'',0)']), title(m)
%     set(gca,'xtick',[1:4])
%     set(gca,'xticklabel',{'veh','LPS','d1','d2'})
%     %ylabel('Post values')
%     yl2=ylim;
%     
% %      subplot(1,2,1),ylim([0 max(yl1(2),yl2(2))])
% %     subplot(1,2,2),ylim([0 max(yl1(2),yl2(2))])
%     
% end

 figure('color',[1 1 1])
for i=1:11
subplot(4,3,i)
    m=Mt{i,2};
    eval(['PlotErrorBar8(',m,'(vehwt)'',',m,'(vehko)'',',m,'(LPSwt)'',',m,'(LPSko)'',',m,'(d1wt)'',',m,'(d1ko)'',',m,'(d2wt)'',',m,'(d2ko)'',0)']), title(m)
    set(gca,'xtick',[1:8])
    set(gca,'xticklabel',{'v','vko','LPS','LPSko','d1','d1ko','d2','d2ko'})
     ylabel(m) 
end

 figure('color',[1 1 1])
for i=1:11
subplot(4,3,i)
    m=Mt{i,2};
    eval(['PlotErrorBar8(',m,'(vehwtTotal)'',',m,'(vehkoTotal)'',',m,'(LPSwt)'',',m,'(LPSko)'',',m,'(d1wt)'',',m,'(d1ko)'',',m,'(d2wt)'',',m,'(d2ko)'',0)']), title(m)
    set(gca,'xtick',[1:8])
    set(gca,'xticklabel',{'v','vko','LPS','LPSko','d1','d1ko','d2','d2ko'})
%     ylabel('Pre values') 
end





for i=1:11
    figure('color',[1 1 1])
    subplot(1,2,1)
    m=Mt{i,1};
    eval(['PlotErrorBar2(',m,'(vehwt)'',',m,'(LPSwt)'',0)']), title(m)
    set(gca,'xtick',[1:2])
    set(gca,'xticklabel',{'veh','LPS'})
    ylabel('Pre values')
    yl1=ylim;
    
    subplot(1,2,2)
    m=Mt{i,2};
    eval(['PlotErrorBar4(',m,'(vehwt)'',',m,'(LPSwt)'',',m,'(d1wt)'',',m,'(d2wt)'',0)']), title(m)
    set(gca,'xtick',[1:4])
    set(gca,'xticklabel',{'veh','LPS','d1','d2'})
    ylabel('Post values')
    yl2=ylim;
    
     subplot(1,2,1),ylim([0 max(yl1(2),yl2(2))])
    subplot(1,2,2),ylim([0 max(yl1(2),yl2(2))])
    
end



for i=1:11
    figure('color',[1 1 1])
    subplot(1,2,1)
    m=Mt{i,1};
    eval(['PlotErrorBar2(',m,'(vehC57)'',',m,'(LPSC57)'',0)']), title(m)
    set(gca,'xtick',[1:2])
    set(gca,'xticklabel',{'veh','LPS'})
    ylabel('Pre values')
    yl1=ylim;
    
    subplot(1,2,2)
    m=Mt{i,2};
    eval(['PlotErrorBar4(',m,'(vehC57)'',',m,'(LPSC57)'',',m,'(d1C57)'',',m,'(d2C57)'',0)']), title(m)
    set(gca,'xtick',[1:4])
    set(gca,'xticklabel',{'veh','LPS','d1','d2'})
    ylabel('Post values')
    yl2=ylim;
    
     subplot(1,2,1),ylim([0 max(yl1(2),yl2(2))])
    subplot(1,2,2),ylim([0 max(yl1(2),yl2(2))])
    
end





 figure('color',[1 1 1])
for i=1:11
subplot(4,3,i), hold on
    m=Mt{i,1};
    m2=Mt{i,2};
    eval(['plot(',m,'(veh)'',',m2,'(vehwt),''ko'',''markerfacecolor'',''k'')'])
    eval(['plot(',m,'(LPSwt)'',',m2,'(LPSwt),''ko'',''markerfacecolor'',''r'')']), title(m)
    xl=xlim;
    yl=ylim;
    line([min(xl(1),yl(1)) max(xl(2),yl(2))],[min(xl(1),yl(1)) max(xl(2),yl(2))],'color','k')
    eval(['[h1,p1]=ttest(',m,'(vehwt),',m2,'(vehwt));'])
    eval(['[h2,p2]=ttest(',m,'(LPSwt),',m2,'(LPSwt));'])
title(['veh,p=',num2str(floor(p1*1000)/1000),': LPS, p=',num2str(floor(p2*1000)/1000)])
ylabel(m2)

%     ylabel('Pre values') 
end

% figure, plot(SpindlesfrequencybeforeDrug(LPS),SpindlesfrequencyafterDrug(LPS),'ko','markerfacecolor','k')
% hold on, plot(SpindlesfrequencybeforeDrug(veh),SpindlesfrequencyafterDrug(veh),'ko','markerfacecolor','r')
% line([0 0.18],[0 0.18],'color','k')


Can=[32 33 34 35];


 figure('color',[1 1 1])
for i=1:11
subplot(4,3,i), hold on
    m=Mt{i,1};
    m2=Mt{i,2};
    eval(['plot(',m,'(Can)'',',m2,'(Can),''ko'',''markerfacecolor'',''k'')'])
%     eval(['plot(',m,'(LPSwt)'',',m2,'(LPSwt),''ko'',''markerfacecolor'',''r'')']), title(m)
    xl=xlim;
    yl=ylim;
    line([min(xl(1),yl(1)) max(xl(2),yl(2))],[min(xl(1),yl(1)) max(xl(2),yl(2))],'color','k')
    eval(['[h1,p1]=ttest(',m,'(Can),',m2,'(Can));'])
%     eval(['[h2,p2]=ttest(',m,'(LPSwt),',m2,'(LPSwt));'])
title(['Can,p=',num2str(floor(p1*1000)/1000)])
ylabel(m2)

%     ylabel('Pre values') 
end















if 1

for i=1:11
    
    figure('color',[1 1 1])
    subplot(1,2,1)
    m=Mt{i,1};
    eval(['PlotErrorBar4(',m,'(basal)'',',m,'(DPCPX)'',',m,'(veh)'',',m,'(LPS)'',0)']), title(m)
    set(gca,'xtick',[1:4])
    set(gca,'xticklabel',{'basal','DPCPX','veh','LPS'})
    ylabel('Pre values')
    yl1=ylim;
    
    subplot(1,2,2)
    m=Mt{i,2};
    eval(['PlotErrorBar6(',m,'(basal)'',',m,'(DPCPX)'',',m,'(veh)'',',m,'(LPS)'',',m,'(d1)'',',m,'(d2)'',0)']), title(m)
    set(gca,'xtick',[1:6])
    set(gca,'xticklabel',{'basal','DPCPX','veh','LPS','d1','d2'})
    ylabel('Post values')
    yl2=ylim;
    
     subplot(1,2,1),ylim([0 max(yl1(2),yl2(2))])
    subplot(1,2,2),ylim([0 max(yl1(2),yl2(2))])
    
end








for i=1:11
    
    figure('color',[1 1 1])
    subplot(1,2,1)
    m=Mt{i,1};
    eval(['PlotErrorBar3(',m,'(veh)'',',m,'(DPCPX)'',',m,'(LPS)'',0)']), title(m)
    set(gca,'xtick',[1:3])
    set(gca,'xticklabel',{'veh','DPCPX','LPS'})
    ylabel('Pre values')
    yl1=ylim;
    
    subplot(1,2,2)
    m=Mt{i,2};
    eval(['PlotErrorBar5(',m,'(veh)'',',m,'(DPCPX)'',',m,'(LPS)'',',m,'(d1)'',',m,'(d2)'',0)']), title(m)
    set(gca,'xtick',[1:5])
    set(gca,'xticklabel',{'veh','DPCPX','LPS','d1','d2'})
    ylabel('Post values')
    yl2=ylim;
    
     subplot(1,2,1),ylim([0 max(yl1(2),yl2(2))])
    subplot(1,2,2),ylim([0 max(yl1(2),yl2(2))])
    
end


end


for i=1:11
    
    figure('color',[1 1 1])
    subplot(1,2,1)
    m=Mt{i,1};
    eval(['PlotErrorBar6(',m,'(basalwt)'',',m,'(basalko)'',',m,'(vehwt)'',',m,'(vehko)'',',m,'(DPCPXwt)'',',m,'(DPCPXko)'',0)']), title(m)
    set(gca,'xtick',[1:6])
    set(gca,'xticklabel',{'wt','KO','Veh wt','Veh ko','DP wt','DP ko'})
    ylabel('Pre values')
    yl1=ylim;
    
    subplot(1,2,2)
    m=Mt{i,2};
    eval(['PlotErrorBar6(',m,'(basalwt)'',',m,'(basalko)'',',m,'(vehwt)'',',m,'(vehko)'',',m,'(DPCPXwt)'',',m,'(DPCPXko)'',0)']), title(m)
    set(gca,'xtick',[1:6])
    set(gca,'xticklabel',{'wt','KO','Veh wt','Veh ko','DP wt','DP ko'})
    ylabel('Post values')
    yl2=ylim;
    
     subplot(1,2,1),ylim([0 max(yl1(2),yl2(2))])
    subplot(1,2,2),ylim([0 max(yl1(2),yl2(2))])
    
end

%  figure('color',[1 1 1])
% 
%     m=Mt{12,3};
%     eval(['PlotErrorBar6(',m,'(basalwt)'',',m,'(basalko)'',',m,'(vehwt)'',',m,'(vehko)'',',m,'(DPCPXwt)'',',m,'(DPCPXko)'',0)']), title(m)
%     set(gca,'xtick',[1:6])
%     set(gca,'xticklabel',{'wt','KO','Veh wt','Veh ko','DP wt','DP ko'})
%     ylabel('Pre values')
%     yl1=ylim;
    
    
    
    figure('color',[1 1 1])
for i=1:11
subplot(4,3,i)
    m=Mt{i,1};
    m2=Mt{i,2};
    eval(['PlotErrorBar4(',m,'(DPCPXwt)'',',m2,'(DPCPXwt)'',',m,'(DPCPXko)'',',m2,'(DPCPXko)'',0)']), title(m)
    set(gca,'xtick',[1:4])
    set(gca,'xticklabel',{'wt','wt+DP','ko','ko+DP'})
    ylabel('Pre values') 
end

% subplot(4,3,12)
%     m=Mt{12,3};
%  
%     eval(['PlotErrorBar4(',m,'(vehwt)'',',m,'(DPCPXwt)'',',m,'(vehko)'',',m,'(DPCPXko)'',0)']), title(m)
%     set(gca,'xtick',[1:4])
%     set(gca,'xticklabel',{'wt','wt+DP','ko','ko+DP'})
%     ylabel('Pre values') 


    figure('color',[1 1 1])
for i=1:11
subplot(4,3,i)
    m=Mt{i,1};
    m2=Mt{i,2};
    eval(['PlotErrorBar8(',m,'(basalwt)'',',m,'(basalko)'',',m2,'(basalwt)'',',m2,'(basalko)'',',m,'(vehwt)'',',m,'(vehko)'',',m2,'(vehwt)'',',m2,'(vehko)'',0)']), title(m)
    set(gca,'xtick',[1:8])
    set(gca,'xticklabel',{'wt','ko','wt','ko','Veh wt','Veh ko','Vpost wt','Vpost ko'})
%     ylabel('Pre values') 
end


for nu=wt
    figure('color',[1 1 1]), 
    subplot(2,3,1), hold on
    try
    plot(RT{nu}{37}(:,1),RT{nu}{37}(:,2)),title('ripples wt')
    plot(RT{nu}{38}(:,1),RT{nu}{38}(:,2))
    plot(RT{nu}{39}(:,1),RT{nu}{39}(:,2))
     end
    yl=ylim;
    line([0 0],yl,'color','r')  
    subplot(2,2,2), hold on
    try
    plot(RT{nu}{40}(:,1),RT{nu}{40}(:,2))%,title('spindles')
    plot(RT{nu}{41}(:,1),RT{nu}{41}(:,2))
    plot(RT{nu}{42}(:,1),RT{nu}{42}(:,2))
    end
    yl=ylim;
    line([0 0],yl,'color','r')  
    subplot(2,2,3), hold on
    try
    plot(RT{nu}{43}(:,1),RT{nu}{43}(:,2))
    plot(RT{nu}{44}(:,1),RT{nu}{44}(:,2))
    plot(RT{nu}{45}(:,1),RT{nu}{45}(:,2))
    end
    yl=ylim;
    line([0 0],yl,'color','r')  
    subplot(2,2,4), hold on
    try
    plot(RT{nu}{46}(:,1),RT{nu}{46}(:,2))
    plot(RT{nu}{47}(:,1),RT{nu}{47}(:,2))
    plot(RT{nu}{48}(:,1),RT{nu}{48}(:,2))
    end
    yl=ylim;
    line([0 0],yl,'color','r')  
end

for nu=ko
    figure('color',[1 1 1]), 
    subplot(2,3,1), hold on
    try
    plot(RT{nu}{37}(:,1),RT{nu}{37}(:,2),'k'),title('ripples ko')
    plot(RT{nu}{38}(:,1),RT{nu}{38}(:,2),'k')
    plot(RT{nu}{39}(:,1),RT{nu}{39}(:,2),'k')
     end
    yl=ylim;
    line([0 0],yl,'color','r')  
    subplot(2,2,2), hold on
    try
    plot(RT{nu}{40}(:,1),RT{nu}{40}(:,2),'k')%,title('spindles')
    plot(RT{nu}{41}(:,1),RT{nu}{41}(:,2),'k')
    plot(RT{nu}{42}(:,1),RT{nu}{42}(:,2),'k')
    end
    yl=ylim;
    line([0 0],yl,'color','r')  
    subplot(2,2,3), hold on
    try
    plot(RT{nu}{43}(:,1),RT{nu}{43}(:,2),'k')
    plot(RT{nu}{44}(:,1),RT{nu}{44}(:,2),'k')
    plot(RT{nu}{45}(:,1),RT{nu}{45}(:,2),'k')
    end
    yl=ylim;
    line([0 0],yl,'color','r')  
    subplot(2,2,4), hold on
    try
    plot(RT{nu}{46}(:,1),RT{nu}{46}(:,2),'k')
    plot(RT{nu}{47}(:,1),RT{nu}{47}(:,2),'k')
    plot(RT{nu}{48}(:,1),RT{nu}{48}(:,2),'k')
    end
    yl=ylim;
    line([0 0],yl,'color','r')  
end






