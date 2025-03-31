%% Aims of this code
% Compare the two measures (PT and Spectro) on OB data from mice that went
% through the U-Maze and then compare the correlation of these measures to
% the goodness of the fit

Mouse_ALL=[688 739 777 849 893 1171 9184 1189 1391 1392 1394];

%% Extract data for all mice
Session_type={'Cond'};% sessions can be added
for sess=1:length(Session_type)
    [ALL_TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) ,NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',[688 739 777 849 893 1171 9184 1189 1391 1392 1394],lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition', 'instfreq');
end

%% 1/ Compare the breathing computed with the two methods 
%% Frequency generated instantaneously with the signal 

% Compute OB frequency and ripples during freezing shock
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,5});
    if isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,5});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}) == 0
        ALL.Inst.Ind_Ripples.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
    end
end

% Compute OB frequency and ripples during freezing safe
for mousenum=1:length(Mouse_ALL)
    ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    if isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Inst.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}) == 0
        ALL.Inst.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
    end
end


%% Frequency generated with the spectrogram (respi_freq_BM)

% Compute OB frequency and ripples during freezing shock
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5});
    if isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Spect.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Spect.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}) == 0
        ALL.Spect.Ind_Ripples.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
    end
end

% Compute OB frequency and ripples during freezing safe
for mousenum=1:length(Mouse_ALL)
    ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = Data(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1))
        ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(end))
        ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.Spect.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Spect.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.Spect.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6});
    if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}) == 0
        ALL.Spect.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
    end
end

%% Pre-processing for the comparison

% Compute restricted frequency from spectrogram to instantaneous (Shock)
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.RestSpect_toInst.Epoch.ShockFz.(ALL_Mouse_names{mousenum}) = Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,5}, ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,5});
    ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}) = Data(ALL.RestSpect_toInst.Epoch.ShockFz.(ALL_Mouse_names{mousenum}));
    if isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1))
        ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(end))
        ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.RestSpect_toInst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.RestSpect_toInst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Inst.Freq_Respi.ShockFz.(ALL_Mouse_names{mousenum}))));
    ALL.RestSpect_toInst.Ind_OB.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL.RestSpect_toInst.Epoch.ShockFz.(ALL_Mouse_names{mousenum}));
%     if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}) == 0
%         ALL.Spect.Ind_Ripples.ShockFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,5}); 
%     end
end

% Compute restricted frequency from spectrogram to instantaneous (Safe)
for mousenum=1:length(Mouse_ALL)
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    ALL.RestSpect_toInst.Epoch.SafeFz.(ALL_Mouse_names{mousenum}) = Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,6}, ALL_TSD_DATA.Cond.instfreq.tsd{mousenum,6});
    ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}) = Data(ALL.RestSpect_toInst.Epoch.SafeFz.(ALL_Mouse_names{mousenum}));
    if isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1))
        ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(1:find(~isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1)) = ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1));
    end
    if isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(end))
        ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'):end) = ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})(find(~isnan(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum})), 1, 'last'));
    end
    ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}) = runmean_BM(ALL.RestSpect_toInst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}),ceil(0.03*length(ALL.Inst.Freq_Respi.SafeFz.(ALL_Mouse_names{mousenum}))));
    ALL.RestSpect_toInst.Ind_OB.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL.RestSpect_toInst.Epoch.SafeFz.(ALL_Mouse_names{mousenum}));
%     if isempty(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}) == 0
%         ALL.Spect.Ind_Ripples.SafeFz.(ALL_Mouse_names{mousenum}) = Range(ALL_TSD_DATA.Cond.ripples.ts{mousenum,6}); 
%     end
end

%% Visualize the two signals

% Compare the signals inst and spect for all mice
fig=figure;
colors = [0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_ALL)
    mouse=ALL_Mouse_names(mousenum);
    subplot(4,3,mousenum)
    plot((1:length(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2, ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(2,:)), hold on
    plot((1:length(ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum})))*0.2, ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}),'Color',colors(1,:)), hold on
    ylim([0.5 7])
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Time freezing (s)', 'FontSize', 25);
title(han,'Spect (blue) vs Inst (green) frequencies during safe side freezing', 'FontSize', 25);

