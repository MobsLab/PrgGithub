

GetAllSalineSessions_BM
Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(11);

% generate all data required for analyses    
for sess=1:length(Session_type)
    [OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM(...
        'all_saline',Mouse,'cond','respi_freq_bm');
end
% or load
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')


% generate variables from data
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    clear R
    TotTime.(Mouse_names{mouse}) = max(Range(OutPutData.Cond.respi_freq_bm.tsd{mouse,1}))/1e4;
    TotEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(OutPutData.Cond.respi_freq_bm.tsd{mouse,1})));
    Blocked_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
    UnblockedEpoch.(Mouse_names{mouse}) = TotEpoch.(Mouse_names{mouse})-Blocked_Epoch.(Mouse_names{mouse});
    FreezeEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep_withnoise');
    ActiveEpoch.(Mouse_names{mouse}) = TotEpoch.(Mouse_names{mouse}) - FreezeEpoch.(Mouse_names{mouse});
    Active_Unblocked.(Mouse_names{mouse}) = and(ActiveEpoch.(Mouse_names{mouse}) , UnblockedEpoch.(Mouse_names{mouse}));
    
    Speed.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'speed');
    chan_numb = Get_chan_numb_BM(CondSess.(Mouse_names{mouse}){1} , 'bulb_deep');
    LFP.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
    R = Range(Restrict(LFP.(Mouse_names{mouse}) , UnblockedEpoch.(Mouse_names{mouse})))/1e4;
    R = R(1:2500:end);
%     R = R(1:1250:end);
    
    ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch_behav');
    
    % RA
    RA.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'risk_assessment') ;
    RA_time.(Mouse_names{mouse}) = Start(RA.(Mouse_names{mouse}))/1e4;
    
    % middle zone entries
    Assess_Zones.(Mouse_names{mouse}) = or(ZoneEpoch.(Mouse_names{mouse}){3} , ZoneEpoch.(Mouse_names{mouse}){4});
    Assess_Zones.(Mouse_names{mouse}) = mergeCloseIntervals(Assess_Zones.(Mouse_names{mouse}) , 1e4);
    Assess_Times.(Mouse_names{mouse}) = Start(Assess_Zones.(Mouse_names{mouse}))/1e4;
    
    % shock zone entries
    ShockZoneEpoch.(Mouse_names{mouse}) = and(ZoneEpoch.(Mouse_names{mouse}){1} , Active_Unblocked.(Mouse_names{mouse}));
    SafeZoneEpoch.(Mouse_names{mouse}) = and(or(ZoneEpoch.(Mouse_names{mouse}){2} , ZoneEpoch.(Mouse_names{mouse}){5}) , Active_Unblocked.(Mouse_names{mouse}));
    
    [ShockZoneEpoch_Corrected.(Mouse_names{mouse}) , SafeZoneEpoch_Corrected.(Mouse_names{mouse})] =...
        Correct_ZoneEntries_Maze_BM(ShockZoneEpoch.(Mouse_names{mouse}) , SafeZoneEpoch.(Mouse_names{mouse}));
    
    ShockZoneEntriesTime.(Mouse_names{mouse}) = Start(ShockZoneEpoch_Corrected.(Mouse_names{mouse}))/1e4;
    ShockZoneEntriesTimeNorm.(Mouse_names{mouse}) = ShockZoneEntriesTime.(Mouse_names{mouse})./TotTime.(Mouse_names{mouse});
    
    % eyelid shocks
    EyelidEpoch.(Mouse_names{mouse}) = Epoch1.Cond{mouse, 2};
    EyelidEpoch_unb.(Mouse_names{mouse}) = and(EyelidEpoch.(Mouse_names{mouse}) , UnblockedEpoch.(Mouse_names{mouse}));
    
    EyelidTimes.(Mouse_names{mouse}) = Start(EyelidEpoch_unb.(Mouse_names{mouse}))/1e4;
    EyelidTimesNorm.(Mouse_names{mouse}) = EyelidTimes.(Mouse_names{mouse})./TotTime.(Mouse_names{mouse});
    
    TotTimeRounded.(Mouse_names{mouse}) = round(TotTime.(Mouse_names{mouse}));
    for time=1:length(R)
        AssessNumber.(Mouse_names{mouse})(time) = sum(Assess_Times.(Mouse_names{mouse})<R(time));
        SZEntriesNumber.(Mouse_names{mouse})(time) = sum(ShockZoneEntriesTime.(Mouse_names{mouse})<R(time));
        EyelidNumber.(Mouse_names{mouse})(time) = sum(EyelidTimes.(Mouse_names{mouse})<R(time));
        try, RA_Number.(Mouse_names{mouse})(time) = sum(RA_time.(Mouse_names{mouse})<R(time)); end
        if time>1, SmallEp = intervalSet(R(time-1) , R(time-1)+2e4); else, SmallEp = intervalSet(0 , R(time-1)+2e4); end
        Respi_Safe.(Mouse_names{mouse})(time) = nanmean(Data(Restrict(OutPutData.Cond.respi_freq_bm.tsd{mouse,6} , SmallEp)));
    end
    disp(Mouse_names{mouse})
