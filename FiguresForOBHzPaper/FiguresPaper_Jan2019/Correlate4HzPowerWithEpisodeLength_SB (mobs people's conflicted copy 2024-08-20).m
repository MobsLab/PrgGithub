clear all
Dir = PathForExperimentFEAR('Fear-electrophy');
Dir1 = RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
Dir2 = RestrictPathForExperiment(Dir,'Session','EXT-24h-envB');
Dir3 = RestrictPathForExperiment(Dir,'Session','EXT-48h-envC');
Dir4 = RestrictPathForExperiment(Dir,'Session','EXT-48h-envB');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = MergePathForExperiment(Dir,Dir3);
Dir = MergePathForExperiment(Dir,Dir4);

mousenum=0;
for mm=1:length(Dir.path)
    
    if strcmp(Dir.group{mm},'CTRL')
        cd(Dir.path{mm})
        if exist('B_Low_Spectrum.mat')>0 | exist('ChannelsToAnalyse/Bulb_deep.mat')>0
            
            mousenum = mousenum+1;
            disp(Dir.path{mm})
            
            
            clear Movtsd FreezeEpoch FreezeAccEpoch Spectro
            
            try, load('behavResources.mat');catch,load('Behavior.mat'); end
            if exist('FreezeAccEpoch','var')
                FreezeEpoch = FreezeAccEpoch;
            end
            
            TotEpoch = intervalSet(0,max(Range(Movtsd)));
            FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
            FreezeEpoch = dropShortIntervals(FreezeEpoch,4*1e4);

            
            %             if exist('B_Low_Spectrum.mat')==0
            %                 load('ChannelsToAnalyse/Bulb_deep.mat')
            %                 LowSpectrumSB(cd,channel,'B')
            %                 disp('SpecCalc')
            %             end
            
            load('B_Low_Spectrum.mat')
            sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
            Pow4 = nanmean(Spectro{1}(:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<6,1,'last'))')';
            PowBe = nanmean(Spectro{1}')';
            
            Pow4Hz = tsd(Spectro{2}*1e4,Pow4./PowBe);
            
            for ep = 1:length(Start(FreezeEpoch))
                
                Epo = subset(FreezeEpoch,ep);
                LitPow4Hz = Restrict(Pow4Hz,Epo);
                %                 yyaxis left
                %                 imagesc(Data(Restrict(sptsd,Epo))'), hold on
                %                 yyaxis right
                %                 plot(Data(LitPow4Hz))
                %                 plot(Data(Restrict(MovAcctsd,Epo)))
                %
                %                 pause
                %                 clf
                [val,ind] = max(Data(LitPow4Hz));
                tps = Range(LitPow4Hz,'s');
                PeakTime{mousenum}(ep)= tps(ind)-tps(1);
                EpDur{mousenum}(ep)= tps(end)-tps(1);
                PeakVal{mousenum}(ep)= val;
                MeanVal{mousenum}(ep)=  mean(Data(LitPow4Hz));
                
                MeanVal_Beg{mousenum}(ep)=  mean(Data(Restrict(Pow4Hz,intervalSet(Start(Epo),Start(Epo)+2*1e4))));
                MeanVal_End{mousenum}(ep)=  mean(Data(Restrict(Pow4Hz,intervalSet(Stop(Epo)-2*1e4,Stop(Epo)))));

                if ep < length(Start(FreezeEpoch))
                    TimeToNextFreezing{mousenum}(ep)=  Stop(Epo,'s') - Start(subset(FreezeEpoch,ep+1),'s');
                else
                    TimeToNextFreezing{mousenum}(ep)= NaN;
                end
                
            end
            
        end
    end
    
end

AllData = [];
for mm = 1:mousenum
    AllData = [AllData,[EpDur{mm};TimeToNextFreezing{mm};...
        PeakTime{mm};PeakVal{mm};MeanVal{mm};MeanVal_Beg{mm};MeanVal_End{mm}]];
end
%1 : dur, 2: time to next freezing
%3: Time of peak; 4: Val of peak; 5: Mean Val; 6: Mean Val Beg; 7: Mean Val
%End

figure
subplot(2,2,1)
plot(AllData(1,:),AllData(4,:),'k.'), hold on
set(gca,'xscale','log')
xlim([2 120])
xlabel('Ep dur (s)')
ylabel('Peak 4Hz SNR')
[R,P]=corrcoef(AllData(1,not(isnan(AllData(4,:)))),AllData(4,not(isnan(AllData(4,:)))));
if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end


subplot(2,2,2)
plot(AllData(1,:),AllData(5,:),'k.'), hold on
set(gca,'xscale','log')
xlim([2 120])
xlabel('Ep dur (s)')
ylabel('Mean 4Hz SNR')
[R,P]=corrcoef(AllData(1,not(isnan(AllData(5,:)))),AllData(5,not(isnan(AllData(5,:)))));
if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end


subplot(2,2,3)
plot(AllData(1,:),AllData(6,:),'k.'), hold on
set(gca,'xscale','log')
xlim([2 120])
xlabel('Ep dur (s)')
ylabel('4Hz SNR - Beginning')
[R,P]=corrcoef(AllData(1,not(isnan(AllData(6,:)))),AllData(6,not(isnan(AllData(6,:)))));
if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end

subplot(2,2,4)
plot(AllData(1,:),AllData(7,:),'k.'), hold on
set(gca,'xscale','log')
xlim([2 120])
xlabel('Ep dur (s)')
ylabel('4Hz SNR - End')
[R,P]=corrcoef(AllData(1,not(isnan(AllData(7,:)))),AllData(7,not(isnan(AllData(7,:)))));
if P(1,2)>0.05, title([num2str(R(1,2)), ' NS']), else,title(num2str(R(1,2))), end

