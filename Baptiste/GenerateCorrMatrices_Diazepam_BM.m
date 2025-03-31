


A = [ShockZoneEntries_Density.Cond{1} ; ShockZone_Occupancy.Cond{1} ; StimDensity.Cond{1} ; ...
    Thigmo_score.Cond{1} ; FreezingShock_DurProp.Cond{1} ; Freezing_DurProp.Cond{1} ; ...
    FreezingSafe_DurProp.Cond{1} ; -DistTraveled.Cond{1}];

Params = {'SZ entries','SZ occupancy','Shocks',...
    'Thigmotaxis','Fz shock','Fz total','Fz safe','-Dist traveled'};


[z,mu,sigma] = zscore(A');


figure
[coef, pval] = corr(z(:,v1));
% [rows_p,cols_p] = find(pval>.05);
[rows_p,cols_p] = find(pval>1);
for i=1:length(rows_p)
    coef(cols_p(i),rows_p(i)) = 0;
end
for i=1:length(coef)
    coef(i,i) = 1;
end
imagesc(coef)
axis xy, colormap redblue, axis square
xticks([1:20]), yticks([1:20]), xticklabels(Params(v1)), yticklabels(Params(v1)), xtickangle(45)
caxis([-1 1])





load('Temp.mat', 'mu','sigma')
z = ((A-mu')./sigma')';
for pc=1:size(eig1,2)
    for mouse=1:round(size(z,1))
        
        PC_values_all{pc}(mouse) = eig1(:,pc)'*z(mouse,v1)';
        
    end
end

Cols = {[.3, .745, .93],[.85, .325, .098]};
X = 1:2;
Legends = {'Saline','DZP'};


figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({SAL.PC_values_all{1} PC_values_all{1}},Cols,X,Legends,'showpoints',1,'paired',0);

subplot(132)
MakeSpreadAndBoxPlot3_SB({SAL.PC_values_all{2} PC_values_all{2}},Cols,X,Legends,'showpoints',1,'paired',0);

subplot(133)
MakeSpreadAndBoxPlot3_SB({SAL.PC_values_all{3} PC_values_all{3}},Cols,X,Legends,'showpoints',1,'paired',0);













