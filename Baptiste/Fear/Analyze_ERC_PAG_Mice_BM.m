
Sessions_PAG_Mice_ERC_DZP_BM

Session_type={'Fear','Cond','Ext','CondPre','CondPost'};
mouse=1; Mouse_names{mouse}='M1199'; Mouse=1199;

Sleep_Epoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'epoch','epochname','sleepyepoch');
Freeze_Epoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');

Acc.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'accelero');
NewMovAcctsd.(Mouse_names{mouse})=tsd(Range(Acc.(Mouse_names{mouse})),runmean(Data(Acc.(Mouse_names{mouse})),100));

for mouse = 1:length(Mouse_names)
    for sess=1:length(Session_type)
        if sess==1; Sess_To_use=FearSess.(Mouse_names{mouse});
        elseif sess==2; Sess_To_use=CondSess.(Mouse_names{mouse});
        elseif sess==3; Sess_To_use=ExtSess.(Mouse_names{mouse});
        elseif sess==4; Sess_To_use=CondPreSess.(Mouse_names{mouse});
        elseif sess==5; Sess_To_use=CondPostSess.(Mouse_names{mouse});
        end
        Acc.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'accelero');
        
        OBSpec.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'spectrum','prefix','B_Low');
        Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','zoneepoch');
        
        ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        
        OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        % Times
        TimeSpent.(Session_type{sess}).Fz.(Mouse_names{mouse})=sum(Stop(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})) - Start(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=sum( Stop(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) )) - Start(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) )))/1e4;
        TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=sum( Stop(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) )) - Start(and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) )))/1e4;
        
        Ripples.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'ripples');
        
        Rg_Acc = Range(Acc.(Session_type{sess}).(Mouse_names{mouse}));
        i=1;
        for bin=1:150:length(Rg_Acc)-150
            SmallEpoch=intervalSet(Rg_Acc(bin),Rg_Acc(bin+150));
            RipDensity_Pre(i) = length(Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch));
            TimeRange(i) = Rg_Acc(bin);
            i=i+1;
        end
        RipDensity_tsd.(Session_type{sess}) = tsd(TimeRange' , RipDensity_Pre');
        clear RipDensity_Pre TimeRange Rg_Acc
        
        RipDensity.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(RipDensity_tsd.(Session_type{sess}) , Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        RipDensity.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(RipDensity_tsd.(Session_type{sess}) , and(ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})));
        RipDensity.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(RipDensity_tsd.(Session_type{sess}) ,and(SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})));
        
    end
    
    % stim
    StimEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','stimepoch');
    StartStimEpoch.(Mouse_names{mouse})=Start(StimEpoch.(Mouse_names{mouse}));
    StimNumb.(Mouse_names{mouse})=length(StartStimEpoch.(Mouse_names{mouse}));
end

HistData = Get_Data_Peak_Spectrum_BM(Mouse);

%% Behaviour figure
figure; 

a=subplot(334); a.Position=[0.13 0.6 0.8 0.3357];
plot(Range(NewMovAcctsd.(Mouse_names{mouse}))/6e5,Data(NewMovAcctsd.(Mouse_names{mouse})))
hold on
plot(Range(Restrict(NewMovAcctsd.(Mouse_names{mouse}) , Sleep_Epoch.(Mouse_names{mouse})))/6e5,Data(Restrict(NewMovAcctsd.(Mouse_names{mouse}) , Sleep_Epoch.(Mouse_names{mouse}))))
plot(Range(Restrict(NewMovAcctsd.(Mouse_names{mouse}) , Freeze_Epoch.(Mouse_names{mouse})))/6e5,Data(Restrict(NewMovAcctsd.(Mouse_names{mouse}) , Freeze_Epoch.(Mouse_names{mouse}))))
Sleep_prop = sum(Stop(Sleep_Epoch.(Mouse_names{mouse}))-Start(Sleep_Epoch.(Mouse_names{mouse})))/max(Range(NewMovAcctsd.(Mouse_names{mouse})));
Fz_prop = sum(Stop(Freeze_Epoch.(Mouse_names{mouse}))-Start(Freeze_Epoch.(Mouse_names{mouse})))/max(Range(NewMovAcctsd.(Mouse_names{mouse})));
xlabel('time (min)'); 
vline(max(Range(Acc.Cond.(Mouse_names{mouse})))/6e5,'--r')
vline(max(Range(Acc.CondPre.(Mouse_names{mouse})))/6e5,'--r')
hold on
yyaxis right
plot(Start(StimEpoch.(Mouse_names{mouse}))/6e5,[1:length(Start(StimEpoch.(Mouse_names{mouse})))],'.r','MarkerSize',30); axis xy
ylabel('# stims'); ylim([-length(Start(StimEpoch.(Mouse_names{mouse}))) length(Start(StimEpoch.(Mouse_names{mouse})))+2])
makepretty
text((max(Range(Acc.CondPre.(Mouse_names{mouse})))/6e5)*0.45, length(Start(StimEpoch.(Mouse_names{mouse}))) , 'CondPre','FontSize',15,'Color','r')
text((max(Range(Acc.Cond.(Mouse_names{mouse})))/6e5)*0.7, length(Start(StimEpoch.(Mouse_names{mouse}))) , 'CondPost','FontSize',15,'Color','r')
text((max(Range(Acc.Fear.(Mouse_names{mouse})))/6e5)*0.9, length(Start(StimEpoch.(Mouse_names{mouse}))) , 'Ext','FontSize',15,'Color','r')
u=legend('Wake',['Sleep : ' num2str(Sleep_prop) '%'],['Fz : ' num2str(Fz_prop) '%'],'stims'); u.Position=[0.8036 0.65 0.1191 0.1018];
xlim([0 max(Range(NewMovAcctsd.(Mouse_names{mouse}))/6e5)])
title('Accelerometer')

