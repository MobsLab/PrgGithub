% ParcoursAutoCorrelogrammeDeltaToneNoTone2


%% Get data



%exp='DeltaTone';
exp='RdmTone';
tic
Dir=PathForExperimentsDeltaSleepKJ_062016(exp);

%params
thresh = 0.2E4; % in 1E-4 s
smoothing_params=3; %for plot

a=1;
for i=1:length(Dir.path)
    try
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(pwd)
        disp(num2str(a))

        load newDeltaPFCx tDelta
        deltas = tDelta;
                 
        load DeltaSleepEvent
        tones = TONEtime2_SWS + Dir.delay{i} * 1E4;
        
        % deltas induced with or without a tone 
        dpfc_tone=[];
        dpfc_notone=[];
        for j=1:length(deltas)
            idx = find(tones<deltas(j),1,'last');
            try
                if ~isempty(idx) && deltas(j)-tones(idx) < thresh
                    dpfc_tone = [dpfc_tone,j];
                else
                    dpfc_notone = [dpfc_notone,j];
                end
            end
        end
        
        %Cross-correlograms
        [C1(a,:),B]=CrossCorr(deltas(dpfc_tone),deltas,300,100);
        C1(a,B==0)=0;
        [C2(a,:),B]=CrossCorr(deltas(dpfc_notone),deltas,300,100);
        C2(a,B==0)=0;
        [C1b(a,:),Bb]=CrossCorr(deltas(dpfc_tone),deltas,1000,500);
        C1b(a,B==0)=0;
        [C2b(a,:),Bb]=CrossCorr(deltas(dpfc_notone),deltas,1000,500);
        C2b(a,B==0)=0;

        tps=B;
        tpsb=Bb;  
        
        MiceName{a}=Dir.name{i};
        PathOK{a}=Dir.path{i};
        a=a+1;
    catch
        disp(['error with ' Dir.path{i}])
    end
end

toc


%% PLOTS

figure('color',[1 1 1]), 

subplot(2,2,1), plot(tps/1E4,nanmean(C1),'k'), hold on, plot(tps/1E4,nanmean(C2),'r'), 
    title('Tone-induced vs normal delta effect'), xlim([tps(1) tps(end)]/1E4)
subplot(2,2,2), plot(tpsb/1E4,nanmean(C1b),'k'), hold on, plot(tpsb/1E4,nanmean(C2b),'r'), 
    title(exp), xlim([tpsb(1) tpsb(end)]/1E4)
subplot(2,2,3), plot(tps/1E4,smooth(nanmean(C1),smoothing_params),'k'), hold on, plot(tps/1E4,smooth(nanmean(C2),smoothing_params),'r'), 
    title('Smoothed'), xlim([tps(1) tps(end)]/1E4)
subplot(2,2,4), plot(tpsb/1E4,smooth(nanmean(C1b),smoothing_params),'k'), hold on, plot(tpsb/1E4,smooth(nanmean(C2b),smoothing_params),'r'), 
    title('Smoothed'), xlim([tpsb(1) tpsb(end)]/1E4)

set(gcf,'position',[ 754    82   570   940])















