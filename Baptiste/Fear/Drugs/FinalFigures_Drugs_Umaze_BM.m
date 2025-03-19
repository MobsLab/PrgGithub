
GetEmbReactMiceFolderList_BM

%Session_type={'RealTimeSess1','RealTimeSess2','RealTimeSess3','RealTimeSess4','RealTimeSess5','RealTimeSess6','RealTimeSess7'};
Session_type={'CondPre','CondPost','Ext'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
Fz_Type={'Total','After_stim','Freezing','Active','Freezing_Freezing_shock','Freezing_Freezing_safe','Active_Freezing_shock','Active_Freezing_safe'};
Side_ind=1:8;

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'wake_ripples','respi_freq_bm','heartrate','ob_high');
end
for sess=1:length(Session_type) % generate all data required for analyses
    TSD_DATA.(Session_type{sess}).heartrate.mean(TSD_DATA.(Session_type{sess}).heartrate.mean==0)=NaN;
end
%% 2D representation
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        for type=1:length(Fz_Type)
            try
                % Respi
                Respi.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).respi_freq_bm.mean(mouse,Side_ind(type));
                % HR
                try
                    HR.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartrate.mean(mouse,Side_ind(type));
                end
                % Ripples
                Ripples.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).wake_ripples.mean(mouse,Side_ind(type));
                % Gamma
                if TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,Side_ind(type))==41.503906250096730;
                    TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,Side_ind(type))=NaN; TSD_DATA.(Session_type{sess}).ob_high.power(mouse,Side_ind(type))=NaN;
                end
                Gamma_Bulb_Freq.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,Side_ind(type));
                Gamma_Bulb_Power.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = log10(TSD_DATA.(Session_type{sess}).ob_high.power(mouse,Side_ind(type)));
            end
        end
    end
    Mouse_names{mouse}
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            for type=1:length(Fz_Type)
                try
                    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                    
                    Respi.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Respi.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                    try
                        HR.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = HR.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                    end
                    Ripples.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                    
                    Gamma_Bulb_Freq.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Gamma_Bulb_Freq.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                    Gamma_Bulb_Power.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = Gamma_Bulb_Power.(Fz_Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                end
            end
        end
    end
end

for sess=1:length(Session_type)
    for group=1:length(Drug_Group)
        for type=1:length(Fz_Type)
            try
                Respi.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Respi.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
                
                HR.(Fz_Type{type}).Figure.(Session_type{sess}){group} = HR.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
                HR.(Fz_Type{type}).Figure.(Session_type{sess}){group}(HR.(Fz_Type{type}).Figure.(Session_type{sess}){group}==0)=NaN;
                
                Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Ripples.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
                Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group}(Ripples.(Fz_Type{type}).Figure.(Session_type{sess}){group}==0)=NaN;
                
                Gamma_Bulb_Freq.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Gamma_Bulb_Freq.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
                Gamma_Bulb_Power.(Fz_Type{type}).Figure.(Session_type{sess}){group} = Gamma_Bulb_Power.(Fz_Type{type}).(Drug_Group{group}).(Session_type{sess});
            end
        end
    end
end

for sess=1:length(Session_type)
    for type=1:length(Fz_Type)
        try; HR.(Fz_Type{type}).Figure.(Session_type{sess}){8}(3:6)=NaN; end
    end
end

%% Constellations
MakeFigures_Constellations_FreezingMaze2D_BM

