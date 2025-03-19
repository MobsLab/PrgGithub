
clear all
Session_type={'Cond','CondPre','CondPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};
Side={'All','Shock','Safe'}; Side_ind=[3 5 6];
GetEmbReactMiceFolderList_BM

for group=1
    Mouse=[11207,11251,11252,11253,11254];;
    for sess=1:3
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples','respi_freq_bm','ob_low');
    end
end

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Sessions_List_ForLoop_BM
        
        FreezeEpoch.All.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
        FreezeEpoch.Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.All.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1});
        FreezeEpoch.Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.All.(Session_type{sess}).(Mouse_names{mouse}) , or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5}));
    end
end


for side=1:length(Side)
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            for ep=1:length(Start(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))
                
                Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ep) = nanmean(Data(Restrict(OutPutData.SalineSB.(Session_type{sess}).respi_freq_bm.tsd{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) , ep))));
                try
                    Ripples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ep) = length(Range(Restrict(OutPutData.SalineSB.(Session_type{sess}).ripples.ts{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) , ep))));
                catch
                    Ripples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ep) = NaN;
                end
                
                OB_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}){ep} = Data(Restrict(OutPutData.SalineSB.(Session_type{sess}).ob_low.spectrogram{mouse,3} , subset(FreezeEpoch.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) , ep)));
                if size(OB_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}){ep},1)==1
                    OB_mean_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ep,:) = OB_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}){ep};
                else
                    OB_mean_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ep,:) = nanmean(OB_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}){ep});
                end
            end
            
            try
                clear ind
                ind = Ripples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})==1; % freezing episodes with ripples
                
                EpProp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = sum(ind);
                EpProp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = sum(~ind);
                
                OB_MeanSpec_FzEp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = OB_mean_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ind,:)./max(OB_mean_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ind,13:end)')';
                OB_MeanSpec_FzEp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = OB_mean_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(~ind,:)./max(OB_mean_spec.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(~ind,13:end)')';
                
                try; h=histogram(Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ind),'BinLimits',[1 8],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
                RespiDistrib_FzEp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values; end
                try; h=histogram(Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(~ind),'BinLimits',[1 8],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
                RespiDistrib_FzEp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values; end
            end
            
            try; EpProp_WithRipples_All.(Side{side}).(Session_type{sess})(mouse) = EpProp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}); end
            try; EpProp_WithoutRipples_All.(Side{side}).(Session_type{sess})(mouse) = EpProp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}); end
            
            try; RespiMean_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})(mouse) = nanmean(Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ind)); end
            try; RespiMean_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})(mouse) = nanmean(Respi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(~ind)); end
            
            try; RespiDistrib_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})(mouse,:) = runmean(RespiDistrib_FzEp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(RespiDistrib_FzEp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3); end
            try; RespiDistrib_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})(mouse,:) = runmean(RespiDistrib_FzEp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(RespiDistrib_FzEp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3); end
            
            try; if size(OB_MeanSpec_FzEp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),1)==1
                    OB_MeanSpec_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})(mouse,:) = OB_MeanSpec_FzEp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                else
                    OB_MeanSpec_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})(mouse,:) = nanmean(OB_MeanSpec_FzEp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}));
                end; end
            try; if size(OB_MeanSpec_FzEp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),1)==1
                    OB_MeanSpec_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})(mouse,:) = OB_MeanSpec_FzEp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                else
                    OB_MeanSpec_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})(mouse,:) = nanmean(OB_MeanSpec_FzEp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}));
                end; end
            
        end
        
        EpProp_WithRipples_All.(Side{side}).(Session_type{sess})(EpProp_WithRipples_All.(Side{side}).(Session_type{sess})==0) = NaN;
        EpProp_WithoutRipples_All.(Side{side}).(Session_type{sess})(EpProp_WithoutRipples_All.(Side{side}).(Session_type{sess})==0) = NaN;
        
        RespiMean_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})(RespiMean_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})==0) = NaN;
        RespiMean_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})(RespiMean_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})==0) = NaN;
       
        RespiDistrib_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})(RespiDistrib_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})==0) = NaN;
        RespiDistrib_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})(RespiDistrib_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})==0) = NaN;
        
        OB_MeanSpec_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})(OB_MeanSpec_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})==0) = NaN;
        OB_MeanSpec_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})(OB_MeanSpec_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})==0) = NaN;
    end