% Plot instantaneous data vs restricted spectrogram data

% For all mice
fig=figure;
for mousenum=1:8
    mouse=ALL_Mouse_names(mousenum);
    subplot(2,4,mousenum)
    square=[2.5 7.5];
    plot(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), '.k')
    axis square
    line(square,square,'LineStyle','--','Color','r','LineWidth',4)
    xlim(square), ylim(square)
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Instantaneous measured frequecies', 'FontSize', 25);
xlabel(han,'Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)', 'FontSize', 25);
title(han,'Correlation between Inst and Spect measured frequencies', 'FontSize', 30);

fig=figure;
for mousenum=8:15
    mouse=ALL_Mouse_names(mousenum);
    subplot(2,4,mousenum-7)
    square=[2.5 7.5];
    plot(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), '.k')
    axis square
    line(square,square,'LineStyle','--','Color','r','LineWidth',4)
    xlim(square), ylim(square)
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Instantaneous measured frequecies', 'FontSize', 25);
xlabel(han,'Spectrogram measured frequencies restricted to instantaneous measured timepoints (Hz)', 'FontSize', 25);
title(han,'Correlation between Inst and Spect measured frequencies', 'FontSize', 30);

%% Compare the two signals

for mousenum=1:length(Mouse_ALL)
    clear aa bb
    ALL_Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    aa = corrcoef(ALL.RestSpect_toInst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}), ALL.Inst.RunMeanFq.SafeFz.(ALL_Mouse_names{mousenum}));
    bb = corrcoef(ALL.RestSpect_toInst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}), ALL.Inst.RunMeanFq.ShockFz.(ALL_Mouse_names{mousenum}));
    CorrMethod.SafeFz(mousenum) =  aa(1,2);
    CorrMethod.ShockFz(mousenum) = bb(1,2);
end

%% 2/ To the quality of the fit 

