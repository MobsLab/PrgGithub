

Mice = [756 757 758 759 760 761 762 763 764 765];
thresh = [5 15 20 25 30 50];

for i = 1 : length(Mice)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(Mice(i)),'-16062018-Hab_00'])
    load('behavResources.mat')
    Numer = sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2);
    Denom = diff(Range(Xtsd,'s'));
    
    tps = Range(Xtsd);
    tps = tps(1:end-1);
    Vtsd = tsd(tps,Numer./Denom);
    
    for t = 1: length(thresh)
        JumpEpoch = thresholdIntervals(Vtsd,thresh(t),'Direction','Above');
        Jump(t,i) = (sum((Stop(JumpEpoch, 's') - Start(JumpEpoch, 's')))/900);
        Jump_Dur{t,i} = (((Stop(JumpEpoch, 's') - Start(JumpEpoch, 's'))));
    end
    
end

 
Mice = [756 758 761 763 765 ; 757 759 762 764 760];
Gr(1,1)=5;
Gr(1,2)=5;
MatNum=[];
MiceNumber = [756 757 758 759 760 761 762 763 764 765];
for k = 1:size(Mice,1)
    for j = 1 : Gr(1,k)
        MatNum(k,j) = find(MiceNumber==Mice(k,j));
    end
end


% find the threshold to consider speed as jump
figure
for t = 1: length(thresh)
    
    AllJump = [];
    for k = 1 : 10
        AllJump = [AllJump;Jump_Dur{t,k}];
        NumJum(k) = length(Jump_Dur{t,k});
    end
    
NumJumpsSal(t,:) = (NumJum(MatNum(1,:)));
NumJumpsMtzl(t,:) = (NumJum(MatNum(2,:)));

        [y,x] = hist(AllJump,[0:0.05:1]);
        hold on
        plot(x,y/sum(y),'linewidth',2)
        ylabel('Number')
        xlabel('Time duration (s)')
        legend({'threshold = 5' 'threshold = 15' 'threshold = 20' 'threshold = 25' 'threshold = 30' 'threshold = 50'});
        xlim([0 1])
end


% boxplot jumps number
figure
x = [(NumJumpsSal(5,:)); (NumJumpsMtzl(5,:))];
boxplot(x','ColorGroup',[1,2],'color',[0 0 0;1 0 0]), hold on
set(gca, 'XTick', [1 2])
set(gca, 'XTickLabels', {'Sal','Mtzl'})
clear p
[p(1),h]=ranksum((NumJumpsSal(5,:)), (NumJumpsMtzl(5,:)));
sigstar({[1,2]},p)
plot(1,x(1,:),'k.','MarkerSize',30)
plot(2,x(2,:),'k.','MarkerSize',30)
xlabel('')
ylabel('Number of jumps')

% jumps number for different thresholds 
figure
errorbar(thresh,nanmean(NumJumpsSal'),stdError(NumJumpsSal'))
hold on
errorbar(thresh,nanmean(NumJumpsMtzl'),stdError(NumJumpsMtzl'))

    MakeSpreadAndBoxPlot_SB({(NumJumpsSal(5,:)); (NumJumpsMtzl(5,:))},{[0.8 0.8 0.8],[1 0.4 0.4]},[1 2],{'CTRL','MTZL'})

