
% Mouse_names = {'M688', 'M739', 'M777', 'M779', 'M849', 'M1144', 'M1146', 'M1147', 'M1170', 'M1171', 'M9184', 'M1189', 'M9205', 'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226'};
% Data2=[log10(Data(:,1:5)) Data(:,6:8) log10(Data(:,9:11))];
% figure
% imagesc(Data2)

clear Data_Hab Data_TestPre Data_TestPost params Data

% Mouse_names = {'M688', 'M777', 'M849', 'M1144', 'M1146', 'M1147', 'M1171', 'M9184', 'M9205', 'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226'};
Mouse_names = {'M688', 'M777', 'M849', 'M1144', 'M1146', 'M1147', 'M1170', 'M1171', 'M9184', 'M9205', 'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226', 'M739', 'M779', 'M893', 'M1189', 'M1393'};
Var={'thigmo','speed & dir pers','motion inertia','beta','p1','p2','p3','gamma','k','bp','Wm','Wnm'};

cd('/home/mobs/Desktop/Elisa/Matlab_variables')
% load('PreTest_all_optimized_model_param.mat')
% load('Hab_all_optimized_model_param.mat')
% load('behavior_2be_predict.mat')
load('behavior_2be_predict_2.mat')

% load('Hab_all_optimized_model_param_ALL.mat')
load('Pre_all_optimized_model_param_ALL.mat')
load('Post_all_optimized_model_param_ALL.mat')
% Data=[M688 ; M777 ; M849 ; M1144 ; M1146 ; M1147 ; M1171 ; M9184 ; M9205 ; M1391 ; M1392 ; M1394 ; M1224 ; M1225 ; M1226];

