
Session_type={'CondPost'}; sess=1; strict=0;

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close

ind_mouse=1:length(Mouse);

DATA2(1,:) = [Freq_Max_Shock(ind_mouse) Freq_Max_Safe(ind_mouse)];

n=2;
for par=[2:8]
    DATA2(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end
ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

z2 = zscore(DATA2(:,[ind ind])')';


ChosenVar = [2,3,4];
LowMov = MeanVal_zscored.sleep_pre{5}(ind,ChosenVar);
HighMov = MeanVal_zscored.sleep_pre{10}(ind,ChosenVar);
GoodGuys = find(sum(isnan(LowMov)')==0 & sum(isnan(HighMov)')==0 );
LowMov = LowMov(GoodGuys,1:end);
HighMov = HighMov(GoodGuys,1:end);
Shock = z2(ChosenVar,1:19)';
Shock = Shock(GoodGuys,:);
Safe = z2(ChosenVar,20:end)';
Safe = Safe(GoodGuys,:);
clear Projector
figure
for perm = 1:100
[Acc_train_Lin,Acc_test_Lin,Proj_train,Proj_test,Projector.SfSk(perm,:)] = PerfomLinearDecoding(Safe,Shock);
end
Projector.SfSk = nanmean(Projector.SfSk);

for perm = 1:100
[Acc_train_Lin,Acc_test_Lin,Proj_train,Proj_test,Projector.LowHighMov(perm,:)] = PerfomLinearDecoding(LowMov,HighMov);
end
Projector.LowHighMov = nanmean(Projector.LowHighMov);


plot(nanmean(Projector.SfSk*Shock'),-nanmean(Projector.LowHighMov*Shock'),'.r')
hold on
plot(nanmean(Projector.SfSk*Safe'),-nanmean(Projector.LowHighMov*Safe'),'.b')

for i=1:10
    Cols{i} = [1-i/10 .5 i/10];
    Legend{11-i} = ['mobility ' num2str(i)];
end
for i = 1:10
    Mov_OI = MeanVal_zscored.Fear{i}(ind,ChosenVar);
GoodGuys = find(sum(isnan(Mov_OI)')==0);
Mov_OI = Mov_OI(GoodGuys,:);
plot(nanmean(Projector.SfSk*Mov_OI'),-nanmean(Projector.LowHighMov*Mov_OI'),'.','color',Cols{i})
end
makepretty


% Decoder
for perm = 1:100
    for mov = 1:10
    
LowMov = MeanVal_zscored.sleep_pre{mov}(ind,:);
GoodGuys = find(sum(isnan(LowMov)')==0 );
LowMov = LowMov(GoodGuys,:);
Safe = z2(:,20:end)';
Safe = Safe(GoodGuys,:);

[Acc_train_Lin,Acc_test_Lin(mov,:),Proj_train,Proj_test,Projector.LowHighMov] = PerfomLinearDecoding(LowMov,Safe);
MouseNum(mov) = size(Safe,1);
    end
Acc(perm,:)  = nanmean(Acc_test_Lin');
end
plot(nanmean(Acc_test_Lin'))

figure

plot(eigen_vector(:,1)*Shock,eigen_vector(:,2)*Shock,'.r')
hold on
plot(eigen_vector(:,1)*Safe',eigen_vector(:,2)*Safe','.b')
for i=1:10
    Cols{i} = [1-i/10 .5 i/10];
    Legend{11-i} = ['mobility ' num2str(i)];
end
for i = 1:10
    Mov_OI = MeanVal_zscored.Fear{i}(ind,:);
GoodGuys = find(sum(isnan(Mov_OI)')==0);
Mov_OI = Mov_OI(GoodGuys,:);
plot(eigen_vector(:,1)*Mov_OI',eigen_vector(:,2)*Mov_OI','.','color',Cols{i})

end
makepretty

clf
CatVar = [];
for ii = 1:10
    CatVar = [CatVar;nanmean(MeanVal.sleep_pre{ii}')];
    
end
SafeVar = nanmean(DATA2(:,52:end)');
ShockVar = nanmean(DATA2(:,1:51)');

for var = 1:8
    subplot(3,3,var)
plot(CatVar(2:end,var))    
hold on
line(xlim,[1 1]*SafeVar(var),'color','b')
line(xlim,[1 1]*ShockVar(var),'color','r')
title(Params{var})
end

