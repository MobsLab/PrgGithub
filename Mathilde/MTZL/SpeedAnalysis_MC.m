Mice = [756 758 761 763 765 ; 757 759 760 762 764];

Gr(1,1)=5;
Gr(1,2)=5;

MatNum=[];
MiceNumber = [756:765];
for k = 1:size(Mice,1)
    for j = 1 : Gr(1,k)
        MatNum(k,j) = find(MiceNumber==Mice(k,j));
    end
end

for i = 1:5
%cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(MiceNumber(MatNum(1,i))),'-12062018-Hab_00'])
cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(MatNum(1,i))),'-16062018-Hab_00'])

load('behavResources.mat')
    Numer = sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2);
    Denom = diff(Range(Xtsd,'s'));
    
    tps = Range(Xtsd);
    tps = tps(1:end-1);
    Vtsd = tsd(tps,Numer./Denom);

Qty_Of_Mov(i,:) = interp1(Range(Imdifftsd,'s'),naninterp(Data(Imdifftsd)),[5:10:895]);
Speed(i,:) = interp1(Range(Vtsd,'s'),naninterp(Data(Vtsd)),[5:10:895]);
Speed_Mov(i,:) = interp1(Range(Vtsd,'s'),naninterp(Data(Vtsd)),[5:1:895]);
Speed_Mov(i,Speed_Mov(i,:)<2)=NaN; 
Speed_Mov(i,Speed_Mov(i,:)>40)=NaN; 

end


for i = 1:5
%cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(MiceNumber(MatNum(2,i))),'-12062018-Hab_00'])
cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(MatNum(2,i))),'-16062018-Hab_00'])

load('behavResources.mat')
Numer = sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2);
Denom = diff(Range(Xtsd,'s'));

tps = Range(Xtsd);
tps = tps(1:end-1);
Vtsd = tsd(tps,Numer./Denom);

Qty_Of_Mov_mtzl(i,:) = interp1(Range(Imdifftsd,'s'),naninterp(Data(Imdifftsd)),[5:10:895]);
Speed_mtzl(i,:) = interp1(Range(Vtsd,'s'),naninterp(Data(Vtsd)),[5:10:895]);
Speed_Mov_mtzl(i,:) = interp1(Range(Vtsd,'s'),naninterp(Data(Vtsd)),[5:1:895]);
Speed_Mov_mtzl(i,Speed_Mov_mtzl(i,:)<2)=NaN; 
Speed_Mov_mtzl(i,Speed_Mov_mtzl(i,:)>40)=NaN; 

end




         
% AllNumJump_sal =  [];
% AllNumJump_mtzl =  [];
% 
% for k = 1 :5
%     AllNumJump_sal =  [AllNumJump_sal;Jump_Dur_sal{k}];
%     AllNumJump_mtzl =  [AllNumJump_mtzl;Jump_Dur_mtzl{k}];
% end



figure
subplot(211)
errorbar([5:10:895],nanmean(Qty_Of_Mov),stdError(Qty_Of_Mov),'k')
hold on
errorbar([5:10:895],nanmean(Qty_Of_Mov_mtzl),stdError(Qty_Of_Mov_mtzl),'r')
ylim([0 400])
title('Qty of mov')
% xlabel('Time (s)')
legend('sal', 'mtzl')
subplot(212)
errorbar([5:10:895],nanmean(Speed),stdError(Speed),'k')
hold on
errorbar([5:10:895],nanmean(Speed_mtzl),stdError(Speed_mtzl),'r')
ylim([0 30])
title('Speed')
% xlabel('Time (s)')
legend('sal', 'mtzl')


% boxplot speed
figure
x = [nanmean(Speed_Mov');nanmean(Speed_Mov_mtzl')];
boxplot(x','ColorGroup',[1,2],'color',[0 0 0;1 0 0]), hold on
set(gca, 'XTick', [1 2])
set(gca, 'XTickLabels', {'Sal','Mtzl'})
clear p
[p(1),h]=ranksum((Speed_Mov(5,:)), (Speed_Mov_mtzl(5,:)));
sigstar({[1,2]},p)
plot(1,x(1,:),'k.','MarkerSize',30)
plot(2,x(2,:),'k.','MarkerSize',30)
ylabel('Speed (cm/s)')
