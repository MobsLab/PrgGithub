function PosOFF=Trackin_offline_OnVideo(filenameavi,ref,mask);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INPUTS default
pasplot=10; % default 10
pasAnalysis=1; % default 1
startAtFrame=2; % default 2
DisplayTracking=0; % 1 if display tracking

BW_threshold=0.2;
smaller_object_size=11;
shape_ratio=5; % dafault 5

% do not change
global BW_threshold2
global smaller_object_size2
global shape_ratio_2
global PosOFF

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
disp(' ')
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end

if ~exist('filenameavi','var')
    filenameavi=input('Enter filenameavi : ','s');
end

if isempty(strfind(filenameavi,mark))
    nameFile=[res,mark,filenameavi];
else
    nameFile=filenameavi;
end
lis=dir(nameFile);

%% Load video
OBJ = mreader(filenameavi);
numFrames = get(OBJ, 'numberOfFrames');
fcy=get(OBJ, 'FrameRate');
if strcmp(filenameavi,'OpenFielddKO2407-8568-1.wmv'),numFrames = 6570;end
try
    if isempty(numFrames)
        lastFrame = read(OBJ, inf);
        numFrames = get(OBJ, 'numberOfFrames');
    end
end
disp(['number of frames=',num2str(numFrames)])
disp(['frames per second=',num2str(fcy)])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK REFERENCE AND MASK

if ~exist('ref','var')
    error('no ref found')
end
if ~exist('mask','var')
    error('no mask found')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Choose what to do
choice=questdlg('Do you need to improve tracking? ','what to do?','No','Tracking offline','Remove points','No');
switch choice
    case 'Tracking offline'
        computeOFF=1;close;
        choice2=questdlg('Is it just a test? ','Test?','Analysis','Preview FAST','Preview SLOW','Custum');
        
        switch choice2
            case 'Analysis'
                pasAnalysis=1;
                DisplayTracking=0;
                defAns={num2str(BW_threshold) num2str(smaller_object_size) num2str(shape_ratio)};
                prompt = {'BW_threshold','smaller_object_size','shape_ratio'};
                dlg_title = 'Change parameters for offline tracking:';
                num_lines = 1;
                answer = inputdlg(prompt,dlg_title,num_lines,defAns);
                BW_threshold=str2num(answer{1});
                smaller_object_size=str2num(answer{2});
                shape_ratio=str2num(answer{3});
                
            case 'Preview FAST'
                pasAnalysis=10;
                pasplot=10;
                DisplayTracking=1;
                
            case 'Preview SLOW'
                pasAnalysis=1;
                pasplot=1;
                DisplayTracking=1;
                
            case 'Custum'
                defAns={'y' num2str(BW_threshold) num2str(smaller_object_size) '5' '10' '2' '5'};
                prompt = {'Display Tracking (y/n)','BW_threshold','smaller_object_size','pas Analysis (!!!! to save put 1)','pas plot','start At Frame','Shape ratio' };
                dlg_title = 'Change parameters for offline tracking:';
                num_lines = 1;
                answer = inputdlg(prompt,dlg_title,num_lines,defAns);
                
                if strcmp(answer{1},'y'), DisplayTracking=1; else DisplayTracking=0;end % 1 if display tracking
                BW_threshold=str2num(answer{2});
                smaller_object_size=str2num(answer{3});
                pasAnalysis=str2num(answer{4}); % default 1
                pasplot=str2num(answer{5}); % default 10
                startAtFrame=str2num(answer{6}); % default 2
                shape_ratio=str2num(answer{7}); % dafault 5
        end
        
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

BW_threshold2=BW_threshold;
smaller_object_size2=smaller_object_size;
shape_ratio_2=shape_ratio;