% Fit the model Fit10
for mousenum=1:length(Mouse_ALL)
    Mouse_names{mousenum}=['M' num2str(Mouse_ALL(mousenum))];
    clear ep ind_to_use Sta Sto
    i=1;
    Sta = Start(Epoch1.Cond{mousenum, 3});
    Sto = Stop(Epoch1.Cond{mousenum, 3});
    
    for ep=1:length(Start(Epoch1.Cond{mousenum, 3}))
       ShockTime_Fz_Distance_pre.(Mouse_names{mousenum}) = Start(Epoch1.Cond{mousenum, 2})-Start(subset(Epoch1.Cond{mousenum, 3},ep));

       ShockTime_Fz_Distance.(Mouse_names{mousenum}) = abs(max(ShockTime_Fz_Distance_pre.(Mouse_names{mousenum})(ShockTime_Fz_Distance_pre.(Mouse_names{mousenum})<0))/1e4);
       if isempty(ShockTime_Fz_Distance.(Mouse_names{mousenum})); ShockTime_Fz_Distance.(Mouse_names{mousenum})=NaN; end

       for bin=1:ceil((sum(Stop(subset(Epoch1.Cond{mousenum, 3},ep))-Start(subset(Epoch1.Cond{mousenum, 3},ep)))/1e4)/2)-1 % bin of 2s or less
           SmallEpoch.(Mouse_names{mousenum}) = intervalSet(Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(bin-1)*1e4 , Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(bin)*1e4);
           PositionArray.(Mouse_names{mousenum})(i) = nanmedian(Data(Restrict(ALL_TSD_DATA.Cond.linearposition.tsd{mousenum, 1}, SmallEpoch.(Mouse_names{mousenum}))));
           OB_FrequencyArray.(Mouse_names{mousenum})(i) = nanmedian(Data(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum, 1}, SmallEpoch.(Mouse_names{mousenum})))); 
           try RipplesDensityArray.(Mouse_names{mousenum})(i) = sum(length(Data(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum, 1}, SmallEpoch.(Mouse_names{mousenum}))))); end
           GlobalTimeArray.(Mouse_names{mousenum})(i) = Start(subset(Epoch1.Cond{mousenum, 3},ep))/1e4+2*(bin-1);       
           TimeSinceLastShockArray.(Mouse_names{mousenum})(i) = ShockTime_Fz_Distance.(Mouse_names{mousenum})+2*(bin-1);       
           TimepentFreezing.(Mouse_names{mousenum})(i) = 2*(bin-1);
           i=i+1;
       end
       
       ind_to_use = ceil((sum(Stop(subset(Epoch1.Cond{mousenum, 3},ep))-Start(subset(Epoch1.Cond{mousenum, 3},ep)))/1e4)/2)-1; % second to last freezing episode indice

       SmallEpoch.(Mouse_names{mousenum}) = intervalSet(Start(subset(Epoch1.Cond{mousenum, 3},ep))+2*(ind_to_use)*1e4 , Stop(subset(Epoch1.Cond{mousenum, 3},ep))); % last small epoch is a bin with time < 2s
       PositionArray.(Mouse_names{mousenum})(i) = nanmedian(Data(Restrict(ALL_TSD_DATA.Cond.linearposition.tsd{mousenum, 1} , SmallEpoch.(Mouse_names{mousenum}))));
       OB_FrequencyArray.(Mouse_names{mousenum})(i) = nanmedian(Data(Restrict(ALL_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum, 1} , SmallEpoch.(Mouse_names{mousenum}))));
       try RipplesDensityArray.(Mouse_names{mousenum})(i) = sum(length(Data(Restrict(ALL_TSD_DATA.Cond.ripples.ts{mousenum, 1}, SmallEpoch.(Mouse_names{mousenum}))))); end
       GlobalTimeArray.(Mouse_names{mousenum})(i) = Start(subset(Epoch1.Cond{mousenum, 3},ep))/1e4+2*(ind_to_use);
       TimeSinceLastShockArray.(Mouse_names{mousenum})(i) = ShockTime_Fz_Distance.(Mouse_names{mousenum})+2*(ind_to_use);
       try TimepentFreezing.(Mouse_names{mousenum})(i) = 2*bin; catch; TimepentFreezing.(Mouse_names{mousenum})(i) = 0; end

      % shock entries & stim number
      % Between freezing epoch
      if ep==1
          BetweenEpoch = intervalSet(0 , Sta(ep));
      else
          BetweenEpoch = intervalSet(Sto(ep-1) , Sta(ep));
      end
      
      % Shock zone entries
      ShockZoneEpoch.(Mouse_names{mousenum}) = and(Epoch1.Cond{mousenum, 7} , BetweenEpoch); 
      
      clear StaShock StoShock
      StaShock = Start(ShockZoneEpoch.(Mouse_names{mousenum})); 
      StoShock = Stop(ShockZoneEpoch.(Mouse_names{mousenum}));
      
      try % zone epoch only considered if longer than 1s and merge with 1s
          clear ind_to_use_shock; ind_to_use_shock = StoShock(1:end-1)==StaShock(2:end);
          StaShock=StaShock([true ; ~ind_to_use_shock]);
          StoShock=StoShock([~ind_to_use_shock ; true]);
          ShockZoneEpoch_Corrected.(Mouse_names{mousenum})=intervalSet(StaShock , StoShock);
          ShockZoneEpoch_Corrected.(Mouse_names{mousenum})=dropShortIntervals(ShockZoneEpoch_Corrected.(Mouse_names{mousenum}),1e4);
          ShockZoneEpoch_Corrected.(Mouse_names{mousenum})=mergeCloseIntervals(ShockZoneEpoch_Corrected.(Mouse_names{mousenum}),1e4);
      catch
          ShockZoneEpoch_Corrected.(Mouse_names{mousenum}) = intervalSet([],[]);
      end
      ShockZoneEntries.(Mouse_names{mousenum}) = length(Start(ShockZoneEpoch_Corrected.(Mouse_names{mousenum})));
      if ShockZoneEntries.(Mouse_names{mousenum})==0; ShockZoneEntries.(Mouse_names{mousenum})=-1; end
      if ep==1
          ShockZoneEntriesArray.(Mouse_names{mousenum})(1) = ShockZoneEntries.(Mouse_names{mousenum});
      else
          ShockZoneEntriesArray.(Mouse_names{mousenum})(ind_start(ep-1)) = ShockZoneEntries.(Mouse_names{mousenum});
      end
      
      % Eyelid stims
      EyelidEpoch.(Mouse_names{mousenum}) = and(Epoch1.Cond{mousenum, 2} , BetweenEpoch); 
      EyelidNumber.(Mouse_names{mousenum}) = length(Start(EyelidEpoch.(Mouse_names{mousenum})));
      if EyelidNumber.(Mouse_names{mousenum})==0; EyelidNumber.(Mouse_names{mousenum})=-1; end
      if ep==1
          EyelidNumberArray.(Mouse_names{mousenum})(1) = EyelidNumber.(Mouse_names{mousenum});
      else
          EyelidNumberArray.(Mouse_names{mousenum})(ind_start(ep-1)) = EyelidNumber.(Mouse_names{mousenum});
      end
      
      i=i+1;
      ind_start(ep) = i;
      
    end
    
    ShockZoneEntriesArray.(Mouse_names{mousenum})(ShockZoneEntriesArray.(Mouse_names{mousenum})==0)=NaN;
    ShockZoneEntriesArray.(Mouse_names{mousenum})(ShockZoneEntriesArray.(Mouse_names{mousenum})==-1)=0;
    ShockZoneEntriesArray.(Mouse_names{mousenum}) = cumsum(ShockZoneEntriesArray.(Mouse_names{mousenum}),'omitnan');
    ShockZoneEntriesArray.(Mouse_names{mousenum})(length(ShockZoneEntriesArray.(Mouse_names{mousenum})):length(TimeSinceLastShockArray.(Mouse_names{mousenum}))) = ShockZoneEntriesArray.(Mouse_names{mousenum})(end);
    
    EyelidNumberArray.(Mouse_names{mousenum})(EyelidNumberArray.(Mouse_names{mousenum})==0)=NaN;
    EyelidNumberArray.(Mouse_names{mousenum})(EyelidNumberArray.(Mouse_names{mousenum})==-1)=0;
    EyelidNumberArray.(Mouse_names{mousenum}) = cumsum(EyelidNumberArray.(Mouse_names{mousenum}),'omitnan');
    EyelidNumberArray.(Mouse_names{mousenum})(length(EyelidNumberArray.(Mouse_names{mousenum})):length(TimeSinceLastShockArray.(Mouse_names{mousenum}))) = EyelidNumberArray.(Mouse_names{mousenum})(end);
    
    
    Timefreezing_cumul.(Mouse_names{mousenum})(1) = 0;
    for j=2:length(TimepentFreezing.(Mouse_names{mousenum}))
        if TimepentFreezing.(Mouse_names{mousenum})(j) == 0
           Timefreezing_cumul.(Mouse_names{mousenum})(j) = Timefreezing_cumul.(Mouse_names{mousenum})(j-1);
        else
           Timefreezing_cumul.(Mouse_names{mousenum})(j) = Timefreezing_cumul.(Mouse_names{mousenum})(j-1) + 2;
        end
    end

    try TotalArray_mouse.(Mouse_names{mousenum}) = [OB_FrequencyArray.(Mouse_names{mousenum})' PositionArray.(Mouse_names{mousenum})' GlobalTimeArray.(Mouse_names{mousenum})' TimeSinceLastShockArray.(Mouse_names{mousenum})' TimepentFreezing.(Mouse_names{mousenum})' Timefreezing_cumul.(Mouse_names{mousenum})' EyelidNumberArray.(Mouse_names{mousenum})' ShockZoneEntriesArray.(Mouse_names{mousenum})' RipplesDensityArray.(Mouse_names{mousenum})']; end
%     TotalArray_mouse.(Mouse_names{mousenum}) = [OB_FrequencyArray.(Mouse_names{mousenum})' PositionArray.(Mouse_names{mousenum})' GlobalTimeArray.(Mouse_names{mousenum})' TimeSinceLastShockArray.(Mouse_names{mousenum})' TimepentFreezing.(Mouse_names{mousenum})' Timefreezing_cumul.(Mouse_names{mousenum})' EyelidNumberArray.(Mouse_names{mousenum})' ShockZoneEntriesArray.(Mouse_names{mousenum})'];

end 

Best_Fitted_variables.INT10.LearnSlope = [0.0090 1.0000e-03 0.0025 1.0000e-03 0.0065 0.0100 0.0045 0.0020 1.0000e-03 0.0045 0.0100];
Best_Fitted_variables.INT10.LearnPoint = [0.9000 0.5000 0.7000 0.6000 0.8000 0.4000 0.1000 0.4000 0.9000 0.9000 0.5000];

Fit10varNames = {'PositionArray', 'TimeSinceLastShockArray', 'CumulTimeFreezing', 'SigPositionxTimeSinceLastShock', 'SigPositionxFit10SigGlocalTime', 'OB_FrequencyArray'};
for mousenum=1:length(Mouse_ALL)
    AllTpsLearnGT = max(GlobalTimeArray.(Mouse_names{mousenum}));
    SigPositionArray.(Mouse_names{mousenum}) = 1./(1+exp(-20*([PositionArray.(Mouse_names{mousenum})]-0.5)));
    Fit10SigGlobalTimeArray.(Mouse_names{mousenum}) = 1./(1+exp(-Best_Fitted_variables.INT10.LearnSlope(mousenum)*([GlobalTimeArray.(Mouse_names{mousenum})]-(AllTpsLearnGT*Best_Fitted_variables.INT10.LearnPoint(mousenum)))));
    Fit10_GLMArray_mouse.(Mouse_names{mousenum}) = table( PositionArray.(Mouse_names{mousenum})', ...
        TimeSinceLastShockArray.(Mouse_names{mousenum})', Timefreezing_cumul.(Mouse_names{mousenum})',...
        (SigPositionArray.(Mouse_names{mousenum})').*(TimeSinceLastShockArray.(Mouse_names{mousenum})'), ...
        (SigPositionArray.(Mouse_names{mousenum})').*(Fit10SigGlobalTimeArray.(Mouse_names{mousenum})'), ...
        OB_FrequencyArray.(Mouse_names{mousenum})', 'VariableNames',Fit10varNames);
%     Fit10_GLMArray_mouse.(Mouse_names{mousenum}) = rmmissing(Fit10_GLMArray_mouse.(Mouse_names{mousenum}));
end 

% Cross-validation on the episodes

% Create train and test arrays
for mousenum=1:length(Mouse_ALL)
    Index_fzepisodes.(Mouse_names{mousenum}) = find(TimepentFreezing.(Mouse_names{mousenum})==0);
    Length_fzepisodes.(Mouse_names{mousenum}) = diff(Index_fzepisodes.(Mouse_names{mousenum}));
    Length_fzepisodes.(Mouse_names{mousenum})(end+1) = length(TimepentFreezing.(Mouse_names{mousenum}))-Index_fzepisodes.(Mouse_names{mousenum})(end)+1;
    IndLength_fzepisodes.(Mouse_names{mousenum}).array(:,1) = Index_fzepisodes.(Mouse_names{mousenum});
    IndLength_fzepisodes.(Mouse_names{mousenum}).array(:,2) = Length_fzepisodes.(Mouse_names{mousenum});
    Random_permutation_fzep.(Mouse_names{mousenum}) = randperm(length(IndLength_fzepisodes.(Mouse_names{mousenum}).array(:,1)));
end

for mousenum=1:length(Mouse_ALL)
    
    indset = 1;
    for j=1:length(Random_permutation_fzep.(Mouse_names{mousenum}))
        
        clear ind_picked_episode picked_episode_start picked_episode_length
        ind_picked_episode = Random_permutation_fzep.(Mouse_names{mousenum})(j);
        picked_episode_start = IndLength_fzepisodes.(Mouse_names{mousenum}).array(ind_picked_episode,1);
        picked_episode_length = IndLength_fzepisodes.(Mouse_names{mousenum}).array(ind_picked_episode,2);
        
        Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table(1,:) = table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum})(picked_episode_start,:));
        for i=1:picked_episode_length-1
            Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table(i+1,:) = table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum})(picked_episode_start+i,:));
        end
        Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table = array2table(Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table, 'VariableNames',Fit10varNames);
        Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table = rmmissing(Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table);
        
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum}));
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(picked_episode_start:picked_episode_start+picked_episode_length-1,:) = [];
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = array2table(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table, 'VariableNames',Fit10varNames);
        Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = rmmissing(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table);

        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = table2array(Fit10_GLMArray_mouse.(Mouse_names{mousenum}));
        for i=1:length(Index_fzepisodes.(Mouse_names{mousenum}))-1
            clear ind_episode episode_length
            ind_episode = Index_fzepisodes.(Mouse_names{mousenum})(i);
            episode_length = Length_fzepisodes.(Mouse_names{mousenum})(i);
            Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(ind_episode:ind_episode+episode_length-1,6) = nanmean(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(ind_episode:ind_episode+episode_length-1,6));
        end
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(picked_episode_start:picked_episode_start+picked_episode_length-1,:) = [];
        
        indices_final = ismember(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(:,5), table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(:,5)));
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table(indices_final,:);
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = array2table(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table, 'VariableNames',Fit10varNames);
        Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = rmmissing(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table);
        
        indset = indset + 1;
    end
    
