clear all
FilePath{1} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/Mouse666/';
FilePath{2} = '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/Mouse689/';
Dates{1} = '09052018';
Dates{2} = '10052018';
Dates{3} = '14052018';
Dates{4} = '15052018';
Dates{5} = '16052018';
Dates{6} = '17052018';
Dates{7} = '18052018';


clear AllSpeed AllMov
for  mm = 1:2
    for dd =1:7
        cd([FilePath{mm} Dates{dd}])
        clear Vtsd, try,load('behavResources.mat','Vtsd','Imdifftsd','Xtsd','Ytsd')
%         Vtsd=tsd(Range(Vtsd),sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2)./diff(Range(Xtsd,'s')));
        end
        load('H_Low_Spectrum.mat')
        sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
        
        clear SWSEpoch REMEpoch Wake
        load('SleepScoring_Accelero.mat','tsdMovement','SWSEpoch','REMEpoch','Wake','Info')
        SWSEpoch_Acc = SWSEpoch;
        Wake_Acc = Wake;
        REMEpoch_Acc = REMEpoch;
        
        AccThresh(mm,dd) = Info.mov_threshold;
        
        
        clear SWSEpoch REMEpoch Wake
        load('SleepScoring_OBGamma.mat','SWSEpoch','REMEpoch','Wake');
        SWSEpoch_OBGamma = SWSEpoch;
        Wake_OBGamma = Wake;
        REMEpoch_OBGamma = REMEpoch;
        
        s=sum(Stop(SWSEpoch_Acc,'s')-Start(SWSEpoch_Acc,'s'));
        r=sum(Stop(REMEpoch_Acc,'s')-Start(REMEpoch_Acc,'s'));
        w=sum(Stop(Wake_Acc,'s')-Start(Wake_Acc,'s'));
        RemProp_Acc(mm,dd) = r/(s+r);
        SleepProp_Acc(mm,dd) = w/(s+r+w);
        
        AllMov_Acc{mm}{dd} = Data(Restrict(tsdMovement,Wake_Acc));
        AllImdiff_Acc{mm}{dd} = Data(Restrict(Imdifftsd,Wake_Acc));
        if exist('Vtsd')
            AllSpeed_Acc{mm}{dd} = (Data(Restrict(Vtsd,Wake_Acc)));
        end
        HPCSpec_REM_Acc{mm}(dd,:) = nanmean(Data(Restrict(sptsd,REMEpoch_Acc)));
        
        s=sum(Stop(SWSEpoch_OBGamma,'s')-Start(SWSEpoch_OBGamma,'s'));
        r=sum(Stop(REMEpoch_OBGamma,'s')-Start(REMEpoch_OBGamma,'s'));
        w=sum(Stop(Wake_OBGamma,'s')-Start(Wake_OBGamma,'s'));
        RemProp_OBGamma(mm,dd) = r/(s+r);
        SleepProp_OBGamma(mm,dd) = w/(s+r+w);
        AllMov_OBGamma{mm}{dd} = Data(Restrict(tsdMovement,Wake_OBGamma));
        AllImdiff_OBGamma{mm}{dd} = Data(Restrict(Imdifftsd,Wake_OBGamma));
        if exist('Vtsd')
            AllSpeed_OBGamma{mm}{dd} = (Data(Restrict(Vtsd,Wake_OBGamma)));
        end
        HPCSpec_REM_OBGamma{mm}(dd,:) = nanmean(Data(Restrict(sptsd,REMEpoch_OBGamma)));
        
    end
end