end


load('B_Low_Spectrum.mat')
for mouse=1:length(Mouse)
    figure
    for sess=1:3
        for side=1:3
            
            subplot(3,3,(sess-1)*3+side)
            
            try; plot(Spectro{3} , nanmean(OB_MeanSpec_FzEp_WithRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))); end
            hold on
            try; plot(Spectro{3} , nanmean(OB_MeanSpec_FzEp_WithoutRipples.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}))); end
            ylim([0 1])
            if sess==1; title(Side{side}); end
            if sess==3; xlabel('Frequency (Hz)'); end
            if side==1; ylabel('Power (a.u.)'); u=text(-5,.2,Session_type{sess},'FontSize',15,'FontWeight','bold'); set(u,'Rotation',90); end
            if and(sess==1 , side==1); legend('+ ripples','- ripples'); end
            xlim([0 10])
            makepretty
            
        end
    end
    a=sgtitle('OB mean spectrum, freezing episodes with and without ripples'); a.FontSize=20;
end


figure
for sess=1:3
    for side=1:3
        
        subplot(3,3,(sess-1)*3+side)
        
        Plot_MeanSpectrumForMice_BM(Spectro{3}.*OB_MeanSpec_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})  , 'color' , [0.4660, 0.6740, 0.1880]);
        Plot_MeanSpectrumForMice_BM(Spectro{3}.*OB_MeanSpec_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})  , 'color' , [0.6350, 0.0780, 0.1840]);
        
        ylim([0 1])
        if sess==1; title(Side{side}); end
        if sess==3; xlabel('Frequency (Hz)'); end
        if side==1; ylabel('Power (a.u.)'); u=text(-5,.2,Session_type{sess},'FontSize',15,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(sess==1 , side==1); f=get(gca,'Children'); legend([f(8),f(4)],'+ ripples','- ripples'); end
        xlim([0 10])
        makepretty
        
    end
end
a=sgtitle('OB mean spectrum, freezing episodes with and without ripples, cond sess, Saline SB, n=4'); a.FontSize=20;


figure
for sess=1:3
    for side=1:3
        
        subplot(3,3,(sess-1)*3+side)
        
        Conf_Inter=nanstd(RespiDistrib_FzEp_WithRipples_All.(Side{side}).(Session_type{sess}))/sqrt(size(RespiDistrib_FzEp_WithRipples_All.(Side{side}).(Session_type{sess}),1));
        h=shadedErrorBar(Spectro{3}(13:103),nanmean(RespiDistrib_FzEp_WithRipples_All.(Side{side}).(Session_type{sess})),Conf_Inter,'k',1); hold on;
        color=[0.4660, 0.6740, 0.1880]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
        hold on
        Conf_Inter=nanstd(RespiDistrib_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess}))/sqrt(size(RespiDistrib_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess}),1));
        h=shadedErrorBar(Spectro{3}(13:103),nanmean(RespiDistrib_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})),Conf_Inter,'k',1); hold on;
        color=[0.6350, 0.0780, 0.1840]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
                