%% 2D representation
figure; n=1;
for group=[1 5 6]
    for sess=1:3
        
        subplot(3,3,(n-1)*3+sess)
        
        plot(Respi.Freezing_shock.Figure.(Session_type{sess}){group} , HR.Freezing_shock.Figure.(Session_type{sess}){group} , '.', 'MarkerSize' , 30 , 'Color' , [1 0 0])
        hold on
        plot(Respi.Freezing_safe.Figure.(Session_type{sess}){group} , HR.Freezing_safe.Figure.(Session_type{sess}){group} , '.', 'MarkerSize' , 30 , 'Color' , [0 0 1])
        makepretty; xlim([2.5 6]); ylim([8 13]);
        if sess==1; ylabel('HR (Hz)'); end
        if n==1; title(Session_type{sess}); end
        if n==3; xlabel('OB (Hz)'); end
        if and(n==1,sess==1); u=text(1.5,9,'SalineSB','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); legend('Freezing_shock fz','Freezing_safe fz'); end
        if and(n==2,sess==1); u=text(1.5,9,'SalineBM','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        if and(n==3,sess==1); u=text(1.5,9,'Diazepam','FontSize',20,'FontWeight','bold'); set(u,'Rotation',90); end
        
    end
    n=n+1;
end
a=suptitle('HR = f(OB freq) analysis, Freezing, Drugs UMaze'); a.FontSize=20;


X = [1:8];
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends_Drugs ={'', '', '', '','','','',''};
MarkerToUse = {'d','s','o'};

X_Freezing_shock = nanmean([Respi.Freezing_shock.Figure.(Session_type{1}){1} ; Respi.Freezing_shock.Figure.(Session_type{1}){3} ; Respi.Freezing_shock.Figure.(Session_type{1}){4} ; Respi.Freezing_shock.Figure.(Session_type{1}){5}]);
Y_Freezing_shock = nanmean([HR.Freezing_shock.Figure.(Session_type{1}){1} ; HR.Freezing_shock.Figure.(Session_type{1}){3} ; HR.Freezing_shock.Figure.(Session_type{1}){4} ; HR.Freezing_shock.Figure.(Session_type{1}){5}]);

X_Freezing_safe = nanmean([Respi.Freezing_safe.Figure.(Session_type{3}){1} ; Respi.Freezing_safe.Figure.(Session_type{3}){3} ; Respi.Freezing_safe.Figure.(Session_type{3}){4} ; Respi.Freezing_safe.Figure.(Session_type{3}){5}]);
Y_Freezing_safe = nanmean([HR.Freezing_safe.Figure.(Session_type{3}){1} ; HR.Freezing_safe.Figure.(Session_type{3}){3} ; HR.Freezing_safe.Figure.(Session_type{3}){4} ; HR.Freezing_safe.Figure.(Session_type{3}){5}]);

X_Freezing_shock_ext = nanmean([Respi.Freezing_shock.Figure.(Session_type{3}){1} ; Respi.Freezing_shock.Figure.(Session_type{3}){3} ; Respi.Freezing_shock.Figure.(Session_type{3}){4} ; Respi.Freezing_shock.Figure.(Session_type{3}){5}]);
Y_Freezing_shock_ext = nanmean([HR.Freezing_shock.Figure.(Session_type{3}){1} ; HR.Freezing_shock.Figure.(Session_type{3}){3} ; HR.Freezing_shock.Figure.(Session_type{3}){4} ; HR.Freezing_shock.Figure.(Session_type{3}){5}]);

Y2_Freezing_shock = nanmean([Ripples.Freezing_shock.Figure.(Session_type{1}){1} ; Ripples.Freezing_shock.Figure.(Session_type{1}){3} ; Ripples.Freezing_shock.Figure.(Session_type{1}){4} ; Ripples.Freezing_shock.Figure.(Session_type{1}){5}]);
Y2_Freezing_safe = nanmean([Ripples.Freezing_safe.Figure.(Session_type{3}){1} ; Ripples.Freezing_safe.Figure.(Session_type{3}){3} ; Ripples.Freezing_safe.Figure.(Session_type{3}){4} ; Ripples.Freezing_safe.Figure.(Session_type{3}){5}]);
Y2_Freezing_shock_ext = nanmean([Ripples.Freezing_shock.Figure.(Session_type{3}){1} ; Ripples.Freezing_shock.Figure.(Session_type{3}){3} ; Ripples.Freezing_shock.Figure.(Session_type{3}){4} ; Ripples.Freezing_shock.Figure.(Session_type{3}){5}]);
% X_Freezing_shock = 5.27; Y_Freezing_shock = 12.16;
% X_Freezing_safe = 3.72; Y_Freezing_safe = 10.6;
% X_Freezing_shock_ext = 4.45; Y_Freezing_shock_ext = 10.61;
% Y2_Freezing_shock = 0.417; Y2_Freezing_safe = 0.9237; Y2_Freezing_shock_ext = 0.5566;

% for 3 sessions types
for group=5:6%1:length(Drug_Group)
    figure; m=1;
    for sess=[1 2 3]
        subplot(2,3,m); n=1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
        hold on
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
        errorbarxy(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_shock.Figure.(Session_type{sess}){group},1)) , nanstd(HR.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(HR.Freezing_shock.Figure.(Session_type{sess}){group},1)));
        errorbarxy(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_safe.Figure.(Session_type{sess}){group},1)) , nanstd(HR.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(HR.Freezing_safe.Figure.(Session_type{sess}){group},1)));
        if m==1; ylabel('HR (Hz)'); f=get(gca,'Children'); legend([f(5),f(4)],'Fz shock','Fz safe'); end
        plot(X_Freezing_shock,Y_Freezing_shock,'.r','MarkerSize',40); plot(X_Freezing_shock_ext,Y_Freezing_shock_ext,'.m','MarkerSize',40); plot(X_Freezing_safe,Y_Freezing_safe,'.b','MarkerSize',40)
        n=n+1;
        makepretty; xlim([3 6]); ylim([8 12.5]); title(Session_type{sess})
        
        subplot(2,3,m+3); n=1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
        hold on
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
        errorbarxy(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_shock.Figure.(Session_type{sess}){group},1)) , nanstd(Ripples.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Ripples.Freezing_shock.Figure.(Session_type{sess}){group},1)));
        errorbarxy(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_safe.Figure.(Session_type{sess}){group},1)) , nanstd(Ripples.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Ripples.Freezing_safe.Figure.(Session_type{sess}){group},1)));
        if m==1; ylabel('Ripples density (#/s)'); end
        plot(X_Freezing_shock,Y2_Freezing_shock,'.r','MarkerSize',40); plot(X_Freezing_shock_ext,Y2_Freezing_shock_ext,'.m','MarkerSize',40); plot(X_Freezing_safe,Y2_Freezing_safe,'.b','MarkerSize',40)
        n=n+1;
        makepretty; xlim([3 6]); ylim([0 1.5]); xlabel('OB freq (Hz)')
        m=m+1;
    end
    a=suptitle(Drug_Group{group}); a.FontSize=20;
