function MakeBehaviourProabFigure_UMaze(Trans,Pvals)

% PVals is optional


%% Plot the states, colored according to stay probability
for init_zn = 1:5
    if Trans(init_zn,init_zn)>0
        scatter(init_zn,1,Trans(init_zn,init_zn)*500,Trans(init_zn,init_zn),'filled')
    end
    hold on
    if Trans(init_zn+5,init_zn+5)>0
        scatter(init_zn,2,Trans(init_zn+5,init_zn+5)*500,Trans(init_zn+5,init_zn+5),'filled')
    end
end
set(gca,'YTick',[1:2],'YTickLabel',{'Act','Fz'},...
    'XTick',[1:5],'XTickLabel',{'Sk','SkCt','Ct','SfCt','Sf'})
colormap(jet)
ylim([0 3])
xlim([0 6])

%% plot the vectors between states
% Fz to act and vice versa
cols = jet(100);
% ContrastFact = 100./max(max(Trans-diag(diag(Trans))));
ContrastFact = 350;
for init_zn = 1:5
    %act to fz
    if Trans(init_zn,init_zn+5)>0
        quiver(init_zn-0.1,1.2,0,0.8,'linewidth',ceil(Trans(init_zn,init_zn+5)*20)+2,'color',cols(ceil(Trans(init_zn,init_zn+5)*ContrastFact),:))
    end
    if Trans(init_zn+5,init_zn)>0
        quiver(init_zn+0.1,1.9,0,-0.8,'linewidth',ceil(Trans(init_zn+5,init_zn)*20)+2,'color',cols(ceil(Trans(init_zn+5,init_zn)*ContrastFact),:))
    end
end

% one zone to the next
for init_zn = 1:4
    % upwards
    if Trans(init_zn,init_zn+1)>0
        quiver(init_zn,0.9,1,0,'linewidth',ceil(Trans(init_zn,init_zn+1)*20)+2,'color',cols(ceil(Trans(init_zn,init_zn+1)*ContrastFact),:))
    end
end

for init_zn = 2:5
    % upwards
    if Trans(init_zn,init_zn-1)>0
        quiver(init_zn,1.1,-1,0,'linewidth',ceil(Trans(init_zn,init_zn-1)*20)+2,'color',cols(ceil(Trans(init_zn,init_zn-1)*ContrastFact),:))
    end
end
colorbar
clim([0.5 1])