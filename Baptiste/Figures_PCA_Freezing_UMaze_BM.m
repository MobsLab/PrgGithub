


function [mu , sigma , eigen_vector , Distance , Line] = Figures_PCA_Freezing_UMaze_BM(Mouse , DATA , Params , Saline , SameAmount , State , General , Line)


%% Initiation
if ~exist('Saline','var')
    Saline=1;
end

if ~exist('SameAmount','var')
    SameAmount=1;
end

if ~exist('State','var')
    State=1;
end

if ~exist('General','var')
    General=0;
end

if ~exist('Line','var')
    Line=0;
end


if and(Saline , ~General)
    mu=NaN; sigma=NaN; eigen_vector=NaN;
end

%% Reequilibrate data
% put same quantity of fz shock/safe active shock/safe
if and(SameAmount , State)
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        ind_to_use{mouse}{1}=and(DATA.(Mouse_names{mouse})(end-1,:)<.5 , DATA.(Mouse_names{mouse})(end,:)>1.5); % active shock
        ind_to_use{mouse}{2}=and(DATA.(Mouse_names{mouse})(end-1,:)>.5 , DATA.(Mouse_names{mouse})(end,:)>1.5); % active safe
        ind_to_use{mouse}{3}=and(DATA.(Mouse_names{mouse})(end-1,:)<.5 , DATA.(Mouse_names{mouse})(end,:)<1.5); % fz shock
        ind_to_use{mouse}{4}=and(DATA.(Mouse_names{mouse})(end-1,:)>.5 , DATA.(Mouse_names{mouse})(end,:)<1.5); % fz shock
        
        for i=1:4
            c(mouse,i) = sum(ind_to_use{mouse}{i}); % min num bin of states
        end
    end
    mice_to_use = min(c')>20;
    Mouse=Mouse(mice_to_use);
    
    clear ind_to_use c Mouse_names
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        ind_to_use{mouse}{1}=and(DATA.(Mouse_names{mouse})(end-1,:)<.5 , DATA.(Mouse_names{mouse})(end,:)>1.5); % active shock
        ind_to_use{mouse}{2}=and(DATA.(Mouse_names{mouse})(end-1,:)>.5 , DATA.(Mouse_names{mouse})(end,:)>1.5); % active safe
        ind_to_use{mouse}{3}=and(DATA.(Mouse_names{mouse})(end-1,:)<.5 , DATA.(Mouse_names{mouse})(end,:)<1.5); % fz shock
        ind_to_use{mouse}{4}=and(DATA.(Mouse_names{mouse})(end-1,:)>.5 , DATA.(Mouse_names{mouse})(end,:)<1.5); % fz shock
        
        for i=1:4
            c(mouse,i) = sum(ind_to_use{mouse}{i});
        end
    end
    
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        DATA2.(Mouse_names{mouse})=[];
        for i=1:4
            clear D, D=DATA.(Mouse_names{mouse})(:,ind_to_use{mouse}{i});
            D = D(:,randperm(length(D))); % chosse random time in this state to be sure to avoid a time effect
            D = D(:,1:min(c(mouse,:)));
            DATA2.(Mouse_names{mouse}) = [DATA2.(Mouse_names{mouse}) D];
        end
    end
    
    clear DATA
    DATA=DATA2;
    clear DATA2
    
    
elseif and(SameAmount , ~State)
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        ind_to_use{mouse}{1}=DATA.(Mouse_names{mouse})(end,:)<.5;  % shock
        ind_to_use{mouse}{2}=DATA.(Mouse_names{mouse})(end,:)>.5;  % safe
        
        for i=1:2
            c(mouse,i) = sum(ind_to_use{mouse}{i}); % min num bin of states
        end
    end
    mice_to_use = min(c')>20;
    Mouse=Mouse(mice_to_use);
    
    clear ind_to_use c Mouse_names
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        ind_to_use{mouse}{1}=DATA.(Mouse_names{mouse})(end,:)<.5;  % shock
        ind_to_use{mouse}{2}=DATA.(Mouse_names{mouse})(end,:)>.5;  % safe
        
        for i=1:2
            c(mouse,i) = sum(ind_to_use{mouse}{i});
        end
    end
    
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        DATA2.(Mouse_names{mouse})=[];
        for i=1:2
            clear D, D=DATA.(Mouse_names{mouse})(:,ind_to_use{mouse}{i});
            D = D(:,randperm(length(D))); % chosse random time in this state to be sure to avoid a time effect
            D = D(:,1:min(c(mouse,:)));
            DATA2.(Mouse_names{mouse}) = [DATA2.(Mouse_names{mouse}) D];
        end
    end
    
    clear DATA
    DATA=DATA2;
    clear DATA2
    
end

% correct if mice are absent
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    if isfield(DATA , Mouse_names{mouse})
        ind(mouse)=1;
    end
end
Mouse=Mouse(logical(ind));
clear Mouse_names

%% Data transformation / Gathering / PCA
% put a log on ob gamma and order
for mouse=1:length(Mouse)    
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    % normalize data if not in the range
    ind=max(DATA.(Mouse_names{mouse})')>20;
    DATA_norm.(Mouse_names{mouse})(ind,:) = log10(DATA.(Mouse_names{mouse})(ind,:));
    DATA_norm.(Mouse_names{mouse})(~ind,:) = DATA.(Mouse_names{mouse})(~ind,:);
    
    [~,b{mouse}] = sort(DATA_norm.(Mouse_names{mouse})(end,:));
    DATA_ordered.(Mouse_names{mouse}) = DATA_norm.(Mouse_names{mouse})(:,b{mouse});
end

% gather
DATA_all=[]; n=0; vec1=ones(1,length(Params));
for mouse=1:length(Mouse)
    
    ind = ~(sum(or(isnan(DATA_ordered.(Mouse_names{mouse})') , DATA_ordered.(Mouse_names{mouse})'==0))==size(DATA_ordered.(Mouse_names{mouse}),2));
    if and(isequal(ind,vec1) , size(DATA_ordered.(Mouse_names{mouse}),2)>20)
        M_pre=DATA_ordered.(Mouse_names{mouse})(ind,:); % remove if not the parameter
        M_pre2=M_pre(:,sum(~isnan(M_pre))==sum(ind)); % remove if missing data for this second parameter
        
        if General
            DATA_all = [DATA_all M_pre2];
        else
            DATA_all = [DATA_all [zscore(M_pre2(1:end-1-State,:)')' ; M_pre2(end-State:end,:)]];
        end
        n=n+1;
        Mouse2(n)=Mouse(mouse);
        
    end
end
disp(['eigen vectors made on ' num2str(n)  ' mice'])
[~,j] = sort(DATA_all(end,:));
DATA_all=DATA_all(:,j);
if State
    [~,j] = sort(DATA_all(end-1,:));
    DATA_all2=DATA_all(:,j);
end


% if drug group, use Saline eigenvector else generate them
if Saline
    if General
        [z,mu,sigma] = zscore(DATA_all(1:end-1-State,:)');
        [Data_corr,~] = corr(z,'type','pearson');
    else
        [Data_corr,~] = corr(DATA_all(1:end-1-State,:)','type','pearson');
    end
    figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close
else
    load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_For_Decoding/final/Data_Physio_Freezing_RipControl_CondPost_2sFullBin.mat',...
        'mu','sigma','eigen_vector')
end


if and(~Saline , and(length(Params)==8 , length(mu)>7))
    mu=mu([1:5 7:8]); sigma=sigma([1:5 7:8]);
end

% PC coordinates
figure
for mouse=1:length(Mouse)
    
    M_Pre{mouse} = DATA_ordered.(Mouse_names{mouse})(1:end-1-State,:);
    if General
        DATA_Ordered_Normalized{mouse} = (M_Pre{mouse}-mu')./sigma';
    else
        DATA_Ordered_Normalized{mouse}=zscore_nan_BM(M_Pre{mouse}')';
    end
    
    DATA_NonOrdered_WithoutTemp{mouse}=DATA_norm.(Mouse_names{mouse})(1:end-1-State,:);
    DATA_NonOrdered_Normalized{mouse}=zscore_nan_BM(DATA_NonOrdered_WithoutTemp{mouse}')';
    
    for pc=1:size(eigen_vector,2)
        for i=1:size(DATA_Ordered_Normalized{mouse} ,2)
            
            ind = ~isnan(DATA_Ordered_Normalized{mouse}(:,i));
            PC_values{pc}{mouse}(i) = (eigen_vector(ind,pc)')*(DATA_Ordered_Normalized{mouse}(ind,i));
            PC_values{pc}{mouse}(PC_values{pc}{mouse}==0)=NaN;
            
            ind = ~isnan(DATA_NonOrdered_Normalized{mouse}(:,i));
            PC_values_NonOrdered{pc}{mouse}(i) = (eigen_vector(ind,pc)')*(DATA_NonOrdered_Normalized{mouse}(ind,i));
            PC_values_NonOrdered{pc}{mouse}(PC_values_NonOrdered{pc}{mouse}==0)=NaN;
            
        end
        
        [CorrTime(mouse,pc),~]=PlotCorrelations_BM(PC_values_NonOrdered{pc}{mouse} , [1:length(PC_values_NonOrdered{pc}{mouse})]);
        [CorrPos(mouse,pc),~]=PlotCorrelations_BM(PC_values{pc}{mouse} , DATA_ordered.(Mouse_names{mouse})(end-State,:));
        if State
            [CorrState(mouse,pc),~]=PlotCorrelations_BM(PC_values{pc}{mouse} , DATA_ordered.(Mouse_names{mouse})(end,:));
        end
    end
end
close

% no renormalisation
% for mouse=1:length(Mouse)
%
%     DATA_NoNorm_WithoutTemp{mouse}=DATA_ordered.(Mouse_names{mouse})([1:3 5:9],:);
%     DATA_NoNorm{mouse}=DATA_NoNorm_WithoutTemp{mouse};
%
%     for i=1:size(DATA_NoNorm{mouse} ,2)
%
%         ind = ~isnan(DATA_NoNorm{mouse}(:,i));
%         PC1_values_NoNorm{mouse}(i) = eig1(ind)'*DATA_NoNorm{mouse}(ind,i);
%         PC1_values_NoNorm{mouse}(PC1_values_NoNorm{mouse}==0)=NaN;
%
%         PC2_values_NoNorm{mouse}(i) = eig2(ind)'*DATA_NoNorm{mouse}(ind,i);
%         PC2_values_NoNorm{mouse}(PC2_values_NoNorm{mouse}==0)=NaN;
%
%     end
% end




%% figures
% each mice individual map, sorted by position
% figure, m=ceil(sqrt(length(Mouse2)));
% for mouse=1:length(Mouse2)
%     Mouse_names2{mouse}=['M' num2str(Mouse2(mouse))];
%     
%     [~,j] = sort(DATA.(Mouse_names2{mouse})(end-1,:));
%     M_pre_pre = DATA.(Mouse_names2{mouse})(:,j);
%     ind = ~(sum(isnan(M_pre_pre'))==size(M_pre_pre,2));
%     M_pre = M_pre_pre(ind,:); % remove if not the parameter
%     M_pre2 = M_pre(:,sum(~isnan(M_pre))==sum(ind)); % remove if missing data for this se(Session_type{sess})
%     
%     M=corr(zscore(M_pre2(1:end-1-State,:)')');
%     subplot(4,5,mouse)
%     imagesc(M)
%     axis square
%     title(Mouse_names2{mouse})
% end
% colormap redblue
% colorbar


if State
    figure
    subplot(621)
    plot(DATA_all(end,:))
    xlabel('freezing bin #'), xlim([0 length(DATA_all)])
    box off
    
    subplot(6,2,[3 5 7 9 11])
    imagesc(corr(zscore(DATA_all(1:end-1-State,:)')'));
    caxis([-1 1])
    axis square
    
    
    subplot(622)
    plot(DATA_all2(end-1,:))
    xlabel('freezing bin #'), xlim([0 length(DATA_all)])
    box off
    
    subplot(6,2,[4 6 8 10 12])
    imagesc(corr(zscore(DATA_all2(1:end-1-State,:)')'));
    caxis([-1 1])
    axis square
    colormap redblue
else
%     figure
%     subplot(611)
%     plot(DATA_all(end,:))
%     xlabel('freezing bin #'), xlim([0 length(DATA_all)])
%     box off
%     
%     subplot(6,1,2:6)
%     imagesc(corr(zscore(DATA_all(1:end-1,:)')'));
%     caxis([-1 1])
%     axis square
%     colormap redblue
end

% BM figures overview
if General
    Correlations_Matrices_Data_BM(zscore(DATA_all(1:end-1-State,:)')' , Params(1:end-1-State) , Mouse_names);
else
    Correlations_Matrices_Data_BM(DATA_all(1:end-1-State,:) , Params(1:end-1-State) , Mouse_names);
end

% Playing with PCs
% 1) PC2 = f(PC1)
% figure
% for mouse=1:length(Mouse)
%     subplot(m,round(m*1.5),mouse)
%     scatter(PC_values{1}{mouse},PC_values{2}{mouse},[],1-DATA_ordered.(Mouse_names{mouse})(10,:),'filled','SizeData',round(30/log(length(PC_values{1}{mouse}))))
%     caxis([0 1])
% end
% colormap redblue


% 2) t = f(PC1)
% figure
% for mouse=1:length(Mouse)
%     subplot(m,round(m*1.5),mouse)
%     scatter(PC_values_NonOrdered{mouse},[1:length(PC_values_NonOrdered{mouse})],[],1-DATA_norm.(Mouse_names{mouse})(10,:),'filled','SizeData',round(30/log(length(PC_values{pc}{mouse}))))
%     caxis([0 1])
% end
% colormap redblue



% one point by mouse
for pc=1:size(eigen_vector,2)
    for mouse=1:length(Mouse)
        
        ind_shock = DATA_ordered.(Mouse_names{mouse})(end-State,:)<.5;
        X_shock{pc}(mouse) = nanmedian(PC_values{pc}{mouse}(ind_shock));
        
        ind_safe = DATA_ordered.(Mouse_names{mouse})(end-State,:)>.5;
        X_safe{pc}(mouse) = nanmedian(PC_values{pc}{mouse}(ind_safe));
        
        if State
            ind_act = DATA_ordered.(Mouse_names{mouse})(end,:)>1.5;
            X_act{pc}(mouse) = nanmedian(PC_values{pc}{mouse}(ind_act));
            
            ind_freezing = DATA_ordered.(Mouse_names{mouse})(end,:)<1.5;
            X_fz{pc}(mouse) = nanmedian(PC_values{pc}{mouse}(ind_freezing));
            
            
            ind_act_shock = and(DATA_ordered.(Mouse_names{mouse})(end-1,:)<.5 , DATA_ordered.(Mouse_names{mouse})(end,:)>1.5);
            X_act_shock{pc}(mouse) = nanmedian(PC_values{pc}{mouse}(ind_act_shock));
            
            ind_act_safe = and(DATA_ordered.(Mouse_names{mouse})(end-1,:)>.5 , DATA_ordered.(Mouse_names{mouse})(end,:)>1.5);
            X_act_safe{pc}(mouse) = nanmedian(PC_values{pc}{mouse}(ind_act_safe));
            
            ind_fz_shock = and(DATA_ordered.(Mouse_names{mouse})(end-1,:)<.5 , DATA_ordered.(Mouse_names{mouse})(end,:)<1.5);
            X_fz_shock{pc}(mouse) = nanmedian(PC_values{pc}{mouse}(ind_fz_shock));
            
            ind_fz_safe = and(DATA_ordered.(Mouse_names{mouse})(end-1,:)>.5 , DATA_ordered.(Mouse_names{mouse})(end,:)<1.5);
            X_fz_safe{pc}(mouse) = nanmedian(PC_values{pc}{mouse}(ind_fz_safe));
        end
    end
end



if State
    for p=1:2:floor(length(eigen_vector)/2)
        
        figure
        plot(X_act_shock{p},X_act_shock{p+1},'m','Marker','x','LineStyle','none','MarkerSize',10)
        hold on
        plot(X_act_safe{p},X_act_safe{p+1},'c','Marker','x','LineStyle','none','MarkerSize',10)
        plot(X_fz_shock{p},X_fz_shock{p+1},'r','Marker','x','LineStyle','none','MarkerSize',10)
        plot(X_fz_safe{p},X_fz_safe{p+1},'b','Marker','x','LineStyle','none','MarkerSize',10)
        
        plot(nanmedian(X_act_shock{p}),nanmedian(X_act_shock{p+1}),'m','Marker','.','LineStyle','none','MarkerSize',60)
        plot(nanmedian(X_act_safe{p}),nanmedian(X_act_safe{p+1}),'c','Marker','.','LineStyle','none','MarkerSize',60)
        plot(nanmedian(X_fz_shock{p}),nanmedian(X_fz_shock{p+1}),'r','Marker','.','LineStyle','none','MarkerSize',60)
        plot(nanmedian(X_fz_safe{p}),nanmedian(X_fz_safe{p+1}),'b','Marker','.','LineStyle','none','MarkerSize',60)
        axis square
        xlabel(['PC' num2str(p) ' value']), ylabel(['PC' num2str(p+1) ' value'])
        f=get(gca,'Children'); l=legend([f([4 3 2 1])],'active shock','active safe','freezing shock','freezing safe');
        
    end
else
    for p=floor(length(eigen_vector)/2)
        
        figure
        plot(X_shock{1},X_shock{2},'.r','MarkerSize',30)
        hold on
        plot(X_safe{1},X_safe{2},'.b','MarkerSize',30)
        axis square
        xlabel('PC1 value'), ylabel('PC2 value')
        grid on
        
        if ~Line
            
            ok=0;
            while ok<1
                disp('choose 2 points')
                [x,y] = ginput(2);
                line([x(1) x(2)],[y(1) y(2)],'LineStyle','--','Color','r')
                ok = input('ok like this ? 1 for yes ');
            end
            Line=[x ; y];
            
        else
            x=Line(1:2); y=Line(3:4);
            line([x(1) x(2)],[y(1) y(2)],'LineStyle','--','Color','r')
        end
    end
end


% BM figures overview
if General
    Correlations_Matrices_Data_BM(zscore(DATA_all(1:end-1-State,:)')' , Params(1:end-1-State) , Mouse_names);
else
    Correlations_Matrices_Data_BM(DATA_all(1:end-1-State,:) , Params(1:end-1-State) , Mouse_names);
end



for mouse=1:length(Mouse)
    
    Distance{1}(mouse) = GetPointLineDistance(X_shock{1}(mouse),X_shock{2}(mouse),x(1),y(1),x(2),y(2));
    Distance{2}(mouse) = GetPointLineDistance(X_safe{1}(mouse),X_safe{2}(mouse),x(1),y(1),x(2),y(2));
    
end

Cols = {[1 0 0],[0 0 1]};
X = 1:2;
Legends = {'Shock','Safe'};

figure
MakeSpreadAndBoxPlot3_SB(Distance,Cols,X,Legends,'showpoints',0,'paired',1);
hline(0), ylabel('distance to line (a.u.)')


if State
    figure
    subplot(121)
    plot(X_act{1},X_act{2},'.g','MarkerSize',30)
    hold on
    plot(X_fz{1},X_fz{2},'.k','MarkerSize',30)
    axis square
    legend('Active','Freezing')
    xlabel('PC1 value'), ylabel('PC2 value')
    
    subplot(222)
    plot(X_fz_shock{1},X_fz_shock{2},'.r','MarkerSize',30)
    hold on
    plot(X_fz_safe{1},X_fz_safe{2},'.b','MarkerSize',30)
    axis square
    legend('Fz shock','Fz safe')
    xlabel('PC1 value'), ylabel('PC2 value')
    
    subplot(224)
    plot(X_act_shock{1},X_act_shock{2},'.m','MarkerSize',30)
    hold on
    plot(X_act_safe{1},X_act_safe{2},'.c','MarkerSize',30)
    axis square
    legend('Act shock','Act safe')
    xlabel('PC1 value'), ylabel('PC2 value')
end



% Interprate PCs
figure
subplot(1,2+State,1)
imagesc(CorrTime)
xticks(1:6), xticklabels({'PC1','PC2','PC3','PC4','PC5','PC6'})
yticks(25), yticklabels({'Mice'}), ytickangle(90)
title('Correlation with time')
caxis([-1 1])

subplot(1,2+State,2)
imagesc(CorrPos)
xticks(1:6), xticklabels({'PC1','PC2','PC3','PC4','PC5','PC6'})
title('Correlation with position')
caxis([-1 1])

if State
    subplot(1,2+State,2+State)
    imagesc(CorrState)
    xticks(1:6), xticklabels({'PC1','PC2','PC3','PC4','PC5','PC6'})
    title('Correlation with state')
    caxis([-1 1])
end

colormap redblue
