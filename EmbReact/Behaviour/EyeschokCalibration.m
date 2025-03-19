%% Look at eyeshock calibration
clear all
Files = PathForExperimentsEmbReact('Calibration_Eyeshock');
MiceToUse = [561,567,568,569,566,666,667,668,669,688,689,739,740,750];
VoltUsed = [3.5,2.5,2.5,3,3.5,3,2.5,2.5,2.5,2.5,2.5,2.5,2.5,2.5];
mousenum = 0;
for f = 1:length(Files.path)
    if ismember(Files.ExpeInfo{f}{1}.nmouse,MiceToUse)
        mousenum = mousenum+1;
        for c = 1:length(Files.ExpeInfo{f})
            try
                cd(Files.path{f}{c})
                Int(mousenum,c) = Files.ExpeInfo{f}{c}.StimulationInt;
                MouseNum(mousenum)=Files.ExpeInfo{f}{1}.nmouse;
                clear Vtsd MovAcctsd StimTimes
                load('behavResources.mat')
                Vtsd = tsd(Range(Xtsd),[0;sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2)]);
                Fz(mousenum,c) = sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
                [M,T] = PlotRipRaw(Vtsd, StimTimes-1, 3000,0, 0);
                JumpToStim{mousenum}(c,:) = interp1(M(:,1),M(:,2),[-3:0.1:3]);
                if exist('MovAcctsd')
                    [M,T] = PlotRipRaw(MovAcctsd, StimTimes-1, 3000,0, 0);
                    JumpToStim_Acc{mousenum}(c,:) = interp1(M(:,1),M(:,2),[-3:0.1:3]);
                else
                    JumpToStim_Acc{mousenum}(c,:) = nan(1,length([-3:0.1:3]));
                end
                
            end
            
        end
    end
end

AllInt = [0:0.5:4];
cols = summer(length(AllInt));
for k = 1:length(JumpToStim)
    subplot(4,4,k)
    for t = 1:size(JumpToStim{k},1)
        plot([-3:0.1:3],(JumpToStim{k}(t,:)'),'color',cols(find(AllInt == Int(k,t)),:)), hold on
        Val(k,t) = max((JumpToStim{k}(t,:)'));
        Val_Acc(k,t) = max((JumpToStim_Acc{k}(t,:)'));

    end
    title(num2str(MouseNum(k)))
end

figure
cols = lines(14);
subplot(131)
Val(Val==0) = NaN;
for k = 1:length(JumpToStim)
    mm = find(MiceToUse == MouseNum(k));
    plot(Int(k,:),Val(k,:),'-','color',cols(k,:)), hold on
    plot(Int(k,find(Int(k,:)==VoltUsed(mm))),Val(k,find(Int(k,:)==VoltUsed(mm))),'*','color',cols(k,:))
end
xlim([0 4])
subplot(132)
Val_Acc(Val_Acc==0) = NaN;
for k = 1:length(JumpToStim)
    mm = find(MiceToUse == MouseNum(k));
    plot(Int(k,:),Val_Acc(k,:),'-'), hold on
    plot(Int(k,find(Int(k,:)==VoltUsed(mm))),Val_Acc(k,find(Int(k,:)==VoltUsed(mm))),'*','color',cols(k,:))
end
xlim([0 4])
subplot(133)
for k = 1:length(JumpToStim)
    mm = find(MiceToUse == MouseNum(k));
    Fz(k,find(Int(k,2:end)==0)+1) = NaN;
    Fz_temp = cumsum(Fz(k,:));
    plot(Int(k,:),Fz_temp,'-'), hold on
    plot(Int(k,find(Int(k,:)==VoltUsed(mm))),Fz_temp(find(Int(k,:)==VoltUsed(mm))),'*','color',cols(k,:))
end
xlim([0 4])

