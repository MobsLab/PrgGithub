function Trackin_offline_OnFrames(filename,ref,mask,BW_threshold,smaller_object_size,shape_ratio);

% examples filename=/media/DataMOBsRAID/ProjetAversion/ManipDec14Bulbectomie/M210/20141211/FEAR-Mouse-210-11122014-EXTpleth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INPUTS
pasplot=3; % default 10
pasAnalysis=2; % default 1
startAtFrame=2; % default 2
DisplayTracking=1; % 1 if display tracking
DoTracking=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
disp(' ')
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end

if ~exist('filename','var')
    filename=input('Enter filename : ','s');
end
if isempty(strfind(filename,mark))
    nameFile=[res,mark,filename];
else
    nameFile=filename;
end

lis=dir(nameFile);

index=[];
for i=1:length(lis)
    NameLis{i}=lis(i).name;
    if strfind(NameLis{i},'-000')
        index=[index,i];
        disp(['N-',num2str(i),'- ',NameLis{i}])
    end
    if strfind(NameLis{i},'TrackingOFFline')
        disp('TrackingOFFline.mat already defined')
        choice=questdlg('Redo Tracking? ','TrackingOFFline.mat already defined','No','Yes','No');
        switch choice
            case 'No'
              DoTracking=0;
        end
    end
end