figure
for mm = 1 :2
    subplot(2,4,(mm-1)*4+1)
    bar(SleepProp_Acc(mm,:))
    set(gca,'XTickLabel',{'Pre','Pre','day1','day2','day3','DAY4'})
    line([2.5 2.5],ylim,'color','k','linewidth',3)
    ylabel('Prop wake')
    
    subplot(2,4,(mm-1)*4+2)
    bar(RemProp_Acc(mm,:))
    set(gca,'XTickLabel',{'Pre','Pre','day1','day2','day3','DAY4'})
    line([2.5 2.5],ylim,'color','k','linewidth',3)
    ylabel('Prop REM/tot sleep')
    
    subplot(2,4,(mm-1)*4+3)
    cols = {'k','k','b','b','b','r'}
    for dd =[1,2,6]
        [Y,X] = hist(log(AllMov_Acc{mm}{dd}),500);
        stairs(X,cumsum(Y)/sum(Y),'color',cols{dd},'linewidth',2)
        hold on
    end
    legend({'Pre','Pre','DAY4'})

    
    subplot(2,4,(mm-1)*4+4)
    cols = {'k','k','b','b','b','r'}
    for dd =[1,2,5]
        [Y,X] = hist(log(AllSpeed_Acc{mm}{dd}),500);
        stairs(X,cumsum(Y)/sum(Y),'color',cols{dd},'linewidth',2)
        hold on
    end
    legend({'Pre','Pre','DAY4'})
end

figure
for mm = 1 :2
    subplot(2,4,(mm-1)*4+1)
    bar(SleepProp_OBGamma(mm,:))
    set(gca,'XTickLabel',{'Pre','Pre','day1','day2','day3','DAY4'})
    line([2.5 2.5],ylim,'color','k','linewidth',3)
    ylabel('Prop wake')
    
    subplot(2,4,(mm-1)*4+2)
    bar(RemProp_OBGamma(mm,:))
    set(gca,'XTickLabel',{'Pre','Pre','day1','day2','day3','DAY4'})
    line([2.5 2.5],ylim,'color','k','linewidth',3)
    ylabel('Prop REM/tot sleep')
    
    subplot(2,4,(mm-1)*4+3)
    cols = {'k','k','b','b','b','r'}
    for dd =[1:6]
        [Y,X] = hist(log(AllMov_OBGamma{mm}{dd}),500);
        stairs(X,cumsum(Y)/sum(Y),'color',cols{dd},'linewidth',2)
        hold on
    end
    legend({'Pre','Pre','DAY4'})

    
    subplot(2,4,(mm-1)*4+4)
    cols = {'k','k','b','b','b','r'}
    for dd =[1:5]
        [Y,X] = hist(log(AllSpeed_OBGamma{mm}{dd}),500);
        stairs(X,cumsum(Y)/sum(Y),'color',cols{dd},'linewidth',2)
        hold on
    end
    legend({'Pre','Pre','DAY4'})
end

fact = 1;
for mm = 1:2
    for dd = 1:7
        AllSpeed_Acc_log{mm}{dd} = log(AllSpeed_Acc{mm}{dd});
        MedSpeed(mm,dd) = nanmedian((AllSpeed_OBGamma{mm}{dd}));
        try,
            Sptemp = AllSpeed_Acc{mm}{dd}(1:fact:8800)/0.13;
            Sptemp(Sptemp<2) =NaN;
            TravDist(mm,dd) = nansum(Sptemp*0.13*fact);
        catch
            TravDist(mm,dd) = NaN;
        end
    end
end

Data = [(TravDist(:,1)');(TravDist(:,5)')]/1000;
PlotErrorBarN_KJ(Data')
set(gca,'XTick',[1,2],'XTickLabels',{'Pre Injection','Post Injection'})
ylabel('Distance travelled (m)')


bar(TravDist')

figure
Data = [mean(RemProp_Acc(:,1:2)');mean(RemProp_Acc(:,3:6)')]*100;
PlotErrorBarN_KJ(Data')
set(gca,'XTick',[1,2],'XTickLabels',{'Pre Injection','Post Injection'},'YTick',[0:2:10])
ylabel('% REM sleep')

figure
Data = [(TravDist(:,1)');(TravDist(:,5)')]/100;
PlotErrorBarN_KJ(Data')
set(gca,'XTick',[1,2],'XTickLabels',{'Pre Injection','Post Injection'})
ylabel('distance travelled')

