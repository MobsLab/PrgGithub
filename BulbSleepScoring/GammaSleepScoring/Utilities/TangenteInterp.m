clear all
DownSampl=[1,5,10,20,50,100,200,500];
FitEpoch=10*1e4;
RemLastVals=100;
EMGmice

for file=1:m
    file
    cd(filename{file})
load('StateEpochEMGSB.mat')
load('StateEpochSB.mat')
CleanWakeEpoch=Wake-NoiseEpoch-GndNoiseEpoch;
CleanWakeEpoch=dropShortIntervals(CleanWakeEpoch,50*1e4);




disp('Gamma Fit')
for d=1:length(DownSampl)
    num=1;
    for k=1:length(Start(CleanWakeEpoch))
        LongPer=Stop(subset(CleanWakeEpoch,k))-Start(subset(CleanWakeEpoch,k))-5*1e4;
        NumPer=floor(LongPer/FitEpoch);
        St=Start(subset(CleanWakeEpoch,k));
        for nn=1:NumPer
            Y=Data(Restrict(smooth_ghi,intervalSet(St+(nn-1)*FitEpoch,St+(nn)*FitEpoch)));
            t=Range(Restrict(smooth_ghi,intervalSet(St+(nn-1)*FitEpoch,St+(nn)*FitEpoch)));
            Y=Y(1:DownSampl(d):end);x=Y-nanmean(Y); t=t(1:DownSampl(d):end);
            TimeToUse=floor(length(Y)/2);
            dy=diff(Y)./diff(t);
            tang=(t-t(TimeToUse))*dy(TimeToUse)+Y(TimeToUse);
            for del=1:5
            ErrCVTanG(d,num,del)=sqrt((Y(TimeToUse+del)-tang(TimeToUse+del)).^2)./abs(Y(TimeToUse+del));
            end

            num=num+1;
%             plot(t,Y) 
%             hold on
%             plot(t,tang)
%             scatter(t(num+1),Y(num+1))
%             scatter(t(num+1),tang(num+1))
% pause
% clf
            
            
        end
    end
end


disp('EMG Fit')
for d=1:length(DownSampl)
    num=1;
    for k=1:length(Start(CleanWakeEpoch))
        LongPer=Stop(subset(CleanWakeEpoch,k))-Start(subset(CleanWakeEpoch,k))-5*1e4;
        NumPer=floor(LongPer/FitEpoch);
        St=Start(subset(CleanWakeEpoch,k));
        for nn=1:NumPer
            Y=Data(Restrict(EMGData,intervalSet(St+(nn-1)*FitEpoch,St+(nn)*FitEpoch)));
            t=Range(Restrict(EMGData,intervalSet(St+(nn-1)*FitEpoch,St+(nn)*FitEpoch)));
            Y=Y(1:DownSampl(d):end);x=Y-nanmean(Y); t=t(1:DownSampl(d):end);
            TimeToUse=floor(length(Y)/2);
            dy=diff(Y)./diff(t);
            tang=(t-t(TimeToUse))*dy(TimeToUse)+Y(TimeToUse);
            for del=1:5
            ErrCVTanE(d,num,del)=sqrt((Y(TimeToUse+del)-tang(TimeToUse+del)).^2)./abs(Y(TimeToUse+del));
            end

            num=num+1;
%             plot(t,Y) 
%             hold on
%             plot(t,tang)
%             scatter(t(num+1),Y(num+1))
%             scatter(t(num+1),tang(num+1))
% pause
% clf
            
            
        end
    end
end
save('PredictionErrorTangente.mat','ErrCVTanE','ErrCVTanG')
clear ErrCVTanE ErrCVTanG

end

figure
for file=1:m
    file
    cd(filename{file})
    load('PredictionErrorTangente.mat','ErrCVTanE','ErrCVTanG')
    cols=distinguishable_colors(length(DownSampl));
    for s=1:length(DownSampl)
        subplot(121)
        dattemp=squeeze(ErrCVTanG(s,:,2:5));
        errorbar([1:4],mean(dattemp),abs(mean(dattemp)-prctile(dattemp,2.5)),abs(mean(dattemp)-prctile(dattemp,97.5)),'color',cols(s,:),'linewidth',2),hold on
        set(gca,'YScale','linear')
        RemG{s}(file,:)=mean(dattemp);
        subplot(122)
        dattemp=squeeze(ErrCVTanE(s,:,2:5));
        errorbar([1:4],mean(dattemp),abs(mean(dattemp)-prctile(dattemp,2.5)),abs(mean(dattemp)-prctile(dattemp,97.5)),'color',cols(s,:),'linewidth',2),hold on
        set(gca,'YScale','linear')
        RemE{s}(file,:)=mean(dattemp);
        
    end
end


clf
    for s=1:length(DownSampl)
        errorbar([1:4],mean( RemG{s}),stdError(RemG{s}),'color',cols(s,:),'linewidth',2),hold on
        errorbar([1:4],mean( RemE{s}),stdError(RemE{s}),'color',cols(s,:),'linewidth',2,'linestyle','--'),hold on
    end
    box off
    set(gca,'YScale','log')
    xlabel('steps ahead')
    ylabel('relative error')


%Example
t=0:0.01:10
y=sin(t)
plot(t,Y)
%-------------------------
dy=diff(y)./diff(t)

k=220; % point number 220
tang=(t-t(k))*dy(k)+y(k)
hold on
plot(t,tang)
scatter(t(k),y(k))
hold off
