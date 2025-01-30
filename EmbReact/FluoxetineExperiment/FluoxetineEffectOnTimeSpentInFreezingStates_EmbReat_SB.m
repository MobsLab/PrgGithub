clear all
SessNames={'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'TestPre_PreDrug',...
    'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug','UMazeCondExplo_PreDrug',...
    'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug','UMazeCondExplo_PostDrug',...
    'TestPost_PostDrug',...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };

SessNum = [1,1,4,2,2,2,2,2,2,4,2,2];

MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859];
Mice.FlxChr = [875 876 877 1001 1002 1095];


for ss = 1:length(SessNames) % fait toutes les sessions une par une
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    for d=1:length(Dir.path) % va dans chaque session
        for dd=1:SessNum(ss) %va dans chaque sous session
            cd(Dir.path{d}{dd})
            disp(Dir.path{d}{dd})
            load('ExpeInfo.mat')
            load('behavResources_SB.mat')
            load('B_Low_Spectrum.mat')
            fLow = Spectro{3};
            Sptsd_B = tsd(Spectro{2}*1e4,Spectro{1});
            
            A = SmoothDec(Data(Sptsd_B),[2 0.01]);
            [val,ind] = max(A(:,30:end)');
            Freqtsd = tsd(Range(Sptsd_B),fLow(30+ind)');
            
            LowEpoch = thresholdIntervals(Freqtsd,3.5,'Direction','Below');
            HighEpoch = thresholdIntervals(Freqtsd,3.5,'Direction','Above');
                        
            if ExpeInfo.DrugInjected=='SAL'
                MouseNum = find(Mice.Sal==ExpeInfo.nmouse);
                MouseType = 'Sal';
            elseif ExpeInfo.DrugInjected=='MDZ'
                MouseNum = find(Mice.Mdz==ExpeInfo.nmouse);
                MouseType = 'Mdz';
            elseif ExpeInfo.DrugInjected=='FLX'
                MouseNum = find(Mice.Flx==ExpeInfo.nmouse);
                MouseType = 'Flx';
            elseif ExpeInfo.DrugInjected=='FLXCHRONIC'
                MouseNum = find(Mice.FlxChr==ExpeInfo.nmouse);
                MouseType = 'FlxChr';
            end
            
            
            if isfield(Behav,'EscapeLat')
                if isnan(Params.DoorRemoved)
                    Params.DoorRemoved = 300;
                end
                Behav.FreezeAccEpoch = and(Behav.FreezeAccEpoch,intervalSet(0,Params.DoorRemoved*1e4));
                for zone = 1:5
                    Behav.ZoneEpoch{zone} = and(Behav.ZoneEpoch{zone},intervalSet(0,Params.DoorRemoved*1e4));
                end
            end
            
            if not(isempty(MouseNum))
                TimeSpentFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = sum(Stop(Behav.FreezeAccEpoch,'s')-Start(Behav.FreezeAccEpoch,'s'));
                TimeSpentLoFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = sum(Stop(and(Behav.FreezeAccEpoch,LowEpoch),'s')-Start(and(Behav.FreezeAccEpoch,LowEpoch),'s'));
                TimeSpentHiFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = sum(Stop(and(Behav.FreezeAccEpoch,HighEpoch),'s')-Start(and(Behav.FreezeAccEpoch,HighEpoch),'s'));
                MouseNumber.(SessNames{ss}).(MouseType)(MouseNum) = ExpeInfo.nmouse;
                for zone = 1:5
                    
                    ZoneEpochNoFz = Behav.ZoneEpoch{zone} - Behav.FreezeAccEpoch;
                    ZoneEpochFz = and(Behav.ZoneEpoch{zone},Behav.FreezeAccEpoch);
                    
                    % Time spent
                    TimeSpentTotZones.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = sum(Stop(Behav.ZoneEpoch{zone},'s')-Start(Behav.ZoneEpoch{zone},'s'));
                    
                    % Time spent freezing
                    TimeSpentFzZones.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = sum(Stop(ZoneEpochFz,'s')-Start(ZoneEpochFz,'s'));
                    
                    % Time spent High freezing
                    TimeSpentFzZonesHigh.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = sum(Stop(and(ZoneEpochFz,HighEpoch),'s')-Start(and(ZoneEpochFz,HighEpoch),'s'));
                    
                    % Time spent Low freezing
                    TimeSpentFzZonesLow.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = sum(Stop(and(ZoneEpochFz,LowEpoch),'s')-Start(and(ZoneEpochFz,LowEpoch),'s'));
                    
                end
            end
            
        end
    end
end


%load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/TimeSpentFreezing_FLX_Sal.mat','TimeSpentFzZonesLow',...
 %   'TimeSpentFzZonesHigh','TimeSpentFzZones','TimeSpentTotZones','TimeSpentFz','TimeSpentLoFz','TimeSpentHiFz','SessNames','MouseNumber')



% Sessions={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug','UMazeCondExplo_PostDrug',...
%     'TestPost_PostDrug','ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };
%Sessions={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };
% Sessions={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug','UMazeCondExplo_PostDrug'};
% Sessions={'TestPost_PostDrug' };
% 
Sessions={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug','ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };

TotTimeZones.Sal = zeros(4,5);
TotTimeZones.Flx = zeros(4,5);
TotTimeZones.Mdz = zeros(4,5);
TotTimeZones.FlxChr = zeros(4,5);

TotFzTimeZones.Sal = zeros(4,5);
TotFzTimeZones.Flx = zeros(4,5);
TotFzTimeZones.Mdz = zeros(4,5);
TotFzTimeZones.FlxChr = zeros(4,5);

TotFzHiTimeZones.Sal = zeros(4,5);
TotFzHiTimeZones.Flx = zeros(4,5);
TotFzHiTimeZones.Mdz = zeros(4,5);
TotFzHiTimeZones.FlxChr = zeros(4,5);

TotFzLoTimeZones.Sal = zeros(4,5);
TotFzLoTimeZones.Flx = zeros(4,5);
TotFzLoTimeZones.Mdz = zeros(4,5);
TotFzLoTimeZones.FlxChr = zeros(4,5);

TotFz.Sal = zeros(4,1);
TotFz.Flx = zeros(4,1);
TotFz.Mdz = zeros(4,1);
TotFz.FlxChr = zeros(4,1);

TotHiFz.Sal = zeros(4,1);
TotHiFz.Flx = zeros(4,1);
TotHiFz.Mdz = zeros(4,1);
TotHiFz.FlxChr = zeros(4,1);

TotLoFz.Sal = zeros(4,1);
TotLoFz.Flx = zeros(4,1);
TotLoFz.Mdz = zeros(4,1);
TotLoFz.FlxChr = zeros(4,1);

for ss = 1:length(Sessions)
    for mg=1:length(MouseGroup)
    TotTimeZones.(MouseGroup{mg}) = TotTimeZones.(MouseGroup{mg}) + nansum(TimeSpentTotZones.(Sessions{ss}).(MouseGroup{mg}),3);

    TotFzTimeZones.(MouseGroup{mg}) = TotFzTimeZones.(MouseGroup{mg}) + nansum(TimeSpentFzZones.(Sessions{ss}).(MouseGroup{mg}),3);

    TotFzHiTimeZones.(MouseGroup{mg}) = TotFzHiTimeZones.(MouseGroup{mg}) + nansum(TimeSpentFzZonesHigh.(Sessions{ss}).(MouseGroup{mg}),3);
    
    TotFzLoTimeZones.(MouseGroup{mg}) = TotFzLoTimeZones.(MouseGroup{mg}) + nansum(TimeSpentFzZonesLow.(Sessions{ss}).(MouseGroup{mg}),3);
    
    TotFz.(MouseGroup{mg}) = TotFz.(MouseGroup{mg}) + nansum(TimeSpentFz.(Sessions{ss}).(MouseGroup{mg}),2);

    TotLoFz.(MouseGroup{mg}) = TotLoFz.(MouseGroup{mg}) + nansum(TimeSpentLoFz.(Sessions{ss}).(MouseGroup{mg}),2);
    
    TotHiFz.(MouseGroup{mg}) = TotHiFz.(MouseGroup{mg}) + nansum(TimeSpentHiFz.(Sessions{ss}).(MouseGroup{mg}),2);
    end
end
%%
% Look at how time is spent in each region
for mg=2:length(MouseGroup)
    figure
    clf
    A = sum(TotFzLoTimeZones.Sal(:,1:2)',1)'./sum(TotTimeZones.Sal(:,1:2)',1)';
    B = sum(TotFzLoTimeZones.(MouseGroupe{mg})(:,1:2)',1)'./sum(TotTimeZones.(MouseGroupe{mg})(:,1:2)',1)';
    if length(B)<6
        k=6-length(B)
    
    
    
    
    subplot(3,2,1)
    PlotErrorSpreadN_KJ(100*[A,B],'newfig',0),ylim([0 30])
    set(gca,'XTick',[1,2],'XTickLabel',{'Sal',MouseGroupe{mg}})
    ylabel('% Low freq freezing')

    A = sum(TotFzHiTimeZones.Sal(:,1:2)',1)'./sum(TotTimeZones.Sal(:,1:2)',1)';
    B = sum(TotFzHiTimeZones.(MouseGroupe{mg})(:,1:2)',1)'./sum(TotTimeZones.(MouseGroupe{mg})(:,1:2)',1)';
    subplot(3,2,2)
    PlotErrorSpreadN_KJ(100*[A,B],'newfig',0),ylim([0 30])
    set(gca,'XTick',[1,2],'XTickLabel',{'Sal',MouseGroupe{mg}})
    ylabel('% Hi freq freezing')

    A = sum(TotFzTimeZones.Sal(:,1)',1)'./sum(TotTimeZones.Sal(:,1:2)',1)';
    B = sum(TotFzTimeZones.(MouseGroupe{mg})(:,1)',1)'./sum(TotTimeZones.(MouseGroupe{mg})(:,1:2)',1)';
    subplot(3,2,3)
    PlotErrorSpreadN_KJ(100*[A,B],'newfig',0),ylim([0 30])
    set(gca,'XTick',[1,2],'XTickLabel',{'Sal',MouseGroupe{mg}})
    ylabel('% Shock side freezing')

    A = sum(TotFzTimeZones.Sal(:,2)',1)'./sum(TotTimeZones.Sal(:,1:2)',1)';
    B = sum(TotFzTimeZones.(MouseGroupe{mg})(:,2)',1)'./sum(TotTimeZones.(MouseGroupe{mg})(:,1:2)',1)';
    subplot(3,2,4)
    PlotErrorSpreadN_KJ(100*[A,B],'newfig',0),ylim([0 30])
    set(gca,'XTick',[1,2],'XTickLabel',{'Sal',MouseGroupe{mg}})
    ylabel('% Safe side freezing')

    A = sum(TotFzHiTimeZones.Sal(:,1)',1)'./sum(TotTimeZones.Sal(:,1)',1)';
    B = sum(TotFzHiTimeZones.(MouseGroupe{mg})(:,1)',1)'./sum(TotTimeZones.(MouseGroupe{mg})(:,1)',1)';
    subplot(3,2,5)
    PlotErrorSpreadN_KJ(100*[A,B],'newfig',0),ylim([0 60])
    set(gca,'XTick',[1,2],'XTickLabel',{'Sal',MouseGroupe{mg}})
    ylabel('% Hi freq freezing - Shock')

    A = sum(TotFzHiTimeZones.Sal(:,2)',1)'./sum(TotTimeZones.Sal(:,2)',1)';
    B = sum(TotFzHiTimeZones.(MouseGroupe{mg})(:,2)',1)'./sum(TotTimeZones.(MouseGroupe{mg})(:,2)',1)';
    subplot(3,2,6)
    PlotErrorSpreadN_KJ(100*[A,B],'newfig',0),ylim([0 60])
    set(gca,'XTick',[1,2],'XTickLabel',{'Sal',MouseGroupe{mg}})
    ylabel('% Hi freq freezing - Safe')
end

%%
% Pie chart in each zone
% Shock
for mg=2:length(MouseGroup)
figure 
clf
A =  [sum(TotFzLoTimeZones.Sal(:,1)',1)'./sum(TotTimeZones.Sal(:,1)',1)',...
    sum(TotFzHiTimeZones.Sal(:,1)',1)'./sum(TotTimeZones.Sal(:,1)',1)',...
    1- sum(TotFzTimeZones.Sal(:,1)',1)'./sum(TotTimeZones.Sal(:,1)',1)'];
subplot(221)
pie(mean(A))
colormap([0 0 1;1 0 0;0.8 0.8 0.8])
title('Saline - Shock zone')

A =  [sum(TotFzLoTimeZones.Flx(:,1)',1)'./sum(TotTimeZones.Flx(:,1)',1)',...
    sum(TotFzHiTimeZones.Flx(:,1)',1)'./sum(TotTimeZones.Flx(:,1)',1)',...
    1- sum(TotFzTimeZones.Flx(:,1)',1)'./sum(TotTimeZones.Flx(:,1)',1)'];
subplot(222)
pie(mean(A))
colormap([0 0 1;1 0 0;0.8 0.8 0.8])
title('Flx - Shock zone')

A =  [sum(TotFzLoTimeZones.Sal(:,2)',1)'./sum(TotTimeZones.Sal(:,2)',1)',...
    sum(TotFzHiTimeZones.Sal(:,2)',1)'./sum(TotTimeZones.Sal(:,2)',1)',...
    1- sum(TotFzTimeZones.Sal(:,2)',1)'./sum(TotTimeZones.Sal(:,2)',1)'];
subplot(223)
pie(mean(A))
colormap([0 0 1;1 0 0;0.8 0.8 0.8])
title('Saline - Safe zone')

A =  [sum(TotFzLoTimeZones.Flx(:,2)',1)'./sum(TotTimeZones.Flx(:,2)',1)',...
    sum(TotFzHiTimeZones.Flx(:,2)',1)'./sum(TotTimeZones.Flx(:,2)',1)',...
    1- sum(TotFzTimeZones.Flx(:,2)',1)'./sum(TotTimeZones.Flx(:,2)',1)'];
subplot(224)
pie(mean(A))
colormap([0 0 1;1 0 0;0.8 0.8 0.8])
title('Flx - Safe zone')

%% Look inside the freezing
figure
clf
A = sum(TotFzLoTimeZones.Sal(:,1:2)',1)'./sum(TotFzTimeZones.Sal(:,1:2)',1)';ylim([0 100])
B = sum(TotFzLoTimeZones.Flx(:,1:2)',1)'./sum(TotFzTimeZones.Flx(:,1:2)',1)';ylim([0 100])
subplot(3,2,1)
PlotErrorSpreadN_KJ(100*[A,B],'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% Low freq freezing')

A = sum(TotFzHiTimeZones.Sal(:,1:2)',1)'./sum(TotFzTimeZones.Sal(:,1:2)',1)';ylim([0 100])
B = sum(TotFzHiTimeZones.Flx(:,1:2)',1)'./sum(TotFzTimeZones.Flx(:,1:2)',1)';ylim([0 100])
subplot(3,2,2)
PlotErrorSpreadN_KJ(100*[A,B],'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% Hi freq freezing')

A = sum(TotFzTimeZones.Sal(:,1)',1)'./sum(TotFzTimeZones.Sal(:,1:2)',1)';ylim([0 100])
B = sum(TotFzTimeZones.Flx(:,1)',1)'./sum(TotFzTimeZones.Flx(:,1:2)',1)';ylim([0 100])
subplot(3,2,3)
PlotErrorSpreadN_KJ(100*[A,B],'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% Shock side freezing')

A = sum(TotFzTimeZones.Sal(:,2)',1)'./sum(TotFzTimeZones.Sal(:,1:2)',1)';ylim([0 100])
B = sum(TotFzTimeZones.Flx(:,2)',1)'./sum(TotFzTimeZones.Flx(:,1:2)',1)';ylim([0 100])
subplot(3,2,4)
PlotErrorSpreadN_KJ(100*[A,B],'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% Safe side freezing')

A = sum(TotFzHiTimeZones.Sal(:,1)',1)'./sum(TotFzTimeZones.Sal(:,1)',1)';ylim([0 100])
B = sum(TotFzHiTimeZones.Flx(:,1)',1)'./sum(TotFzTimeZones.Flx(:,1)',1)';ylim([0 100])
subplot(3,2,5)
PlotErrorSpreadN_KJ(100*[A,B],'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% Hi freq freezing - Shock')

A = sum(TotFzLoTimeZones.Sal(:,2)',1)'./sum(TotFzTimeZones.Sal(:,2)',1)';ylim([0 100])
B = sum(TotFzLoTimeZones.Flx(:,2)',1)'./sum(TotFzTimeZones.Flx(:,2)',1)';ylim([0 100])
subplot(3,2,6)
PlotErrorSpreadN_KJ(100*[A,B],'newfig',0)
set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'})
ylabel('% Lo freq freezing - Safe')



figure
subplot(121)
A = [TotFzHiTimeZones.Sal(:,1)./sum(TotFzTimeZones.Sal(:,1:2)',1)',...
TotFzHiTimeZones.Sal(:,2)./sum(TotFzTimeZones.Sal(:,1:2)',1)',...
TotFzLoTimeZones.Sal(:,2)./sum(TotFzTimeZones.Sal(:,1:2)',1)',...
TotFzLoTimeZones.Sal(:,1)./sum(TotFzTimeZones.Sal(:,1:2)',1)'];
colormap([1 0 0;0.4 0.4 0.8;0 0 1;0.8 0.4 0.4])
pie(sum(A))
legend({'HiSk','HiSf','LoSf','LoSk'})
B = [TotFzHiTimeZones.Flx(:,1)./sum(TotFzTimeZones.Flx(:,1:2)',1)',...
TotFzHiTimeZones.Flx(:,2)./sum(TotFzTimeZones.Flx(:,1:2)',1)',...
TotFzLoTimeZones.Flx(:,2)./sum(TotFzTimeZones.Flx(:,1:2)',1)',...
TotFzLoTimeZones.Flx(:,1)./sum(TotFzTimeZones.Flx(:,1:2)',1)'];
subplot(122)
pie(sum(B))

%%

figure
subplot(121)
A = TotFzHiTimeZones.Sal(:,2)./sum(TotFzTimeZones.Sal(:,2)',1)';
B = TotFzHiTimeZones.Flx(:,2)./sum(TotFzTimeZones.Flx(:,2)',1)';
PlotErrorSpreadN_KJ([A,B],'newfig',0)
subplot(122)
A = TotFzHiTimeZones.Sal(:,1)./sum(TotFzTimeZones.Sal(:,1)',1)';
B = TotFzHiTimeZones.Flx(:,1)./sum(TotFzTimeZones.Flx(:,1)',1)';
PlotErrorSpreadN_KJ([A,B],'newfig',0)


figure
clf
subplot(321)
PlotErrorSpreadN_KJ(TotTimeZones.Sal(:,[1,4,3,5,2]),'newfig',0), ylim([0 5000])
subplot(322)
PlotErrorSpreadN_KJ(TotTimeZones.Flx(:,[1,4,3,5,2]),'newfig',0), ylim([0 5000])

subplot(323)
PlotErrorSpreadN_KJ(TotFzTimeZones.Sal(:,[1,4,3,5,2])./TotTimeZones.Sal(:,[1,4,3,5,2]),'newfig',0),% ylim([0 .3])
subplot(324)
PlotErrorSpreadN_KJ(TotFzTimeZones.Flx(:,[1,4,3,5,2])./TotTimeZones.Flx(:,[1,4,3,5,2]),'newfig',0), %ylim([0 .3])

subplot(325)
PlotErrorSpreadN_KJ(TotFzHiTimeZones.Sal(:,[1,4,3,5,2])./TotFzTimeZones.Sal(:,[1,4,3,5,2]),'newfig',0),ylim([0 1])
subplot(326)
PlotErrorSpreadN_KJ(TotFzHiTimeZones.Flx(:,[1,4,3,5,2])./TotFzTimeZones.Flx(:,[1,4,3,5,2]),'newfig',0),ylim([0 1])



Sessions={'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'TestPre_PreDrug',...
    'UMazeCondExplo_PreDrug','UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
    'UMazeCondExplo_PostDrug','UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'TestPost_PostDrug',...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };
TotFzHiTimeZones.Sal = [];
TotFzHiTimeZones.Flx = [];
TotFzLoTimeZones.Sal = [];
TotFzLoTimeZones.Flx = [];

RealOrder = [1,2,3,4,5,6,...
    7,9,11,8,10,12,...
    13,15,17,14,16,18,...
    19,20,21,22,...
    23,25,24,26];

for ss = 1:length(Sessions)
    
    TotFzHiTimeZones.Sal = [TotFzHiTimeZones.Sal,squeeze(nansum(TimeSpentFzZonesHigh.(Sessions{ss}).Sal,2))];
    TotFzHiTimeZones.Flx = [TotFzHiTimeZones.Flx,squeeze(nansum(TimeSpentFzZonesHigh.(Sessions{ss}).Flx,2))];
    
    TotFzLoTimeZones.Sal = [TotFzLoTimeZones.Sal,squeeze(nansum(TimeSpentFzZonesLow.(Sessions{ss}).Sal,2))];
    TotFzLoTimeZones.Flx = [TotFzLoTimeZones.Flx,squeeze(nansum(TimeSpentFzZonesLow.(Sessions{ss}).Flx,2))];

  
end

subplot(211)
for mouse = 1:4
    plot(cumsum(TotFzHiTimeZones.Sal(mouse,RealOrder))./sum(TotFzHiTimeZones.Sal(mouse,RealOrder)),'r')
    SalHi(mouse,:) = cumsum(TotFzHiTimeZones.Sal(mouse,RealOrder))./sum(TotFzHiTimeZones.Sal(mouse,RealOrder));
    hold on
    plot(cumsum(TotFzLoTimeZones.Sal(mouse,RealOrder))./sum(TotFzLoTimeZones.Sal(mouse,RealOrder)),'b')
    SalLo(mouse,:) = cumsum(TotFzLoTimeZones.Sal(mouse,RealOrder))./sum(TotFzLoTimeZones.Sal(mouse,RealOrder));
end
subplot(212)
for mouse = 1:4
    plot(cumsum(TotFzHiTimeZones.Flx(mouse,RealOrder))./sum(TotFzHiTimeZones.Flx(mouse,RealOrder)),'r')
    FlxHi(mouse,:) = cumsum(TotFzHiTimeZones.Flx(mouse,RealOrder))./sum(TotFzHiTimeZones.Flx(mouse,RealOrder));
    hold on
    plot(cumsum(TotFzLoTimeZones.Flx(mouse,RealOrder))./sum(TotFzLoTimeZones.Flx(mouse,RealOrder)),'b')
    FlxLo(mouse,:) = cumsum(TotFzLoTimeZones.Flx(mouse,RealOrder))./sum(TotFzLoTimeZones.Flx(mouse,RealOrder));
end

figure
plot(nanmean(SalHi),'r'),hold on
plot(nanmean(FlxHi),':r'),hold on
plot(nanmean(SalLo),'b'),hold on
plot(nanmean(FlxLo),':b'),hold on