if DoTracking
    if length(index)>1
        ok=input(['Do you want to concatenantes all the ',num2str(length(index)),' folders (y/n)? '],'s');
        if ok~='y',
            index=input('   Enter Number of file as given above (eg [3 4 5]): ');
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CHECK REFERENCE AND MASK
    if ~exist([nameFile,mark,'InfoTracking.mat'],'file')
         load([nameFile,mark,'Behavior.mat'],'imageRef','mask','BW_threshold2','smaller_object_size2','shape_ratio2');
         ref=imageRef;
         BW_threshold=BW_threshold2;
         smaller_object_size=smaller_object_size2;
         shape_ratio=shape_ratio2;
         save([nameFile,mark,'InfoTracking.mat'],'ref','mask','BW_threshold','smaller_object_size');
    end
    
    if ~exist('ref','var')
        load([nameFile,mark,'InfoTracking.mat'],'ref')
    end
    if ~exist('mask','var')
        load([nameFile,mark,'InfoTracking.mat'],'mask')
    end
    if ~exist('BW_threshold','var')
        load([nameFile,mark,'InfoTracking.mat'],'BW_threshold')
    end
    if ~exist('smaller_object_size','var')
        load([nameFile,mark,'InfoTracking.mat'],'smaller_object_size')
    end
    if ~exist('shape_ratio','var')
        shape_ratio=5; % default 5
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CHECK ONLINE TRACKING
    PosON=[];
    for i=index
        dirNames=dir([nameFile,mark,NameLis{i}]);
        % online
        clear PosMat
        try
            load([nameFile,mark,NameLis{i},mark,'PosMat.mat'])
            if isempty(PosON)
                PosON=PosMat;
            else
                PosON=[PosON;[PosMat(:,1)+max(PosON(:,1)),PosMat(:,[2,3])]];
            end
        end
    end
    
    if ~isempty(PosON)
        figure('Color',[1 1 1]),
        imagesc(mask);
        hold on, plot(PosON(~isnan(PosON(:,2)),2),PosON(~isnan(PosON(:,2)),3),'.-w')
        title('Tracking ONLINE');
    else
        disp('No Online Tracking!!')
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Choose what to do
    choice=questdlg('Do you need to improve tracking? ','what to do?','No','Tracking offline','Remove points','No');
    switch choice
        case 'Tracking offline'
            computeOFF=1;close;
            choice2=questdlg('Is it just a test? ','Test?','Analysis','Preview','Custum','Analysis');
            
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
                    
                case 'Preview'
                    pasAnalysis=5;
                    pasplot=5;
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
    global BW_threshold2;
    global smaller_object_size2;
    global shape_ratio2;
    
    BW_threshold2=BW_threshold;
    smaller_object_size2=smaller_object_size;
    shape_ratio2=shape_ratio;
    
    if computeOFF
        if DisplayTracking
            figure('Color',[1 1 1]), numF=gcf;
            subplot(211)
            hul = imagesc(ref); colormap gray
            subplot(212),
            subimage = uint8(double(ref).*double(mask));
            hul2 = imagesc(subimage); colormap gray
            hold on, g=plot(0,0,'m+');
            
            chronoshow=uicontrol('style','edit', 'units','normalized','position',[0.05 0.26 0.04 0.05],...
            'string',num2str(floor(0)),'ForegroundColor','g','BackgroundColor','k');
        end
        numfr=0;
        PosOFF=[];
        tic
        
        % online gui reglage
        guireg_fig=OnlineGuiReglage;
        
        for i=index
            
            dirNames=dir([nameFile,mark,NameLis{i}]);
            eval('h=waitbar(0,[''Tracking '',NameLis{i},''...'']);');
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
            disp(['Number of frames=',num2str(sum(isfr))])
            inputDisplay=uicontrol(gcf,'style','text','units','normalized','position',[0.01 0.5 0.75 0.02],'string','frame =?');
            for fr=indexfr
                numfr=fr;
                waitbar(fr/sum(isfr));
                set(inputDisplay,'string',[num2str(fr),'/',num2str(length(indexfr))]);
                clear datas Time t1 IM subimage diff_im
                eval('load([nameFile,mark,NameLis{i},mark,dirNames(index_frames(fr)).name])');
                
                t1=datas.time;
                if numfr==1; timeDeb=t1(4)*60*60+t1(5)*60+t1(6);end
                Time=(t1(4)*60*60+t1(5)*60+t1(6))-timeDeb;
                
                %get image
                IM=datas.image;
                %Soustrait l'image de r�f�rence
                subimage = abs(ref-IM);
                % use mask to clear image
                subimage = uint8(double(subimage).*double(mask));
                % Convert the resulting grayscale image into a binary image.
                diff_im = im2bw(subimage,BW_threshold2);
                % Remove all the objects less large than smaller_object_size2
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
                goodind=find(rap<shape_ratio2);
                centroids=centroids(goodind,:);
                
                if DisplayTracking && (rem(fr,pasplot)==1 || pasplot==1)
                    %display video and mouse position
                    %                 figure(numF), subplot(2,1,1),imagesc(IM), colormap gray
                    %                 subplot(2,1,2),imagesc(diff_im), colormap gray
                    %                 pause(0.001)
                    set(hul,'Cdata',IM);
                    set(hul2,'Cdata',diff_im);
                    
                    if ~isempty(centroids),
                        %hold on, plot(centroids(1),centroids(2), '-m+');
                        set(g,'Xdata',centroids(1),'YData',centroids(2))
                    else
                        set(g,'Xdata',0,'YData',0)
                    end
                    
                    set(chronoshow,'string',num2str(Time));
                end
                if size(centroids) == [1 2] %si on ne detecte qu'un objet
                    tempPosOFF(numfr,1:3)=[Time,centroids(1),centroids(2)];
                else
                    tempPosOFF(numfr,1)=Time;
                end
                
            end
            disp(' ')
            disp(['BW_threshold2=',num2str(BW_threshold2)]);
            disp(['smaller_object_size2=',num2str(smaller_object_size2)]);
            disp(['shape_ratio2=',num2str(shape_ratio2)]);
            
            try close(h);end
            
            if isempty(PosOFF)
                PosOFF=tempPosOFF;
            else
                PosOFF=[PosOFF;[tempPosOFF(:,1)+max(PosOFF(:,1)),tempPosOFF(:,[2,3])]];
            end
            
        end
        close(guireg_fig)
        disp(' ')
        toc
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% COMPARE ONLINE AND OFFLINE TRACKING
    
    figure('Color',[1 1 1]),
    %subplot(1,2,1), scatter(PosON(:,2),PosON(:,3),5,PosON(:,1),'filled'); colorbar
    subplot(1,2,1), imagesc(mask); colormap gray
    try hold on, plot(PosON(~isnan(PosON(:,2)),2),PosON(~isnan(PosON(:,2)),3),'b');end
    title('Tracking ONLINE')
    
    %subplot(1,2,2), scatter(PosOFF(:,2),PosOFF(:,3),5,PosOFF(:,1),'filled');colorbar
    subplot(1,2,2),imagesc(mask); colormap gray
    hold on, plot(PosOFF(~isnan(PosOFF(:,2)),2),PosOFF(~isnan(PosOFF(:,2)),3),'b')
    title('Tracking OFFLINE')
    
    choice=questdlg('Redefine a mask to exclude absurd points ?','Affine mask?','Yes','No','No');
    switch choice
        case 'yes'
            R2=ref;
            R2(mask==0)=0;
            figure('Color',[1 1 1]),
            subplot(2,1,1), imagesc(R2); colormap gray
            
            [x, y, BW, xi, yi] = roipoly(R2);
            
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% SAVE
    
    BW_threshold=BW_threshold2;
    smaller_object_size=smaller_object_size2;
    shape_ratio=shape_ratio2;
    
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
        save([nameFile,mark,'Temp'],'filename','PosON','PosOFF','ref','mask','smaller_object_size','BW_threshold','shape_ratio')
    end
    
end