if computeOFF
    if DisplayTracking,
        figure('Color',[1 1 1]), numF=gcf;
        subplot(211)
        hul = imagesc(ref); colormap gray
        subplot(212),
        subimage = uint8(double(ref).*double(mask));
        hul2 = imagesc(subimage); colormap gray
        hold on, g=plot(0,0,'m+');
    end
    numfr=0;
    PosOFF=[];
    tic
    h=waitbar(0,'Tracking offline');
    
    % offline
    tempPosOFF=NaN(numFrames,3);
    t1=0;
    
    % online gui reglage
    guireg_fig=OnlineGuiReglage;
    
    
    for fr=1:pasAnalysis:numFrames
        waitbar(fr/numFrames);
        clear datas IM subimage diff_im
        
        
        t1=t1+1/fcy;
        %get image
        vidFrames = read(OBJ,fr);
        Mov=vidFrames(:,:,3,1);
        IM=Mov;
        IM=double(IM);
        
        % soustrait ref, remove mask
        subimage = abs(ref-IM);
        subimage = uint8(double(subimage).*double(mask));
        
        % Convert the resulting grayscale image into a binary image.
        diff_im = im2bw(subimage,BW_threshold2);
        % Remove all the objects less large than smaller_object_size
        diff_im = bwareaopen(diff_im,smaller_object_size2);
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
        
        if DisplayTracking && rem(fr,pasplot)==0
            %display video and mouse position
            %figure(numF), subplot(2,1,1),imagesc(IM), colormap gray
            %subplot(2,1,2),imagesc(diff_im), colormap gray
            %pause(0.001)
            set(hul,'Cdata',IM);
            set(hul2,'Cdata',diff_im);
            
            if ~isempty(centroids),
                set(g,'Xdata',centroids(1),'YData',centroids(2))
                %hold on, plot(centroids(1),centroids(2), '-m+');
            else
                set(g,'Xdata',0,'YData',0)
            end
        end
        if size(centroids) == [1 2] %si on ne detecte qu'un objet
            tempPosOFF(fr,1:3)=[t1,centroids(1),centroids(2)];
        else
            tempPosOFF(fr,1)=t1;
        end
        
    end
    disp(' ')
    disp(['BW_threshold2=',num2str(BW_threshold2)]);
    disp(['smaller_object_size2=',num2str(smaller_object_size2)]);
    disp(['shape_ratio_2=',num2str(shape_ratio_2)]);
    
    close(h)
    
    if isempty(PosOFF)
        PosOFF=tempPosOFF;
    else
        PosOFF=[PosOFF;[tempPosOFF(:,1)+max(PosOFF(:,1)),tempPosOFF(:,[2,3])]];
    end
    close(guireg_fig)
    disp(' ')
    toc
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPARE ONLINE AND OFFLINE TRACKING

figure('Color',[1 1 1]),
%subplot(1,2,1), scatter(PosON(:,2),PosON(:,3),5,PosON(:,1),'filled'); colorbar
% subplot(1,2,1), imagesc(mask); colormap gray
% hold on, plot(PosON(~isnan(PosON(:,2)),2),PosON(~isnan(PosON(:,2)),3),'o-b')
% title('Tracking ONLINE')
%
% %subplot(1,2,2), scatter(PosOFF(:,2),PosOFF(:,3),5,PosOFF(:,1),'filled');colorbar
% subplot(1,2,2),
imagesc(mask); colormap gray
hold on, plot(PosOFF(~isnan(PosOFF(:,2)),2),PosOFF(~isnan(PosOFF(:,2)),3),'o-b')
title('Tracking OFFLINE')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVE

BW_threshold=BW_threshold2;
smaller_object_size=smaller_object_size2;
shape_ratio=shape_ratio_2;

rmindex=[strfind(filenameavi,'.avi');strfind(filenameavi,'.wmv')];
filename=filenameavi(1:rmindex-1);
if isempty(strfind(filename,mark))
    nameFile=[res,mark,filename];
else
    nameFile=filename;
end

if ~exist(nameFile,'dir')
    mkdir(nameFile)
end

if pasAnalysis==1 || computeOFF==0
    
    choice=questdlg('Do you want to save PosOFF and parameters in TrackingOFFline.mat? ','SAVE','Yes','No','Yes');
    switch choice
        case 'Yes'
            save([nameFile,mark,'TrackingOFFline'],'PosON','PosOFF','ref','mask','smaller_object_size','BW_threshold','shape_ratio')
            disp('All has been saved in TrackingOFFline.mat');
            try delete([nameFile,mark,'Temp.mat']);end
            savetemp=0;
        case 'No'
            savetemp=1;
    end
else
    hlg = warndlg('You cannot save stupid human!!!',['pasAnalysis=',num2str(pasAnalysis)]);
    uiwait(hlg) ;
    savetemp=1;
end

if savetemp
    disp('Saving parameters in Temp.mat ...');
    save([nameFile,mark,'Temp'],'filename','PosOFF','ref','mask','smaller_object_size','BW_threshold','shape_ratio')
end

