DataMouse = rmmissing(DATA.M688);
R_init = corrcoef(DataMouse);
eigR_init = eig(R_init);

DataMouse_Fit8 = Array_Train.Fit8.M688.Trainset(1).table;
R_Fit8 = corrcoef(table2array(DataMouse_Fit8));
eigR_Fit8 = eig(R_Fit8);

figure;
imagesc(R_init);
xticklabels({'OB freq', 'Pos', 'GT', 'TSLShock', 'TSFreez', 'CumulTSFreez', 'Eyelid'})
yticklabels({'OB freq', 'Pos', 'GT', 'TSLShock', 'TSFreez', 'CumulTSFreez', 'Eyelid'})

figure;
imagesc(R_Fit8);
xticklabels({'Pos', 'GT', 'TSLShock', 'CumulTSFreez', 'sigPosxTSLS', 'SigPosxSigGT', 'OB freq'})
yticklabels({'Pos', 'GT', 'TSLShock', 'CumulTSFreez', 'sigPosxTSLS', 'SigPosxSigGT', 'OB freq'})


num_vars = size(DataMouse, 2);
vif_values = zeros(1, num_vars);

for i = 1:num_vars
    subset_matrix = [DataMouse(:,1:i-1) DataMouse(:,i+1:end)];
    
    [ignoreA,ignoreB,Rbis] = regress(DataMouse(:,i), subset_matrix);
    
    vif_values(i) = 1 / (1 - Rbis.^2);
    
end

disp(vif_values);

for i=1:mousenum;
    RelationGTTSLS = corrcoef 
