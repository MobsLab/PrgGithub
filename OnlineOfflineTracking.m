function OnlineOfflineTracking(directory)

cd(directory)
load('reference_image.mat')
files=dir;
files=files(3:end);
            for f=1:10:length(files)
                if files(f).isdir==1
                    clear vitesse position
                    cd /media/DataMOBs/ProjetAversion
                    cd(mice(m).name)
                    cd(experiments(e).name)
                    cd(files(f).name)
                    a=dir;
                    framenum=size(a,1)-3;
                    BW_threshold=0.15;
                    smaller_object_size=193;
                    nx = 32;
                    ny = 24;
                    % occupation = zeros(ny,nx); %carte d'occupation
                    % RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur
                                               
clear position
clear vitesse
figure
                    for i=1:framenum
                        eval(strcat('load(''',a(2+i).name,''')'))
                        
%                         if i==1
%                             t0=datas.time;
%                         end
%                         subimage = abs(ref-datas.image);
%                         subimage=uint8(double(subimage).*double(rightmask));
%                         [length_line,length_column] = size(datas.image);
%                         
%                         % Convert the resulting grayscale image into a binary image.
%                         diff_im = im2bw(subimage,BW_threshold);
%                         % Remove all the objects less large than smaller_object_size
%                         diff_im = bwareaopen(diff_im,smaller_object_size);
%                         % Label all the connected components in the image.
%                         bw = bwlabel(diff_im, 8);
%                         
%                         % We get a set of properties for each labeled region.
%                         stats = regionprops( bw, 'Centroid','Area');
%                         clear best
%                         try 
%                         for p=1:length(stats)
%                         best(p)=stats(p).Area;
%                         end
%                         [A,B]=max(best);
%                                                 centroids = cat(1, stats(B).Centroid);
%                         
%                         catch
%                         centroids = cat(1, stats.Centroid);
%                         end
%                         
                   
                        
                        %display video, mouse position and occupation map
                        %         subplot(2,2,1)
                                imagesc(datas.image)
                                axis image
                                colormap gray
                                hold on
                                [position(1,i),position(2,i)]=ginput(1);
%                         if size(centroids) == [1 2] %si on ne detecte qu'un objet
%                             nodetect=0;
%                                         plot(centroids(1),centroids(2), '-m+')
%                             %             pause
%                             %calcul de la position sur la carte d'occupation
%                             %                         x_oc = max(round(centroids(1)/length_column*nx),1);
%                             %                         y_oc = max(round(centroids(2)/length_line*ny),1);
%                             %                         occupation(y_oc,x_oc) = occupation(y_oc,x_oc) + 1;
%                             position(1,i)=centroids(1);
%                             position(2,i)=centroids(2);
%                  
%                         else
%                             position(1,i)=NaN;
%                             position(2,i)=NaN;
%                             nodetect=1;
%                         end
                        
                        position(3,i)=datas.time;
                        if i~=1
                            position(4,i)=sum(sum(datas.image-lastimage));
                        end
                        lastimage=datas.image;
                        clf
%                        pause(0.005)                                                
                    end
                    
                    vitesse(3,:)=position(3,:);
                    vitesse(1,2:end)=(position(1,2:end)-position(1,1:end-1))./(position(3,2:end)-position(3,1:end-1));
                    vitesse(2,2:end)=(position(2,2:end)-position(2,1:end-1))./(position(3,2:end)-position(3,1:end-1));
                    vitesse(4,2:end)=sqrt(vitesse(1,2:end).^2+vitesse(2,2:end).^2);
                    vitesse(4,vitesse(4,:)>800)=NaN;
                     cd /media/DataMOBs/ProjetAversion
                    cd(mice(m).name)
                    cd(experiments(e).name)
                    save('trackin.mat','position','vitesse')
                end
            end
        catch
            keyboard
        end
    end
end