subplot(337)
FreezingProportion(1)=sum(Stop(Freeze_Epoch.Fear.(Mouse_names{mouse}))-Start(Freeze_Epoch.Fear.(Mouse_names{mouse})))/max(Range(Acc.Fear.(Mouse_names{mouse})));
FreezingProportion(2)=TimeSpent.Fear.Fz_Shock.(Mouse_names{mouse})/max(Range(Acc.Fear.(Mouse_names{mouse}),'s'));
FreezingProportion(3)=TimeSpent.Fear.Fz_Safe.(Mouse_names{mouse})/max(Range(Acc.Fear.(Mouse_names{mouse}),'s'));
FreezingTime=sum(Stop(Freeze_Epoch.Fear.(Mouse_names{mouse}))-Start(Freeze_Epoch.Fear.(Mouse_names{mouse})))/1e4;
bar(FreezingProportion*100)
makepretty
xticklabels({'Total fz','Shock fz','Safe fz'})
ylabel('Fz proportion (%)')
xtickangle(45)
text(0.7,(max(FreezingProportion(1))*100)*1.1,[num2str(round(FreezingTime)) 's'])

subplot(338)
bar([0.22 , 0.24 NaN 0.02 , 0.5])
xticklabels({'Shock Pre','Safe Pre','','Shock Post','Shock Post'})
xtickangle(45)
makepretty
title('Zone occupancies')

subplot(339)
title('HR values')

a=suptitle(['Mouse ' num2str(Mouse) ' ID card 1']); a.FontSize=20;



%% CondPre Post
load('B_Low_Spectrum.mat'); RangeLow = Spectro{3};

