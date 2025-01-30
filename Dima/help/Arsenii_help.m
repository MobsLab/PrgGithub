savefolder = '/media/nas5/ProjetERC2/Mouse-905/20190404/Retracking/TestPost/TestPost1';
load('/media/nas5/ProjetERC2/Mouse-905/20190404/Retracking/TestPost/TestPost1/behavResources');


% function [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = Morph(CleanXtsd, CleanYtsd, Zone, ref, Ratio_IMAonREAL)
[CleanAlignedYtsd,CleanAlignedXtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB(CleanYtsd,CleanXtsd, Zone{1}, ref, Ratio_IMAonREAL);
% end


% function CleanLinearDist = Linearize(mask, Zone, CleanXtsd, CleanYtsd)

figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);


imagesc(mask+Zone{1})
curvexy=ginput(4);
clf

xxx = Data(CleanXtsd)';
yyy = Data(CleanYtsd)';
mapxy=[Data(CleanXtsd)'; Data(CleanYtsd)']';
[xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');

t(isnan(xxx))=NaN;

subplot(211)
imagesc(mask+Zone{1})
hold on
plot(Data(CleanXtsd)'*Ratio_IMAonREAL,Data(CleanYtsd)'*Ratio_IMAonREAL)
subplot(212)
plot(t), ylim([0 1])

CleanLinearDist=tsd(Range(CleanXtsd),t);

% end

save([savefolder, '/behavResources.mat'],'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned', 'CleanXYOutput', 'CleanLinearDist', '-append');
clear all
close all
 