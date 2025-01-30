function [Pos,PosTh,Vit,Movtsd,Fs]=Tracking_Immobility_ML(filename,plo,NameRefFile,Fsamp)
                        
%
% function Tracking_Immobility_ML
%
% inputs
% - filename = File.mat containing all frames
% - NameRefFile = cf ComputeImageRef.m
% - plot (optional) = 
% - Fsamp (optional) = sampling tracking. default = 5Hz

manual_remove_artifacts=0;
filename_tosave=filename(1:max([strfind(filename,'.avi'),strfind(filename,'.wmv')])-1);
if strcmp(filename_tosave(end-1:end),'-1'), filename_tosave=filename_tosave(1:end-2);end

tic;
res=pwd;
%% inputs
if ~exist('filename','var') || ~exist('NameRefFile','var')
    error('Missing inputs arguments')
end

try
    load([res,'/',NameRefFile]); mask;
    try ref_im; catch, ref_im=ref;end
catch
    disp('Bug, type:   load([res,''/'',NameRefFile]); ref_im=ref; mask;  ')
    disp('then type;  return')
    keyboard
end
   
if ~exist('Fsamp','var') 
    Fsamp=5; % 5Hz sampling tracking
end
if ~exist('plo','var')
    plo=0;
end

if ~exist('th_immob','var') || ~exist('thtps_immob','var') 
    th_immob=2;
    thtps_immob=2;
    save(NameRefFile,'-append','th_immob','thtps_immob')
end

%% load video

OBJ = mmreader(filename);
numFrames = get(OBJ, 'numberOfFrames');

try
    if length(numFrames)==0
        lastFrame = read(OBJ, inf);
        numFrames = get(OBJ, 'numberOfFrames');
    end
end

dur = get(OBJ, 'Duration');
dt=dur/numFrames;

pas=max(1,round(1/Fsamp/dt))/2;

%% determine smaller_object_size, lum_threshold and BW_threshold

try vidFrames=read(OBJ,1);catch, keyboard;end
frame_ref1=vidFrames(:,:,3,1);
frame_ref1=single(frame_ref1);
if ~exist('smaller_object_size','var') || ~exist('BW_threshold','var') || ~exist('lum_threshold','var')
   
    subimage = abs(ref_im - frame_ref1);
    % lum_threshold
    figure('Color',[1 1 1])
    for i=1:15
        subimagetemp=subimage;
        subimagetemp(subimagetemp<20*i)=0;
        subplot(3,5,i), imagesc(subimagetemp)
        title(['lum threshold=',num2str(20*i)])
    end
    lum_threshold=input('Enter best lum_threshold (nan for keyboard): ');
    if isnan(lum_threshold); keyboard;end
    subimage_lum=subimage;
    subimage_lum(subimage_lum<lum_threshold)=0;
    close
    
    %BW_threshold
    figure('Color',[1 1 1])
    for i=1:15
        diff_im2 = im2bw(subimage_lum,1/i);
        subplot(3,5,i), imagesc(diff_im2)
        title(['BW threshold=',num2str(1/i)])
    end
    BW_threshold=input('Enter best BW_threshold (nan for keyboard): ');
    if isnan(BW_threshold); keyboard;end
    diff_im=im2bw(subimage_lum,BW_threshold);
    close
    
    % smaller_object_size
    figure('Color',[1 1 1])
    a=0;
    for i=70:20:450
        a=a+1;diff_im2 = bwareaopen(diff_im,i);
        subplot(4,5,a), imagesc(diff_im2);
        title(['object size=',num2str(i)])
    end
    smaller_object_size=input('Enter best object_size (nan for keyboard): ');
    if isnan(smaller_object_size); keyboard;end
    close
    
    save(NameRefFile,'-append','BW_threshold','smaller_object_size','subimage','lum_threshold');
end


%% begin tracking

disp(['   pas = ',num2str(pas),'      Begin tracking and immobility...'])
h = waitbar(0, 'Tracking and Immobility...');

if plo, figure('Color',[1 1 1]), numFig=gcf; title('Tracking');end


indx=1;
for ind=1:pas:numFrames

    waitbar(ind/numFrames, h);
    
    vidFrames = read(OBJ,ind);
    IM=vidFrames(:,:,3,1);
    IM=single(IM);
    % ----------------------
    % code gab
    subimage = abs(ref_im - IM);
    subimage(subimage<lum_threshold)=0;
    diff_im = im2bw(subimage,BW_threshold);
    diff_im = bwareaopen(diff_im,smaller_object_size);
    diff_im = diff_im.*mask;
    
    % immobility
    if ind~=1, 
        immob_IM = diff_im - diff_im_temp;
        immob_val(indx)=sqrt(sum(sum(((immob_IM).*(immob_IM)))))/12000/2*100;
    end
    
    % tracking
    bw = bwlabel(diff_im, 8);
    stats = regionprops( bw, 'Centroid','Area');
    centroids = cat(1, stats.Centroid);
    
    if size(centroids) == [1 2]
        gooddetect=1;
        %position on occupation map
        x_oc = max(round(centroids(1)),1);
        y_oc = max(round(centroids(2)),1);
        Pos(indx,2)=x_oc;
        Pos(indx,3)=y_oc;
        % display
        if plo
            figure(numFig),
            subplot(2,2,1)
            hold off, imagesc(subimage)
            hold on, plot(x_oc,y_oc,'y+')
            subplot(2,2,2)
            hold off, imagesc(diff_im)
            hold on, plot(x_oc,y_oc,'y+')
            if ind~=1, 
                subplot(2,2,4)
                hold off, imagesc(immob_IM)
            end
        end

    else
        centroids = 'undefined';
        gooddetect=0;
        Pos(indx,2)=NaN;
        Pos(indx,3)=NaN;
        if plo
            figure(numFig),
            subplot(2,2,1)
            hold off, imagesc(subimage)
            text(floor(size(subimage,2)/2),floor(size(subimage,1)/2),'NaN','Color','w')
            subplot(2,2,2)
            hold off, imagesc(diff_im)
            text(floor(size(subimage,2)/2),floor(size(subimage,1)/2),'NaN','Color','w')
            if ind~=1, 
                subplot(2,2,4)
                hold off, imagesc(immob_IM)
            end
        end
    end
    % ----------------------

    Pos(indx,1)=ind*dt;
    Pos(indx,4)=gooddetect;
    indx=indx+1;

    diff_im_temp=diff_im;

    clear IM t datas
