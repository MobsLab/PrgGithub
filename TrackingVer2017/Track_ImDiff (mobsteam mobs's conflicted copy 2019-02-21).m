function [Pos,ImDiff,PixelsUsed,NewIm,NewZone]=Track_ImDiff_IRCamera(im,mask,ref,BW_threshold,smaller_object_size,sm_fact,se,SrdZone,...
    Ratio_IMAonREAL,OldIm,OldZone,camtype)

switch camtype
    case 'Webcam'
        im=ref-im;
end

% [length_line,length_column] = size(im);

% apply the mask
im = im.*double(mask);

% smooth the image
if sm_fact>0
    im=imgaussfilt(im,sm_fact);
end
% binarize the image using a threshold
diff_im = im2bw(im,BW_threshold);

% drop parts of the binary image that are too small
diff_im = bwareaopen(diff_im,smaller_object_size);

% dilate objects, this allows to fuse two very close parts of the mouse,
% typically when it is cut in two by the cable
diff_im=imdilate(diff_im,se);

% Get the position of the remaining parts of the image
stats = regionprops(diff_im,'Centroid');
centroids = cat(1, stats.Centroid);

if size(centroids) == [1 2] % only one blob is detected in the image --> we've got the mouse
    % Record the position
    Pos(1,1)=centroids(1)/Ratio_IMAonREAL;
    Pos(1,2)=centroids(2)/Ratio_IMAonREAL;
    
%     % For online place field
%     x_oc = max(round(centroids(1)/length_column*nx),1);
%     y_oc = max(round(centroids(2)/length_line*ny),1);
    
    % calculate the number of different pixels between two images
    FzZone=roipoly(im,[centroids(1)-SrdZone centroids(1)-SrdZone centroids(1)+SrdZone centroids(1)+SrdZone],...
        [centroids(2)-SrdZone centroids(2)+SrdZone centroids(2)+SrdZone centroids(2)-SrdZone]);
    PixelsUsed=sum(sum((double(FzZone).*double(mask)+double(OldZone).*double(mask))>0));
    immob_IM = double(diff_im).*double(FzZone) - double(OldIm).*double(OldZone);

    ImDiff=(sum(sum(((immob_IM).*(immob_IM)))));
    NewIm=diff_im;
    NewZone=FzZone;
else % more than one blob --> no mouse
    Pos(1,:)=[NaN;NaN];
    PixelsUsed=sum(sum(double(mask)));
    immob_IM = double(diff_im).*double(mask) - double(OldIm).*double(mask);
    ImDiff=(sum(sum(((immob_IM).*(immob_IM)))));
    NewIm=diff_im;
    NewZone=mask;
end

end