a=figure; a.Position=[1e3 1e3 3e3 2e3]; n=1;
for sess=[4 5 3]

    subplot(4,3,n)     % spectrograms
    imagesc( linspace(0 , round(TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})) , size(Range(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))')), axis xy; makepretty
    l=hline([2 4 6],{'-k','-k','-k'},{'','',''});
    u=text(-round(TimeSpent.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse}))/10 , 8,'Shock','FontSize',10,'FontWeight','bold'); set(u,'Rotation',90);
    title((Session_type{sess}))
    
    hAx(1)=gca;
    hAx(2)=axes('Position',hAx(1).Position,'XAxisLocation','top','YAxisLocation','right','color','none');
    hold(hAx(2),'on')
    plot(hAx(2),Data(RipDensity.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})),'r','LineWidth',2)
    ylim([-5 6]); xlim([0 length(Data(RipDensity.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})))])
        
    subplot(4,3,n+3)
    imagesc( linspace(0 , round(TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})) , size(Range(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))')), axis xy; makepretty
    hline([2 4 6],{'-k','-k','-k'},{'','',''})
    u=text(-round(TimeSpent.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse}))/10 , 8,'Safe','FontSize',10,'FontWeight','bold'); set(u,'Rotation',90);
    xlabel('time (s)')
    
    hAx(1)=gca;
    hAx(2)=axes('Position',hAx(1).Position,'XAxisLocation','top','YAxisLocation','right','color','none');
    hold(hAx(2),'on')
    plot(hAx(2),Data(RipDensity.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})),'r','LineWidth',2)
    ylim([-5 6]); xlim([0 length(Data(RipDensity.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})))])
      
    a=subplot(2,6,7+(n-1)*2);  % mean spectrums
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})).*RangeLow);
    [a,b]=max(Mean_All_Sp(:,16:end)); vline(RangeLow(b+15),'--r')
    plot(RangeLow,Mean_All_Sp/a,'r','linewidth',2), hold on
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data(OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})).*RangeLow);
    [c,d]=max(Mean_All_Sp(:,16:end)); vline(RangeLow(d+15),'--b')
    plot(RangeLow,Mean_All_Sp/c,'b','linewidth',2), ylabel('power (a.u.)'); xlabel('Frequency (Hz)'); hold on
    makepretty
    xlim([0 8]); xticks([1:8]); grid on
    a=legend('shock zone freezing','safe zone freezing'); a.Position=[0.01 0.11 0.11 0.024]
    title((Session_type{sess}))
      
    a=subplot(2,6,8+(n-1)*2); % time spent
    clear Mean_All_Sp; Mean_All_Sp=runmean(HistData.Shock.(Session_type{sess}).(Mouse_names{mouse})/sum(HistData.Shock.(Session_type{sess}).(Mouse_names{mouse})),3);
    [a,b]=max(Mean_All_Sp); vline(RangeLow(b+12),'--r')
    plot(Spectro{3}(13:103) , Mean_All_Sp/a,'-r','linewidth',2); hold on
    clear Mean_All_Sp; Mean_All_Sp=runmean(HistData.Safe.(Session_type{sess}).(Mouse_names{mouse})/sum(HistData.Safe.(Session_type{sess}).(Mouse_names{mouse})),3);
    [c,d]=max(Mean_All_Sp); vline(RangeLow(d+12),'--b')
    plot(Spectro{3}(13:103) , Mean_All_Sp/c,'-b','linewidth',2); hold on
    makepretty; grid on;
    xlabel('Frequency (Hz)'); ylabel('%'); xlim([0 8]); xticks([1:8]);
       
    n=n+1;
end

a=suptitle(['Mouse ' num2str(Mouse) ' ID card 2']); a.FontSize=20;


