cd C:\Users\MOBS\Desktop\ProjetAVERSION\MatlabArduino_quantif_behav\Mouse102\Aversion-Mouse-102-12112013-01-FearStims_ExpG
load('reference_image.mat')
files=dir;
cd F12112013-0000
a=dir;
framenum=size(a)-3;
BW_threshold=0.2;
smaller_object_size=100;
nx = 32;
ny = 24;
occupation = zeros(ny,nx); %carte d'occupation
RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur

for i=1:framenum
    eval(strcat('load(''',a(2+i).name,''')'))
    
    if i==1
        t0=datas.time;
    end
    subimage = abs(ref-datas.image);
    [length_line,length_column] = size(datas.image);
    
    % Convert the resulting grayscale image into a binary image.
    diff_im = im2bw(subimage,BW_threshold);
    % Remove all the objects less large than smaller_object_size
    diff_im = bwareaopen(diff_im,smaller_object_size);
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % We get a set of properties for each labeled region.
    stats = regionprops( bw, 'Centroid','Area');
    centroids = cat(1, stats.Centroid);
    
    
    %display video, mouse position and occupation map
    %         subplot(2,2,1)
    %         imagesc(datas.image)
    %         axis image
    %         colormap gray
    %         hold on
    if size(centroids) == [1 2] %si on ne detecte qu'un objet
        nodetect=0;
        %             plot(centroids(1),centroids(2), '-m+')
        %             pause
        %calcul de la position sur la carte d'occupation
        x_oc = max(round(centroids(1)/length_column*nx),1);
        y_oc = max(round(centroids(2)/length_line*ny),1);
        occupation(y_oc,x_oc) = occupation(y_oc,x_oc) + 1;
        position(1,i)=centroids(1);
        position(2,i)=centroids(2);
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
    
end

vitesse(3,:)=position(3,:);
vitesse(1,2:end)=(position(1,2:end)-position(1,1:end-1))./(position(3,2:end)-position(3,1:end-1));
vitesse(2,2:end)=(position(2,2:end)-position(2,1:end-1))./(position(3,2:end)-position(3,1:end-1));
vitesse(4,2:end)=sqrt(vitesse(1,2:end).^2+vitesse(2,2:end).^2);