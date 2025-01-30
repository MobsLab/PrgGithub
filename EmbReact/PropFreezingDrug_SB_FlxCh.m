clear all

cd /media/nas6/ProjetEmbReact/SB_Data
load('VarCond.mat')
load('VarE.mat')

clear AllHist

MiceID.DZP = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'SALINE'))));
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1174) = [];

MouseToUse_DZP = VarCond.MouseID(MiceID.FlxCh);
MouseToUse_Sal = VarCond.MouseID(MiceID.SALLate);

FreqLim = 3;
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
    MakeSpreadAndBoxPlot_SB(BehavFz.(fldnames{fl}),{},[1,2],{'SAL','FluCh'},1,1)
    title(fldnames{fl})
    xtickangle(45)
    if fl>FreqLim
        ylim([0 1.1])
    end
    
end