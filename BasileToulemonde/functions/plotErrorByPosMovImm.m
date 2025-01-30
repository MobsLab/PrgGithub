function h2 = plotErrorByPosMovImm(dirAnalysis, nbbin, dur,nameEpoch)

    eval(['cd ',dirAnalysis])

    load('DataDoAnalysisFor1mouse.mat')
    load('DataPred36.mat')
    load('DataPred200.mat')
    load('DataPred504.mat')
    load('Epochs36.mat')
    load('Epochs200.mat')
    load('Epochs504.mat')

    try
        nameEpoch;
    catch
        nameEpoch='hab';
    end
    
    MovEpoch=thresholdIntervals(V,7.5,'Direction','Above');
    ImmobEpoch=thresholdIntervals(V,1,'Direction','Below');

%     figure;
%     [h504,b504]=hist(Data(Restrict(Restrict(LinearTrueTsd504,EpochOK504),hab))-Data(Restrict(Restrict(LinearPredTsd504,EpochOK504),hab)),[-1:0.01:1]);
%     [h200,b200]=hist(Data(Restrict(Restrict(LinearTrueTsd200,EpochOK200),hab))-Data(Restrict(Restrict(LinearPredTsd200,EpochOK200),hab)),[-1:0.01:1]);
%     [h36,b36]=hist(Data(Restrict(Restrict(LinearTrueTsd36,EpochOK36),hab))-Data(Restrict(Restrict(LinearPredTsd36,EpochOK36),hab)),[-1:0.01:1]);
%     subplot(1,3,1), hold on, plot(b36,h36/max(h36), 'g','DisplayName','Decoding with TW of 36ms'),plot(b200,h200/max(h200), 'b','DisplayName','Decoding with TW of 200ms'),plot(b504,h504/max(h504), 'r','DisplayName','Decoding with TW of 504ms'), title('hab')
%     subplot(1,3,1), xlabel('Error = True - Predicted'), ylabel('Quantity')
%     
%     [h504,b504]=hist(Data(Restrict(Restrict(LinearTrueTsd504,EpochOK504),and(MovEpoch,hab)))-Data(Restrict(Restrict(LinearPredTsd504,EpochOK504),and(MovEpoch,hab))),[-1:0.01:1]);
%     [h200,b200]=hist(Data(Restrict(Restrict(LinearTrueTsd200,EpochOK200),and(MovEpoch,hab)))-Data(Restrict(Restrict(LinearPredTsd200,EpochOK200),and(MovEpoch,hab))),[-1:0.01:1]);
%     [h36,b36]=hist(Data(Restrict(Restrict(LinearTrueTsd36,EpochOK36),and(MovEpoch,hab)))-Data(Restrict(Restrict(LinearPredTsd36,EpochOK36),and(MovEpoch,hab))),[-1:0.01:1]);
%     subplot(1,3,2), hold on, plot(b36,h36/max(h36), 'g','DisplayName','Decoding with TW of 36ms'),plot(b200,h200/max(h200), 'b','DisplayName','Decoding with TW of 200ms'),plot(b504,h504/max(h504), 'r','DisplayName','Decoding with TW of 504ms'), title('Mov')
%     subplot(1,3,2), xlabel('Error = True - Predicted'), ylabel('Quantity')
% 
%     [h504,b504]=hist(Data(Restrict(Restrict(LinearTrueTsd504,EpochOK504),and(ImmobEpoch,hab)))-Data(Restrict(Restrict(LinearPredTsd504,EpochOK504),and(ImmobEpoch,hab))),[-1:0.01:1]);
%     [h200,b200]=hist(Data(Restrict(Restrict(LinearTrueTsd200,EpochOK200),and(ImmobEpoch,hab)))-Data(Restrict(Restrict(LinearPredTsd200,EpochOK200),and(ImmobEpoch,hab))),[-1:0.01:1]);
%     [h36,b36]=hist(Data(Restrict(Restrict(LinearTrueTsd36,EpochOK36),and(ImmobEpoch,hab)))-Data(Restrict(Restrict(LinearPredTsd36,EpochOK36),and(ImmobEpoch,hab))),[-1:0.01:1]);
%     subplot(1,3,3), hold on, plot(b36,h36/max(h36), 'g','DisplayName','Decoding with TW of 36ms'),plot(b200,h200/max(h200), 'b','DisplayName','Decoding with TW of 200ms'),plot(b504,h504/max(h504), 'r','DisplayName','Decoding with TW of 504ms'), title('Immob')
%     subplot(1,3,3), xlabel('Error = True - Predicted'), ylabel('Quantity')
    
