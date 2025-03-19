

GetAllSalineSessions_BM

GetAllSalineSessions_BM
Session_type={'Cond','Ext'};
Mouse=[117 404 425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568 569 566 666 667 668 669 688 739 777 779 849 1144 1146 1147  1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];
Var = {'Respi'};
Side = {'All','Shock','Safe'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1%:length(Session_type)
        
        Sessions_List_ForLoop_BM
        try
            % variables
            %             Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
            %             Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples_all');
            %
            %             ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_zoneepoch');
            %
            %             ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
            %             SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
            %                         FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname' , 'all_fz_epoch');
            %
            %                         Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
            %                         Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
            %
            Ripples_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            %             Ripples_ShockFz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}));
            %             Ripples_SafeFz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}));
            %
            %             Respi_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            %             Respi_ShockFz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}));
            %             Respi_SafeFz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}));
            
        end
    end
    disp(Mouse_names{mouse})
end


for mouse=1:length(Mouse)
    try
        RipDataFz.(Session_type{1}).(Mouse_names{mouse}) = Data(Ripples_Fz.(Session_type{1}).(Mouse_names{mouse}));
        RipDataShockFz.(Session_type{1}).(Mouse_names{mouse}) = Data(Ripples_ShockFz.(Session_type{1}).(Mouse_names{mouse}));
        RipDataSafeFz.(Session_type{1}).(Mouse_names{mouse}) = Data(Ripples_SafeFz.(Session_type{1}).(Mouse_names{mouse}));
        
        RipDurDataShockFz_all(mouse) = nanmean(RipDataShockFz.(Session_type{1}).(Mouse_names{mouse})(:,4));
        RipDurDataSafeFz_all(mouse) = nanmean(RipDataSafeFz.(Session_type{1}).(Mouse_names{mouse})(:,4));
        RipFreqDataShockFz_all(mouse) = nanmean(RipDataShockFz.(Session_type{1}).(Mouse_names{mouse})(:,5));
        RipFreqDataSafeFz_all(mouse) = nanmean(RipDataSafeFz.(Session_type{1}).(Mouse_names{mouse})(:,5));
        RipAmpDataShockFz_all(mouse) = nanmean(RipDataShockFz.(Session_type{1}).(Mouse_names{mouse})(:,6));
        RipAmpDataSafeFz_all(mouse) = nanmean(RipDataSafeFz.(Session_type{1}).(Mouse_names{mouse})(:,6));
    end
    try
        RespiDataFz.(Session_type{1}).(Mouse_names{mouse}) = Data(Respi_Fz.(Session_type{1}).(Mouse_names{mouse}));
        RespiDataShockFz.(Session_type{1}).(Mouse_names{mouse}) = Data(Respi_ShockFz.(Session_type{1}).(Mouse_names{mouse}));
        RespiDataSafeFz.(Session_type{1}).(Mouse_names{mouse}) = Data(Respi_SafeFz.(Session_type{1}).(Mouse_names{mouse}));
        RespiDataShockFz_all(mouse) = nanmean(RespiDataShockFz.(Session_type{1}).(Mouse_names{mouse}));
        RespiDataSafeFz_all(mouse) = nanmean(RespiDataSafeFz.(Session_type{1}).(Mouse_names{mouse}));
    end
    try
        Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse}) = Restrict(Respi_Fz.(Session_type{1}).(Mouse_names{mouse}) , Ripples_Fz.(Session_type{1}).(Mouse_names{mouse}));
        Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse}) = Data(Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse}));
    end
end
RespiDataShockFz_all(RespiDataShockFz_all==0)=NaN;
RespiDataSafeFz_all(RespiDataSafeFz_all==0)=NaN;
RipDurDataShockFz_all(RipDurDataShockFz_all==0)=NaN;
RipDurDataSafeFz_all(RipDurDataSafeFz_all==0)=NaN;
RipFreqDataShockFz_all(RipFreqDataShockFz_all==0)=NaN;
RipFreqDataSafeFz_all(RipFreqDataSafeFz_all==0)=NaN;
RipAmpDataShockFz_all(RipAmpDataShockFz_all==0)=NaN;
RipAmpDataSafeFz_all(RipAmpDataSafeFz_all==0)=NaN;

