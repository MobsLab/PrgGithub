%% Extrait de Model_06
% Figure pour observer tous les prédicteurs
% Lock all the parameters to the data in an array for a given model (different
% trainsets and we remove the raws in which there is at least one NaN value)
for mousenum=1:length(Mouse_ALL)
    clear Mod_ind
    Mod_ind = ismember(TotalArray_mouse.(Mouse_names{mousenum})(:,1), table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)));
    % Extract indexes of frequencies available in my trainset array that
    % correspond to a frequency in the total array (selected observations)
    PositionArray.Fit10.(Mouse_names{mousenum}) = PositionArray.(Mouse_names{mousenum})(Mod_ind);
    try RipplesDensityArray.Fit10.(Mouse_names{mousenum}) = RipplesDensityArray.(Mouse_names{mousenum})(Mod_ind); end
    ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}) = ShockZoneEntriesArray.(Mouse_names{mousenum})(Mod_ind);
    NumShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}) = diff(ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}));
    NumShockZoneEntriesArray.Fit10.(Mouse_names{mousenum})(1) = ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum})(1);
    EyelidNumberArray.Fit10.(Mouse_names{mousenum}) = EyelidNumberArray.(Mouse_names{mousenum})(Mod_ind);
    NumEyelidNumberArray.Fit10.(Mouse_names{mousenum}) = diff(EyelidNumberArray.Fit10.(Mouse_names{mousenum}));
    NumEyelidNumberArray.Fit10.(Mouse_names{mousenum})(1) = EyelidNumberArray.Fit10.(Mouse_names{mousenum})(1);
end

% Karim aimerait pouvoir ajouter le paramètre temps global transformé dans
% la figure recap pour voir à quel moment le modèle fitte que la souris a
% appris
figure
for mousenum=1:length(Mouse_ALL) 
    % plot mean episode frequency and fitted data
    clear common_ind mean_freq_episodes
    subplot(4,3,mousenum)
%     plot(table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6)), 'x'), hold on 
    common_ind = ismember(table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,1)), table2array(Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,1)));
    mean_freq_episodes = table2array(Mean_Array_Train.Fit10.(Mouse_names{mousenum}).Trainset(1).table(:,6));
    plot(mean_freq_episodes(common_ind), 'x'), hold on
    plot(table2array(Output_GLM.Train_mdl.Fit10.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1)), 'o')
    plot(PositionArray.Fit10.(Mouse_names{mousenum}))
    makepretty
    
    % plot ripples
    clear x y color
    try x = 1:length(RipplesDensityArray.(Mouse_names{mousenum}));
    y = 1.5*ones(1,length(RipplesDensityArray.(Mouse_names{mousenum})))+rand(1, length(RipplesDensityArray.(Mouse_names{mousenum})));
    color = RipplesDensityArray.(Mouse_names{mousenum});
    scatter(x,y,[],color); end
    hold on;
    colormap(brewermap(8,'Reds'))
    if mousenum==2; title('INT10'); end
    
    xlabel('Observation', 'FontSize', 20)
    ylabel('Mean ep freq', 'FontSize', 20)
    ylim([0 10])

    % plot shock zone entries 
    clear ind x y sz vect
    x = NumShockZoneEntriesArray.Fit10.(Mouse_names{mousenum});
    ind = x==0;
    sz= x(~ind);
    vect = 1:length(x);
    vect = vect(~ind);
    y = 8*ones(1,length(vect));
    scatter(vect, y, 10*sz)
%     plot(8+((ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}))./max(ShockZoneEntriesArray.Fit10.(Mouse_names{mousenum}))));
    
    % plot shocks
    clear ind x y sz vect
    x = NumEyelidNumberArray.Fit10.(Mouse_names{mousenum});
    ind = x==0;
    sz= x(~ind);
    vect = 1:length(x);
    vect = vect(~ind);
    y = 10*ones(1,length(vect));
    scatter(vect, y, 10*sz)
    
end
subplot(4,3,12); colorbar; caxis([0 7]);



%% Extrait de Model_05
% Preditors code (qu'il faut adapter pour plotter les bêtas et pas les
% p-valeurs, il faut changer la colonne de la table selectionné, ici 4 je crois que c'est 1 pour les bêtas)
for mousenum=1:length(Mouse_ALL)
    Compare_significant_predictors.Fit8(mousenum,1) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(2,4));%Position
    Compare_significant_predictors.Fit8(mousenum,2) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(3,4));%GT
    Compare_significant_predictors.Fit8(mousenum,3) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(4,4));%T since last shock
    Compare_significant_predictors.Fit8(mousenum,4) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(5,4));%T freezing
    Compare_significant_predictors.Fit8(mousenum,5) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(6,4));%T freezing cumul
    Compare_significant_predictors.Fit8(mousenum,6) = table2array(Table_estimates_pval.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table(7,4));%
    
end

% Predictors figure
figure
MakeSpreadAndBoxPlot3_ECSB({Compare_significant_predictors.Fit8(:,1)...
    Compare_significant_predictors.Fit8(:,2) Compare_significant_predictors.Fit8(:,3) ...
    Compare_significant_predictors.Fit8(:,4) Compare_significant_predictors.Fit8(:,5) ...
    Compare_significant_predictors.Fit8(:,6)}, ...
    {},[1 2 3 4 5 6],...
    {'Pos','GT', 'TLS', 'CFT', 'sig(Pos)xTLS', 'sig(Pos)xsig(GT)'},'paired',1,'showpoints',0);
txt1 = string(sum(Compare_significant_predictors.Fit8<0.05));
for i=1:length(txt1)
text(i,1e-10,txt1(i), 'FontSize', 12)
end
xlim([0 7])
line([0 20], [0.05 0.05], 'linewidth', 2, 'Color', [0 0 0])
ylabel('pvalues of predictors, chosen interactions', 'FontSize', 25);
xtickangle(20);
set(gca,'linewidth',1.5,'Yscale','log', 'FontSize', 12)

% R2 code
for mousenum=1:length(Mouse_ALL)
    Mean_Rsquared_deviance_Train_Fit8(mousenum)=nanmean(struct2array(Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset));
    Rsquared_deviance_Train_Fit8(mousenum)=struct2array(Rsquared.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1));
    Corr_coef.Fit8.Train = corrcoef(table2array(Array_Train.Fit8.(Mouse_names{mousenum}).Trainset(1).table(:,7)), table2array(Output_GLM.Train_mdl.Fit8.(Mouse_names{mousenum}).Trainset(1).table.Fitted(:,1))).^2;
    Corr_coef.Fit8.Test = corrcoef(Array_Test_frequencies.Fit8.(Mouse_names{mousenum}).Value, Test_mdl.Fit8.(Mouse_names{mousenum}).Value).^2;
    Rsquared_Train_Fit8(mousenum)=Corr_coef.Fit8.Train(1,2);
    Rsquared_Test_Fit8(mousenum)=Corr_coef.Fit8.Test(1,2);
end

% R2 figure
figure
MakeSpreadAndBoxPlot3_ECSB({Rsquared_deviance_Train_Fit8' Rsquared_Test_Fit8'},{[0.9 0.7 0.1] [0.2 0.7 0.45]},...
    [1 2],{'Train','Test'},'paired',1,'showpoints',0);
ylabel('GOF INT8 model');
xlim([0.5 2.5])
ylim([0 1])
set(gca,'linewidth',1.5,'YTick',[0:0.2:1], 'FontSize', 14)
title(median(Mean_Rsquared_deviance_Train_Fit8))



function final_graph_model = makefinalfigureGLM(