end

% Run GLMs

% INT10
for mousenum=1:length(Mouse_ALL)
    indset=1;
    for i=1:size(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset,2)
        Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = fitglm(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(indset).table,...
            'linear','ResponseVar','OB_FrequencyArray','Distribution', 'gamma', 'link', 'reciprocal');
        Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table;
        Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table.Rsquared.Deviance;
        Deviance.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table.Deviance;
        LR.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table.LogLikelihood;
        Table_estimates_pval.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table = Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table.Coefficients;
        
        Array_Test_frequencies.Fit10.(Mouse_names{mousenum}).Testset(indset).Value = table2array(Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table(:,6));
        [Test_mdl.Fit10.(Mouse_names{mousenum}).Testset(indset).Value, Test_mdl.Fit10.(Mouse_names{mousenum}).Testset(indset).CI] = predict(Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(indset).table, Array_Test.Fit10.(Mouse_names{mousenum}).Testset(indset).table);
        indset=indset+1;
    end
end

% Evaluate models and GOFs on train
for mousenum=1:length(Mouse_ALL)
    indset=1;
    Array_Test_corr.Fit10.(Mouse_names{mousenum}) = [];
    Array_Predict_corr.Fit10.(Mouse_names{mousenum}) = [];
    for i=1:size(Array_Test.Fit10.(Mouse_names{mousenum}).Testset,2)
        Array_Test_corr.Fit10.(Mouse_names{mousenum}) = [Array_Test_corr.Fit10.(Mouse_names{mousenum}), Array_Test_frequencies.Fit10.(Mouse_names{mousenum}).Testset(indset).Value'];
        Array_Predict_corr.Fit10.(Mouse_names{mousenum}) = [Array_Predict_corr.Fit10.(Mouse_names{mousenum}), Test_mdl.Fit10.(Mouse_names{mousenum}).Testset(indset).Value'];
    indset=indset+1;
    end
end

% Compute R2 
for mousenum=1:length(Mouse_ALL)
    clear aa bb
    Mean_Rsquared_deviance_Train_Fit10(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit10(mousenum)=struct2array(Rsquared.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1));
    aa = corrcoef(table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)), table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)));
    bb = corrcoef(Array_Test_corr.Fit10.(Mouse_names{mousenum}), Array_Predict_corr.Fit10.(Mouse_names{mousenum}));
    Corr_coef.Fit10.Train(mousenum) = aa(1,2);
    Corr_coef.Fit10.Test(mousenum) = bb(1,2);
end

%% Compare the corr bet methods and the corr of the fit

Corr_final.SafeFz = corrcoef(Corr_coef.Fit10.Train, CorrMethod.SafeFz);
Corr_final.ShockFz = corrcoef(Corr_coef.Fit10.Train, CorrMethod.ShockFz);

figure
plot(Corr_coef.Fit10.Train, CorrMethod.SafeFz, '*'), hold on
plot(Corr_coef.Fit10.Train, CorrMethod.ShockFz, '*'), hold on
xlim([-0.1 1]);
ylim([-0.1 1]);
xlabel('Corr(Train, Fitted values)', 'FontSize', 25);
ylabel('Corr(Spectro, PT)', 'FontSize', 25);
makepretty

