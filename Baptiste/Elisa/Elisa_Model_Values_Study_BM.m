figure
subplot(331)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,1) , optim_score_optim_TestPre(1,:,2))
axis square
u=text(-.1,.1,'Obj2 = f(Obj1)'), set(u,'FontSize',15,'FontWeight','bold','Rotation',90), ylabel('optimisation score (a.u.)')
xlim([0 .5]), ylim([0 .5])
title('1st optimization')
subplot(332)
PlotCorrelations_BM(optim_score_optim_TestPre(2,:,1) , optim_score_optim_TestPre(2,:,2))
axis square
xlim([0 .5]), ylim([0 .5])
title('2nd optimization')
subplot(333)
PlotCorrelations_BM(optim_score_optim_TestPre(3,:,1) , optim_score_optim_TestPre(3,:,2))
axis square
xlim([0 .5]), ylim([0 .5])
title('3rd optimization')

subplot(334)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,1) , optim_score_optim_TestPre(1,:,3))
axis square
u=text(-.1,.1,'Obj3 = f(Obj1)'), set(u,'FontSize',15,'FontWeight','bold','Rotation',90), ylabel('optimisation score (a.u.)')
xlim([0 .5]), ylim([0 .5])
subplot(335)
PlotCorrelations_BM(optim_score_optim_TestPre(2,:,1) , optim_score_optim_TestPre(2,:,3))
axis square
xlim([0 .5]), ylim([0 .5])
subplot(336)
PlotCorrelations_BM(optim_score_optim_TestPre(3,:,1) , optim_score_optim_TestPre(3,:,3))
axis square
xlim([0 .5]), ylim([0 .5])

subplot(337)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,2) , optim_score_optim_TestPre(1,:,3))
axis square
u=text(-.1,.1,'Obj3 = f(Obj2)'), set(u,'FontSize',15,'FontWeight','bold','Rotation',90), ylabel('optimisation score (a.u.)')
xlabel('optimisation score (a.u.)'), xlim([0 .5]), ylim([0 .5])
subplot(338)
PlotCorrelations_BM(optim_score_optim_TestPre(2,:,2) , optim_score_optim_TestPre(2,:,3))
axis square
xlabel('optimisation score (a.u.)'), xlim([0 .5]), ylim([0 .5])
subplot(339)
PlotCorrelations_BM(optim_score_optim_TestPre(3,:,2) , optim_score_optim_TestPre(3,:,3))
axis square
xlabel('optimisation score (a.u.)'), xlim([0 .5]), ylim([0 .5])


figure
subplot(331)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,1) , optim_score_optim_TestPre(2,:,3))
axis square
u=text(-.1,.1,'Optimization2 = f(Optimization1)'), set(u,'FontSize',10,'FontWeight','bold','Rotation',90), ylabel('optimisation score (a.u.)')
xlim([0 .5]), ylim([0 .5])
title('1st objective')
subplot(332)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,2) , optim_score_optim_TestPre(2,:,3))
axis square
xlim([0 .5]), ylim([0 .5])
title('2nd objective')
subplot(333)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,3) , optim_score_optim_TestPre(2,:,3))
axis square
xlim([0 .5]), ylim([0 .5])
title('3rd objective')

subplot(334)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,1) , optim_score_optim_TestPre(3,:,1))
axis square
u=text(-.1,.1,'Optimization3 = f(Optimization2)'), set(u,'FontSize',10,'FontWeight','bold','Rotation',90), ylabel('optimisation score (a.u.)')
xlim([0 .5]), ylim([0 .5])
subplot(335)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,2) , optim_score_optim_TestPre(3,:,2))
axis square
xlim([0 .5]), ylim([0 .5])
subplot(336)
PlotCorrelations_BM(optim_score_optim_TestPre(1,:,3) , optim_score_optim_TestPre(3,:,3))
axis square
xlim([0 .5]), ylim([0 .5])

subplot(337)
PlotCorrelations_BM(optim_score_optim_TestPre(2,:,1) , optim_score_optim_TestPre(3,:,1))
axis square
u=text(-.1,.1,'Optimization3 = f(Optimization2)'), set(u,'FontSize',10,'FontWeight','bold','Rotation',90), ylabel('optimisation score (a.u.)')
xlabel('optimisation score (a.u.)'), xlim([0 .5]), ylim([0 .5])
subplot(338)
PlotCorrelations_BM(optim_score_optim_TestPre(2,:,2) , optim_score_optim_TestPre(3,:,2))
axis square
xlabel('optimisation score (a.u.)'), xlim([0 .5]), ylim([0 .5])
subplot(339)
PlotCorrelations_BM(optim_score_optim_TestPre(2,:,3) , optim_score_optim_TestPre(3,:,3))
axis square
xlabel('optimisation score (a.u.)'), xlim([0 .5]), ylim([0 .5])


ind1 = optim_score_optim_TestPre(1,:,3)<.2;
ind2 = and(optim_score_optim_TestPre(1,:,3)>.2 , optim_score_optim_TestPre(2,:,3)<.2);
ind3 = and(optim_score_optim_TestPre(1,:,3)>.2 , optim_score_optim_TestPre(3,:,3)<.2);



model_results_Final = [model_results_Pre1(: , ind1)  model_results_Pre2(: , ind2)  model_results_Pre3(: , ind3)];


%%
Mouse_names = {'M688', 'M777', 'M849', 'M1144', 'M1146', 'M1147', 'M1170', 'M1171', 'M9184', 'M9205',...
    'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226', 'M739', 'M779', 'M893', 'M1189', 'M1393'}; 

