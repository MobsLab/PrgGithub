clear all

cd /media/nas6/ProjetEmbReact/SB_Data

load('VarE.mat')
load('VarCond.mat')
clear AllHist



MouseToUse_DZP = [11205,11204,11189,11184,11147];
MouseToUse_Sal = [1205,1204,1189,1184,1147];

FreqLim = 3.5;
FreqLimHi = 6;

for mouse = 1:length(MouseToUse_DZP)
    id = find(VarCond.MouseID==MouseToUse_Sal(mouse));
    %   Total time spent freezing / fz shock / fz safe / hi / low
    %   Total time spent freezing / fz shock / fz safe / hi / low
    BehavFz.TotalFz{1}(mouse) = length(VarCond.PosFz{id});
    BehavFz.TotalSkFz{1}(mouse) = nansum(VarCond.PosFz{id}<0.5);
    BehavFz.TotalSfFz{1}(mouse) = nansum(VarCond.PosFz{id}>0.5);
    
    % Prop shock / Prop safe
    BehavFz.PropSkFz{1}(mouse) = nanmean(VarCond.PosFz{id}<0.5);
    BehavFz.PropSfFz{1}(mouse) = nanmean(VarCond.PosFz{id}>0.5);
    
    % Prop Hi / Prop low
    DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})>0.5;
    temp = VarCond.OB_WVFreq{id};
    temp(DiffAbs) = NaN;
    temp(temp<1.8) = NaN;
    temp(temp>9) = NaN;
    BehavFz.PropLo{1}(mouse) = nansum(temp<FreqLim)./nansum(temp<FreqLimHi);
    BehavFz.PropHi{1}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi)./nansum(temp<FreqLimHi);
    
    % Prop hi / prop low in safe / in shock
    BehavFz.PropLoSk{1}(mouse) = nansum(temp<FreqLim  & VarCond.PosFz{id}<0.5)./nansum(temp<FreqLimHi  & VarCond.PosFz{id}<0.5);
    BehavFz.PropHiSk{1}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi & VarCond.PosFz{id}<0.5)./nansum(temp<FreqLimHi & VarCond.PosFz{id}<0.5);
    BehavFz.PropLoSf{1}(mouse) = nansum(temp<FreqLim  & VarCond.PosFz{id}>0.5)./nansum(temp<FreqLimHi  & VarCond.PosFz{id}>0.5);
    BehavFz.PropHiSf{1}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi & VarCond.PosFz{id}>0.5)./nansum(temp<FreqLimHi & VarCond.PosFz{id}>0.5);
    
    
    id = find(VarCond.MouseID==MouseToUse_DZP(mouse));
    %   Total time spent freezing / fz shock / fz safe / hi / low
    BehavFz.TotalFz{2}(mouse) = length(VarCond.PosFz{id});
    BehavFz.TotalSkFz{2}(mouse) = nansum(VarCond.PosFz{id}<0.5);
    BehavFz.TotalSfFz{2}(mouse) = nansum(VarCond.PosFz{id}>0.5);
    
    % Prop shock / Prop safe
    BehavFz.PropSkFz{2}(mouse) = nanmean(VarCond.PosFz{id}<0.5);
    BehavFz.PropSfFz{2}(mouse) = nanmean(VarCond.PosFz{id}>0.5);
    
    % Prop Hi / Prop low
    DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})>0.5;
    temp = VarCond.OB_WVFreq{id};
    temp(DiffAbs) = NaN;
    temp(temp<1.8) = NaN;
    temp(temp>9) = NaN;
    BehavFz.PropLo{2}(mouse) = nansum(temp<FreqLim)./nansum(temp<FreqLimHi);
    BehavFz.PropHi{2}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi)./nansum(temp<FreqLimHi);
    
    % Prop hi / prop low in safe / in shock
    BehavFz.PropLoSk{2}(mouse) = nansum(temp<FreqLim  & VarCond.PosFz{id}<0.5)./nansum(temp<FreqLimHi  & VarCond.PosFz{id}<0.5);
    BehavFz.PropHiSk{2}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi & VarCond.PosFz{id}<0.5)./nansum(temp<FreqLimHi & VarCond.PosFz{id}<0.5);
    BehavFz.PropLoSf{2}(mouse) = nansum(temp<FreqLim  & VarCond.PosFz{id}>0.5)./nansum(temp<FreqLimHi  & VarCond.PosFz{id}>0.5);
    BehavFz.PropHiSf{2}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi & VarCond.PosFz{id}>0.5)./nansum(temp<FreqLimHi & VarCond.PosFz{id}>0.5);
end

figure
Pos = [1,2,3,5,6,9,10,13,14,15, 16]
fldnames  = fieldnames(BehavFz);
for fl = 1:length(fldnames)
    subplot(4,4,Pos(fl))
    MakeSpreadAndBoxPlot_SB(BehavFz.(fldnames{fl}),{},[1,2],{'SAL','DZP'},1,1)
    title(fldnames{fl})
    xtickangle(45)
    if fl>FreqLim
        ylim([0 1.1])
    end
    
end