function [ref,nom_RefAvi,FreqVideoRef]=Create_ArtificialRefAvi(dirName,nom_RefAvi)

% Create_ArtificialRefAvi(dirName,nom_RefAvi)

%%

if ~exist('dirName','var')
    dirName=pwd;
end

ok='n';
while ok~='y'
    try 
        nom; 
        OBJ;
        numFrames;
        lengthavi;
        FreqVideoRef;
    catch
        nom=uigetfile('*.wmv;*.avi','Get video to use to create artificial ref video',dirName);
        OBJ = mmreader([dirName,'/',nom]);
        numFrames = get(OBJ, 'numberOfFrames');
        try
            if length(numFrames)==0
                lastFrame = read(OBJ, inf);
                numFrames = get(OBJ, 'numberOfFrames');
            end
        end
        
        lengthavi=input(['Enter length in second of ',nom,': ']);
        FreqVideoRef=round(numFrames/lengthavi);
    end
    
    disp(' ')
    okk='n';
    while okk~='y'
        a=input('Give time in second of the two ref images (e.g. [1 200]): '); if a(1)==0, a(1)=0.5;end
        prop=input('Give proportion of images to concatenate (default=1/2): ');
        vidFrames2 = read(OBJ,a(1)*FreqVideoRef);
        vidFrames3 = read(OBJ,a(2)*FreqVideoRef);
        [le1,le2,le3]=size(vidFrames2);
        Temp{1}=[vidFrames3(:,1:floor(le2*prop),:),vidFrames2(:,floor(le2*prop)+1:le2,:)];% horizontal catenation
        Temp{2}=[vidFrames2(:,1:floor(le2*prop),:),vidFrames3(:,floor(le2*prop)+1:le2,:)];
        Temp{3}=[vidFrames3(1:floor(le1*prop),:,:);vidFrames2(floor(le1*prop)+1:le1,:,:)];% vertical catenation
        Temp{4}=[vidFrames2(1:floor(le1*prop),:,:);vidFrames3(floor(le1*prop)+1:le1,:,:)];
        for i=1:4, subplot(2,2,i), imshow(Temp{i}); title(['ref image ',num2str(i)]); end
        i=input('Which is the good ref image? (give 1 if none) ');
        
        if exist('vidFrames','var')
            vidFrames1=Temp{i}; clear Temp; subplot(1,1,1), imshow(vidFrames1), title('Chosen Ref image ');
        else
            vidFrames=Temp{i}; clear Temp; subplot(1,1,1), imshow(vidFrames), title('Chosen Ref image ');
        end
        okk=input('Are you satisfied with the image ref (y/n)? ','s');
    end

    if exist('vidFrames1','var')
        vidFrames2 =vidFrames;
        vidFrames3 =vidFrames1;
        [le1,le2,le3]=size(vidFrames2);
        Temp{1}=[vidFrames3(:,1:floor(le2/2),:),vidFrames2(:,floor(le2/2)+1:le2,:)];% horizontal catenation
        Temp{2}=[vidFrames2(:,1:floor(le2/2),:),vidFrames3(:,floor(le2/2)+1:le2,:)];
        Temp{3}=[vidFrames3(1:floor(le1/2),:,:);vidFrames2(floor(le1/2)+1:le1,:,:)];% vertical catenation
        Temp{4}=[vidFrames2(1:floor(le1/2),:,:);vidFrames3(floor(le1/2)+1:le1,:,:)];
        
        for i=1:4, subplot(2,2,i), imshow(Temp{i}); title(['ref image ',num2str(i)]); end
        i=input('Which is the good ref image? ');
        vidFrames=Temp{i}; clear Temp; subplot(1,1,1), imshow(vidFrames), title('Chosen Ref image ');
    end
    disp('You can also concatenate this image with another one by clicking no')
    ok=input('Are you satisfied with the image ref (y/n or k for keyboard)? ','s');
    if ok=='k', keyboard;end
end

if ~exist('nom_RefAvi','var')
    nom_RefAvi=['Ref-',nom];
end

try
    aviobj=avifile([dirName,'/',nom_RefAvi]);
    aviobj = addframe(aviobj,vidFrames);
    aviobj=close(aviobj);
    disp(['        ->  ',nom_RefAvi,'.avi has been created.'])
catch
    disp(['        Problem creating ',nom_RefAvi,'.avi !!'])
end

%% save reference
try
    Mov=vidFrames(:,:,3,1);
 ref=Mov;
 ref=single(ref);
catch
    Mov=vidFrames;
    ref=Mov;
end

choice=questdlg('Do you want to save ref in Ref.mat? ','SAVE','Yes','No','Yes');
switch choice
    case 'Yes'
        save Ref ref
    case 'No'
        warning('Nothing has been saved!!!');
end

 