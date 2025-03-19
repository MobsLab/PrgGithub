function PVal= MakeBehaviourProabFigure_UMaze_CompareGroups(Trans,Trans2)

%% Get all the pvalues and directions
for ii = 1:10
    for kk = 1:10
        PVal(ii,kk) = ranksum(squeeze(Trans(:,ii,kk)),squeeze(Trans2(:,ii,kk)));
        Dir(ii,kk) = nanmean(squeeze(Trans2(:,ii,kk))) - nanmean(squeeze(Trans(:,ii,kk)));
    end
end

%% Plot the two groups
figure
subplot(2,1,1)
MakeBehaviourProabFigure_UMaze(squeeze(nanmean(Trans,1)));
ylim([0.7 2.3])

subplot(2,1,2)
MakeBehaviourProabFigure_UMaze(squeeze(nanmean(Trans2,1)));
ylim([0.7 2.3])

%% add the stars
subplot(2,1,2)
Pval_diag  = diag(PVal);
Dir_diag  = diag(Dir);

for ii = 1:5
    if Pval_diag(ii) < 0.05
        if Dir_diag(ii)<0.05
            text(ii-0.05,1,'<','FontSize',20);
        else
            text(ii-0.05,1,'>','FontSize',20);
        end
    end
    if Pval_diag(ii+5) < 0.05
        if Dir_diag(ii+5)<0
            text(ii-0.05,2,'<','FontSize',20);
        else
            text(ii-0.05,2,'>','FontSize',20);            
        end
    end
end

%% plot the vectors between states
% Fz to act and vice versa
for init_zn = 1:5
    %act to fz
    if PVal(init_zn,init_zn+5)<0.05
        if Dir(init_zn,init_zn+5)<0
            text(init_zn-0.2,1.5,'<','FontSize',20);
        else
            text(init_zn-0.2,1.5,'>','FontSize',20);
        end
    end
    
    if PVal(init_zn+5,init_zn)<0.05
        if Dir(init_zn+5,init_zn)<0
            text(init_zn+0.05,1.5,'<','FontSize',20);
        else
            text(init_zn+0.05,1.5,'>','FontSize',20);
        end
    end
    
end

% one zone to the next
for init_zn = 1:4
    % upwards
    if PVal(init_zn,init_zn+1)<0.05
        if Dir(init_zn,init_zn+1)<0
            text(init_zn+0.5,0.9,1.5,'<','FontSize',20);
        else
            text(init_zn+0.5,0.9,1.5,'>','FontSize',20);
        end
    end
end

for init_zn = 2:5
    % upwards
    if PVal(init_zn,init_zn-1)<0.05
        if Dir(init_zn,init_zn-1)<0
            text(init_zn-0.5,1.1,1.5,'<','FontSize',20);
        else
            text(init_zn-0.5,1.1,1.5,'>','FontSize',20);
        end
    end
end