%         ylim([0 1])
        if sess==1; title(Side{side}); end
        if sess==3; xlabel('Frequency (Hz)'); end
        if side==1; ylabel('Power (a.u.)'); u=text(-5,.2,Session_type{sess},'FontSize',15,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(sess==1 , side==1); f=get(gca,'Children'); legend([f(8),f(4)],'+ ripples','- ripples'); end
        xlim([0 10])
        makepretty
        
    end
end
a=sgtitle('OB mean spectrum, freezing episodes with and without ripples, cond sess, Saline SB, n=4'); a.FontSize=20;



figure
for sess=1:3
    for side=1:3
        
        subplot(3,3,(sess-1)*3+side)
        
        if sess==3
            MakeSpreadAndBoxPlot2_SB({RespiMean_FzEp_WithRipples_All.(Side{side}).(Session_type{sess}) RespiMean_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})},{[0.4660, 0.6740, 0.1880],[0.6350, 0.0780, 0.1840]},[1:2],{'+ ripples','- ripples'},'showpoints',0,'paired',1);
        else
            MakeSpreadAndBoxPlot2_SB({RespiMean_FzEp_WithRipples_All.(Side{side}).(Session_type{sess}) RespiMean_FzEp_WithoutRipples_All.(Side{side}).(Session_type{sess})},{[0.4660, 0.6740, 0.1880],[0.6350, 0.0780, 0.1840]},[1:2],{'',''},'showpoints',0,'paired',1);
        end
        
        if sess==1; title(Side{side}); end
        if side==1; ylabel('Frequency (Hz)'); u=text(-1,3.7,Session_type{sess},'FontSize',15,'FontWeight','bold'); set(u,'Rotation',90); end
        ylim([3 7])
        
    end
end
a=sgtitle('OB mean spectrum, freezing episodes with and without ripples, cond sess, Saline SB, n=4'); a.FontSize=20;


figure
for sess=1%:3
    for side=2:3
        
        subplot(1,3,(sess-1)*3+side-1)
        
        if sess==1
            MakeSpreadAndBoxPlot2_SB({EpProp_WithRipples_All.(Side{side}).(Session_type{sess}) EpProp_WithoutRipples_All.(Side{side}).(Session_type{sess})},{[0.466, 0.674, 0.188],[0.635, 0.078, 0.184]},[1:2],{'+ ripples','- ripples'},'showpoints',0,'paired',1);
        else
            MakeSpreadAndBoxPlot2_SB({EpProp_WithRipples_All.(Side{side}).(Session_type{sess}) EpProp_WithoutRipples_All.(Side{side}).(Session_type{sess})},{[0.466, 0.674, 0.188],[0.635, 0.078, 0.184]},[1:2],{'',''},'showpoints',0,'paired',1);
        end
        
        if sess==1; title(Side{side}); end
        if side==2; ylabel('Frequency (Hz)'); u=text(-1,3.7,Session_type{sess},'FontSize',15,'FontWeight','bold'); set(u,'Rotation',90); end
        %         ylim([3 7])
        
    end
    subplot(1,3,sess*3)
    if sess==1
        MakeSpreadAndBoxPlot2_SB({EpProp_WithRipples_All.(Side{2}).(Session_type{sess})./EpProp_WithoutRipples_All.(Side{2}).(Session_type{sess}) EpProp_WithRipples_All.(Side{3}).(Session_type{sess})./EpProp_WithoutRipples_All.(Side{3}).(Session_type{sess})},{[1 .5 .5],[.5 .5 1]},[1:2],{'shock','safe'},'showpoints',0,'paired',1);
    else
        MakeSpreadAndBoxPlot2_SB({EpProp_WithRipples_All.(Side{2}).(Session_type{sess})./EpProp_WithoutRipples_All.(Side{2}).(Session_type{sess}) EpProp_WithRipples_All.(Side{3}).(Session_type{sess})./EpProp_WithoutRipples_All.(Side{3}).(Session_type{sess})},{[1 .5 .5],[.5 .5 1]},[1:2],{'',''},'showpoints',0,'paired',1);
    end
    ylabel('proportion');
    if sess==1; title('Fz ep with ripples'); end
end
a=sgtitle('Freezing episodes with and without ripples, cond sess, Saline SB, n=4'); a.FontSize=15;