end

legend('Freezing_shock fz Saline SB','Freezing_safe fz Saline SB','Freezing_shock fz Chronic Flx','Freezing_safe fz Chronic Flx')
legend('Freezing_shock fz Saline SB','Freezing_safe fz Saline SB','Freezing_shock fz Acute Flx','Freezing_safe fz Acute Flx')
legend('Freezing_shock fz Saline SB','Freezing_safe fz Saline SB','Freezing_shock fz MDZ','Freezing_safe fz MDZ')
legend('Freezing_shock fz Saline SB','Freezing_safe fz Saline SB','Freezing_shock fz Saline BM','Freezing_safe fz Saline BM')

a=suptitle('Saline Long'); a.FontSize=20;

% only 2 sessions types
figure; m=1;
for sess=[2 3]
    subplot(2,2,m); n=1;
    for group=[5 6]
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
        hold on
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
        errorbarxy(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_shock.Figure.(Session_type{sess}){group},1)) , nanstd(HR.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(HR.Freezing_shock.Figure.(Session_type{sess}){group},1)));
        errorbarxy(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_safe.Figure.(Session_type{sess}){group},1)) , nanstd(HR.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(HR.Freezing_safe.Figure.(Session_type{sess}){group},1)));
      if m==1; ylabel('HR (Hz)');  legend('Freezing_shock fz saline BM','Freezing_safe fz saline BM','Freezing_shock fz MDZ','Freezing_safe fz MDZ'); end
        n=n+1;
    end
    makepretty; xlim([3 6]); ylim([8 12.5]); title(Session_type{sess})
    
    subplot(2,2,m+2); n=1;
    for group=[5 6]
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
        hold on
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
        errorbarxy(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_shock.Figure.(Session_type{sess}){group},1)) , nanstd(Ripples.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Ripples.Freezing_shock.Figure.(Session_type{sess}){group},1)));
        errorbarxy(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_safe.Figure.(Session_type{sess}){group},1)) , nanstd(Ripples.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Ripples.Freezing_safe.Figure.(Session_type{sess}){group},1)));
        if m==1; ylabel('Ripples density (#/s)'); end
        n=n+1;
    end
    makepretty; xlim([3 6]); ylim([0 0.6]); xlabel('OB freq (Hz)')
    
    m=m+1;
end