Var_Names = {'beta', 'thigmotaxis', 'direct_persist', 'immobility', 'p1', 'p2','p3', 'gamma', 'k', 'bp', 'Wm', 'Wnm'};

ind_mice = 1:21;
ind_var = [1 5:12];

[v1_1, v2_1 , eig1_1 , eig2_1] = Understand_Elisa_Data_BM(model_results_Pre1(ind_var,:)' , Mouse_names(ind_mice) , Var_Names(ind_var));
[v1_2, v2_2 , eig1_2 , eig2_2] = Understand_Elisa_Data_BM(model_results_Pre2(ind_var,:)' , Mouse_names(ind_mice) , Var_Names(ind_var));
[v1_3, v2_3 , eig1_3 , eig2_3] = Understand_Elisa_Data_BM(model_results_Pre3(ind_var,:)' , Mouse_names(ind_mice) , Var_Names(ind_var));


ind_grp1 = model_results_Pre1(1,:)<2;
ind_grp2 = model_results_Pre1(1,:)>2;

figure
subplot(131)
PlotCorrelations_BM(model_results_Pre1(1,ind_grp1) , model_results_Pre1(11,ind_grp1) , 'Color' , 'b')
PlotCorrelations_BM(model_results_Pre1(1,ind_grp2) , model_results_Pre1(11,ind_grp2) , 'Color' , 'r')
axis square
xlim([0 10]), ylim([0 10])
xlabel('beta values'), ylabel('Wm values')
title('1st optimization')

subplot(132)
PlotCorrelations_BM(model_results_Pre2(1,ind_grp1) , model_results_Pre2(11,ind_grp1) , 'Color' , 'b')
PlotCorrelations_BM(model_results_Pre2(1,ind_grp2) , model_results_Pre2(11,ind_grp2) , 'Color' , 'r')
axis square
xlim([0 10]), ylim([0 10])
xlabel('beta values')
title('2nd optimization')

subplot(133)
PlotCorrelations_BM(model_results_Pre3(1,ind_grp1) , model_results_Pre3(11,ind_grp1) , 'Color' , 'b')
PlotCorrelations_BM(model_results_Pre3(1,ind_grp2) , model_results_Pre3(11,ind_grp2) , 'Color' , 'r')
axis square
xlim([0 10]), ylim([0 10])
xlabel('beta values')
title('3rd optimization')




A = zscore(model_results_Pre1')';
A = saline(25:36,:);

figure
PlotCorrelations_BM(A(1,ind_grp1) , A(11,ind_grp1) , 'Color' , 'b')
PlotCorrelations_BM(A(1,ind_grp2) , A(11,ind_grp2) , 'Color' , 'r')
axis square



X = 1:3;
Cols = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5]};
Legends ={'1' '2' '3'};


figure
MakeSpreadAndBoxPlot2_SB({model_results_Pre1(1,ind_grp1) model_results_Pre2(1,ind_grp1) model_results_Pre3(1,ind_grp1)} ,Cols,X,Legends,'showpoints',0,'paired',1);

figure
MakeSpreadAndBoxPlot2_SB({model_results_Pre1(11,ind_grp1) model_results_Pre2(11,ind_grp1) model_results_Pre3(11,ind_grp1)} ,Cols,X,Legends,'showpoints',0,'paired',1);



figure
PlotCorrelations_BM(ImmobilityTime.TestPre(ind) , proj_norm(ind))
xlim([.25 .6]), ylim([-1.2 1.2])
axis square

figure
for i=1:12
   subplot(3,4,i)
    PlotCorrelations_BM(ImmobilityTime.TestPre , model_results_Pre1(i,:))
    
end


figure
for i=1:12
   subplot(3,4,i)
    PlotCorrelations_BM(ImmobilityTime.TestPre , model_results_Pre2(i,:))
    
end

figure
for i=1:12
   subplot(3,4,i)
    PlotCorrelations_BM(ImmobilityTime.TestPre , model_results_Pre3(i,:))
    
end

figure
PlotCorrelations_BM(model_results_Pre1(1,:).*model_results_Pre1(5,:) , model_results_Pre3(1,:).*model_results_Pre3(5,:))

figure
A = zscore(model_results_Pre1')';
B = zscore(model_results_Pre2')';
PlotCorrelations_BM(A(1,:).*A(11,:) , B(1,:).*B(11,:))





[D1 , p1] = corr(model_results_Pre1(ind_var,ind_mice) , model_results_Pre2(ind_var,ind_mice) ,'type','pearson');
[D2 , p2] = corr(model_results_Pre1(ind_var,ind_mice) , model_results_Pre3(ind_var,ind_mice) ,'type','pearson');
[D3 , p3] = corr(model_results_Pre2(ind_var,ind_mice) , model_results_Pre3(ind_var,ind_mice) ,'type','pearson');

for i=1:21
    B(i) = D1(i,i);
end
for i=1:21
    B(2,i) = D2(i,i);
end
for i=1:21
    B(3,i) = D3(i,i);
end

[D1 , p1] = corr(model_results_Pre1(ind_var,ind_mice)' , model_results_Pre2(ind_var,ind_mice)' ,'type','pearson');
[D2 , p2] = corr(model_results_Pre1(ind_var,ind_mice)' , model_results_Pre3(ind_var,ind_mice)' ,'type','pearson');
[D3 , p3] = corr(model_results_Pre2(ind_var,ind_mice)' , model_results_Pre3(ind_var,ind_mice)' ,'type','pearson');

for i=1:12
    B(i) = D1(i,i);
end
for i=1:12
    B(2,i) = D2(i,i);
end
for i=1:12
    B(3,i) = D3(i,i);
end

mean(mean(B))
mean(mean(D1))












