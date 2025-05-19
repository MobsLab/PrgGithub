function PosOFF=Trackin_offline_RB(filename,BW_threshold,smaller_object_size,ref,mask)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INPUTS
pasplot=10; % default 10
pasAnalysis=5; % default 1
startAtFrame=2; % default 2
shape_ratio_2=5; % dafault 5
DisplayTracking=1; % 1 if display tracking



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION

res=pwd;
if ~exist('filename','var')
    filename=input('Enter filename : ','s');
end

try 
    lis=dir([res,'/',filename]);
    mark='/';
catch
    lis=dir([res,'\',filename]);
    mark='\';
end

index=[];
for i=1:length(lis)
    NameLis{i}=lis(i).name;
    if strfind(NameLis{i},'-000')
        index=[index,i];
        disp(['N-',num2str(i),'- ',NameLis{i}])
    end
    if strfind(NameLis{i},'TrackingOFFline')
        error('TrackingOFFline.mat already defined')
    end
end
if length(index)>1
    ok=input(['Do you want to concatenantes all the ',num2str(length(index)),' folders (y/n)? '],'s');
    if ok~='y', 
        index=input('   Enter Number of file as given above (eg [3 4 5]): ');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK REFERENCE AND MASK

if ~exist('ref','var')
    load([res,mark,filename,mark,'InfoTracking.mat'],'ref')
end
if ~exist('mask','var')
    load([res,mark,filename,mark,'InfoTracking.mat'],'mask')
end
if ~exist('BW_threshold','var')
    load([res,mark,filename,mark,'InfoTracking.mat'],'BW_threshold')
end
if ~exist('smaller_object_size','var')
    load([res,mark,filename,mark,'InfoTracking.mat'],'smaller_object_size')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK ONLINE TRACKING
PosON=[];
for i=index
    dirNames=dir([res,mark,filename,mark,NameLis{i}]);
    % online
    clear PosMat
    load([res,mark,filename,mark,NameLis{i},mark,'PosMat.mat'])
    if isempty(PosON)
        PosON=PosMat;
    else
        PosON=[PosON;[PosMat(:,1)+max(PosON(:,1)),PosMat(:,[2,3])]];
    end
end

figure('Color',[1 1 1]),
subplot(1,2,1), imagesc(mask);
hold on, plot(PosON(~isnan(PosON(:,2)),2),PosON(~isnan(PosON(:,2)),3),'.-w')
title('Tracking ONLINE'); A=axis;
subplot(1,2,2),
scatter(PosON(:,2),PosON(:,3),7,PosON(:,1),'filled'); colorbar
axis ij, axis(A)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Choose what to do
choice=questdlg('Do you need to improve tracking? ','what to do?','No','Tracking offline','Remove points','No');
switch choice
    case 'Tracking offline'
        computeOFF=1;close; 
    case 'No'
        computeOFF=0; PosOFF=PosON;
        disp('PosOFF to save is equal to PosON')
    case 'Remove points'
        computeOFF=0;
        choice2='Yes';
        PosWork=PosMat(~isnan(PosON(:,2)),:);
        while ~strcmp(choice2,'No')
            A=ginput(1);
            temp=sum([abs(PosWork(:,2)-A(1)),abs(PosWork(:,3)-A(2))],2);
            PosWork(temp==min(temp),:)=[];
            imagesc(mask);
            hold on, plot(PosWork(:,2),PosWork(:,3),'.-w')
            choice2=questdlg('Remove other points? ','manual points','Yes','No','No');
        end
        
        PosOFF=PosWork;
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRACKING
if computeOFF
    figure('Color',[1 1 1]), numF=gcf;
    numfr=0;
    PosOFF=[];
    tic
    for i=index
        dirNames=dir([res,mark,filename,mark,NameLis{i}]);
        eval(['h=waitbar(0,[''Tracking '',NameLis{i},''...'']);']);
        isfr=zeros(length(dirNames),1);
        for fr=1:length(dirNames)
            if length(dirNames(fr).name)>5 && strcmp(dirNames(fr).name(1:5),'frame')
                isfr(fr)=1;
            end
        end
        
        % offline
        tempPosOFF=NaN(sum(isfr),3);
        index_frames=find(isfr);
        indexfr=[1,startAtFrame:pasAnalysis:length(index_frames)];
        for fr=indexfr
            numfr=fr;
            waitbar(fr/sum(isfr));
            
            clear datas Time t1 IM subimage diff_im
            eval('load([res,mark,filename,mark,NameLis{i},mark,dirNames(index_frames(fr)).name])');
            
            t1=datas.time;
            if numfr==1; timeDeb=t1(4)*60*60+t1(5)*60+t1(6);end
            Time=(t1(4)*60*60+t1(5)*60+t1(6))-timeDeb;
            
            %get image
            IM=datas.image;
            %Soustrait l'image de r�f�rence
            subimage = abs(ref-IM);
            % use mask to clear image
            subimage(find(mask==0))=0;
            % Convert the resulting grayscale image into a binary image.
            diff_im = im2bw(subimage,BW_threshold);
            % Remove all the objects less large than smaller_object_size
            diff_im = bwareaopen(diff_im,smaller_object_size);
            % Label all the connected components in the image.
            bw = bwlabel(diff_im, 8);
            
            % We get a set of properties for each labeled region.
            stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength','Area');
            centroids = cat(1, stats.Centroid);
            sizes=cat(1,stats.Area);
            maj = cat(1, stats.MajorAxisLength);
            minu = cat(1, stats.MinorAxisLength);
            rap=maj./minu;
            goodind=find(rap<shape_ratio_2);
            centroids=centroids(goodind,:);
            
            if DisplayTracking && rem(fr,pasplot)
                %display video and mouse position
                figure(numF), subplot(2,1,1),imagesc(IM), colormap gray
                subplot(2,1,2),imagesc(diff_im), colormap gray
                pause(0.001)
                if ~isempty(centroids), hold on, plot(centroids(1),centroids(2), '-m+');end
            end
            if size(centroids) == [1 2] %si on ne detecte qu'un objet
                tempPosOFF(numfr,1:3)=[Time,centroids(1),centroids(2)];
            else
                tempPosOFF(numfr,1)=Time;
            end
            
        end
        close(h)
        if isempty(PosOFF)
            PosOFF=tempPosOFF;
        else
            PosOFF=[PosOFF;[tempPosOFF(:,1)+max(PosOFF(:,1)),tempPosOFF(:,[2,3])]];
        end
        
    end
    toc
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPARE ONLINE AND OFFLINE TRACKING

figure('Color',[1 1 1]),
%subplot(1,2,1), scatter(PosON(:,2),PosON(:,3),5,PosON(:,1),'filled'); colorbar
subplot(1,2,1), imagesc(mask); colormap gray
hold on, plot(PosON(~isnan(PosON(:,2)),2),PosON(~isnan(PosON(:,2)),3),'o-b')
title('Tracking ONLINE')

%subplot(1,2,2), scatter(PosOFF(:,2),PosOFF(:,3),5,PosOFF(:,1),'filled');colorbar
subplot(1,2,2),imagesc(mask); colormap gray
hold on, plot(PosOFF(~isnan(PosOFF(:,2)),2),PosOFF(~isnan(PosOFF(:,2)),3),'o-b')  
title('Tracking OFFLINE')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVE

choice=questdlg('Do you want to save PosOFF and parameters in TrackingOFFline.mat? ','SAVE','Yes','No','Yes');
switch choice
    case 'Yes'
        save([res,mark,filename,mark,'TrackingOFFline'],'PosON','PosOFF','ref','mask','smaller_object_size','BW_threshold')
        disp('All has been saved in TrackingOFFline.mat');
    case 'No'
        warning('Nothing has been saved from the Tracking offline !!!');
end


                