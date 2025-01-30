clear all
Dir=PathForExperimentsEmbReact('BaselineSleep');

[Acc_all,Acc_ConfMat,MeanW] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',0,'testonfr',0);
[Acc_all_Rand,Acc_ConfMat_Rand,MeanW_Rand] = MultiClassBinaryDecoder_SB(Vals,'permutnum',100,'dorand',1,'testonfr',0);


S = S(numNeurons);
S{1} = tsd([0;Range(S{1});max(Range(LFP))],[0;Range(S{1});max(Range(LFP))]);
Q = MakeQfromS(S,2*1e4);


AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');

timeDown = Data(Restrict(AllTime,down_PFCx));
tps = Range(LFP);
DownBins = tsdArray(tsd([0;tps(timeDown);max(Range(LFP))],[0;tps(timeDown);max(Range(LFP))]));
QDown = MakeQfromS(DownBins,2*1e4);
QDown = tsd(Range(QDown),Data(QDown)/2500); % divide by number of bins in 2seconds

timeDown = Data(Restrict(AllTime,Epoch{3}));
tps = Range(LFP);
N3Bins = tsdArray(tsd([0;tps(timeDown);max(Range(LFP))],[0;tps(timeDown);max(Range(LFP))]));
QN3 = MakeQfromS(N3Bins,2*1e4);
QN3 = tsd(Range(QN3),Data(QN3)/2500); % divide by number of bins in 2seconds