end
close(h);

%% Freezing computation and Save
try
%     Pos_immob=Pos(2:end,:);
%     immob_time=Pos_immob(Pos_immob(:,4)==0,1);
%     immob_val=immob_val(Pos_immob(:,4)==0);
    immob_time=Pos(:,1);
    
    Movtsd=tsd(immob_time*1E4',SmoothDec(immob_val',1));
    Freeze=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
    Freeze2=dropShortIntervals(Freeze,thtps_immob*1E4);
    
    save(filename_tosave,'Movtsd','Freeze','Freeze2');
catch
    keyboard
end
%% remove manual artifacts
if manual_remove_artifacts
    try
    figure('Color',[1 1 1])
    plot(Pos(:,2),Pos(:,3))
    ylim([0,size(ref_im,1)]);xlim([0,size(ref_im,2)])
    title(filename_tosave)
    
    ok=input('Is there artefacts you want to remove manually (y/n) ? ','s');
    while ok=='y'
        disp('delimitate square area on figure');
        for i=1:4
            [x_art(i),y_art(i)]=ginput(1);
            hold on, plot(x_art(i),y_art(i),'k+')
        end
        
        x_art_lim=[min(x_art),max(x_art)];
        y_art_lim=[min(y_art),max(y_art)];
        [i,j]=find(Pos(:,2)>x_art_lim(1) & Pos(:,2)<x_art_lim(2) & Pos(:,3)>y_art_lim(1) & Pos(:,3)<y_art_lim(2));
        Pos(i,:)= [];
        
        hold off, plot(Pos(:,2),Pos(:,3))
        ylim([0,size(ref_im,1)]);xlim([0,size(ref_im,2)])
        title(filename_tosave)
        ok=input('Is there other artefacts you want to remove manually (y/n) ? ','s');
    end
    close
    catch
        keyboard
    end
end
%% save Pos
try
    file = fopen([filename_tosave,'.pos'],'w');
    
    for i = 1:length(Pos),
        fprintf(file,'%f\t',Pos(i,2));
        fprintf(file,'%f\t',Pos(i,3));
        fprintf(file,'%f\n',Pos(i,4));
    end
    
    
    fclose(file);
    % end
    
    disp(['   Sampling frequency :',num2str(1/median(diff(Pos(:,1)))),'Hz']);
    
    Fs=1/median(diff(Pos(:,1)));
    
    save(filename_tosave,'-append','Pos','Fs');
catch
    disp(['Problem: could not save ',filename_tosave,'.pos'])
end


%% Speed
try
    
    
    Vitesse=NaN(1,length(Pos)-1);
    for i=1:length(Pos)-1
        if ~isnan(Pos(i,2)) && ~isnan(Pos(i+1,2))
            Ndt=Pos(i+1,1)-Pos(i,1);
            Vx = (Pos(i,2)-Pos(i+1,2))/(Ndt);
            Vy = (Pos(i,3)-Pos(i+1,3))/(Ndt);
            Vitesse(i) = sqrt(Vx^2+Vy^2);
        end
    end;
    VitesseTemp=Vitesse(~isnan(Vitesse));
    Vit=SmoothDec(VitesseTemp',1);
    %Vit=SmoothDec(Vitesse',1);
    % M=M(Vit>vitTh,:);
    % Remove low speed + Remove artefacts - too high speed
    
    vitTh=percentile(Vit,20);
    
    PosTh=Pos(Vit>vitTh & Vit<10*median(Vit),:);
    % PosTh=Pos(find(Vit>vitTh,:);
    
    LowTh=vitTh;
    HighTh=10*median(Vit);
    save(filename_tosave,'-append','PosTh','Vit','LowTh','HighTh');
catch
    disp('Problem with speed');keyboard
end

toc;



%% final display

figure('Color',[1 1 1])
try
subplot(1,2,1), plot(Pos(:,2),Pos(:,3))
hold on, plot(PosTh(:,2),PosTh(:,3),'r')
ylim([0,size(ref_im,1)]);xlim([0,size(ref_im,2)])
title([filename_tosave,' Tracking'])
end
subplot(1,2,2),plot(Range(Movtsd,'s'),Data(Movtsd))
title([filename_tosave,' Immobility'])  


if ~exist('Pos','var'), Pos=NaN;end
if ~exist('PosTh','var'), PosTh=NaN;end
if ~exist('Vit','var'), Vit=NaN;end
if ~exist('Movtsd','var'), Movtsd=NaN;end
if ~exist('Fs','var'), Fs=NaN;end