%% on the interest of applying some transformations on variables
% figure
% subplot(121)
% PlotCorrelations_BM(Data(:,3),Data(:,12)')
% axis square, axis xy
% xlabel('motion inertia'), ylabel('Wnm')
% title('regular scale')
% 
% subplot(122)
% PlotCorrelations_BM(log10(Data(:,3)),log10(Data(:,12))')
% axis square, axis xy
% xlabel('motion inertia'), ylabel('Wnm')
% title('log scale')
% 
% a=suptitle('On the interest of applying some transformations on variables'); a.FontSize=20;


% figure
% PlotCorrelations_BM(log10(Data_Hab(5,:)),log10(Data_TestPre(5,:)))
% axis square, axis xy
% xlabel('motion inertia, Hab'), ylabel('motion inertia, TestPre')
% title('Correlations variables Hab-TestPre')



%% Box-cox Hab All
% % clear Data_Hab Data_TestPre Data_TestPost params Data
% clear all
Mouse_names = {'M688', 'M777', 'M849', 'M1144', 'M1146', 'M1147', 'M1170', 'M1171', 'M9184', 'M9205', 'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226', 'M739', 'M779', 'M893', 'M1189', 'M1393'};
Var={'thigmo','speed & dir pers','motion inertia','beta','p1','p2','p3','gamma','k','bp','Wm','Wnm'};

cd('/home/mobs/Desktop/Elisa/Matlab_variables')
load('behavior_2be_predict_2.mat')
load('Hab_all_optimized_model_param_ALL_.mat');

% Data_Hab = load('Hab_all_optimized_model_param_ALL.mat');
% params = [beta, p1", "p2", "p3", "gamma", "k", "bp", "Wm", "Wnm", "thigmotaxis", "directpersist", "immobility"];
params = [beta; p1; p2; p3; gamma; k; bp; Wm; Wnm; thigmotaxis; direct_persist; immobility];
% A = load('Hab_all_optimized_model_param_ALL.mat');
% Data_Hab=[A.M688 ; A.M777 ; A.M849 ; A.M1144 ; A.M1146 ; A.M1147; A.M1170, A.M1171 ; A.M9184 ; A.M9205 ; A.M1391 ; A.M1392 ; A.M1394 ;  A.M1224 ; A.M1225; A.M1226; A.M739; A.M779; A.M893; A.M1189; A.M1393'];
% Data_Hab=[A.M688 ; A.M777 ; A.M849 ; A.M1144 ; A.M1146 ; A.M1147; A.M1171 ; A.M9184 ; A.M9205 ; A.M1391 ; A.M1392 ; A.M1394 ;  A.M1224 ; A.M1225; A.M1226];
% Behav_measur = double(cat(1, all_freez_cond_all, all_stim_free, thigmo_cond_free, learning_rate, diff_occup_shock_zone_post_pre))';
Behav_measur = [double(all_freez_cond_all)' double(all_stim_free)' thigmo_cond_free' learning_rate' double(diff_occup_shock_zone_post_pre)'];

name_bm = ["all freez cond all", "all stim free", "thigmo cond free", "learning rate", "diff occup shock zone post pre"];
% name_bm = ["learning rate"];


figure
% Data = Data_Hab;
color = jet(12);
LamVals = (-10:0.05:10);
best_RVal_Hab = zeros(length(name_bm), length(params(:, 1)), 2);

for bm_ = 1:length(name_bm)
    subplot(2, 3, bm_);
    
    for param = 1:length(params(:, 1))
        all_lambda = zeros(length(LamVals), 2);
        RVal = zeros(length(LamVals), 1);

        for l = 1:length(LamVals)
            lam = LamVals(l);
            
            if lam ==0
                X = log(abs(params(param, :)));
            else
                X = ((abs(params(param, :)).^lam)-1)/lam;
            end
            Y=log(abs(Behav_measur(:, bm_)));

            Y(isinf(X))=[];
            X(isinf(X))=[];

            [R,P]=corrcoef(X',Y);
            
            all_lambda(l, 1) = lam;
            all_lambda(l, 2) = abs(R(2, 1));
            RVal(l) = R(2, 1);
        end
        [l_max, id_l_max] = max(all_lambda(:, 2));
        best_RVal_Hab(bm_, param, 1) = l_max;
        best_RVal_Hab(bm_, param, 2) = all_lambda(id_l_max);

        plot(LamVals, RVal, 'color', color(param, :), 'linewidth',2, 'DisplayName', Var{param}), hold on;
        xlabel('Coefficient lambda');
        ylabel('Pearson coefficient (R)');
    end
    title(strcat('Hab All -', ' ', name_bm(bm_)));
    ylim([-1,1]);
end
% add a bit space to the figure
fig = gcf;
fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend(Var, 'Location','northeastoutside');
Lgnd.Position(1) = 0.75;
Lgnd.Position(2) = 0.01;
%%

% A = load('Hab_all_optimized_model_param.mat');
% Data_Hab=[A.M688 ; A.M777 ; A.M849 ; A.M1144 ; A.M1146 ; A.M1147; A.M1171 ; A.M9184 ; A.M9205 ; A.M1391 ; A.M1392 ; A.M1394 ;  A.M1224 ; A.M1225; A.M1226];
% figure
% Data = Data_Hab;
% color = jet(12);
% LamVals = (-10:0.05:10);
% best_RVal_Hab = zeros(length(name_bm), length(Data(1, :)), 2);
% 
% for bm_ = 1:length(name_bm)
%     subplot(2, 3, bm_);
%     
%     for param = 1:length(Data(1, :))
%         all_lambda = zeros(length(LamVals), 2);
%         RVal = zeros(length(LamVals), 1);
% 
%         for l = 1:length(LamVals)
%             lam = LamVals(l);
%             
%             if lam ==0
%                 X = log(Data(:,param));
%             else
%                 X = ((Data(:,param).^lam)-1)/lam;
%             end
%             Y=log(abs(Behav_measur(:, bm_)));
% 
%             Y(isinf(X))=[];
%             X(isinf(X))=[];
% 
%             [R,P]=corrcoef(X',Y');
%             
%             all_lambda(l, 1) = lam;
%             all_lambda(l, 2) = abs(R(2, 1));
%             RVal(l) = R(2, 1);
%         end
%         [l_max, id_l_max] = max(all_lambda(:, 2));
%         best_RVal_Hab(bm_, param, 1) = l_max;
%         best_RVal_Hab(bm_, param, 2) = all_lambda(id_l_max);
% 
%         plot(LamVals, RVal, 'color', color(param, :), 'linewidth',2, 'DisplayName', Var{param}), hold on;
%         xlabel('Coefficient lambda');
%         ylabel('Pearson coefficient (R)');
%     end
%     title(strcat('Hab All -', ' ', name_bm(bm_)));
%     ylim([-1,1]);
% end
% % add a bit space to the figure
% fig = gcf;
% fig.Position(3) = fig.Position(3) + 250;
% % add legend
% Lgnd = legend(Var, 'Location','northeastoutside');
% Lgnd.Position(1) = 0.75;
% Lgnd.Position(2) = 0.01;
% 

%% Box-cox TestPre All
% clear beta p1 p2 p3 gamma k bp Wm Wnm thigmotaxis direct_persist immobility
load('behavior_2be_predict_2.mat')
% clear Data_Hab Data_TestPre Data_TestPost params Data
Data_TestPre = load('Pre_all_optimized_model_param_ALL_.mat');
% params = [beta, p1", "p2", "p3", "gamma", "k", "bp", "Wm", "Wnm", "thigmotaxis", "directpersist", "immobility"];
params = [beta; p1; p2; p3; gamma; k; bp; Wm; Wnm; thigmotaxis; direct_persist; immobility];
% A = load('Hab_all_optimized_model_param_ALL.mat');
% Data_Hab=[A.M688 ; A.M777 ; A.M849 ; A.M1144 ; A.M1146 ; A.M1147; A.M1170, A.M1171 ; A.M9184 ; A.M9205 ; A.M1391 ; A.M1392 ; A.M1394 ;  A.M1224 ; A.M1225; A.M1226; A.M739; A.M779; A.M893; A.M1189; A.M1393'];
% Data_Hab=[A.M688 ; A.M777 ; A.M849 ; A.M1144 ; A.M1146 ; A.M1147; A.M1171 ; A.M9184 ; A.M9205 ; A.M1391 ; A.M1392 ; A.M1394 ;  A.M1224 ; A.M1225; A.M1226];
% Behav_measur = double(cat(1, all_freez_cond_all, all_stim_free, thigmo_cond_free, learning_rate, diff_occup_shock_zone_post_pre))';
Behav_measur = [double(all_freez_cond_all)' double(all_stim_free)' thigmo_cond_free' learning_rate' double(diff_occup_shock_zone_post_pre)'];

name_bm = ["all freez cond all", "all stim free", "thigmo cond free", "learning rate", "diff occup shock zone post pre"];
% name_bm = ["learning rate"];


figure
Data = Data_TestPre;
color = jet(12);
LamVals = (-10:0.05:10);
best_RVal_Pre = zeros(length(name_bm), length(params(:, 1)), 2);

for bm_ = 1:length(name_bm)
    subplot(2, 3, bm_);
    
    for param = 1:length(params(:, 1))
        all_lambda = zeros(length(LamVals), 2);
        RVal = zeros(length(LamVals), 1);

        for l = 1:length(LamVals)
            lam = LamVals(l);
            
            if lam ==0
                X = log(abs(params(param, :)));
            else
                X = ((abs(params(param, :)).^lam)-1)/lam;
            end
            Y=log(abs(Behav_measur(:, bm_)));

            Y(isinf(X))=[];
            X(isinf(X))=[];

            [R,P]=corrcoef(X',Y);
            
            all_lambda(l, 1) = lam;
            all_lambda(l, 2) = abs(R(2, 1));
            RVal(l) = R(2, 1);
        end
        [l_max, id_l_max] = max(all_lambda(:, 2));
        best_RVal_Pre(bm_, param, 1) = l_max;
        best_RVal_Pre(bm_, param, 2) = all_lambda(id_l_max);

        plot(LamVals, RVal, 'color', color(param, :), 'linewidth',2, 'DisplayName', Var{param}), hold on;
        xlabel('Coefficient lambda');
        ylabel('Pearson coefficient (R)');
    end
    title(strcat('TestPre All -', ' ', name_bm(bm_)));
    ylim([-1,1]);
end
% add a bit space to the figure
fig = gcf;
fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend(Var, 'Location','northeastoutside');
Lgnd.Position(1) = 0.75;
Lgnd.Position(2) = 0.01;


%%
clear A Data
B=load('PreTest_all_optimized_model_param.mat');
Data_TestPre=[B.M688 ; B.M777 ; B.M849 ; B.M1144 ; B.M1146 ; B.M1147 ; B.M1171 ; B.M9184 ; B.M9205 ; B.M1391 ; B.M1392 ; B.M1394 ; B.M1224 ; B.M1225 ; B.M1226];

Behav_measur = double(cat(1, all_freez_cond_all, all_stim_free, thigmo_cond_free, learning_rate, diff_occup_shock_zone_post_pre))';
name_bm = ["all freez cond all", "all stim free", "thigmo cond free", "learning rate", "diff occup shock zone post pre"];

figure
Data = Data_TestPre;
color = jet(12);
LamVals = (-10:0.05:10);
best_RVal_Pre = zeros(length(name_bm), length(Data(1, :)), 2);

for bm_ = 1:length(name_bm)
    subplot(2, 3, bm_)
    
    for param = 1:length(Data(1, :))
        all_lambda = zeros(length(LamVals), 2);
        RVal = zeros(length(LamVals), 1);

        for l = 1:length(LamVals)
            lam = LamVals(l);
            
            if lam ==0
                X = log(Data(:,param));
            else
                X = ((Data(:,param).^lam)-1)/lam;
            end
            Y=log(abs(Behav_measur(:,bm_)));

            Y(isinf(X))=[];
            X(isinf(X))=[];

            [R,P]=corrcoef(X',Y');
            
            all_lambda(l, 1) = lam;
            all_lambda(l, 2) = abs(R(2, 1));
            RVal(l) = R(2, 1);

        end 
        [l_max, id_l_max] = max(all_lambda(:, 2));
        best_RVal_Pre(bm_, param, 1) = l_max;
        best_RVal_Pre(bm_, param, 2) = all_lambda(id_l_max);
        
        plot(LamVals, RVal, 'color', color(param, :), 'linewidth',2, 'DisplayName', Var{param}), hold on;
        xlabel('Coefficient lambda')
        ylabel('Pearson coefficient (R)')
    end
    title(strcat('TestPre All -', ' ', name_bm(bm_)))
    ylim([-1,1]);
end
% add a bit space to the figure
fig = gcf;
fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend(Var, 'Location','northeastoutside');
Lgnd.Position(1) = 0.75;
Lgnd.Position(2) = 0.01;


%% Box-cox TestPost All
% clear Data_Hab Data_TestPre Data_TestPost params Data
% clear beta p1 p2 p3 gamma k bp Wm Wnm thigmotaxis direct_persist immobility
load('behavior_2be_predict_2.mat')
Data_TestPost = load('Post_all_optimized_model_param_ALL_.mat');
% params = [beta, p1", "p2", "p3", "gamma", "k", "bp", "Wm", "Wnm", "thigmotaxis", "directpersist", "immobility"];
params = [beta; p1; p2; p3; gamma; k; bp; Wm; Wnm; thigmotaxis; direct_persist; immobility];
% A = load('Hab_all_optimized_model_param_ALL.mat');
% Data_Hab=[A.M688 ; A.M777 ; A.M849 ; A.M1144 ; A.M1146 ; A.M1147; A.M1170, A.M1171 ; A.M9184 ; A.M9205 ; A.M1391 ; A.M1392 ; A.M1394 ;  A.M1224 ; A.M1225; A.M1226; A.M739; A.M779; A.M893; A.M1189; A.M1393'];
% Data_Hab=[A.M688 ; A.M777 ; A.M849 ; A.M1144 ; A.M1146 ; A.M1147; A.M1171 ; A.M9184 ; A.M9205 ; A.M1391 ; A.M1392 ; A.M1394 ;  A.M1224 ; A.M1225; A.M1226];
% Behav_measur = double(cat(1, all_freez_cond_all, all_stim_free, thigmo_cond_free, learning_rate, diff_occup_shock_zone_post_pre))';
Behav_measur = [double(all_freez_cond_all)' double(all_stim_free)' thigmo_cond_free' learning_rate' double(diff_occup_shock_zone_post_pre)'];

name_bm = ["all freez cond all", "all stim free", "thigmo cond free", "learning rate", "diff occup shock zone post pre"];
% name_bm = ["learning rate"];


figure
Data = Data_TestPost;
color = jet(12);
LamVals = (-10:0.05:10);
best_RVal_Post = zeros(length(name_bm), length(params(:, 1)), 2);

for bm_ = 1:length(name_bm)
    subplot(2, 3, bm_);
    
    for param = 1:length(params(:, 1))
        all_lambda = zeros(length(LamVals), 2);
        RVal = zeros(length(LamVals), 1);

        for l = 1:length(LamVals)
            lam = LamVals(l);
            
            if lam ==0
                X = log(abs(params(param, :)));
            else
                X = ((abs(params(param, :)).^lam)-1)/lam;
            end
            Y=log(abs(Behav_measur(:, bm_)));

            Y(isinf(X))=[];
            X(isinf(X))=[];

            [R,P]=corrcoef(X',Y);
            
            all_lambda(l, 1) = lam;
            all_lambda(l, 2) = abs(R(2, 1));
            RVal(l) = R(2, 1);
        end
        [l_max, id_l_max] = max(all_lambda(:, 2));
        best_RVal_Post(bm_, param, 1) = l_max;
        best_RVal_Post(bm_, param, 2) = all_lambda(id_l_max);

        plot(LamVals, RVal, 'color', color(param, :), 'linewidth',2, 'DisplayName', Var{param}), hold on;
        xlabel('Coefficient lambda');
        ylabel('Pearson coefficient (R)');
    end
    title(strcat('TestPost All -', ' ', name_bm(bm_)));
    ylim([-1,1]);
end
% add a bit space to the figure
fig = gcf;
fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend(Var, 'Location','northeastoutside');
Lgnd.Position(1) = 0.75;
Lgnd.Position(2) = 0.01;

%%
clear A B Data
C=load('PostTest_all_optimized_model_param.mat');
Data_TestPost=[C.M688 ; C.M777 ; C.M849 ; C.M1144 ; C.M1146 ; C.M1147 ; C.M1171 ; C.M9184 ; C.M9205 ; C.M1391 ; C.M1392 ; C.M1394 ; C.M1224 ; C.M1225 ; C.M1226];

Behav_measur = double(cat(1, all_freez_cond_all, all_stim_free, thigmo_cond_free, learning_rate, diff_occup_shock_zone_post_pre))';
name_bm = ["all freez cond all", "all stim free", "thigmo cond free", "learning rate", "diff occup shock zone post pre"];

figure
ax = gca;
Data = Data_TestPost;
color = jet(12);
LamVals = (-10:0.05:10);
best_RVal_Post = zeros(length(name_bm), length(Data(1, :)), 2);

for bm_ = 1:length(name_bm)
    subplot(2, 3, bm_)
    
    for param = 1:length(Data(1, :))
        all_lambda = zeros(length(LamVals), 2);
        RVal = zeros(length(LamVals), 1);

        for l = 1:length(LamVals)
            lam = LamVals(l);
            
            if lam ==0
                X = log(Data(:,param));
            else
                X = ((Data(:,param).^lam)-1)/lam;
            end
            Y=log(abs(Behav_measur(:,bm_)));

            Y(isinf(X))=[];
            X(isinf(X))=[];

            [R,P]=corrcoef(X',Y);
            
            all_lambda(l, 1) = lam;
            all_lambda(l, 2) = abs(R(2, 1));
            RVal(l) = R(2, 1);
        end
        [l_max, id_l_max] = max(all_lambda(:, 2));
        best_RVal_Post(bm_, param, 1) = l_max;
        best_RVal_Post(bm_, param, 2) = all_lambda(id_l_max);

        plot(LamVals, RVal, 'color', color(param, :), 'linewidth',2, 'DisplayName', Var{param}), hold on;
        xlabel('Coefficient lambda');
        ylabel('Pearson coefficient (R)');
    end
    title(strcat('TestPost All -', ' ', name_bm(bm_)));
    ylim([-1,1])
end
% add a bit space to the figure
fig = gcf;
fig.Position(3) = fig.Position(3) + 250;
% add legend
Lgnd = legend(Var, 'Location','northeastoutside');
Lgnd.Position(1) = 0.75;
Lgnd.Position(2) = 0.01;

%% select the best lambda for all the parameter and bm across the sessions
params = [beta; p1; p2; p3; gamma; k; bp; Wm; Wnm; thigmotaxis; direct_persist; immobility];

overall_best_RVal = zeros(length(name_bm), length(Data(1, :)));
overall_best_lambda = zeros(length(name_bm), length(Data(1, :)));

for b=1:length(name_bm)
%     for p=1:length(Data(1, :))
    for p=1:length(params(:, 1))

        all_v = cat(1, best_RVal_Hab(b, p, :), best_RVal_Pre(b, p, :), best_RVal_Post(b, p, :));        
        [l_max, id_l_max] = max(all_v(:, 1));
        overall_best_RVal(b, p) = all_v(id_l_max, 1);
        overall_best_lambda(b, p) = all_v(id_l_max, 2);

    end
end

%% compute corr

All_corr = zeros(length(name_bm), length(params(:, 1)));
All_p = zeros(length(name_bm), length(params(:, 1)));
% Data = Data_Hab
for b=1:length(name_bm)
    for p=1:length(params(:, 1))
        lam = overall_best_lambda(b, p)
        disp(lam);
        if lam ==0
            X = log(abs(params(param, :)));
        else
            X = ((abs(params(param, :)).^lam)-1)/lam;
        end
    Y=log(abs(Behav_measur(:,bm_)));
    Y(isinf(X))=[];
    X(isinf(X))=[];
    [R,P]=corrcoef(X',Y);

%     [Data_corr,pv] = corr(X, Y, 'type','pearson');
%     All_corr(b, p) = Data_corr;
%     All_p(b, p) = pv;
    All_corr(b, p) = R(2, 1);
    All_p(b, p) = P(2, 1);
    
    
%     figure
%     PlotCorrelations_BM(X, Y')
%     axis square, axis xy
%     xlabel(strcat(Var(p), ', Hab')), ylabel(strcat(name_bm(b), ', TestPre'))
%     title('Correlations model parameters - behavioral metrics')    
    end    
end


%% 
% 
% 
%     for param = 1:length(params(:, 1))
%         all_lambda = zeros(length(LamVals), 2);
%         RVal = zeros(length(LamVals), 1);
% 
%         for l = 1:length(LamVals)
%             lam = LamVals(l);
%             
%             if lam ==0
%                 X = log(abs(params(param, :)));
%             else
%                 X = ((abs(params(param, :)).^lam)-1)/lam;
%             end
%             Y=log(abs(Behav_measur(:, bm_)));

All_corr = zeros(length(name_bm), length(Data(1, :)));
All_p = zeros(length(name_bm), length(Data(1, :)));
Data = Data_Hab
for b=1:length(name_bm)
    for p=1:length(Data(1, :))
        lam = overall_best_lambda(b, p)
        if lam ==0
            X = log(Data(:,param));
        else
            X = ((Data(:,param).^lam)-1)/lam;
        end
    Y=log(abs(Behav_measur(:,bm_)));
    Y(isinf(X))=[];
    X(isinf(X))=[];
    [R,P]=corrcoef(X',Y');

%     [Data_corr,pv] = corr(X, Y, 'type','pearson');
%     All_corr(b, p) = Data_corr;
%     All_p(b, p) = pv;
    All_corr(b, p) = R(2, 1);
    All_p(b, p) = P(2, 1);
    
    
%     figure
%     PlotCorrelations_BM(X, Y')
%     axis square, axis xy
%     xlabel(strcat(Var(p), ', Hab')), ylabel(strcat(name_bm(b), ', TestPre'))
%     title('Correlations model parameters - behavioral metrics')    
    end    
end

%% plot

% [Data_corr_ordered , ~ , ~ , v] = OrderMatrix_EM(All_corr);
[rows,cols] = find(All_p<.05);

figure
subplot(221)
imagesc(All_corr)
colormap redblue
plot(rows,cols,'*k')
axis square, axis xy
yticks(1:length(name_bm)), yticklabels(name_bm), xtickangle(45);
% xticks(1:length(Data(1, :))), xticklabels(Var);
xticks(1:length(params(:, 1))), xticklabels(Var);
title('Correlation matrix on model parameters');

colorbar
% 
% % subplot(122)
% imagesc(All_corr)
% hold on
% axis square, axis xy
% xticks(1:12), xticklabels(Var), xtickangle(45)
% yticks(1:12), yticklabels(Var)
% caxis([-1 1])

subplot(222)
[rlvm, frvals, frvecs1, trnsfrmd1, mn, dv] = pca(All_corr);
App_Data1 = trnsfrmd1(:,1) * frvecs1(:,1)';
ylabel('% variance explained')
xticklabels({'λ1','λ2','λ3','λ4'})

subplot(223)
imagesc(App_Data1)
axis square, axis xy
yticks(1:length(name_bm)), yticklabels(name_bm), xtickangle(45);
xticks(1:length(params(:, 1))), xticklabels(Var);
title('λ1 x PC1')    

a=suptitle('Global approach for model parameters using matrices correlations, Hab-all'); a.FontSize=20;


% 
% subplot(247)
% [rlvm, frvals, frvecs2, trnsfrmd2, mn, dv] = pca(Data_corr4);
% App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
% ylabel('% variance explained')
% xticklabels({'λ1','λ2','λ3','λ4'}
% 
% subplot(246)
% imagesc(Data_corr4)
% hold on
% plot(rows4,cols4,'*k')
% axis square, axis xy
% xticks(1:15), xticklabels(Mouse_names(v2)), xtickangle(45)
% yticks(1:15), yticklabels(Mouse_names(v2))
% caxis([-1 1])
% title('Correlation matrix on mice')
% % 
% subplot(247)
% [rlvm, frvals, frvecs2, trnsfrmd2, mn, dv] = pca(Data_corr4);
% App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
% ylabel('% variance explained')
% xticklabels({'λ1','λ2','λ3','λ4'})
% 
% subplot(248)
% imagesc(App_Data2)
% axis square, axis xy
% xticks(1:15), xticklabels(Mouse_names(v2)), xtickangle(45)
% yticks(1:15), yticklabels(Mouse_names(v2))
% title('λ1 x PC1')



%%

%% plot

% [Data_corr_ordered , ~ , ~ , v] = OrderMatrix_EM(All_corr);
[rows,cols] = find(All_p<.05);

figure
subplot(221)
imagesc(All_corr)
colormap redblue
plot(rows,cols,'*k')
axis square, axis xy
yticks(1:length(name_bm)), yticklabels(name_bm), xtickangle(45);
% xticks(1:length(Data(1, :))), xticklabels(Var);
xticks(1:length(params(:, 1))), xticklabels(Var);
title('Correlation matrix on model parameters');

colorbar
% 
% % subplot(122)
% imagesc(All_corr)
% hold on
% axis square, axis xy
% xticks(1:12), xticklabels(Var), xtickangle(45)
% yticks(1:12), yticklabels(Var)
% caxis([-1 1])

subplot(222)
[rlvm, frvals, frvecs1, trnsfrmd1, mn, dv] = pca(All_corr);
App_Data1 = trnsfrmd1(:,1) * frvecs1(:,1)';
ylabel('% variance explained')
xticklabels({'λ1','λ2','λ3','λ4'})

subplot(223)
imagesc(App_Data1)
axis square, axis xy
yticks(1:length(name_bm)), yticklabels(name_bm), xtickangle(45);
xticks(1:length(params(:, 1))), xticklabels(Var);
title('λ1 x PC1')    

a=suptitle('Global approach for model parameters using matrices correlations, Hab-all'); a.FontSize=20;


% 
% subplot(247)
% [rlvm, frvals, frvecs2, trnsfrmd2, mn, dv] = pca(Data_corr4);
% App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
% ylabel('% variance explained')
% xticklabels({'λ1','λ2','λ3','λ4'}
% 
% subplot(246)
% imagesc(Data_corr4)
% hold on
% plot(rows4,cols4,'*k')
% axis square, axis xy
% xticks(1:15), xticklabels(Mouse_names(v2)), xtickangle(45)
% yticks(1:15), yticklabels(Mouse_names(v2))
% caxis([-1 1])
% title('Correlation matrix on mice')
% % 
% subplot(247)
% [rlvm, frvals, frvecs2, trnsfrmd2, mn, dv] = pca(Data_corr4);
% App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
% ylabel('% variance explained')
% xticklabels({'λ1','λ2','λ3','λ4'})
% 
% subplot(248)
% imagesc(App_Data2)
% axis square, axis xy
% xticks(1:15), xticklabels(Mouse_names(v2)), xtickangle(45)
% yticks(1:15), yticklabels(Mouse_names(v2))
% title('λ1 x PC1')

%% figures new data

figure
subplot(241)
imagesc(X)
colormap redblue
% axis square, axis xy
yticks(1:length(name_bm)), yticklabels(name_bm), xtickangle(45);
xticks(1:length(Data(1, :))), xticklabels(Var);
colorbar
title('Hab')

subplot(245)
imagesc(Y)
% axis square, axis xy
yticks(1:length(name_bm)), yticklabels(name_bm), xtickangle(45);
xticks(1:length(Data(1, :))), xticklabels(Var);
title('TestPre')


%%


% imagesc(All_corr)
figure
imagesc(All_corr)
colormap redblue
axis square, axis xy
yticks(1:length(name_bm)), yticklabels(name_bm), xtickangle(45);
xticks(1:length(Data(1, :))), xticklabels(Var);
colorbar
% title('Behavioral measures by mouse')


[Data_corr_ordered , ~ , ~ , v] = OrderMatrix_BM(All_corr);
imagesc(Data_corr_ordered)
hold on
plot(rows,cols,'*k')

figure
[rlvm, frvals, frvecs1, trnsfrmd1, mn, dv] = pca(Data_corr_ordered);
App_Data = trnsfrmd1(:,1) * frvecs1(:,1)';
ylabel('% variance explained')
xticklabels({'λ1','λ2','λ3','λ4'})

imagesc(App_Data)
axis square, axis xy
xticks(1:12), xticklabels(Var(v)), xtickangle(45)
yticks(1:12), yticklabels(Var(v))
title('λ1 x PC1')    




%   Data_log = Behav_measur
%         [Data_corr1,p1] = corr(double(Data_log), 'type','pearson');
%         [Data_corr2,p2] = corr(double(Data_log), 'type','pearson');
%     end
%     
%     [Data_corr3 , ~ , ~ , v] = OrderMatrix_BM(Data_corr1);
%     [Data_corr4 , ~ , ~ , v2] = OrderMatrix_BM(Data_corr2);
%     
%     [rows1,cols1] = find(p1<.05);
%     [rows2,cols2] = find(p2<.05);
%     [rows3,cols3] = find(p1(v,v)<.05);
%     [rows4,cols4] = find(p2(v2,v2)<.05);
%     


%%
% figure
% subplot(3,3,[2,3,5,6])
% cols = plasma(5);
% lam_Gam = LamVals(ind_Gam);
% for k=1:4
%     if lam_Gam ==0
%         X = log(AllGamma_OB(AllMice==k));
%     else
%         X = ((AllGamma_OB(AllMice==k).^lam_Gam)-1)/lam_Gam;
%     end
%     plot(X,log(AllReac(AllMice==k)),'.','color',cols(k,:),'MarkerSize',20), hold on
% end
% if lam_Gam ==0
%     X = log([AllGamma_OB]);
% else
%     X = ([AllGamma_OB].^lam_Gam-1)/lam_Gam;
% end
% [cf_,good_]=LinearFit(X,log([AllReac]));
% CF=coeffvalues(cf_);
% plot(X,CF(1)*X+CF(2),'color',[0.6 0.6 0.6],'linewidth',4)
% xlim([-4 3])
% ylim([13 21])
% set(gca,'FontSize',15,'LineWidth',1.5)
% box off


    
Data_log = Behav_measur
Data_log=Data_Hab;
cc = all_freez_cond_all';
Data_log(1:15, 16) = all_freez_cond_all;

%Data_log = cat(1, Data_Hab, all_freez_cond_all);
[Data_corr1,p1] = corr(double(Data_log), 'type','pearson');
imagesc(Data_corr1)
% [Data_corr2,p2] = corr(Data_log','type','pearson');

%%

for f=10:10
    clear Data Data1 Data2 Data_log Data_log1 Data_log2 Data_corr1 Data_corr2 Data_corr3 Data_corr4 p1 p2 v v2 rows1 rows2 rows3 rows4 cols1 cols2 cols3 cols4
    
    if f<5
        Data=Data_Hab;
    elseif and(f>4,f<9)
        Data=Data_TestPre;
    elseif f>8
        Data1=Data_Hab;
        Data2=Data_TestPre;
    elseif f == 10
       Data=Behav_measur;  
    end
    
    if or(f==1,f==5)
        % 1) log, pearson
        Data_log=log10(Data);
        [Data_corr1,p1] = corr(Data_log,'type','pearson');
        [Data_corr2,p2] = corr(Data_log','type','pearson');
    elseif or(f==2,f==6)
        % 2) log, spearman
        Data_log=log10(Data);
        [Data_corr1,p1] = corr(Data_log,'type','spearman');
        [Data_corr2,p2] = corr(Data_log','type','spearman');
    elseif or(f==3,f==7)
        % 3) zscore, pearson
        Data_log=zscore(Data);
        [Data_corr1,p1] = corr(Data_log,'type','pearson');
        [Data_corr2,p2] = corr(Data_log','type','pearson');
    elseif or(f==4,f==8)
        % 4) zscore, spearman
        Data_log=zscore(Data);
        [Data_corr1,p1] = corr(Data_log,'type','spearman');
        [Data_corr2,p2] = corr(Data_log','type','spearman');
    elseif f==9
        % 5) Hab/TestPre, log, pearson
        Data_log1=log10(Data1); Data_log2=log10(Data2);
        [Data_corr1,p1] = corr(Data_log1,Data_log2,'type','pearson');
        [Data_corr2,p2] = corr(Data_log1',Data_log2','type','pearson');
    elseif f==10
        Data_log = Behav_measur
        [Data_corr1,p1] = corr(double(Data_log), 'type','pearson');
        [Data_corr2,p2] = corr(double(Data_log), 'type','pearson');
    end
    
    [Data_corr3 , ~ , ~ , v] = OrderMatrix_BM(Data_corr1);
    [Data_corr4 , ~ , ~ , v2] = OrderMatrix_BM(Data_corr2);
    
    [rows1,cols1] = find(p1<.05);
    [rows2,cols2] = find(p2<.05);
    [rows3,cols3] = find(p1(v,v)<.05);
    [rows4,cols4] = find(p2(v2,v2)<.05);
    
    figure
    if f==10
        subplot(341)
        imagesc(Data_log)
        colormap redblue
        axis square, axis xy
        xticks(1:length(Mouse_names)), xticklabels(Mouse_names), xtickangle(45)
        yticks(1:5), yticklabels(['a'; 'b'; 'c'; 'd'; 'e'])
        colorbar
        title('Behavioral measures by mouse')
    elseif f<9
        subplot(141)
        imagesc(Data_log)
        colormap redblue
        axis square, axis xy
        xticks(1:12), xticklabels(Var), xtickangle(45)
        yticks(1:15), yticklabels(Mouse_names)
        colorbar
        title('Parameters values by mouse')
    else
        subplot(241)
        imagesc(Data_log1)
        colormap redblue
        axis square, axis xy
        xticks(1:12), xticklabels(Var), xtickangle(45)
        yticks(1:15), yticklabels(Mouse_names)
        colorbar
        title('Hab')
        
        subplot(245)
        imagesc(Data_log2)
        axis square, axis xy
        xticks(1:12), xticklabels(Var), xtickangle(45)
        yticks(1:15), yticklabels(Mouse_names)
        title('TestPre')
    end
    
    subplot(242)
    imagesc(Data_corr3)
    hold on
    plot(rows3,cols3,'*k')
    axis square, axis xy
    xticks(1:12), xticklabels(Var(v)), xtickangle(45)
    yticks(1:12), yticklabels(Var(v))
    caxis([-1 1])
    title('Correlation matrix on model parameters')
    
    subplot(243)
    [rlvm, frvals, frvecs1, trnsfrmd1, mn, dv] = pca(Data_corr3);
    App_Data1 = trnsfrmd1(:,1) * frvecs1(:,1)';
    ylabel('% variance explained')
    xticklabels({'λ1','λ2','λ3','λ4'})
    
    subplot(244)
    imagesc(App_Data1)
    axis square, axis xy
    xticks(1:12), xticklabels(Var(v)), xtickangle(45)
    yticks(1:12), yticklabels(Var(v))
    title('λ1 x PC1')    
    
    subplot(246)
    imagesc(Data_corr4)
    hold on
    plot(rows4,cols4,'*k')
    axis square, axis xy
    xticks(1:15), xticklabels(Mouse_names(v2)), xtickangle(45)
    yticks(1:15), yticklabels(Mouse_names(v2))
    caxis([-1 1])
    title('Correlation matrix on mice')
    
    subplot(247)
    [rlvm, frvals, frvecs2, trnsfrmd2, mn, dv] = pca(Data_corr4);
    App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
    ylabel('% variance explained')
    xticklabels({'λ1','λ2','λ3','λ4'})
    
    subplot(248)
    imagesc(App_Data2)
    axis square, axis xy
    xticks(1:15), xticklabels(Mouse_names(v2)), xtickangle(45)
    yticks(1:15), yticklabels(Mouse_names(v2))
    title('λ1 x PC1')
end
a=suptitle('Global approach for model parameters using matrices correlations, Hab-TestPre sessions'); a.FontSize=20;


