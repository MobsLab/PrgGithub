clear all
DownSampl=10;
Future=[5,10,10,10,15,15,20,10];
Past=[5,10,10,20,20,30,30,50];
FitEpoch=20*1e4;
RemLastVals=100;
EMGmice


for file=4:m
    
    cd(filename{file})
    load('StateEpochEMGSB.mat')
    load('StateEpochSB.mat')
    CleanWakeEpoch=Wake-NoiseEpoch-GndNoiseEpoch;
    CleanWakeEpoch=dropShortIntervals(CleanWakeEpoch,50*1e4);
    
    
    
    disp('Gamma Fit')
    for f=1:length(Future)
        num=1;
        Mdl=vgxset('n',1,'nAR',Past(f),'Constant',false);
        while num<250
            for k=1:length(Start(CleanWakeEpoch))
                LongPer=Stop(subset(CleanWakeEpoch,k))-Start(subset(CleanWakeEpoch,k))-5*1e4;
                NumPer=floor(LongPer/FitEpoch);
                St=Start(subset(CleanWakeEpoch,k));
                for nn=1:NumPer
                    Y=Data(Restrict(smooth_ghi,intervalSet(St+(nn-1)*FitEpoch,St+(nn)*FitEpoch)));
                    Y=Y(1:DownSampl:end);Y=Y-nanmean(Y);
                    % Construct model
                    [EstSpec,EstStdErrors,LLF,W]=vgxvarx(Mdl,Y(1:end-Future(f)-RemLastVals));
                    % Crossvalidate on unseen data
                    [Forecast,Cov]=vgxpred(EstSpec,Future(f),[],Y(1:end-Future(f)-RemLastVals));
                    ErrCVG(f,num)=sum(sqrt((Y(end-Future(f)-RemLastVals+1:end-RemLastVals)-Forecast).^2))./sum(sqrt((Y(end-Future(f)-RemLastVals+1:end-RemLastVals)).^2));
                    num=num+1;
                    %             plot(Y,'k','linewidth',2), hold on
                    %             Y2=Y;
                    %             A=EstSpec.AR;
                    %             for n=length(Y(1:end-Future(f)-RemLastVals))+1:length(Y(1:end-RemLastVals))-1
                    %                 Y2(n)=0;
                    %                 for time=1:length(A)
                    %                 Y2(n)=A{time}*Y2(n-time)+ Y2(n);
                    %                 end
                    %             end
                    %             plot(Y2,':r','linewidth',2)
                    %             vgxplot(EstSpec,Y(1:end-RemLastVals-Future(f)),Forecast,Cov)
                    %
                    %             pause
                    %             clf
                end
            end
        end
    end
    
    disp('EMG Fit')
    for f=1:length(Future)
        num=1;
        Mdl=vgxset('n',1,'nAR',Past(f),'Constant',false);
        
        while num<250
            for k=1:length(Start(CleanWakeEpoch))
                LongPer=Stop(subset(CleanWakeEpoch,k))-Start(subset(CleanWakeEpoch,k))-5*1e4;
                NumPer=floor(LongPer/FitEpoch);
                St=Start(subset(CleanWakeEpoch,k));
                for nn=1:NumPer
                    Y=Data(Restrict(EMGData,intervalSet(St+(nn-1)*FitEpoch,St+(nn)*FitEpoch)));
                    Y=Y(1:DownSampl:end);Y=Y-nanmean(Y);
                    % Construct model
                    [EstSpec,EstStdErrors,LLF,W]=vgxvarx(Mdl,Y(1:end-Future(f)-RemLastVals));
                    % Crossvalidate on unseen data
                    [Forecast,Cov]=vgxpred(EstSpec,Future(f),[],Y(1:end-Future(f)-RemLastVals));
                    ErrCVE(f,num)=sum(sqrt((Y(end-Future(f)-RemLastVals+1:end-RemLastVals)-Forecast).^2))./sum(sqrt((Y(end-Future(f)-RemLastVals+1:end-RemLastVals)).^2));
                    num=num+1;
                    %             plot(Y,'k','linewidth',2), hold on
                    %             Y2=Y;
                    %             A=EstSpec.AR;
                    %             for n=length(Y(1:end-Future(f)-RemLastVals))+1:length(Y(1:end-RemLastVals))-1
                    %                 Y2(n)=0;
                    %                 for time=1:length(A)
                    %                 Y2(n)=A{time}*Y2(n-time)+ Y2(n);
                    %                 end
                    %             end
                    %             plot(Y2,':r','linewidth',2)
                    %             vgxplot(EstSpec,Y(1:end-RemLastVals-Future(f)),Forecast,Cov)
                    %
                    %             pause
                    %             clf
                end
            end
        end
    end
    
    save('PredictionError.mat','ErrCVE','ErrCVG')
    clear ErrCVE ErrCVG
end


for file=1:m
    
    cd(filename{file})
load('PredictionError.mat')
MeanEmg(file,:)=mean(ErrCVE');
MeanGamma(file,:)=mean(ErrCVG');
end
clear A,A{1}=MeanEmg';A{2}=MeanGamma';
y=[MeanGamma(:);MeanEmg(:)];
g1=[ones(1,length(MeanGamma(:))),ones(1,length(MeanEmg(:)))*2]';
g2temp=[ones(1,6),ones(1,6)*2,ones(1,6)*3,ones(1,6)*4,ones(1,6)*5,ones(1,6)*6,ones(1,6)*7,ones(1,6)*8];
g2=[g2temp,g2temp]';
[p,tbl,stats] = anovan(y,{g1 g2},'model','interaction',...
    'varnames',{'g1','g2'});
Future=[5,10,10,10,15,15,20,10]*0.0080;
Past=[5,10,10,20,20,30,30,50]*0.0080;
for k=1:8
   CondNames{k}=[num2str(Past(k)), 's -->',num2str(Future(k)),'s'];    
end

PlotErrorBarNGroups(A,1,CondNames,{'EMG','Gamma'})

Y=Data(Restrict(smooth_ghi,subset(CleanWakeEpoch,k)));
Y=Y(1:10:end);Y=Y-nanmean(Y);
Mdl=vgxset('n',1,'nAR',10,'Constant',true);
% Construct model
[EstSpec,EstStdErrors,LLF,W]=vgxvarx(Mdl,Y(1:end-15));
% Crossvalidate on unknown data
[Forecast,Cov]=vgxpred(EstSpec,5,[],Y(1:end-15));
vgxplot(EstSpec,Y(1:end-15),Forecast,Cov), hold on
plot(Y)

vgxdisp(EstSpec, EstStdErrors)
EstW = vgxinfer(EstSpec, Y);

subplot(2,1,1);
plot([ W(:,1), EstW(:,1) ]);
subplot(2,1,2);
plot([ W(:,2), EstW(:,2) ]);
legend('VARMA(2, 2)', 'VAR(2)');



clf
k=[rand(1,5)*0.1];
coef=[1.3,-0.7];
for n=1:9000
    k(5+n)=10+coef(1)*k(5+n-1)+coef(2)*k(5+n-2)+0.1*randn(1);
end
Mdl=vgxset('n',1,'nAR',2,'Constant',false);
% Construct model
[EstSpec,EstStdErrors,LLF,W]=vgxvarx(Mdl,k(1:end-40));
% Crossvalidate on unseen data
[Forecast,Cov]=vgxpred(EstSpec,20,[],k(1:end-40));
vgxplot(EstSpec,k(1:end-40),Forecast,Cov), hold on
plot(k)
for n=8966:8965+40
    k(n)=A{1}*k(n-1)+A{2}*k(n-2);
end
plot(k,'g')
