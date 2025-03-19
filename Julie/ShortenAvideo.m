% attention probelem de frequence à regler (compression temporelle)
% 02.121.2015
OBJ = mmreader('Hab10min_01122015_run_0_M270.avi');
v = VideoWriter('M270_shortened2.avi');
open(v)


for i=1:300
    vidFrames = read(OBJ,i);
    writeVideo(v,vidFrames)
end

close (v)