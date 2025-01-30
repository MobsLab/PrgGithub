workingDir = '/media/mobsrick/DataMOBs71/Mouse-622/25102017-UMazeHab/raw/FEAR-Mouse-622-25102017-01-Hab0/';
outputVideo = VideoWriter(fullfile(workingDir,'622_UMaze_25102017.avi'));
outputVideo.FrameRate = 30;
open(outputVideo)

indir = '/media/mobsrick/DataMOBs71/Mouse-622/25102017-UMazeHab/raw/FEAR-Mouse-622-25102017-01-Hab0//F25102017-0001';
a = what(indir);
cd(indir);

for ii = 1:length(a.mat)
   load(a.mat{ii});
   % For older versions of the code
%    writeVideo(outputVideo,datas.image)
% For new versions of the code
   b = datas.image/100;
   writeVideo(outputVideo,b)
end

close(outputVideo)