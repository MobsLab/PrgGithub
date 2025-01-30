
% This codes takes the mice with fluoxetine and saline and looks at the
% effect on REM sleep
clear all, close all
SessionNames={'SleepPre_PreDrug' 'SleepPost_PreDrug' 'SleepPost_PostDrug'};
MouseType = {'Sal','Flx','FlxIneff'};
ReloadData = 1;

SALMice = [688,739,777,779,849];
FLXMice = [740,750,778,775,794,796];
MDZMice = [829,851,856,857,858,859];

if ReloadData
    
    for ss=1:length(SessionNames)
        Files=PathForExperimentsEmbReact(SessionNames{ss});
        
        for mm=1:length(Files.path)
            cd(Files.path{mm}{1})
            load('StateEpochSB.mat','Wake','SWSEpoch','REMEpoch')
            load('ExpeInfo.mat')
            
            if (double(strcmp(ExpeInfo.DrugInjected,'FLX'))+double(strcmp(ExpeInfo.DrugInjected,'FLX-Ineff'))*4)==0
                MouseNum = find(SALMice==ExpeInfo.nmouse);
                MouseType{MouseNum} = 'Sal';
            elseif (double(strcmp(ExpeInfo.DrugInjected,'FLX'))+double(strcmp(ExpeInfo.DrugInjected,'FLX-Ineff'))*4)==1
                MouseNum = find(FLXMice==ExpeInfo.nmouse);
                MouseType{MouseNum} = 'Flx';
            elseif (double(strcmp(ExpeInfo.DrugInjected,'FLX'))+double(strcmp(ExpeInfo.DrugInjected,'FLX-Ineff'))*4)==1
                MouseNum = find(MDZMice==ExpeInfo.nmouse);
                MouseType{MouseNum} = 'MDZ';
            else
                MouseNum = 1;
                MouseType{MouseNum} = 'FlxIneff';

            end
            
            SleepDur.(SessionNames{ss}).(MouseType{MouseNum}).REMDur(MouseNum) = sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'));
            SleepDur.(SessionNames{ss}).(MouseType{MouseNum}).SWSDur(MouseNum) = sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'));
            SleepDur.(SessionNames{ss}).(MouseType{MouseNum}).WakeDur(MouseNum) = sum(Stop(Wake,'s')-Start(Wake,'s'));
        end
    end
    save('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/FLX_SleepEffect.mat','SleepDur')
else
    load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/FLX_SleepEffect.mat')
end


for mt = 1:3
    for ss = 1:length(SessionNames)
        AllRemDur.(MouseType{mt})(ss,:) = SleepDur.(SessionNames{ss}).(MouseType{mt}).REMDur./(SleepDur.(SessionNames{ss}).(MouseType{mt}).REMDur+ SleepDur.(SessionNames{ss}).(MouseType{mt}).SWSDur);
        AllSleepDur.(MouseType{mt})(ss,:) = (SleepDur.(SessionNames{ss}).(MouseType{mt}).REMDur+ SleepDur.(SessionNames{ss}).(MouseType{mt}).SWSDur)./(SleepDur.(SessionNames{ss}).(MouseType{mt}).REMDur+ SleepDur.(SessionNames{ss}).(MouseType{mt}).SWSDur+ SleepDur.(SessionNames{ss}).(MouseType{mt}).WakeDur);
    end
end


figure
subplot(221)
for  k=1:3
    bar(k,nanmean(AllSleepDur.Sal(k,:)),'Facecolor',[0.4 0.4 0.4]),hold on
    plot(k,AllSleepDur.Sal(k,:),'.k','MarkerSize',10)
end
ylabel('% time sleeping')
set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post','Post+Flx'})
title('SALINE')
ylim([0 1])

subplot(222)
for  k=1:3
    bar(k,nanmean(AllSleepDur.Flx(k,:)),'Facecolor',[0.6 0.6 0.6]),hold on
    plot(k,AllSleepDur.Flx(k,:),'.k','MarkerSize',10)
end
ylabel('% time sleeping')
set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post','Post+Flx'})
title('FLUOXETINE')
ylim([0 1])

subplot(223)
for  k=1:3
    bar(k,nanmean(AllRemDur.Sal(k,:)),'Facecolor',[0.4 0.4 0.4]),hold on
    plot(k,AllRemDur.Sal(k,:),'.k','MarkerSize',10)
end
ylabel('% time sleeping')
set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post','Post+Flx'})
ylabel('% time REM/Sleep')
ylim([0 0.3])

subplot(224)
for  k=1:3
    bar(k,nanmean(AllRemDur.Flx(k,:)),'Facecolor',[0.6 0.6 0.6]),hold on
    plot(k,AllRemDur.Flx(k,:),'.k','MarkerSize',10)
        plot(k,AllRemDur.FlxIneff(k,:),'.r','MarkerSize',10)

end
ylabel('% time sleeping')
set(gca,'XTick',[1:3],'XTickLabel',{'Pre','Post','Post+Flx'})
ylabel('% time REM/Sleep')
ylim([0 0.3])

figure
clf
subplot(121)
Cols2 = {[0.8 0.8 0.8],[0.8 0.8 0.8],[1 0.8 1]};
A = {AllRemDur.Sal(1,:),AllRemDur.Sal(2,:),AllRemDur.Sal(3,:)};
MakeSpreadAndBoxPlot_SB(A,Cols2,1:3)

figure
Cols2 = {[1 0.9 1],[1 0.9 1],[1 0.8 1]};
A = {AllRemDur.Flx(1,:),AllRemDur.Flx(2,:),AllRemDur.Flx(3,:)};
MakeSpreadAndBoxPlot_SB(A,Cols2,1:3)
 for  k=1:3
plot(k,AllRemDur.FlxIneff(k,:),'.b','MarkerSize',20)
 end

