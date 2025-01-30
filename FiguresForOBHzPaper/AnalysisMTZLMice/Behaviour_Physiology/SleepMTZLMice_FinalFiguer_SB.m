clear all
Dir = PathForExperimentsMtzlProject('BaselineSleep');
load('/home/gruffalo/Dropbox/Kteam/IRCameraCalibration/CalibrationOct2017IRCamera.mat')
TempOutput(isnan(ValuesInput))=[];
ValuesInput(isnan(ValuesInput))=[];

for mouse = 1:length(Dir.path)
    for day = 1:4
        close all
        cd(Dir.path{mouse}{day})
        disp(Dir.path{mouse}{day})
        
        if exist('LFPData') == 7
            try
            clear Wake REMEpoch SWSEpoch
            load('SleepScoring_Accelero.mat','Wake','REMEpoch','SWSEpoch','Epoch','TotalNoiseEpoch')
            TotEpoch = or(Epoch,TotalNoiseEpoch);
            
            RemPerc(mouse,day) = sum(Stop(REMEpoch)-Start(REMEpoch))./sum(Stop(or(REMEpoch,SWSEpoch))-Start(or(REMEpoch,SWSEpoch)));
            SleepPerc(mouse,day) = sum(Stop(or(REMEpoch,SWSEpoch))-Start(or(REMEpoch,SWSEpoch)))./sum(Stop(TotEpoch)-Start(TotEpoch));
            MouseSaline(mouse) = strcmp(Dir.ExpeInfo{mouse}{day}.DrugInjected ,'SALINE');
            
            try
                clear MouseTemp_InDegrees frame_limits
                load('behavResources.mat','MouseTemp_InDegrees','PosMat')
                    if sum(MouseTemp_InDegrees(:,1)*1e4)==0
                        MouseTemp_InDegrees(:,1) = [1/length(MouseTemp_InDegrees):max(PosMat(:,1))/length(MouseTemp_InDegrees):max(PosMat(:,1))];
                    end
                Temptsd = tsd(MouseTemp_InDegrees(:,1)*1e4,MouseTemp_InDegrees(:,2));
                BodyTemp(mouse,day) = nanmean(Data(Restrict(Temptsd,SWSEpoch)));
            catch
                BodyTemp(mouse,day) = NaN;
            end
            end
        else
            
            RemPerc(mouse,day) = NaN;
            SleepPerc(mouse,day) = NaN;
            MouseSaline(mouse) = 3;
            BodyTemp(mouse,day) = NaN;
            
        end
    end
    
end

Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.6 0.6]};
figure
subplot(311)
errorbar([1:4],nanmean(SleepPerc(MouseSaline==1,:)),stdError(SleepPerc(MouseSaline==1,:)),'linewidth',2,'color',Cols{1})
hold on
errorbar([1:4],nanmean(SleepPerc(MouseSaline==0,:)),stdError(SleepPerc(MouseSaline==0,:)),'linewidth',2,'color',Cols{2})
box off
ylabel('% time sleeping')
set(gca,'FontSize',15,'linewidth',1.5)
legend('SAL','MTZL')
xlim([0.5 4.5])
A = SleepPerc(MouseSaline==1,:);
B= SleepPerc(MouseSaline==0,:);
B(8:end,:) = [];
for day = 1:4
    [p(day),h(day),stats(day)] = ranksum(A(:,(day)),B(:,(day)));
end

subplot(312)
errorbar([1:4],nanmean(RemPerc(MouseSaline==1,:)),stdError(RemPerc(MouseSaline==1,:)),'linewidth',2,'color',Cols{1})
hold on
errorbar([1:4],nanmean(RemPerc(MouseSaline==0,:)),stdError(RemPerc(MouseSaline==0,:)),'linewidth',2,'color',Cols{2})
ylabel('% REM of total sleep')
box off
set(gca,'FontSize',15,'linewidth',1.5)
xlim([0.5 4.5])
A = RemPerc(MouseSaline==1,:);
B= RemPerc(MouseSaline==0,:);
B(8:end,:) = [];
for day = 1:4
    [p(day),h(day),stats(day)] = ranksum(A(:,(day)),B(:,(day)));
end

subplot(313)
errorbar([1:4],nanmean(BodyTemp(MouseSaline==1,:)),stdError(BodyTemp(MouseSaline==1,:)),'linewidth',2,'color',Cols{1})
hold on
errorbar([1:4],nanmean(BodyTemp(MouseSaline==0,:)),stdError(BodyTemp(MouseSaline==0,:)),'linewidth',2,'color',Cols{2})
ylabel('Body temperature')
box off
set(gca,'FontSize',15,'linewidth',1.5)
xlim([0.5 4.5])
A = BodyTemp(MouseSaline==1,:);
A(sum(isnan(A'))>3,:) = [];

B= BodyTemp(MouseSaline==0,:);
B(sum(isnan(B'))>3,:) = [];
for day = 1:4
    [p(day),h(day),stats(day)] = ranksum(A(:,(day)),B(:,(day)));
end


anova2([A;B],5)