% pooling saline and DZP BM together
figure;
sess=2; n=1;
subplot(2,2,1);
Data1=[Respi.Freezing_shock.Figure.(Session_type{sess}){5} ; Respi.Freezing_shock.Figure.CondPost{7}];
Data2=[HR.Freezing_shock.Figure.(Session_type{sess}){5} ; HR.Freezing_shock.Figure.CondPost{7}];
Data3=[Respi.Freezing_safe.Figure.(Session_type{sess}){5} ; Respi.Freezing_safe.Figure.CondPost{7}];
Data4=[HR.Freezing_safe.Figure.(Session_type{sess}){5} ; HR.Freezing_safe.Figure.CondPost{7}];
plot(nanmean(Data1) , nanmean(Data2) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
hold on
plot(nanmean(Data3) , nanmean(Data4) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
errorbarxy(nanmean(Data1) , nanmean(Data2) , nanstd(Data1)/sqrt(size(Data1,1)) , nanstd(Data3)/sqrt(size(Data2,1)));
errorbarxy(nanmean(Data3) , nanmean(Data4) , nanstd(Data3)/sqrt(size(Data3,1)) , nanstd(Data4)/sqrt(size(Data4,1)));

n=n+1;
Data1=[Respi.Freezing_shock.Figure.(Session_type{sess}){6} ; Respi.Freezing_shock.Figure.CondPost{8}];
Data2=[HR.Freezing_shock.Figure.(Session_type{sess}){6} ; HR.Freezing_shock.Figure.CondPost{8}];
Data3=[Respi.Freezing_safe.Figure.(Session_type{sess}){6} ; Respi.Freezing_safe.Figure.CondPost{8}];
Data4=[HR.Freezing_safe.Figure.(Session_type{sess}){6} ; HR.Freezing_safe.Figure.CondPost{8}];
plot(nanmean(Data1) , nanmean(Data2) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
hold on
plot(nanmean(Data3) , nanmean(Data4) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
errorbarxy(nanmean(Data1) , nanmean(Data2) , nanstd(Data1)/sqrt(size(Data1,1)) , nanstd(Data3)/sqrt(size(Data2,1)));
errorbarxy(nanmean(Data3) , nanmean(Data4) , nanstd(Data3)/sqrt(size(Data3,1)) , nanstd(Data4)/sqrt(size(Data4,1)));
makepretty; xlim([3.5 5.2]); ylim([8 12.5]); title(Session_type{sess})
ylabel('HR (Hz)');  legend('Freezing_shock fz saline BM','Freezing_safe fz saline BM','Freezing_shock fz DZP','Freezing_safe fz DZP');

subplot(2,2,2); sess=3; n=1;
Data1=[Respi.Freezing_shock.Figure.(Session_type{sess}){5} ; Respi.Freezing_shock.Figure.(Session_type{sess}){7}];
Data2=[HR.Freezing_shock.Figure.(Session_type{sess}){5} ; HR.Freezing_shock.Figure.(Session_type{sess}){7}];
Data3=[Respi.Freezing_safe.Figure.(Session_type{sess}){5} ; Respi.Freezing_safe.Figure.(Session_type{sess}){7}];
Data4=[HR.Freezing_safe.Figure.(Session_type{sess}){5} ; HR.Freezing_safe.Figure.(Session_type{sess}){7}];
plot(nanmean(Data1) , nanmean(Data2) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
hold on
plot(nanmean(Data3) , nanmean(Data4) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
errorbarxy(nanmean(Data1) , nanmean(Data2) , nanstd(Data1)/sqrt(size(Data1,1)) , nanstd(Data3)/sqrt(size(Data2,1)));
errorbarxy(nanmean(Data3) , nanmean(Data4) , nanstd(Data3)/sqrt(size(Data3,1)) , nanstd(Data4)/sqrt(size(Data4,1)));
n=n+1;
Data1=[Respi.Freezing_shock.Figure.(Session_type{sess}){6} ; Respi.Freezing_shock.Figure.(Session_type{sess}){8}];
Data2=[HR.Freezing_shock.Figure.(Session_type{sess}){6} ; HR.Freezing_shock.Figure.(Session_type{sess}){8}];
Data3=[Respi.Freezing_safe.Figure.(Session_type{sess}){6} ; Respi.Freezing_safe.Figure.(Session_type{sess}){8}];
Data4=[HR.Freezing_safe.Figure.(Session_type{sess}){6} ; HR.Freezing_safe.Figure.(Session_type{sess}){8}];
plot(nanmean(Data1) , nanmean(Data2) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
hold on
plot(nanmean(Data3) , nanmean(Data4) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
errorbarxy(nanmean(Data1) , nanmean(Data2) , nanstd(Data1)/sqrt(size(Data1,1)) , nanstd(Data3)/sqrt(size(Data2,1)));
errorbarxy(nanmean(Data3) , nanmean(Data4) , nanstd(Data3)/sqrt(size(Data3,1)) , nanstd(Data4)/sqrt(size(Data4,1)));
makepretty; xlim([3.5 5.2]); ylim([8 12.5]); title(Session_type{sess})


%% Ripples
sess=2; n=1;
subplot(2,2,3);
Data1=[Respi.Freezing_shock.Figure.(Session_type{sess}){5} ; Respi.Freezing_shock.Figure.(Session_type{sess}){7}];
Data2=[Ripples.Freezing_shock.Figure.(Session_type{sess}){5} ; Ripples.Freezing_shock.Figure.(Session_type{sess}){7}];
Data3=[Respi.Freezing_safe.Figure.(Session_type{sess}){5} ; Respi.Freezing_safe.Figure.(Session_type{sess}){7}];
Data4=[Ripples.Freezing_safe.Figure.(Session_type{sess}){5} ; Ripples.Freezing_safe.Figure.(Session_type{sess}){7}];
plot(nanmean(Data1) , nanmean(Data2) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
hold on
plot(nanmean(Data3) , nanmean(Data4) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
errorbarxy(nanmean(Data1) , nanmean(Data2) , nanstd(Data1)/sqrt(size(Data1,1)) , nanstd(Data3)/sqrt(size(Data2,1)));
errorbarxy(nanmean(Data3) , nanmean(Data4) , nanstd(Data3)/sqrt(size(Data3,1)) , nanstd(Data4)/sqrt(size(Data4,1)));
n=n+1;
Data1=[Respi.Freezing_shock.Figure.(Session_type{sess}){6} ; Respi.Freezing_shock.Figure.CondPost{8}];
Data2=[Ripples.Freezing_shock.Figure.(Session_type{sess}){6} ; Ripples.Freezing_shock.Figure.CondPost{8}];
Data3=[Respi.Freezing_safe.Figure.(Session_type{sess}){6} ; Respi.Freezing_safe.Figure.CondPost{8}];
Data4=[Ripples.Freezing_safe.Figure.(Session_type{sess}){6} ; Ripples.Freezing_safe.Figure.CondPost{8}];
plot(nanmean(Data1) , nanmean(Data2) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
hold on
plot(nanmean(Data3) , nanmean(Data4) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
errorbarxy(nanmean(Data1) , nanmean(Data2) , nanstd(Data1)/sqrt(size(Data1,1)) , nanstd(Data3)/sqrt(size(Data2,1)));
errorbarxy(nanmean(Data3) , nanmean(Data4) , nanstd(Data3)/sqrt(size(Data3,1)) , nanstd(Data4)/sqrt(size(Data4,1)));
makepretty; xlim([3.5 5.2]); ylim([-0.1 0.6]);
ylabel('Ripples (#/s)');
subplot(2,2,4); sess=3; n=1;
Data1=[Respi.Freezing_shock.Figure.(Session_type{sess}){5} ; Respi.Freezing_shock.Figure.(Session_type{sess}){7}];
Data2=[Ripples.Freezing_shock.Figure.(Session_type{sess}){5} ; Ripples.Freezing_shock.Figure.(Session_type{sess}){7}];
Data3=[Respi.Freezing_safe.Figure.(Session_type{sess}){5} ; Respi.Freezing_safe.Figure.(Session_type{sess}){7}];
Data4=[Ripples.Freezing_safe.Figure.(Session_type{sess}){5} ; Ripples.Freezing_safe.Figure.(Session_type{sess}){7}];
plot(nanmean(Data1) , nanmean(Data2) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
hold on
plot(nanmean(Data3) , nanmean(Data4) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
errorbarxy(nanmean(Data1) , nanmean(Data2) , nanstd(Data1)/sqrt(size(Data1,1)) , nanstd(Data3)/sqrt(size(Data2,1)));
errorbarxy(nanmean(Data3) , nanmean(Data4) , nanstd(Data3)/sqrt(size(Data3,1)) , nanstd(Data4)/sqrt(size(Data4,1)));
n=n+1;
Data1=[Respi.Freezing_shock.Figure.(Session_type{sess}){6} ; Respi.Freezing_shock.Figure.(Session_type{sess}){8}];
Data2=[Ripples.Freezing_shock.Figure.(Session_type{sess}){6} ; Ripples.Freezing_shock.Figure.(Session_type{sess}){8}];
Data3=[Respi.Freezing_safe.Figure.(Session_type{sess}){6} ; Respi.Freezing_safe.Figure.(Session_type{sess}){8}];
Data4=[Ripples.Freezing_safe.Figure.(Session_type{sess}){6} ; Ripples.Freezing_safe.Figure.(Session_type{sess}){8}];
plot(nanmean(Data1) , nanmean(Data2) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
hold on
plot(nanmean(Data3) , nanmean(Data4) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
errorbarxy(nanmean(Data1) , nanmean(Data2) , nanstd(Data1)/sqrt(size(Data1,1)) , nanstd(Data3)/sqrt(size(Data2,1)));
errorbarxy(nanmean(Data3) , nanmean(Data4) , nanstd(Data3)/sqrt(size(Data3,1)) , nanstd(Data4)/sqrt(size(Data4,1)));
makepretty; xlim([3.5 5.2]); ylim([-0.1 0.6]);




%% Trajectories in 2D space
figure
subplot(131); group=3;
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 0.5 0.5]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
    
    a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [0.5 0.5 1]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
    
    makepretty
end
xlabel('OB frequency (Hz)'); ylabel('HR (Hz)')
%f=get(gca,'Children'); legend([f(8),f(4)],'Freezing_shock side freezing','Freezing_safe side freezing');


subplot(132); 
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 0.5 0.5]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
    
    a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [0.5 0.5 1]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
    
    makepretty
end
xlabel('OB frequency (Hz)'); ylabel('Rip density (#/s)')

subplot(133); 
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 0.5 0.5]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
    
    a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [0.5 0.5 1]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
    
    makepretty
    
end
xlabel('OB frequency (Hz)'); ylabel('Gamma (a.u)')

a=suptitle(Drug_Group{group}); a.FontSize=20;


%% All freezing

for mouse=1:length(Mouse)
    for sess=1:5%length(Session_type)
        % Respi
        Respi.All.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).respi_freq_BM.mean(mouse,3);
        % HR
        try
            HR.All.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartrate.mean(mouse,3);
        end
        % Ripples
        Ripples.All.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).wake_ripples.mean(mouse,3);
    end
    Mouse_names{mouse}
end

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:5%length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Respi.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Respi.All.(Session_type{sess}).(Mouse_names{mouse});
            try
                HR.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = HR.All.(Session_type{sess}).(Mouse_names{mouse});
            end
            Ripples.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.All.(Session_type{sess}).(Mouse_names{mouse});
            
        end
    end
end

for sess=1:5%length(Session_type)
    for group=1:length(Drug_Group)
        Respi.All.Figure.(Session_type{sess}){group} = Respi.All.(Drug_Group{group}).(Session_type{sess});
        
        HR.All.Figure.(Session_type{sess}){group} = HR.All.(Drug_Group{group}).(Session_type{sess});
        HR.All.Figure.(Session_type{sess}){group}(HR.All.Figure.(Session_type{sess}){group}==0)=NaN;
        
        Ripples.All.Figure.(Session_type{sess}){group} = Ripples.All.(Drug_Group{group}).(Session_type{sess});
        Ripples.All.Figure.(Session_type{sess}){group}(Ripples.All.Figure.(Session_type{sess}){group}==0)=NaN;
    end
end



for group=1:length(Drug_Group)
    figure; m=1;
    for sess=[4 5 3]
        subplot(2,3,m); n=1;
        plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
        hold on
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
        errorbarxy(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_shock.Figure.(Session_type{sess}){group},1)) , nanstd(HR.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(HR.Freezing_shock.Figure.(Session_type{sess}){group},1)));
        errorbarxy(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_safe.Figure.(Session_type{sess}){group},1)) , nanstd(HR.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(HR.Freezing_safe.Figure.(Session_type{sess}){group},1)));
        if m==1; ylabel('HR (Hz)');  legend('Freezing_shock fz saline SB','Freezing_safe fz saline SB','Freezing_shock fz MDZ','Freezing_safe fz MDZ'); end
        plot(X_Freezing_shock,Y_Freezing_shock,'.r','MarkerSize',40); plot(X_Freezing_shock_ext,Y_Freezing_shock_ext,'.m','MarkerSize',40); plot(X_Freezing_safe,Y_Freezing_safe,'.b','MarkerSize',40)
        n=n+1;
        makepretty; xlim([3 6]); ylim([8 12.5]); title(Session_type{sess})
        subplot(2,3,m+3); n=1;
        
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [1 .5 .5], 'LineWidth',4)
        hold on
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , MarkerToUse{n}, 'MarkerSize' , 20 , 'Color' , [.5 .5 1], 'LineWidth',4)
        errorbarxy(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_shock.Figure.(Session_type{sess}){group},1)) , nanstd(Ripples.Freezing_shock.Figure.(Session_type{sess}){group})/sqrt(size(Ripples.Freezing_shock.Figure.(Session_type{sess}){group},1)));
        errorbarxy(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , nanstd(Respi.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Respi.Freezing_safe.Figure.(Session_type{sess}){group},1)) , nanstd(Ripples.Freezing_safe.Figure.(Session_type{sess}){group})/sqrt(size(Ripples.Freezing_safe.Figure.(Session_type{sess}){group},1)));
        if m==1; ylabel('Ripples density (#/s)'); end
        plot(X_Freezing_shock,Y2_Freezing_shock,'.r','MarkerSize',40); plot(X_Freezing_shock_ext,Y2_Freezing_shock_ext,'.m','MarkerSize',40); plot(X_Freezing_safe,Y2_Freezing_safe,'.b','MarkerSize',40)
        n=n+1;
        makepretty; xlim([3 6]); ylim([0 0.6]); xlabel('OB freq (Hz)')
        m=m+1;
    end
    a=suptitle(Drug_Group{group}); a.FontSize=20;
end

subplot(231)
sess=4;
group=1;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
hold on
group=3;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'p' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=4;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 's' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=5;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , '.' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=7;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , '*' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
makepretty; xlim([3 6]); ylim([8 12.5]);

subplot(232)
sess=5;
group=1;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
hold on
group=3;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'p' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=4;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 's' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=5;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , '.' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=7;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , '*' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
makepretty; xlim([3 6]); ylim([8 12.5]);

subplot(233)
sess=3;
group=1;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
hold on
group=3;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'p' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=4;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 's' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=5;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , '.' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=7;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , '*' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
makepretty; xlim([3 6]); ylim([8 12.5]);


subplot(234)
sess=4;
group=1;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
hold on
group=3;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'p' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=4;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 's' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=5;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , '.' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=7;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , '*' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
makepretty; xlim([3 6]); ylim([0 0.6]);

subplot(235)
sess=5;
group=1;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
hold on
group=3;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'p' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=4;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 's' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=5;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , '.' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=7;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , '*' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
makepretty; xlim([3 6]); ylim([0 0.6]);

subplot(236)
sess=3;
group=1;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
hold on
group=3;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'p' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=4;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 's' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=5;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , '.' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
group=7;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , '*' , 'MarkerSize' , 20 , 'Color' , [0 0 0], 'LineWidth',4)
makepretty; xlim([3 6]); ylim([0 0.6]);



sess=4;
group=6;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.6 .3 .4], 'LineWidth',4)
group=8;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .8], 'LineWidth',4)


sess=5;
group=6;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.6 .3 .4], 'LineWidth',4)
group=8;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .8], 'LineWidth',4)

sess=3;
group=6;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.6 .3 .4], 'LineWidth',4)
group=8;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(HR.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .8], 'LineWidth',4)


sess=4;
group=6;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.6 .3 .4], 'LineWidth',4)
group=8;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .8], 'LineWidth',4)


sess=5;
group=6;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.6 .3 .4], 'LineWidth',4)
group=8;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .8], 'LineWidth',4)

sess=3;
group=6;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.6 .3 .4], 'LineWidth',4)
group=8;
plot(nanmean(Respi.All.Figure.(Session_type{sess}){group}) , nanmean(Ripples.All.Figure.(Session_type{sess}){group}) , 'o' , 'MarkerSize' , 20 , 'Color' , [.3 .3 .8], 'LineWidth',4)