RipFreqDataShockFz_all(or(RipFreqDataShockFz_all<171 , RipFreqDataShockFz_all>200))=NaN;
RipFreqDataSafeFz_all(or(RipFreqDataSafeFz_all<171 , RipFreqDataSafeFz_all>200))=NaN;
RipAmpDataShockFz_all(RipAmpDataShockFz_all>3e3)=NaN;
RipAmpDataSafeFz_all(RipAmpDataSafeFz_all>3e3)=NaN;

Cols = {[1 .5 .5],[.5 .5 1]};
X = [1:2];
Legends = {'Shock','Safe'};

% 2 fz types
figure
MakeSpreadAndBoxPlot3_SB({RespiDataShockFz_all RespiDataSafeFz_all},Cols,X,Legends,'showpoints',1,'paired',0);

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({RipDurDataShockFz_all RipDurDataSafeFz_all},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('ms'), title('Duration')
subplot(132)
MakeSpreadAndBoxPlot3_SB({RipFreqDataShockFz_all RipFreqDataSafeFz_all},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Hz'), title('Frequency')
subplot(133)
MakeSpreadAndBoxPlot3_SB({RipAmpDataShockFz_all RipAmpDataSafeFz_all},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('a.u.'), title('Amplitude')

a=suptitle('Ripples features during freezing'); a.FontSize=15;

% all mice for duration, frequency, amplitude
for mouse=1:50
    try
        figure
        subplot(131)
        D1=Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse});
        D2=RipDataFz.(Session_type{1}).(Mouse_names{mouse})(:,4)';
        [R_dur(mouse),P_dur(mouse)] = PlotCorrelations_BM(D1 , D2);
        
        subplot(132)
        D1=Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse});
        D2=RipDataFz.(Session_type{1}).(Mouse_names{mouse})(:,5)';
        [R_freq(mouse),P_freq(mouse)] = PlotCorrelations_BM(D1 , D2);
        
        subplot(133)
        D1=Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse});
        D2=RipDataFz.(Session_type{1}).(Mouse_names{mouse})(:,6)';
        [R_amp(mouse),P_amp(mouse)] = PlotCorrelations_BM(D1 , D2);
    end
end
R_dur(R_dur==0) = NaN; P_dur(P_dur==0) = NaN;
R_freq(R_freq==0) = NaN; P_freq(P_freq==0) = NaN;
R_amp(R_amp==0) = NaN; P_amp(P_amp==0) = NaN;



figure
subplot(231)
hist(R_dur,50)
legend([num2str(max(sum(R_dur<0) , sum(R_dur>0))/0.31) '% mice with R same way'])
vline(0)
title('Duration'), ylabel('R')
subplot(234)
hist(P_dur,50)
legend([num2str((sum(P_dur<.05)/31)*100) '% mice significative'])
vline(.05), ylabel('P')

subplot(232)
hist(R_freq,50)
legend([num2str(max(sum(R_freq<0) , sum(R_freq>0))/0.31) '% mice with R same way'])
vline(0)
title('Frequency')
subplot(235)
hist(P_freq,50)
legend([num2str((sum(P_freq<.05)/31)*100) '% mice significative'])
vline(.05)

subplot(233)
hist(R_amp,50)
legend([num2str(max(sum(R_amp<0) , sum(R_amp>0))/0.31) '% mice with R same way'])
vline(0)
title('Amplitude')
subplot(236)
hist(P_amp,50)
legend([num2str((sum(P_amp<.05)/31)*100) '% mice significative'])
vline(.05)

a=suptitle('Influence of respiratory rate on ripples features during freezing'); a.FontSize=15;


% best examples
figure
mouse=21;
subplot(121)
D1=Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse});
D2=RipDataFz.(Session_type{1}).(Mouse_names{mouse})(:,5)';
PlotCorrelations_BM(D1 , D2)
axis square
xlabel('Respiratory rate (Hz)'), ylabel('Ripples frequency (Hz)')
title('Frequency')

