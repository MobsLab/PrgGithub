

%% Where ripples occur during freezing episodes


Mouse=[739,777,849,1226,1227,1251,1253,1254,1189];
Session_type={'Cond','Ext','Fear','sleep_pre','sleep_post'};
Features={'Duration','Frequency','Amplitude'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples_all');
end

bin=20;
for sess=1:length(Session_type)
    if or(sess==4 , sess==5)
        NameEpoch{1}='Total'; NameEpoch{2}='Wake'; NameEpoch{3}='Sleep'; NameEpoch{4}='NREM'; NameEpoch{5}='REM'; NameEpoch{6}='N1'; NameEpoch{7}='N2'; NameEpoch{8}='N3'; Side=NameEpoch;
    else
        NameEpoch{1}='Total'; NameEpoch{2}='After_stim'; NameEpoch{3}='Freezing'; NameEpoch{4}='Active'; NameEpoch{5}='Freezing_shock'; NameEpoch{6}='Freezing_safe'; NameEpoch{7}='Active_shock'; NameEpoch{8}='Active_safe'; Side=NameEpoch;
    end
    
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side=1:length(Side)
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse,side}))
                
                try
                    Fz_Epoch = subset(Epoch1.(Session_type{sess}){mouse,side} , ep);
                    Ripples_during_Fz_Epoch = Restrict(TSD_DATA.(Session_type{sess}).ripples_all.tsd{mouse,side} , Fz_Epoch);
                    % start of all ripples time in this epoch, 2nd column of ripples array
                    Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ep,1:length(Ripples_during_Fz_Epoch)) = (Range(Ripples_during_Fz_Epoch) - Start(Fz_Epoch))/sum(Stop(Fz_Epoch)-Start(Fz_Epoch));
                    
                    clear Fz_Epoch Ripples_during_Fz_Epoch
                end
                
            end
            try
                Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})==0)=NaN;
                
                h=histogram(Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),'NumBins',bin);
                HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
            end
        end
    end
end


Drug_Group ={'Saline'};
for group=1
    
    Mouse=[739,777,849,1226,1227,1251,1253,1254,1189];
    
    for sess=1:length(Session_type) % generate all data required for analyses
    if or(sess==4 , sess==5)
        NameEpoch{1}='Total'; NameEpoch{2}='Wake'; NameEpoch{3}='Sleep'; NameEpoch{4}='NREM'; NameEpoch{5}='REM'; NameEpoch{6}='N1'; NameEpoch{7}='N2'; NameEpoch{8}='N3'; Side=NameEpoch;
    else
        NameEpoch{1}='Total'; NameEpoch{2}='After_stim'; NameEpoch{3}='Freezing'; NameEpoch{4}='Active'; NameEpoch{5}='Freezing_shock'; NameEpoch{6}='Freezing_safe'; NameEpoch{7}='Active_shock'; NameEpoch{8}='Active_safe'; Side=NameEpoch;
    end
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                for feat=1:length(Features)
                    try
                        if isnan(runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                            HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,bin);
                        else
                            % ripples number normalized along considered episode
                            HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                            % ripples number / episode number
                            HistData_ByEp.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),3)./(size(Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),1));
                            % ripples number / episode number / episode duration            
                            HistData_ByEp_ByDur.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = bin*runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),3)./(size(Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),1)*nanmean(Stop(Epoch1.(Session_type{sess}){mouse,side})-Start(Epoch1.(Session_type{sess}){mouse,side}))/1e4);
                        end
                    catch
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,bin);
                    end
                end
            end
        end
    end
end



% sleep / freezing
figure
subplot(221)
Conf_Inter=nanstd(HistData.NREM.Saline.sleep_post)/sqrt(size(HistData.NREM.Saline.sleep_post,1));
shadedErrorBar([1:bin],nanmean(HistData.NREM.Saline.sleep_post),Conf_Inter,'r',1); hold on;
Conf_Inter=nanstd(HistData.Freezing.Saline.Fear)/sqrt(size(HistData.Freezing.Saline.Fear,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing.Saline.Fear),Conf_Inter,'k',1); hold on;
makepretty; ylabel('#'); 
f=get(gca,'Children'); legend([f(8),f(4)],'NREM','Freezing')
hline(1/bin,'--r')

% NREM sleep substages
subplot(222)
Conf_Inter=nanstd(HistData.N1.Saline.sleep_post)/sqrt(size(HistData.N1.Saline.sleep_post,1));
shadedErrorBar([1:bin],nanmean(HistData.N1.Saline.sleep_post),Conf_Inter,'k',1); hold on;
Conf_Inter=nanstd(HistData.N2.Saline.sleep_post)/sqrt(size(HistData.N2.Saline.sleep_post,1));
shadedErrorBar([1:bin],nanmean(HistData.N2.Saline.sleep_post),Conf_Inter,'m',1); hold on;
Conf_Inter=nanstd(HistData.N3.Saline.sleep_post)/sqrt(size(HistData.N3.Saline.sleep_post,1));
shadedErrorBar([1:bin],nanmean(HistData.N3.Saline.sleep_post),Conf_Inter,'r',1); hold on;
makepretty; 
f=get(gca,'Children'); legend([f(12),f(8),f(4)],'N1','N2','N3')
hline(1/bin,'--r')

