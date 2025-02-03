writerObj=VideoWriter()
writerObj.FrameRate =
open(writerObj);
for i=1:framenum
    eval(strcat('load(''',a(2+i).name,''')'))
    h=figure(1)
    imagesc(datas.image);
    colormap gray;
    frame=getframe(h);
    writeVideo(writerObj);
    clf
end
close (writerObj)