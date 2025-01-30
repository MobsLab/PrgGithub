function [Movtsd,Fs]=Immobility_ML(filename)
                        
%
% function 
Fsamp=10; %Hz sampling
tic;
res=pwd;
%% inputs
if ~exist('filename','var')
    error('Missing inputs arguments')
end

if ~exist('plo','var')
    plo=1;
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

vidFrames=read(OBJ,1);
frame_ref1=vidFrames(:,:,3,1);
subimage=single(frame_ref1);
    
%BW_threshold
figure('Color',[1 1 1])
for i=1:15
    diff_im2 = im2bw(subimage,1/i);
    subplot(3,5,i), imagesc(diff_im2)
    title(['BW threshold=',num2str(1/i)])
end
BW_threshold=input('Enter best BW_threshold (nan for keyboard): ');
if isnan(BW_threshold); keyboard;end
diff_im=im2bw(subimage,BW_threshold);
close

% mask
figure('Color',[1 1 1]),num=gcf; 
subplot(2,1,1), imagesc(subimage)
ok='y';
disp('Determine the appropriate area on image.')
ref=subimage;
while ok=='y'
    figure(num), clf,
    subplot(2,1,2), hold on, imagesc(vidFrames);
    subplot(2,1,1),imagesc(subimage),
    [XGrid,YGrid]=meshgrid(1:size(ref,1),1:size(ref,2));
    
    title('Click to determine a square area, then press ENTER');
    [x,y]=ginput;
    xmi=min(y);
    xma=max(y);
    yma=max(x);
    ymi=min(x);
    XGrid((XGrid>xmi&XGrid<xma))=0;
    YGrid((YGrid<yma&YGrid>ymi))=0;
    mask=XGrid'+YGrid';
    mask(find(mask>0))=1;
    mask(find(mask<0))=0;
    
    
    mask=1-abs(mask);
    R=ref;
    R(find(mask==0))=0;
    
    
    figure('Color',[1 1 1])
    subplot(2,1,1), imagesc(ref)
    subplot(2,1,2), imagesc(2*R+ref), title('Change the area? (y/n)')
    
    ok=input('Change the area? (y/n) : ','s');
    close
end

%% begin tracking

disp(['   pas = ',num2str(pas),'      Begin immobility...'])
h = waitbar(0, 'Immobility...');

figure('Color',[1 1 1]),
indx=1;
for ind=1:pas:numFrames

    waitbar(ind/numFrames, h);
    
    vidFrames = read(OBJ,ind);
    IM=vidFrames(:,:,3,1);
    IM=single(IM);
    % ----------------------
    % code gab
    subimage = IM;
    diff_im = im2bw(subimage,BW_threshold);
    diff_im = diff_im.*mask;
    
    % immobility
    if ind~=1, 
        immob_IM = diff_im - diff_im_temp;
        immob_val(indx)=sqrt(sum(sum(((immob_IM).*(immob_IM)))))/12000/2*100;
        imagesc(immob_IM)
    end
    diff_im_temp=diff_im;

    clear IM
end
close(h);

%% Freezing computation and Save
keyboard;
try
Pos_immob=Pos(2:end,:);
immob_time=Pos_immob(Pos_immob(:,4)==0,1);
immob_val=immob_val(Pos_immob(:,4)==0);

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
%% Speed
try
    Pos(isnan(Pos(:,2))|isnan(Pos(:,3)),:)=[];
    
    for i=1:length(Pos)-1
        Ndt=Pos(i+1,1)-Pos(i,1);
        Vx = (Pos(i,2)-Pos(i+1,2))/(Ndt);
        Vy = (Pos(i,3)-Pos(i+1,3))/(Ndt);
        Vitesse(i) = sqrt(Vx^2+Vy^2);
    end;
    
    Vit=SmoothDec(Vitesse',1);
    % M=M(Vit>vitTh,:);
    
    
    % Remove low speed + Remove artefacts - too high speed
    
    vitTh=percentile(Vit,20);
    PosTh=Pos(Vit>vitTh & Vit<10*median(Vit),:);
    % PosTh=Pos(find(Vit>vitTh,:);
catch
    keyboard
end

toc;

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
    
    LowTh=vitTh;
    HighTh=10*median(Vit);
    
    disp(['   Sampling frequency :',num2str(1/median(diff(Pos(:,1)))),'Hz']);
    
    Fs=1/median(diff(Pos(:,1)));
    
    save(filename_tosave,'-append','Pos','PosTh','Vit','Fs','LowTh','HighTh');
catch
    keyboard
end

%% final display
figure('Color',[1 1 1])
subplot(1,2,1), plot(Pos(:,2),Pos(:,3))
hold on, plot(PosTh(:,2),PosTh(:,3),'r')
ylim([0,size(ref_im,1)]);xlim([0,size(ref_im,2)])
title([filename_tosave,' Tracking'])

subplot(1,2,2),plot(Range(Movtsd,'s'),Data(Movtsd))
title([filename_tosave,' Immobility'])  