%     figure;
%     [h200,b200]=hist(Data(Restrict(Restrict(LinearTrueTsd200,EpochOK200),hab))-Data(Restrict(Restrict(LinearPredTsd200,EpochOK200),hab)),[-1:0.01:1]);
%     subplot(1,3,1), hold on, plot(b200,h200/max(h200), 'b','DisplayName','Decoding with TW of 200ms'), title('hab')
%     subplot(1,3,1), xlabel('Error = True - Predicted'), ylabel('Quantity')
%     
%     
%     [h200,b200]=hist(Data(Restrict(Restrict(LinearTrueTsd200,EpochOK200),and(MovEpoch,hab)))-Data(Restrict(Restrict(LinearPredTsd200,EpochOK200),and(MovEpoch,hab))),[-1:0.01:1]);
%     subplot(1,3,2), hold on,plot(b200,h200/max(h200), 'b','DisplayName','Decoding with TW of 200ms'), title('Mov')
%     subplot(1,3,2), xlabel('Error = True - Predicted'), ylabel('Quantity')
% 
%     [h200,b200]=hist(Data(Restrict(Restrict(LinearTrueTsd200,EpochOK200),and(ImmobEpoch,hab)))-Data(Restrict(Restrict(LinearPredTsd200,EpochOK200),and(ImmobEpoch,hab))),[-1:0.01:1]);
%     subplot(1,3,3), hold on, plot(b200,h200/max(h200), 'b','DisplayName','Decoding with TW of 200ms'), title('Immob')
%     subplot(1,3,3), xlabel('Error = True - Predicted'), ylabel('Quantity')
% 
%     lgd = legend('Location','best');
%     lgd.Position(1:2) = [0.685 0.7];
    
    eval(['epoch = ',nameEpoch,';']);
    
    eval(['LinearTrueTsd = LinearTrueTsd',num2str(200),';'])
    eval(['LinearPredTsd = LinearPredTsd',num2str(200),';'])
     eval(['epochtemp=and(and(MovEpoch,epoch),EpochOK',num2str(dur),');'])
%    eval(['epochtemp=and(and(ImmobEpoch,epoch),EpochOK',num2str(dur),');'])
    
    
    clear nb dur
    for i=1:nbbin
        temp1=thresholdIntervals(LinearTrueTsd,(i-1)/(nbbin-1),'Direction','Above');
        temp2=thresholdIntervals(LinearTrueTsd,i/(nbbin-1),'Direction','Below');
        dur(i,:)=[(i-1)/nbbin i/nbbin];
        EpochLin{i}=and(epochtemp,and(temp1,temp2)); 
        nb(i)=length(Data(Restrict(LinearTrueTsd,EpochLin{i})));
    end


    clear R h h2
    for i=1:nbbin
        R(i,1)=mean(abs(Data(Restrict(LinearTrueTsd, and(EpochLin{i},epochtemp)))-Data(Restrict(LinearPredTsd, and(EpochLin{i},epochtemp)))));
        R(i,2)=stdError(abs(Data(Restrict(LinearTrueTsd, and(EpochLin{i},epochtemp)))-Data(Restrict(LinearPredTsd, and(EpochLin{i},epochtemp)))));
        [h(i,:),b]=hist(Data(Restrict(LinearTrueTsd, and(EpochLin{i},epochtemp)))-Data(Restrict(LinearPredTsd, and(EpochLin{i},epochtemp))),[-1:0.01:1]);
        [h2(i,:),b2]=hist(Data(Restrict(LinearPredTsd, and(EpochLin{i},epochtemp))),[0.025:0.05:0.975]);
        
    end
    
    
    figure, 
    subplot(1,3,1), errorbar([1:nbbin]/nbbin,R(:,1),R(:,2)), xlim([0 1])
    subplot(1,3,2), imagesc(b,[1:nbbin]/nbbin,zscore(h')')
    subplot(1,3,3), imagesc([0.025:0.05:0.975],[1:nbbin]/nbbin,zscore(h2))
    subplot(1,3,1), xlabel('Linearized Position')
    subplot(1,3,1), ylabel('Mean Linear Error')
    subplot(1,3,2), xlabel('Value of the Error')
    subplot(1,3,2), ylabel('Linearized Position')
    subplot(1,3,3), xlabel('True Linearized Position')
    subplot(1,3,3), ylabel('Decoded Linearized Position')
    subplot(1,3,1), xlim([0 0.85])
    subplot(1,3,2), xlim([-0.85 0.85])
    subplot(1,3,3), xlim([0 0.85])
    subplot(1,3,1), ylim([0.025 0.85])
    subplot(1,3,2), ylim([0.025 0.85])
    subplot(1,3,3), ylim([0.025 0.85])
end