end


for mouse=1:length(Mouse)
    %     Learn_Rate{mouse} = SZEntriesNumber.(Mouse_names{mouse})./EyelidNumber.(Mouse_names{mouse});
    %     Learn_Rate{mouse}(Learn_Rate{mouse}==Inf) = 0;
    %     Learn_Rate2{mouse} = SZEntriesNumber.(Mouse_names{mouse})-EyelidNumber.(Mouse_names{mouse});
    
    clear D D2
    D = AssessNumber.(Mouse_names{mouse});
    bin = 25;
    for i=1:ceil(length(D)/bin)-1
        D2(i) = nanmean(D((i-1)*bin+1:i*bin));
    end
%     AssessNumber_der{mouse} = runmean(diff(D2),10);
    AssessNumber_der{mouse} = diff(D2);
    AssessNumber_interp(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
    AssessNumber_all(mouse,1:length(D)) = D;
    AssessNumber_der_interp(mouse,:) = interp1(linspace(0,1,length(AssessNumber_der{mouse})) , AssessNumber_der{mouse} , linspace(0,1,100));
    
    clear D D2
    D = SZEntriesNumber.(Mouse_names{mouse});
    for i=1:ceil(length(D)/bin)-1
        D2(i) = nanmean(D((i-1)*bin+1:i*bin));
    end
%     SZEntriesNumber_der{mouse} = runmean(diff(D2),10);
    SZEntriesNumber_der{mouse} = diff(D2);
    SZEntriesNumber_interp(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
    SZEntriesNumber_all(mouse,1:length(D)) = D;
    SZEntriesNumber_der_interp(mouse,:) = interp1(linspace(0,1,length(SZEntriesNumber_der{mouse})) , SZEntriesNumber_der{mouse} , linspace(0,1,100));
    
    clear D D2
    D = EyelidNumber.(Mouse_names{mouse});
    for i=1:ceil(length(D)/bin)-1
        D2(i) = nanmean(D((i-1)*bin+1:i*bin));
    end
%     EyelidNumber_der{mouse} = runmean(diff(D2),10);
    EyelidNumber_der{mouse} = diff(D2);
    EyelidNumber_interp(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
    EyelidNumber_all(mouse,1:length(D)) = D;
    EyelidNumber_der_interp(mouse,:) = interp1(linspace(0,1,length(EyelidNumber_der{mouse})) , EyelidNumber_der{mouse} , linspace(0,1,100));

    clear D D2
    D = Respi_Safe.(Mouse_names{mouse});
    for i=1:ceil(length(D)/bin)-1
        D2(i) = nanmean(D((i-1)*bin+1:i*bin));
    end
%     EyelidNumber_der{mouse} = runmean(diff(D2),10);
    Respi_Safe_der{mouse} = D2;
end


%% figures
figure
Data_to_use = AssessNumber_interp./AssessNumber_interp(:,100);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;

Data_to_use = SZEntriesNumber_interp./SZEntriesNumber_interp(:,100);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-m',1); hold on;

Data_to_use = EyelidNumber_interp./EyelidNumber_interp(:,100);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;





for mouse=1:length(Mouse)
    DATA(1,1:length(AssessNumber_der{mouse}),mouse) = AssessNumber_der{mouse};
    DATA(1,length(AssessNumber_der{mouse})+1:80,mouse) = NaN;
    DATA(2,1:length(SZEntriesNumber_der{mouse}),mouse) = SZEntriesNumber_der{mouse};
    DATA(2,length(SZEntriesNumber_der{mouse})+1:80,mouse) = NaN;
    DATA(3,1:length(EyelidNumber_der{mouse}),mouse) = EyelidNumber_der{mouse};
    DATA(3,length(EyelidNumber_der{mouse})+1:80,mouse) = NaN;
    DATA(4,1:length(Respi_Safe_der{mouse}),mouse) = Respi_Safe_der{mouse};
    DATA(4,length(Respi_Safe_der{mouse})+1:80,mouse) = NaN;
end




figure
subplot(131)
Data_to_use = squeeze(DATA(3,1:50,:))'*(6/5);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([50:50:50*50]/60 , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
xlabel('time (min)'), ylabel('shocks (#/min)')
xlim([0 42]), box off, ylim([0 2])

subplot(132)
Data_to_use = squeeze(DATA(2,1:50,:))'*(6/5);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([50:50:50*50]/60 , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
xlabel('time (min)'), ylabel('SZ entries (#/min)')
xlim([0 42]), box off, ylim([0 2])

subplot(133)
Data_to_use = squeeze(DATA(1,1:50,:))'*(6/5);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([50:50:50*50]/60 , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
xlabel('time (min)'), ylabel('Middle zone entries (#/min)')
xlim([0 42]), ylim([0 2]), box off



figure
Data_to_use = movmean(squeeze(DATA(3,1:50,:)),3,'omitnan')'*(6/5);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis left
shadedErrorBar([50:50:50*50]/60 , Mean_All_Sp , Conf_Inter ,'-b',1); hold on;
xlabel('time (min)'), ylabel('shocks (#/min)')
xlim([0 42]), box off, ylim([0 1.4])

Data_to_use = movmean(squeeze(DATA(4,1:50,:)),3,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
yyaxis right
shadedErrorBar([50:50:50*50]/60 , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
xlabel('time (min)'), ylabel('Breathing (Hz)')
ylim([2.8 4.7])







%% old
figure, i=1;
for mouse=1:45
    subplot(4,5,i)
    plot(AssessNumber.(Mouse_names{mouse}))
    hold on
    plot(SZEntriesNumber.(Mouse_names{mouse}))
    plot(EyelidNumber.(Mouse_names{mouse}))
    plot(RA_Number.(Mouse_names{mouse}))
    title(Mouse_names{mouse})
    ylim([0 100]), xlim([0 3.5e3])
    if mouse<38; line([3.39e3 3.39e3],[1 1e2],'LineStyle','--','Color','r'); else; line([2.54e3 2.54e3],[1 1e2],'LineStyle','--','Color','r'); end
    if i==1; legend('Middle entries','Shock zone entries','Aversive stims'); end
    if mouse>45; xlabel('time (a.u.)'); end
    if sum(mouse==[31 36 41 46]); ylabel('# (log scale)'); end
%     set(gca , 'Yscale','log')
    makepretty
    
    i=i+1;
end

figure, i=1;
for mouse=1:length(Mouse)
    subplot(4,5,i)
    plot(AssessNumber_der{mouse})
    hold on
    plot(SZEntriesNumber_der{mouse})
    plot(EyelidNumber_der{mouse})
    title(Mouse_names{mouse})
    ylim([0 1.5]), xlim([0 70])
    if mouse>45; xlabel('time (a.u.)'); end
    if i==1; legend('Middle entries','Shock zone entries','Aversive stims'); end
    if mouse<38; line([134 134],[0 1.5],'LineStyle','--','Color','r'); else; line([100 100],[0 1.5],'LineStyle','--','Color','r'); end
    if sum(mouse==[31 36 41 46]); ylabel('diff (a.u.)'); end
    makepretty
    
    i=i+1;
end


for mouse=1:length(Mouse)
    TOT.(Mouse_names{mouse}) = [AssessNumber_der{mouse} ; SZEntriesNumber_der{mouse} ; EyelidNumber_der{mouse}];
    for bin=1:length(TOT.(Mouse_names{mouse}))
        % receive stims --> dumb
        if TOT.(Mouse_names{mouse})(3,bin)>.1
            Profile.(Mouse_names{mouse})(bin) = 4;
            % didn't receive stims and SZ entries --> brave
        elseif and(TOT.(Mouse_names{mouse})(3,bin)<.1 , TOT.(Mouse_names{mouse})(2,bin)>.2)
            Profile.(Mouse_names{mouse})(bin) = 3;
            % didn't receive stims and only goes to assess zone --> careful
        elseif and(TOT.(Mouse_names{mouse})(3,bin)<.1 , and(TOT.(Mouse_names{mouse})(2,bin)<.2 , TOT.(Mouse_names{mouse})(1,bin)>.2))
            Profile.(Mouse_names{mouse})(bin) = 2;
            % didn't receive stims stay safe zone --> fearful
        elseif and(TOT.(Mouse_names{mouse})(3,bin)<.1 , and(TOT.(Mouse_names{mouse})(2,bin)<.2 , TOT.(Mouse_names{mouse})(1,bin)<.2))
            Profile.(Mouse_names{mouse})(bin) = 1;
        end
    end
    [~,Profile_Fin.(Mouse_names{mouse})] = max([sum(Profile.(Mouse_names{mouse})==1) , sum(Profile.(Mouse_names{mouse})==2) sum(Profile.(Mouse_names{mouse})==3) sum(Profile.(Mouse_names{mouse})==4)]);
    Profile_all(mouse,:) = interp1(linspace(0,1,length(Profile.(Mouse_names{mouse}))) , runmean(Profile.(Mouse_names{mouse}),5) , linspace(0,1,100));
end


figure, i=1;
for mouse=31:length(Mouse)
    subplot(4,5,i)
    imagesc(runmean(Profile.(Mouse_names{mouse}),5))
    caxis ([1 4]), xlim([0 135])
    if i==1; a=colorbar; a.Ticks=1:4; a.TickLabels = {'fearful','careful','brave','dumb'}; end
    colormap jet
    title(Mouse_names{mouse})
    yticklabels({''}), if mouse>45; xlabel('time (a.u.)'); end

    i=i+1;
end


figure, i=1;
for mouse=1:length(Mouse)
    subplot(11,5,i)
%     imagesc(Profile.(Mouse_names{mouse}))
    imagesc(runmean(Profile.(Mouse_names{mouse}),5))
    caxis ([1 4]), xlim([0 135])
    if i==1; a=colorbar; a.Ticks=1:4; a.TickLabels = {'fearful','careful','brave','dumb'}; end
    colormap jet
    title(Mouse_names{mouse})
    yticklabels({''}), if mouse>45; xlabel('time (a.u.)'); end
    
    i=i+1;
end

figure, i=1;
for mouse=1:length(Mouse)
    subplot(11,5,i)
    imagesc(Profile_Fin.(Mouse_names{mouse}))
    if i==1; a=colorbar; a.Ticks=1:4; a.TickLabels = {'fearful','careful','brave','dumb'}; end
    caxis ([1 4])
    colormap jet
    title(Mouse_names{mouse})
    
    i=i+1;
end

for i=1:100; Var_Names{i}=''; end
[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(Profile_all , Mouse_names , Var_Names)

ind = 31:size(Profile_all,1); Data = Profile_all(ind,:);
figure
subplot(131)
imagesc(Data)
colormap redblue
axis xy
xticks(1:length(Var_Names)), xticklabels({''}), xlabel('time (a.u.)')%xticklabels(Var_Names), xtickangle(45)
yticks(1:length(Mouse_names)), yticklabels(Mouse_names(ind))
a=colorbar; a.Ticks=1:4; a.TickLabels = {'fearful','careful','brave','dumb'}
u=text(-30,6.55,'----------------------------------------------------'); u.FontSize=25;
u=text(-30,3.4,'SB'); u.FontSize=25; u=text(-30,15,'BM'); u.FontSize=25;
title('Parameters values by mouse')

[Data_corr1,p1] = corr(Data,'type','pearson');
[Data_corr2,p2] = corr(Data','type','pearson');

subplot(132)
imagesc(Data_corr1)
axis xy, axis square
xlabel('time (a.u.)'), ylabel('time (a.u.)')
title('Time correlation matrix')

subplot(133)
imagesc(Data_corr2)
axis xy, axis square
xticks([1:length(ind)]), yticks([1:length(ind)])
xticklabels(Mouse_names(ind)), yticklabels(Mouse_names(ind)), xtickangle(45)
u=vline(6.5,'-k'); u.LineWidth=4; u=hline(6.5,'-k'); u.LineWidth=4;
title('Mice correlation matrix')









%%

for mouse=1:length(Mouse)
    clear D D2
    D = Learn_Rate2{mouse};
    bin = 100;
    for i=1:ceil(length(D)/bin)-1
        D2(i) = nanmean(D((i-1)*bin+1:i*bin));
    end
    Learn_Rate2_der{mouse} = diff(D2);
end






figure
subplot(121)
for mouse=[31:37 50:52]
    plot(runmean_BM(Learn_Rate2{mouse},10))
    hold on
end

subplot(122)
for mouse=38:49
    plot(runmean_BM(Learn_Rate2{mouse},10))
    hold on
end


figure
subplot(121)
for mouse=[31:37]% 50:52]
    plot(runmean_BM(Learn_Rate2{mouse}-max(Learn_Rate2{mouse}),10))
    %     plot(runmean(Learn_Rate2{mouse},10))
    hold on
end

subplot(122)
for mouse=38:49
    plot(runmean_BM(Learn_Rate2{mouse}-max(Learn_Rate2{mouse}),10))
    hold on
end





figure
subplot(121)
for mouse=[31:37 50:52]
    plot(Learn_Rate2_der{mouse})
    hold on
end

subplot(122)
for mouse=38:49
    plot(Learn_Rate2_der{mouse})
    hold on
end


% this is the "finite difference" derivative. Note it is  one element shorter than y and x
yd = diff(y)./diff(x);
% this is to assign yd an abscissa midway between two subsequent x
xd = (x(2:end)+x(1:(end-1)))/2;
% this should be a rough plot of your derivative
plot(xd,yd)








figure
for mouse=48:50
    plot(runmean(Learn_Rate2{mouse},10)-max(runmean(Learn_Rate2{mouse},10)))
    hold on
end




figure
for mouse=31:50
    plot(runmean(Learn_Rate2{mouse},10))
    hold on
end







figure
for mouse=31:35
    plot(runmean_BM(Learn_Rate{mouse},10))
    hold on
end



