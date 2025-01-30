% NEWMCAnalysis;

clear
close all

DetailForNewUpDown;

load Data
load DataMCLFP
load Spikes
load UpDownCorrected

try     
    cd NEW
catch
    mkdir NEW
    cd NEW
end

[Res,numfig]=PatchCellPropertiesLR(Y+X(1),tps,spikes,DebutUp,FinUp,1,data,nom);

cd ..

save ResultsNEW Res