mouse=42;
subplot(122)
D1=Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse});
D2=RipDataFz.(Session_type{1}).(Mouse_names{mouse})(:,6)';
PlotCorrelations_BM(D1 , D2)
axis square
xlabel('Respiratory rate (Hz)'), ylabel('Ripples amplitude (a.u.)')
title('Amplitude')

a=suptitle('Influence of respiratory rate on ripples features during freezing'); a.FontSize=15;


% hist2d to sum up mice
for mouse=1:50
    try
        D1=Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse});
        D2=RipDataFz.(Session_type{1}).(Mouse_names{mouse})(:,4); D2(D2>80)=NaN;
        Duration_Respi_Corr.(Session_type{1})(mouse,:,:) = hist2d([D1 ; 1 ; 1 ; 7 ; 7] , [D2 ; 20 ; 80 ; 20 ; 80] , 30 , 30);
        Duration_Respi_Corr.(Session_type{1})(mouse,:,:) = Duration_Respi_Corr.(Session_type{1})(mouse,:,:)./nansum(nansum(Duration_Respi_Corr.(Session_type{1})(mouse,:,:)));
        
        D1=Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse});
        D2=RipDataFz.(Session_type{1}).(Mouse_names{mouse})(:,5);  D2(or(D2<150 , D2>220))=NaN;
        Freq_Respi_Corr.(Session_type{1})(mouse,:,:) = hist2d([D1 ; 1 ; 1 ; 7 ; 7] , [D2 ; 150 ; 220 ; 150 ; 220] , 30 , 30);
        Freq_Respi_Corr.(Session_type{1})(mouse,:,:) = Freq_Respi_Corr.(Session_type{1})(mouse,:,:)/nansum(nansum(Freq_Respi_Corr.(Session_type{1})(mouse,:,:)));
        
        D1=Data_Respi_RipTimes.(Session_type{1}).(Mouse_names{mouse});
        D2=RipDataFz.(Session_type{1}).(Mouse_names{mouse})(:,6);
        Amplitude_Respi_Corr.(Session_type{1})(mouse,:,:) = hist2d([D1 ; 1 ; 1 ; 7 ; 7] , [D2 ; 600 ; 2500 ; 600 ; 2500] , 30 , 30);
        Amplitude_Respi_Corr.(Session_type{1})(mouse,:,:) = Amplitude_Respi_Corr.(Session_type{1})(mouse,:,:)/nansum(nansum(Amplitude_Respi_Corr.(Session_type{1})(mouse,:,:)));
    end
end

figure
subplot(131)
contourf(linspace(1,7,30) , linspace(20,80,30) , SmoothDec(squeeze(nanmean(Duration_Respi_Corr.(Session_type{1})(P_dur<.05,:,:)))',.7)), axis xy
xlabel('Respiratory rate (Hz)'), ylabel('Ripples duration (ms)')
title('Duration')

subplot(132)
contourf(linspace(1,7,30) , linspace(150,220,30) , SmoothDec(squeeze(nanmean(Freq_Respi_Corr.(Session_type{1}))),.7)), axis xy
xlabel('Respiratory rate (Hz)'), ylabel('Ripples frequency (Hz)')
title('Frequency')

subplot(133)
contourf(linspace(1,7,30) , linspace(600,2500,30) , SmoothDec(squeeze(nanmean(Amplitude_Respi_Corr.(Session_type{1}))),.7)), axis xy
xlabel('Respiratory rate (Hz)'), ylabel('Ripples amplitude (a.u.)')
title('Amplitude')

a=suptitle('Influence of respiratory rate on ripples features during freezing'); a.FontSize=15;


figure
contourf(linspace(1,7,30) , linspace(600,2500,30) , SmoothDec(squeeze(nanmean(Amplitude_Respi_Corr.(Session_type{1})(P_amp<.05,:,:))),.7)), axis xy

