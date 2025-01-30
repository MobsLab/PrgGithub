clear all

cd /media/nas6/ProjetEmbReact/SB_Data
load('VarCond.mat')
load('VarCond.mat')

clear AllHist

MiceID.SAL = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'SALINE'))));
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];

MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1174) = [];
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'DIAZEPAM'))));

MiceID = rmfield(MiceID,'SAL');

FreqLim = 3;
FreqLimHi = 7;

DrugTypes = fieldnames(MiceID);

for dd = 1:length(DrugTypes)
    
    for mouse = 1:length(MiceID.(DrugTypes{dd}))
        id = find(VarCond.MouseID==VarCond.MouseID(MiceID.(DrugTypes{dd})(mouse)));
        %   Total time spent freezing / fz shock / fz safe / hi / low
        %   Total time spent freezing / fz shock / fz safe / hi / low
        BehavFz.TotalFz{dd}(mouse) = length(VarCond.PosFz{id});
        BehavFz.TotalSkFz{dd}(mouse) = nansum(VarCond.PosFz{id}<0.5);
        BehavFz.TotalSfFz{dd}(mouse) = nansum(VarCond.PosFz{id}>0.5);
        
        % Prop shock / Prop safe
        BehavFz.PropSkFz{dd}(mouse) = nanmean(VarCond.PosFz{id}<0.5);
        BehavFz.PropSfFz{dd}(mouse) = nanmean(VarCond.PosFz{id}>0.5);
        
        % Prop Hi / Prop low
        DiffAbs = abs(VarCond.OB_WVFreq{id} - VarCond.OB_PTFreq{id})>0.5;
        temp = VarCond.OB_WVFreq{id};
        temp(DiffAbs) = NaN;
        temp(temp<1.8) = NaN;
        temp(temp>9) = NaN;
        BehavFz.PropLo{dd}(mouse) = nansum(temp<FreqLim)./nansum(temp<FreqLimHi);
        BehavFz.PropHi{dd}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi)./nansum(temp<FreqLimHi);
        
        % Prop hi / prop low in safe / in shock
        BehavFz.PropLoSk{dd}(mouse) = nansum(temp<FreqLim  & VarCond.PosFz{id}<0.5)./nansum(temp<FreqLimHi  & VarCond.PosFz{id}<0.5);
        BehavFz.PropHiSk{dd}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi & VarCond.PosFz{id}<0.5)./nansum(temp<FreqLimHi & VarCond.PosFz{id}<0.5);
        BehavFz.PropLoSf{dd}(mouse) = nansum(temp<FreqLim  & VarCond.PosFz{id}>0.5)./nansum(temp<FreqLimHi  & VarCond.PosFz{id}>0.5);
        BehavFz.PropHiSf{dd}(mouse) = nansum(temp>FreqLim & temp<FreqLimHi & VarCond.PosFz{id}>0.5)./nansum(temp<FreqLimHi & VarCond.PosFz{id}>0.5);
        
        
    end
end

% figure
% Pos = [1,2,3,5,6,9,10,13,14,15, 16]
% fldnames  = fieldnames(BehavFz);
% for fl = 1:length(fldnames)
%     subplot(4,4,Pos(fl))
%     MakeSpreadAndBoxPlot_SB(BehavFz.(fldnames{fl}),{},[1:length(DrugTypes)],DrugTypes,1,0)
%     title(fldnames{fl})
%     xtickangle(45)
%     if fl>FreqLim
%         ylim([0 1.1])
%     end
%     
% end

figure
Pos = [1,2,3,5,6,9,10,13,14,15, 16]
fldnames  = fieldnames(BehavFz);
for fl = 1:length(fldnames)
    subplot(4,4,Pos(fl))
    PlotErrorBarN_KJ(BehavFz.(fldnames{fl}),'newfig',0,'paired',0)
    title(fldnames{fl})
    xtickangle(45)
    if fl>FreqLim
        ylim([0 1.3])
    end
    set(gca,'XTick',[1:length(DrugTypes)],'XTickLabel',DrugTypes)
    xtickangle(45)
end