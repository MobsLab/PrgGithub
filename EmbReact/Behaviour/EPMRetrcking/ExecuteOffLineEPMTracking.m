index=[];
PosMat=[];
diff_im=[];
lis=dir;
for i=1:length(lis)
    NameLis{i}=lis(i).name;
    if strfind(NameLis{i},'frame')
        index=[index,i];
    end
end
        [l2,l1] = size(ref);
        if size(se.Neighborhood,1)==7
            se2 = strel('disk',4*2);
        elseif size(se.Neighborhood,1)==5
            se2 = strel('disk',3*2);
        elseif size(se.Neighborhood,1)==3
            se2 = strel('disk',2*2);
        else
            se2=se;
        end
        
for fr=1:length(index)
    
    datas=load(NameLis{index(fr)});datas=struct2array(datas);
    IM=datas.image;
    
    %Substract reference image
    subimage = (ref-IM);
    subimage = uint8(double(subimage).*double(mask));
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(subimage,BW_threshold);
    diff_im1=diff_im;
    diff_im=imerode(diff_im,se);
        diff_im=imdilate(diff_im,se2);

    % Remove all the objects less large than smaller_object_size
    diff_im = bwareaopen(diff_im,smaller_object_size);
    
    % Label all the connected components in the image.
    bw = logical(diff_im); %CHANGED
    % We get a set of properties for each labeled region.
    stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength','Area');
    centroids = cat(1, stats.Centroid);
    maj = cat(1, stats.MajorAxisLength);
    mini = cat(1, stats.MinorAxisLength);
    rap=maj./mini;
    badcentroids=centroids(rap>shape_ratio,:); %CHANGED
    centroids=centroids(rap<shape_ratio,:); %CHANGED
    
    %display video, mouse position
    if size(centroids) == [1 2]
        
        PosMat(fr,1)=centroids(1);
        PosMat(fr,2)=centroids(2);
        
        if fr>3
            FzZone=roipoly([1:l1],[1:l2],IM,[centroids(1)-SrdZone centroids(1)-SrdZone centroids(1)+SrdZone centroids(1)+SrdZone],...
                [centroids(2)-SrdZone centroids(2)+SrdZone centroids(2)+SrdZone centroids(2)-SrdZone]);
            PixelsUsed=sum(sum(double(FzZone).*double(mask)+double(FzZone_temp).*double(mask)));
            
            % Convert the resulting grayscale image into a binary image.
            diff_im_FZ = im2bw(subimage,BW_threshold_imdiff);
            diff_im1=diff_im_FZ;
            
            immob_IM = double(diff_im_FZ).*double(FzZone) - double(image_temp).*double(FzZone_temp);
            % Remove all the objects less large than smaller_object_size
            immob_IM = bwareaopen(immob_IM,smaller_object_size_imdiff);
            image_temp=diff_im_FZ;
            FzZone_temp=FzZone;
            
            im_diff(fr)=(sum(sum(((immob_IM).*(immob_IM)))))./PixelsUsed;
                        
        else
            im_diff(fr)=NaN;
            image_temp=diff_im;
            FzZone_temp=mask;
            PixelsUsed=SrdZone*SrdZone;
        end
    else
        im_diff(fr)=NaN;
        PosMat(fr,1)=NaN;
        PosMat(fr,2)=NaN;
        image_temp=diff_im;
        FzZone_temp=mask;   
    end
end