num = 0;
for dd = 1:length(Dir.path)
    for kk = 1:length(Dir.path{dd})
        cd(Dir.path{dd}{kk})
        
        if (exist('SleepSubstages.mat')==2 | exist('NREMsubstages.mat')==2) & exist('SpikeData.mat')==2 & exist('DownState.mat')==2
            clear Epoch NameEpoch S Q LFP numNeurons numtt TT Vals
            try,load('SleepSubstages.mat')
            catch
                load('NREMsubstages.mat')
            end
            load('SpikeData.mat')
            load('DownState.mat')
            load('LFPData/LFP1.mat')
            
            [numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
            try,S = tsdArray(S);end
            S = S(numNeurons);
            Q = MakeQfromS(S,2*1e4);
            Qsmallbin = MakeQfromS(S,0.2*1e4);
            
%             AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
%             timeDown = Data(Restrict(AllTime,down_PFCx));
%             AllTime = Data(AllTime)*0+1;
%             AllTime(timeDown) = 0;
%             out=DownSampleByBlocks(tsd(Range(LFP),AllTime),2,'mean')
%             out = Restrict(out,ts(Range(Q)));
%             
%             DatQ = Data(Q);
%             for sp = 1:length(numNeurons)
%                 DatQ(:,sp) = DatQ(:,sp)./Data(out);
%             end
%             Q = tsd(Range(Q),DatQ);
            
            clear Vals Tps
            Vals.N3 = Data(Restrict(Q,Epoch{3}));
            Tps.N3 = Range(Restrict(Q,Epoch{3}));
            Vals.N2 = Data(Restrict(Q,Epoch{2}));
            Tps.N2 = Range(Restrict(Q,Epoch{2}));
            Vals.N1 = Data(Restrict(Q,Epoch{1}));
            Tps.N1 = Range(Restrict(Q,Epoch{1}));
            Vals.REM = Data(Restrict(Q,Epoch{4}));
            Tps.REM = Range(Restrict(Q,Epoch{4}));
            Vals.Wake = Data(Restrict(Q,Epoch{5}));
            Tps.Wake = Range(Restrict(Q,Epoch{5}));
            keyboard
            num = num+1;
            NumNeurons(num) = length(numNeurons);
            Mouse(num) = Dir.ExpeInfo{dd}{kk}.nmouse;
            
            fields = fieldnames(Vals);
            for ff = 1:length(fields)
                for gg = 1:length(fields)
                    if gg>ff
                        
                        % train
                        Vect = full(nanmean(Vals.(fields{ff})(1:end/2,:))-nanmean(Vals.(fields{gg})(1:end/2,:)));
                        Proj1 = full(Vals.(fields{ff})(1:end/2,:)*Vect');
                        Proj2 = full(Vals.(fields{gg})(1:end/2,:)*Vect');
                        Bias = (mean(Proj2) + mean(Proj1))/2;
                        
                        % test
                        Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect');
                        Proj2 = full(Vals.(fields{gg})(end/2:end,:)*Vect');
                        
                        ErrRate{num}(ff,gg) = ((sum(Proj1<Bias)/length(Proj1)) + (sum(Proj2>Bias)/length(Proj2)))/2;
                        
                        MaxTps = max([Tps.(fields{ff})(1:end/2);Tps.(fields{gg})(1:end/2)]);
                        TestEpoch = intervalSet(MaxTps,max(Range(LFP)));
                        TimeProject = tsd(Range(Qsmallbin),Data(Qsmallbin)*Vect');
                        [aft_cell,bef_cell]=transEpoch(and(Epoch{ff},TestEpoch),and(Epoch{gg},TestEpoch));
                        keyboard
                        try
                            [M,T] = PlotRipRaw(TimeProject,Start(aft_cell{1,2},'s'),4000,0,0);
                            Trans{ff,gg}(num,:) = M(:,2);
                        catch
                            Trans{ff,gg}(num,:) = nan(41,1);
                        end
                        
                        try
                            [M,T] = PlotRipRaw(TimeProject,Start(bef_cell{1,2},'s'),4000,0,0);
                            Trans{gg,ff}(num,:) = M(:,2);
                        catch
                            Trans{gg,ff}(num,:) = nan(41,1);
                        end
                        
                    end
                end
            end
%             figure(1)
%             Vect = full(nanmean(Vals.N3(1:end/2,:))-nanmean(Vals.Wake(1:end/2,:)));
%             for ff = 1:length(fields)
%                 ValsToPlot{ff} = full(Vals.(fields{ff})(1:end/2,:)*Vect');
%             end
%             subplot(4,2,num)
%             nhist(ValsToPlot)
%             title(num2str(Mouse(num)))

            %             Vect1 = full(nanmean(Vals.(fields{4})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
            %             Vect2 = full(nanmean(Vals.(fields{5})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
            %             Vect3 = full(nanmean(Vals.(fields{5})(1:end/2,:))-nanmean(Vals.(fields{4})(1:end/2,:)));
            %
            %             figure
            %             cols = lines(5);
            %             subplot(3,1,1)
            %             Vect1 = full(nanmean(Vals.(fields{3})(1:end/2,:))-nanmean(Vals.(fields{2})(1:end/2,:)));
            %             Vect2 = full(nanmean(Vals.(fields{3})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
            %
            %             for ff = 1:5
            %                 Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
            %                 Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
            %                 plot(nanmean(Proj1),nanmean(Proj2),'.','MarkerSize',20,'color',cols(ff,:)),hold on
            %                 errorbarxy(nanmean(Proj1),nanmean(Proj2),std(Proj1),std(Proj2),'MarkerSize',20,'color','k'),hold on
            %             end
            %             legend({'N1','N2','N3','R','W'},'Location','NorthWest')
            %             xlabel('N3/N2 axis')
            %             ylabel('N3/N1 axis')
            %
            %               subplot(3,1,2)
            %             Vect1 = full(nanmean(Vals.(fields{4})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
            %             Vect2 = full(nanmean(Vals.(fields{5})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
            %
            %             for ff = 1:5
            %                 Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
            %                 Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
            %                 plot(nanmean(Proj1),nanmean(Proj2),'.','MarkerSize',20,'color',cols(ff,:)),hold on
            %                 errorbarxy(nanmean(Proj1),nanmean(Proj2),std(Proj1),std(Proj2),'MarkerSize',20,'color','k'),hold on
            %             end
            %             legend({'N1','N2','N3','R','W'},'Location','NorthWest')
            %             xlabel('REM/N1 axis')
            %             ylabel('Wake/N1 axis')
            %
            %
            %               subplot(3,1,3)
            %             Vect1 = full(nanmean(Vals.(fields{4})(1:end/2,:))-nanmean(Vals.(fields{5})(1:end/2,:)));
            %             Vect2 = full(nanmean(Vals.(fields{3})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
            %
            %             for ff = 1:5
            %                 Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
            %                 Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
            %                 plot(nanmean(Proj1),nanmean(Proj2),'.','MarkerSize',20,'color',cols(ff,:)),hold on
            %                 errorbarxy(nanmean(Proj1),nanmean(Proj2),std(Proj1),std(Proj2),'MarkerSize',20,'color','k'),hold on
            %             end
            %             legend({'N1','N2','N3','R','W'},'Location','NorthWest')
            %             xlabel('REM/Wake axis')
            %             ylabel('N3/N1 axis')
            %
            %
            
        end
    end
end

figure
TotError = zeros(5,5);
for g= 1:8
    subplot(2,4,g)
    imagesc(1-ErrRate{g})
    clim([0.4 1])
    set(gca,'XTickLabel',{'N1','N2','N3','R','W'},'YTickLabel',{'N1','N2','N3','R','W'},'XTick',[1:5],'YTick',[1:5])
    TotError = TotError + 1-ErrRate{g};
    title(num2str(Mouse(g)))
    axis xy
    colormap jet
end

figure
for ff = 1:length(fields)
    for gg = 1:length(fields)
        if gg>ff
            subplot(4,4,(ff-1)*4+(gg-1))
            errorbar(M(:,1),nanmean(nanzscore(Trans{ff,gg}')'),stdError(nanzscore(Trans{ff,gg}')'),'b')
            hold on
            errorbar(M(:,1),nanmean(nanzscore(Trans{gg,ff}')'),stdError(nanzscore(Trans{gg,ff}')'),'r')
        end
    end
end

%%
clear all
load('SleepSubstages.mat')
load('SpikeData.mat')
load('DownState.mat')
load('LFPData/LFP1.mat')

[numNeurons, numtt, TT] = GetSpikesFromStructure('PFCx','remove_MUA',1);
S = tsdArray(S);
S = S(numNeurons);
Q = MakeQfromS(S,2*1e4);
AllTime = tsd(Range(LFP),[1:length(Range(LFP))]');
timeDown = Data(Restrict(AllTime,down_PFCx));
AllTime = Data(AllTime)*0+1;
AllTime(timeDown) = 0;
out=DownSampleByBlocks(tsd(Range(LFP),AllTime),2,'mean')
out = Restrict(out,ts(Range(Q)));
DatQ = Data(Q);
for sp = 1:length(numNeurons)
    DatQ(:,sp) = DatQ(:,sp).*Data(out);
end
Q = tsd(Range(Q),DatQ);

clear Vals
Vals.N1 = Data(Restrict(Q,Epoch{1}));
Vals.N2 = Data(Restrict(Q,Epoch{2}));
Vals.N3 = Data(Restrict(Q,Epoch{3}));
Vals.REM = Data(Restrict(Q,Epoch{4}));
Vals.Wake = Data(Restrict(Q,Epoch{5}));

figure
fields = fieldnames(Vals);
for ff = 1:length(fields)
    for gg = 1:length(fields)
        if gg~=ff
            Vect = full(nanmean(Vals.(fields{ff})(1:end/2,:))-nanmean(Vals.(fields{gg})(1:end/2,:)));
            Proj1 = full(Vals.(fields{ff})(1:end/2,:)*Vect');
            Proj2 = full(Vals.(fields{gg})(1:end/2,:)*Vect');
            Bias = (mean(Proj2) + mean(Proj1))/2;
            Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect');
            Proj2 = full(Vals.(fields{gg})(end/2:end,:)*Vect');
            
            subplot(length(fields),length(fields),(ff-1)*length(fields)+gg)
            nhist({Proj1,Proj2})
            ErrRate(ff,gg) = ((sum(Proj1<Bias)/length(Proj1)) + (sum(Proj2>Bias)/length(Proj2)))/2;
            line([1 1]*Bias,ylim)
            title([fields{ff} 'vs' fields{gg}])
        end
    end
end


Vect1 = full(nanmean(Vals.(fields{4})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
Vect2 = full(nanmean(Vals.(fields{5})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
Vect3 = full(nanmean(Vals.(fields{5})(1:end/2,:))-nanmean(Vals.(fields{4})(1:end/2,:)));

figure
cols = lines(5)

for ff = 1:5
    Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
    Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
    Proj3 = full(Vals.(fields{ff})(end/2:end,:)*Vect3');
    plot3(Proj3,Proj2,Proj1,'*','color',cols(ff,:))
    hold on
    %     plot3(nanmean(Proj3),nanmean(Proj2),nanmean(Proj1),'.','MarkerSize',40,'color','k')
    %     plot3(nanmean(Proj3),nanmean(Proj2),nanmean(Proj1),'.','MarkerSize',20,'color',cols(ff,:))
    
end

Vect1 = full(nanmean(Vals.(fields{4})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
Vect2 = full(nanmean(Vals.(fields{5})(1:end/2,:))-nanmean(Vals.(fields{1})(1:end/2,:)));
Vect3 = full(nanmean(Vals.(fields{5})(1:end/2,:))-nanmean(Vals.(fields{4})(1:end/2,:)));

figure
for ff = [1,4,5]
    Proj1 = full(Vals.(fields{ff})(end/2:end,:)*Vect1');
    Proj2 = full(Vals.(fields{ff})(end/2:end,:)*Vect2');
    Proj3 = full(Vals.(fields{ff})(end/2:end,:)*Vect3');
    
    plot3(Proj1,Proj2,Proj3,'.'),hold on
end

