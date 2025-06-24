cd /home/pinky/Documents/PrgGithub/Ella/Python/data_SophieBagur/Sb_codes_aaptedFromElla
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/GLMResults/';

T = readNPY('corrected_motion_timebins.npy');
dat = readNPY('corrected_motion_data.npy');
mouse = readNPY('corrected_motion_mouseID.npy');
neuronID = readNPY('corrected_motion_neuronNum.npy');

MouseUnique = unique(mouse);
for mm = 1 : length(MouseUnique)
SpikeRate_MotionCorrected.(['M' num2str(MouseUnique(mm))]) = {};
end

for sp = 1:length(neuronID)
    mm = find(MouseUnique == mouse(sp));
    len = find(isnan(T(mm,:)),1,'first')-1;
    SpikeRate_MotionCorrected.(['M' num2str(mouse(sp))]){neuronID(sp)} = tsd(T(mm,1:len)*1e4,dat(sp,1:len)');
end



R2Info = readtable('r2_lin_nonlin.csv');
clear R2Vals_GLM
for mm = 1 : length(MouseUnique)
R2Vals_GLM.(['M' num2str(MouseUnique(mm))]) = {};
end

for sp = 1:size(R2Info,1)
    mm = R2Info{sp,1}{1}(6:end);
    neur = eval(R2Info{sp,2}{1}(8:end));
    model = R2Info{sp,3}{1};
    R2Vals_GLM.(['M' num2str((mm))]).(model)(mm,neur,1) = R2Info{sp,4};
    R2Vals_GLM.(['M' num2str((mm))]).(model)(mm,neur,2) = R2Info{sp,5};
end

save([SaveFolder 'GLMR2.mat'],'R2Vals_GLM')
save([SaveFolder 'MotionCorrectedSpikes.mat'],'SpikeRate_MotionCorrected')