%% Ripples
for mouse =1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        if sess==1
            Epoch_to_use=FearSess.(Mouse_names{mouse});
        elseif sess==2
            Epoch_to_use=CondSess.(Mouse_names{mouse});
        elseif sess==3
            Epoch_to_use=ExtSess.(Mouse_names{mouse});
        elseif sess==4
            Epoch_to_use=CondPreSess.(Mouse_names{mouse});
        elseif sess==5
            Epoch_to_use=CondPostSess.(Mouse_names{mouse});
        end
        
        Ripples.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Epoch_to_use,'ripples');
        
        Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Epoch_to_use,'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Epoch_to_use,'Epoch','epochname','zoneepoch');
        
        ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        
        Fz_Shock_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = and(ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        Fz_Safe_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = and(SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        if isempty(Ripples.(Session_type{sess}).(Mouse_names{mouse}))
            RipplesDensity.Shock.(Mouse_names{mouse}) = NaN;
            RipplesDensity.Safe.(Mouse_names{mouse}) = NaN;
        else
            RipplesDensity.Shock.(Session_type{sess}).(Mouse_names{mouse}) = length(Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}),Fz_Shock_Epoch.(Session_type{sess}).(Mouse_names{mouse}) ))/(sum(Stop(Fz_Shock_Epoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(Fz_Shock_Epoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4);
            RipplesDensity.Safe.(Session_type{sess}).(Mouse_names{mouse}) = length(Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}),Fz_Safe_Epoch.(Session_type{sess}).(Mouse_names{mouse}) ))/(sum(Stop(Fz_Safe_Epoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(Fz_Safe_Epoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4);
        end
        disp(Mouse_names{mouse})
    end
end


figure
subplot(121)
bar([RipplesDensity.Shock.CondPre.(Mouse_names{mouse})     RipplesDensity.Safe.CondPre.(Mouse_names{mouse})  ; RipplesDensity.Shock.CondPost.(Mouse_names{mouse})   RipplesDensity.Safe.CondPost.(Mouse_names{mouse}) ;   RipplesDensity.Shock.Ext.(Mouse_names{mouse})   RipplesDensity.Safe.Ext.(Mouse_names{mouse}) ])
ylabel('ripples density during freezing')
xticklabels({'CondPre','CondPost','Ext'})
legend('shock','safe')
makepretty

%% Sleep

cd(SleepSess.(Mouse_names{1}){1})
load('StateEpochSB.mat')
SleepPreREM = sum(Stop(REMEpoch)-Start(REMEpoch))/sum(Stop(Sleep)-Start(Sleep));
load('Ripples.mat')
RipDensityPre =length(Start(and(RipplesEpochR,SWSEpoch)))/(sum(Stop(SWSEpoch)-Start(SWSEpoch))/1e4);
               
cd(SleepSess.(Mouse_names{1}){2})
load('StateEpochSB.mat')
SleepPostREM = sum(Stop(REMEpoch)-Start(REMEpoch))/sum(Stop(Sleep)-Start(Sleep));
load('Ripples.mat')
RipDensityPost =length(Start(and(RipplesEpochR,SWSEpoch)))/(sum(Stop(SWSEpoch)-Start(SWSEpoch))/1e4);
 
subplot(222)
bar([SleepPreREM ; SleepPostREM]); xticklabels({'SleepPre','SleepPost'}); ylabel('REM proportion')
ylim([0 0.10])
subplot(224)
bar([RipDensityPre ; RipDensityPost]); xticklabels({'SleepPre','SleepPost'}); ylabel('ripples density')

a=suptitle(['Ripples analysis ' Mouse_names{mouse}]); a.FontSize=20;
%% TestPost

OBSpec.TestPost.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
Freeze_Epoch.TestPost.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');

OBSpec.TestPost.Fz.(Mouse_names{mouse})=Restrict(OBSpec.TestPost.(Mouse_names{mouse}),Freeze_Epoch.TestPost.(Mouse_names{mouse}));

figure
imagesc(Range(OBSpec.TestPost.Fz.(Mouse_names{mouse})) , Spectro{3} , Data(OBSpec.TestPost.Fz.(Mouse_names{mouse}))'); axis xy
a=sum(Stop(Freeze_Epoch.TestPost.(Mouse_names{mouse}))-Start(Freeze_Epoch.TestPost.(Mouse_names{mouse})))/1e4;
ylabel('Frequency (Hz)'); xlabel(['time (last for ' num2str(round(a)) 's)'])
caxis([0 5e5])
title(['Freezing during TestPost ' Mouse_names{mouse}])
hline([2 4 6],'-k'); 

%% real evolution spectrogram
[tf,idx] = ismember(Range(OBSpec.Fear.Fz_Shock.(Mouse_names{mouse})),Range(OBSpec.Fear.Fz.(Mouse_names{mouse})));
A(:,1) = Range(OBSpec.Fear.Fz.(Mouse_names{mouse}));
A(idx,2) = 1;

figure
a=subplot(211); a.Position=[0.1 0.85 0.8 0.05];
imagesc(A(:,2)');  colormap jet

a=subplot(212); a.Position=[0.1 0.1 0.8 0.7];
imagesc( linspace(0 , round(TimeSpent.Fear.Fz.(Mouse_names{mouse})) , size(Range(OBSpec.Fear.Fz.(Mouse_names{mouse})),1) ), RangeLow , zscore_nan_BM(Data(OBSpec.Fear.Fz.(Mouse_names{mouse}))')), axis xy; makepretty
hline([2 4 6],{'-k','-k','-k'},{'','',''});
vline(round(TimeSpent.CondPre.Fz.(Mouse_names{mouse})),'--r')
vline(round(TimeSpent.Cond.Fz.(Mouse_names{mouse})),'--r')
xlabel('time (s)'); ylabel('Frequency (Hz)')

hAx(1)=gca;
hAx(2)=axes('Position',hAx(1).Position,'XAxisLocation','top','YAxisLocation','right','color','none'); makepretty
hold(hAx(2),'on')
plot(hAx(2),Data(RipDensity.Fear.Fz.(Mouse_names{mouse})),'r','LineWidth',2)
ylim([-max(Data(RipDensity.Fear.Fz.(Mouse_names{mouse}))) max(Data(RipDensity.Fear.Fz.(Mouse_names{mouse})))]); xlim([0 length(Data(RipDensity.Fear.Fz.(Mouse_names{mouse})))])
legend('Ripples density')
















