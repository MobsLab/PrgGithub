function [Acc_train,Acc_test,Proj_train,Proj_test,Projector] = PerfomLinearDecoding(Data1,Data2)

% points by neurons

% randomize
Data1 = Data1(randperm(size(Data1,1),size(Data1,1)),:);
Data2 = Data2(randperm(size(Data2,1),size(Data2,1)),:);

% Split in two for cross validation
MinLg = floor(min([size(Data1,1),size(Data2,1)])/2);

Data1_Tr = Data1(1:MinLg,:);
Data2_Tr = Data2(1:MinLg,:);

Data1_Te = Data1(MinLg+1:MinLg*2-1,:);
Data2_Te = Data2(MinLg+1:MinLg*2-1,:);

% 
% LOO
% MinLg = floor(min([size(Data1,1),size(Data2,1)]));
% 
% Data1_Tr = Data1(1:MinLg-1,:);
% Data2_Tr = Data2(1:MinLg-1,:);
% 
% Data1_Te = Data1(MinLg,:);
% Data2_Te = Data2(MinLg,:);


% Get projection vector
Projector = nanmean(Data1_Tr,1) - nanmean(Data2_Tr,1);
Bias = (nanmean(Projector*Data1_Tr') + nanmean(Projector*Data2_Tr'))/2;

Acc_train = [nanmean(Projector*Data1_Tr'>Bias),nanmean(Projector*Data2_Tr'<Bias)];
Acc_test = [nanmean(Projector*Data1_Te'>Bias),nanmean(Projector*Data2_Te'<Bias)];

Proj_train = [Projector*Data1_Tr';Projector*Data2_Tr'];
Proj_test = [Projector*Data1_Te';Projector*Data2_Te'];

end



