

Dir_open = PathForExperimentsNicotineETM('OpenArm');
Dir_closed = PathForExperimentsNicotineETM('ClosedArm');

a=1; b=1; c=1; d=1;
for i=1:length(Dir_open.ExpeInfo)
    if convertCharsToStrings(Dir_open.ExpeInfo{i}{1}.DrugInfo.DrugInjected)  == 'CHRONIC NICOTINE'
        Dir.Nicotine.open{a} = Dir_open.path{i};
        a=a+1;
    elseif convertCharsToStrings(Dir_open.ExpeInfo{i}{1}.DrugInfo.DrugInjected)  == 'SALINE'
        Dir.Saline.open{b} = Dir_open.path{i};
        b=b+1;
    end
end
for i=1:length(Dir_closed.ExpeInfo)
    if convertCharsToStrings(Dir_closed.ExpeInfo{i}{1}.DrugInfo.DrugInjected)  == 'CHRONIC NICOTINE'
        Dir.Nicotine.closed{c} = Dir_closed.path{i};
        c=c+1;
    elseif convertCharsToStrings(Dir_closed.ExpeInfo{i}{1}.DrugInfo.DrugInjected)  == 'SALINE'
        Dir.Saline.closed{d} = Dir_closed.path{i};
        d=d+1;
    end
end


for mouse=1:6
    for sess=1:5
        cd(Dir.Saline.open{mouse}{sess})
        load('LFPData/LFP0.mat')
        TIME.Saline.Open(mouse,sess) = max(Range(LFP,'s'));
    end
        for sess=1:5
        cd(Dir.Saline.closed{mouse}{sess})
        load('LFPData/LFP0.mat')
        TIME.Saline.Closed(mouse,sess) = max(Range(LFP,'s'));
    end
end
    
for mouse=1:6
    for sess=1:5
        cd(Dir.Nicotine.open{mouse}{sess})
        load('LFPData/LFP0.mat')
        TIME.Nicotine.Open(mouse,sess) = max(Range(LFP,'s'));
    end
        for sess=1:5
        cd(Dir.Nicotine.closed{mouse}{sess})
        load('LFPData/LFP0.mat')
        TIME.Nicotine.Closed(mouse,sess) = max(Range(LFP,'s'));
    end
end
    
% solving 1376 issues
TIME.Nicotine.Open(1,:)=NaN; TIME.Nicotine.Closed(1,:)=NaN;

clear A B C D
A = mean(TIME.Saline.Open(:,2:4)');
B = mean(TIME.Saline.Closed(:,2:4)');
C = mean(TIME.Nicotine.Open(:,2:4)');
D = mean(TIME.Nicotine.Closed(:,2:4)');

X = [1:2];
Cols = {[.2 .2 .2],[0 1 0]};
Legends ={'Saline' 'Nicotine'};

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({A C}  ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim()
title('Open Arm')

subplot(122)
MakeSpreadAndBoxPlot2_SB({B D}  ,Cols,X,Legends,'showpoints',1,'paired',0);
title('Closed Arm')


%%
figure
subplot(221)
plot(TIME.Saline.Open')
makepretty, xticks([1:5]), ylabel('delay (s)')
u=text(0,40,'Open Arm','FontSize',15,'FontWeight','bold','Rotation',90);
title('Saline')

subplot(223)
plot(TIME.Saline.Closed')
makepretty, xticks([1:5]), ylabel('delay (s)')
xlabel('sess number'), ylim([0 400])
u=text(0,40,'Closed Arm','FontSize',15,'FontWeight','bold','Rotation',90);

subplot(222)
plot(TIME.Nicotine.Open')
makepretty, xticks([1:5])
title('Withdraw chronic nicotine')
ylim([0 140])

subplot(224)
plot(TIME.Nicotine.Closed')
makepretty, xticks([1:5])
xlabel('sess number')

%%
figure
subplot(211)
Conf_Inter=nanstd(TIME.Saline.Open)/sqrt(size(TIME.Saline.Open,1));
shadedErrorBar([1:5] , nanmean(TIME.Saline.Open) , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(TIME.Nicotine.Open)/sqrt(size(TIME.Nicotine.Open,1));
shadedErrorBar([1:5] , nanmean(TIME.Nicotine.Open) , Conf_Inter,'-g',1); hold on;
makepretty, xticks([1:5]), ylabel('delay (s)')
f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Nicotine');
title('Open arm')

subplot(212)
Conf_Inter=nanstd(TIME.Saline.Closed)/sqrt(size(TIME.Saline.Closed,1));
shadedErrorBar([1:5] , nanmean(TIME.Saline.Closed) , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(TIME.Nicotine.Closed)/sqrt(size(TIME.Nicotine.Closed,1));
shadedErrorBar([1:5] , nanmean(TIME.Nicotine.Closed) , Conf_Inter,'-g',1); hold on;
makepretty, xticks([1:5]), ylabel('delay (s)')
title('Closed arm')



%%
for i=9
    for j=1:5
        cd(Dir_closed.path{i}{j})
        load('ExpeInfo.mat')
        ExpeInfo.DrugInfo.DrugInjected = 'SALINE';
        save('ExpeInfo.mat','ExpeInfo')
    end
end