% freezing, shock, safe
subplot(223)
Conf_Inter=nanstd(HistData.Freezing.Saline.Ext)/sqrt(size(HistData.Freezing.Saline.Ext,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing.Saline.Ext),Conf_Inter,'c',1); hold on;
Conf_Inter=nanstd(HistData.Freezing.Saline.Cond)/sqrt(size(HistData.Freezing.Saline.Cond,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing.Saline.Cond),Conf_Inter,'m',1); hold on;
makepretty; xlabel('normalized time (a.u.)'); ylabel('#'); 
f=get(gca,'Children'); legend([f(4),f(8)],'Cond','Ext')
hline(1/bin,'--r')

% Fear freezing shock / Fear freezing ssafe
subplot(224)
Conf_Inter=nanstd(HistData.Freezing_shock.Saline.Fear)/sqrt(size(HistData.Freezing_shock.Saline.Fear,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing_shock.Saline.Fear),Conf_Inter,'r',1); hold on;
Conf_Inter=nanstd(HistData.Freezing_safe.Saline.Fear)/sqrt(size(HistData.Freezing_safe.Saline.Fear,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing_safe.Saline.Fear),Conf_Inter,'b',1); hold on;
makepretty; xlabel('normalized time (a.u.)'); 
f=get(gca,'Children'); legend([f(8),f(4)],'Shock Fz','Safe Fz')
hline(1/bin,'--r')

a=suptitle('Ripples density in a episode, normalized, n=9'); a.FontSize=20;



%% Non norm
% sleep / freezing
figure
subplot(221)
Conf_Inter=nanstd(HistData_ByEp_ByDur.NREM.Saline.sleep_post)/sqrt(size(HistData_ByEp_ByDur.NREM.Saline.sleep_post,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.NREM.Saline.sleep_post),Conf_Inter,'r',1); hold on;
Conf_Inter=nanstd(HistData_ByEp_ByDur.Freezing.Saline.Fear)/sqrt(size(HistData_ByEp_ByDur.Freezing.Saline.Fear,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.Freezing.Saline.Fear),Conf_Inter,'k',1); hold on;
makepretty; ylabel('#/s'); 
f=get(gca,'Children'); legend([f(8),f(4)],'NREM','Freezing')

% NREM sleep substages
subplot(222)
Conf_Inter=nanstd(HistData_ByEp_ByDur.N1.Saline.sleep_post)/sqrt(size(HistData_ByEp_ByDur.N1.Saline.sleep_post,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.N1.Saline.sleep_post),Conf_Inter,'k',1); hold on;
Conf_Inter=nanstd(HistData_ByEp_ByDur.N2.Saline.sleep_post)/sqrt(size(HistData_ByEp_ByDur.N2.Saline.sleep_post,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.N2.Saline.sleep_post),Conf_Inter,'m',1); hold on;
Conf_Inter=nanstd(HistData_ByEp_ByDur.N3.Saline.sleep_post)/sqrt(size(HistData_ByEp_ByDur.N3.Saline.sleep_post,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.N3.Saline.sleep_post),Conf_Inter,'r',1); hold on;
makepretty; 
f=get(gca,'Children'); legend([f(12),f(8),f(4)],'N1','N2','N3')

% freezing, shock, safe
subplot(223)
Conf_Inter=nanstd(HistData_ByEp_ByDur.Freezing.Saline.Ext)/sqrt(size(HistData_ByEp_ByDur.Freezing.Saline.Ext,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.Freezing.Saline.Ext),Conf_Inter,'c',1); hold on;
Conf_Inter=nanstd(HistData_ByEp_ByDur.Freezing.Saline.Cond)/sqrt(size(HistData_ByEp_ByDur.Freezing.Saline.Cond,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.Freezing.Saline.Cond),Conf_Inter,'m',1); hold on;
makepretty; xlabel('normalized time (a.u.)'); ylabel('#/s'); 
f=get(gca,'Children'); legend([f(4),f(8)],'Cond','Ext')

% Fear freezing shock / Fear freezing ssafe
subplot(224)
Conf_Inter=nanstd(HistData_ByEp_ByDur.Freezing_shock.Saline.Fear)/sqrt(size(HistData_ByEp_ByDur.Freezing_shock.Saline.Fear,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.Freezing_shock.Saline.Fear),Conf_Inter,'r',1); hold on;
Conf_Inter=nanstd(HistData_ByEp_ByDur.Freezing_safe.Saline.Fear)/sqrt(size(HistData_ByEp_ByDur.Freezing_safe.Saline.Fear,1));
shadedErrorBar([1:bin],nanmean(HistData_ByEp_ByDur.Freezing_safe.Saline.Fear),Conf_Inter,'b',1); hold on;
makepretty; xlabel('normalized time (a.u.)'); 
f=get(gca,'Children'); legend([f(8),f(4)],'Shock Fz','Safe Fz')

a=suptitle('Ripples density in a episode, n=9'); a.FontSize=20;















