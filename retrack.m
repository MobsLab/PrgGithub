function  position=retrack(fname,BW_threshold,smaller_object_size,totmask,sat)

%declaring some variables
nx = 32;
ny = 24;


cd(fname)


   refim= load('reference_image.mat');
   refim=refim.ref;   


files=dir;
files=files(3:end);
framenum=size(files,1);
if nargin==4
sat=0;
end
diff=200;
numpics=diff;
startpics=1;

while sat~=1

for i=startpics:numpics
    i
    eval(strcat('load(''',files(i).name,''')'))
    
    if i==1
        t0=datas.time;
    end
    
    subimage = abs(refim-datas.image);
    subimage=uint8(double(subimage).*double(totmask));
    [length_line,length_column] = size(datas.image);
    %
    %                         % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(subimage,BW_threshold);
    %                         % Remove all the objects less large than smaller_object_size
    diff_im = bwareaopen(diff_im,smaller_object_size);
    %                         % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    %
    %                         % We get a set of properties for each labeled region.
    stats = regionprops( bw, 'Centroid','Area');
    clear best
    try
        for p=1:length(stats)
            best(p)=stats(p).Area;
        end
        [A,B]=max(best);
        centroids = cat(1, stats(B).Centroid);
        %
    catch
        centroids = cat(1, stats.Centroid);
    end
    %
    
    
    %display video, mouse position and occupation map
    imagesc(datas.image)
    axis image
    colormap gray
    hold on
    if size(centroids) == [1 2] %si on ne detecte qu'un objet
        nodetect=0;
        plot(centroids(1),centroids(2), '-m+')
        pause(0.02)
        
        position(1,i)=centroids(1);
        position(2,i)=centroids(2);
        %
    else
        position(1,i)=NaN;
        position(2,i)=NaN;
        nodetect=1;
    end
    
    position(3,i)=etime(t0,datas.time);
    if i~=1
        position(4,i)=sum(sum(datas.image-lastimage));
    end
    lastimage=datas.image;
    clf
end
sat=input('Are you satisfied? 1 if yes, 0 if want to see more, 2 to change parameters');

if sat==0
    startpics=numpics;
    numpics=startpics+diff;
elseif sat==2
    inter=input(strcat('New parameters BWthreshold =',num2str(BW_threshold), 'and small_obj_size=',num2str(smaller_object_size)));
    BW_threshold=inter(1);
    smaller_object_size=inter(2);
    startpics=1;
    numpics=diff;
end


end

for i=1:length(files)
    eval(strcat('load(''',files(i).name,''')'))
    
    if i==1
        t0=datas.time;
    end
    
    subimage = abs(refim-datas.image);
    subimage=uint8(double(subimage).*double(totmask));
    [length_line,length_column] = size(datas.image);
    %
    %                         % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(subimage,BW_threshold);
    %                         % Remove all the objects less large than smaller_object_size
    diff_im = bwareaopen(diff_im,smaller_object_size);
    %                         % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    %
    %                         % We get a set of properties for each labeled region.
    stats = regionprops( bw, 'Centroid','Area');
    clear best
    try
        for p=1:length(stats)
            best(p)=stats(p).Area;
        end
        [A,B]=max(best);
        centroids = cat(1, stats(B).Centroid);
        %
    catch
        centroids = cat(1, stats.Centroid);
    end
    %
    
    
    %display video, mouse position and occupation map
   
    if size(centroids) == [1 2] %si on ne detecte qu'un objet
        
        position(1,i)=centroids(1);
        position(2,i)=centroids(2);
        %
    else
        position(1,i)=NaN;
        position(2,i)=NaN;
        nodetect=1;
    end
    
    position(3,i)=etime(datas.time,t0);
    if i~=1
        position(4,i)=sum(sum(datas.image-lastimage));
    end
    lastimage=datas.image;
    clf
end
a=totmask(max(floor(position(2,:)),1),max(floor(position(1,:)),1));
g=diag(a);
ind=find(~g);
imagesc(refim)
hold on
scatter(position(1,:),position(2,:),'r')
scatter(position(1,ind),position(2,ind),'g')
position(1,ind)=NaN;
position(2,ind)=NaN;

end