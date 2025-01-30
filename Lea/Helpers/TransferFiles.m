


%% TRANSFER FROM HARD DRIVE TO DROPBOX

% Dir = PathForExperimentsBasalSleepSpike2_HardDrive ;
% 
% for p=1:length(Dir.path)
%     
%     eval(['cd(Dir.path{',num2str(p),'}'')'])
%     disp(p)
%     eval(['copyfile NoiseHomeostasisLP.mat /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/Noise/NoiseHomeostasisLP' num2str(p) '.mat'])
% end 


%% TRANSFER FROM DROPBOX TO LAB COMPUTER

Dir = PathForExperimentsBasalSleepSpike2 ;   
cd('/home/mobsjunior/Dropbox/Mobs_member/LeaPrunier/Noise')

for p=1:length(Dir.path)
    disp(p)
    eval(['copyfile NoiseHomeostasisLP' num2str(p) '.mat ' Dir.path{p} '/NoiseHomeostasisLP.mat'])
end 