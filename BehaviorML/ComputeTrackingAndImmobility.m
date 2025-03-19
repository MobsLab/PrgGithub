function ComputeTrackingAndImmobility


%% INPUTS
colori={'g','r','m','k','b','r'};
scrsz = get(0,'ScreenSize');
color_on = [ 0 0 0];
color_off= [0.5 0.5 0.5];


global MaskInProcessing
global plot_images
global enableTrack
global restartVideo
global BW_threshold2
global smaller_object_size2
global shape_ratio2
global BadRef
global RealFrameRate
% default values for tracking :
shape_ratio=5; % dafault 5
BW_threshold=0.2;
smaller_object_size=11;
plot_images=1;
BadRef=0;
RealFrameRate=30;
enableTrack=1;
% anoying problems
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

Fig_Track=figure('units','normalized','position',[0.1 0.08 0.3 0.6],...
    'numbertitle','off','name','TrackingAndImmobility','menubar','none','tag','figure Odor');
set(Fig_Track,'Color',color_on);

trackbutton(1)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.1 0.92 0.2 0.05],...
    'string','1- Inputs for Tracking','callback', @InputTracking);
set(trackbutton(1),'enable','on','FontWeight','bold')

trackbutton(2)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.4 0.92 0.2 0.05],...
    'string','2- Compute References','callback', @ComputeRef);
set(trackbutton(2),'enable','off')

trackbutton(3)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.7 0.92 0.2 0.05],...
    'string','3- Compute Tracking','callback', @ComputeTracking);
set(trackbutton(3),'enable','off')

trackbutton(4)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.07 0.05 0.15 0.04],...
    'string','Display Tracking','callback', @DisplayTracking);
set(trackbutton(4),'enable','off')

trackbutton(5)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.35 0.05 0.15 0.04],...
    'string','Restart Tracking','callback', @ReStartTracking);
set(trackbutton(5),'enable','off')

trackbutton(6)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.53 0.05 0.07 0.03],...
    'string','Bad Ref','callback', @RemoveRef);
set(trackbutton(6),'enable','off')

trackbutton(7)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.65 0.05 0.1 0.04],...
    'string','Keyboard','callback', @PauseTracking);
set(trackbutton(7),'enable','off')

trackbutton(8)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.82 0.05 0.1 0.05],...
    'string','Multiple Rec','callback', @MultipleRec);
%set(trackbutton(8),'enable','off')

inputDisplay(1)=uicontrol(Fig_Track,'style','text','units','normalized','position',[0.01 0.89 0.75 0.02],'string','filename = TO DEFINE');
set(inputDisplay(1),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')

inputDisplay(2)=uicontrol(Fig_Track,'style','text','units','normalized','position',[0.09 0.015 0.1 0.03],'string','ON');
set(inputDisplay(2),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')

inputDisplay(3)=uicontrol(Fig_Track,'style','text','units','normalized','position',[0.3 0.015 0.25 0.03],'string','Time in Video: NaN');
set(inputDisplay(3),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')

inputDisplay(4)=uicontrol(Fig_Track,'style','text','units','normalized','position',[0.51 0.015 0.1 0.03],'string','OFF');
set(inputDisplay(4),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% select files and inputs
    function InputTracking(obj,event)
        try
            tempload=load([res,'/InputsTracking.mat']); tempload.NomRef; tempload.NumR; tempload.RmNumR; tempload.plot_images;
            disp('InputsTracking.mat already defined, skipping this step')
            
        catch
            prompt = {'Number of Environment in the experiment',...
                'Number of Animals recorded at the same time'};
            answer = inputdlg(prompt,'Change InputsTracking',1,{'1','1'});
            
            if answer{1}~='1',
                ExempleRefNames={'Rond','Croix','Carre','Triangle','Rond','Croix','Carre','Triangle'}; clear prompt
                for aa=1:str2num(answer{1}), prompt{aa}=['Reference File Environment ',num2str(aa)];end
                NomRef= inputdlg(prompt,'Name for Reference files',1,ExempleRefNames(1:str2num(answer{2})));
            else NomRef={''};
            end
            
            if answer{2}~='1',
                ExempleRefNames={'Mouse-100','Mouse-101','Mouse-102','Mouse-103'};
                prompt={'basename to replace'};
                for aa=1:str2num(answer{2}), prompt{aa+1}=['name mouse ',num2str(aa)];end
                RmNumR=inputdlg(prompt,'Names of mice',1,['Mouse-100-101',ExempleRefNames(1:str2num(answer{2}))]);
                NumR=RmNumR(2:end);RmNumR=RmNumR(1);
            else NumR={''}; RmNumR={''};
            end
            save InputsTracking NomRef NumR RmNumR plot_images shape_ratio BW_threshold smaller_object_size
        end
        h = msgbox('InputsTracking Done!','InputsTracking'); pause(1);try close(h);end
        set(trackbutton(2),'enable','on','FontWeight','bold')
        set(trackbutton(1),'FontWeight','normal');
    end

% -----------------------------------------------------------------
%% select files and inputs
    function ComputeRef(obj,event)
        tempload=load('InputsTracking.mat');
        try RealFrameRate=tempload.RealFrameRate; end
        for j=1:length(tempload.NomRef)
            for r=1:length(tempload.NumR)
                set(inputDisplay(1),'string',['Filename = Ref',num2str(tempload.NomRef{j}),tempload.NumR{r}]);
                
                ok=0;
                while ok~=1
                    DoRef=1;
                    while DoRef==1
                        
                        % load and check ref and mask
                        try
                            disp(['Ref',tempload.NomRef{j},tempload.NumR{r},'.mat'])
                            Rtempload=load(['Ref',tempload.NomRef{j},tempload.NumR{r},'.mat']);
                            figure(Fig_Track),colormap gray
                            subplot(1,2,1), imagesc(Rtempload.ref),axis image; title('Ref','Color','w')
                            subplot(1,2,2), imagesc(Rtempload.ref.*Rtempload.mask),axis image; title('masked Ref','Color','w')
                            choice = questdlg('Are you ok with this ref and mask?', ['Ref',num2str(tempload.NomRef{j}),tempload.NumR{r}],'Redo','Done','Done');
                            switch choice
                                case 'Redo'
                                    choice2 = questdlg('What''s wrong?', 'change ref and mask','Change MASK','Redo all','Change MASK');
                                    switch choice2
                                        case 'Change MASK'
                                            DoRef=2;
                                        case 'Redo all'
                                            DoRef=1;
                                    end
                                case 'Done'
                                    DoRef=0; ok=1;
                            end
                            %%
                            title('Click on two points to define a distance','Color','w')
                            for ji=1:2
                                [x,y]=ginput(1);
                                hold on, plot(x,y,'+r')
                                x1(ji)=x; y1(ji)=y;
                            end
                            line(x1,y1,'Color','r','Linewidth',2)
                            
                            answer = inputdlg({'Enter real distance (cm):'},'Define Real distance',1,{'40'});
                            text(mean(x1)+10,mean(y1)+10,[answer{1},' cm'],'Color','r')
                            
                            d_xy=sqrt((diff(x1)^2+diff(y1)^2));
                            Ratio_IMAonREAL=d_xy/str2num(answer{1});
                            
                            hold on, line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
                            text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
                            save('InputsTracking.mat','-append','Ratio_IMAonREAL');
                            
                        end
                        
                        if DoRef==1
                            set(inputDisplay(1),'string',['COMPUTING Ref',num2str(tempload.NomRef{j}),tempload.NumR{r},'. Load Ref Video or cancel to create one.']);
                            RefVideo=uigetfile('*.wmv;*.avi',['Get video Ref',num2str(tempload.NomRef{j}),tempload.NumR{r}]');
                            if RefVideo==0,
                                choice = questdlg('Create video Ref?', 'No existing video Ref' ,'Yes','No','Yes');
                                switch choice
                                    case 'Yes'
                                        %artRefVideo=uigetfile('*.wmv;*.avi',['Get video Ref',num2str(tempload.NomRef{j}),tempload.NumR{r}]');
                                        set(inputDisplay(1),'string',['COMPUTING Ref',num2str(tempload.NomRef{j}),tempload.NumR{r},'. WAIT...']);
                                        disp('Wait for videofile to be loaded to create ref...');
                                        Create_ArtificialRefAvi(res,[tempload.RmNumR{:},'Ref']);
                                        RefVideo=[tempload.RmNumR{:},'Ref.avi'];
                                        disp('Done');
                                    case 'No'
                                        warndlg('Carreful! No reference computed!!')
                                end
                            end
                            
                            % do reference image
                            try 
                                OBJref = mmreader(RefVideo);
                            catch
                                OBJref = VideoReader(RefVideo);
                            end
                
                            ima=read(OBJref,1); okref=0;
                            subplot(1,2,1), imagesc(ima); axis image
                            while okref~=1
                                choice = questdlg('Ref Image ok?', 'Reference Image' ,'Yes','Give another frame','Give 3 different frames','Yes');
                                switch choice
                                    case 'Yes'
                                        okref=1; ref=single(ima(:,:,3,1));
                                    case 'Give another frame'
                                        fr=inputdlg('Frame :','Choose frame for reference Image',1,{'1'}); fr=str2double(fr{1});
                                        ima=read(OBJref,fr);subplot(1,2,1), imagesc(ima); axis image; ref=single(ima(:,:,3,1));
                                    case 'Give 3 different frames'
                                        fr=inputdlg({'frame 1','frame 2','frame 3'},'Choose frames for reference Image',1,{'1','10','20'}); fr=str2double(fr);
                                        vidFrames1 = read(OBJref,fr(1));Mo1=single(vidFrames1(:,:,3,1));
                                        vidFrames2 = read(OBJref,fr(2));Mo2=single(vidFrames2(:,:,3,1));
                                        vidFrames3 = read(OBJref,fr(3));Mo3=single(vidFrames3(:,:,3,1));
                                        th=10; Mo1(Mo1<th)=th; Mo2(Mo2<th)=th; Mo3(Mo3<th)=th;
                                        ima=(Mo1+Mo2+Mo3)/3; subplot(1,2,1), imagesc(ima); axis image; colormap gray
                                        ref=single(ima);
                                end
                            end
                            mask=single(ones(size(ref)));
                            save(['Ref',tempload.NomRef{j},tempload.NumR{r},'.mat'],'ref','mask')
                            clear OBJref ima
                            
                        end
                    end
                    
                    % construct or redo mask
                    if DoRef==2
                        Rtempload=load(['Ref',tempload.NomRef{j},tempload.NumR{r},'.mat']);
                        Get_mask(['Ref',tempload.NomRef{j},tempload.NumR{r},'.mat']);
                        MaskInProcessing=1; save(['Ref',tempload.NomRef{j},tempload.NumR{r},'.mat'],'MaskInProcessing','-append')
                        while MaskInProcessing
                            Rtempload=load(['Ref',tempload.NomRef{j},tempload.NumR{r},'.mat']);
                            MaskInProcessing=Rtempload.MaskInProcessing; pause(1);
                        end
                        Rtempload=load(['Ref',tempload.NomRef{j},tempload.NumR{r},'.mat']);
                        subplot(1,2,2), imagesc(Rtempload.ref.*Rtempload.mask),axis image; title('masked Ref','Color','w')
                        
                        % final approbation
                        choice = questdlg('Are you ok with this ref and mask?', ['Ref',num2str(tempload.NomRef{j}),tempload.NumR{r}],'Yes','No','Yes');
                        switch choice
                            case 'Yes'
                                ok=1;
                        end
                    end
                    
                end
            end
            
            % ask video file to track
            try
                tempload=load('InputsTracking.mat');
                NomFiles=tempload.NomFiles;
                NomFiles{j}(1);
            catch
                set(inputDisplay(1),'string',['GET VIDEOS CORRESPONDING TO Ref',tempload.NomRef{j}])
                disp(['GET VIDEOS CORRESPONDING TO Ref',tempload.NomRef{j}])
                tempnomfiles=uigetfile('*.wmv;*.avi',['Get video corresponding to Ref',tempload.NomRef{j}],'MultiSelect','on');
                try tempnomfiles{1}; catch, tt=tempnomfiles; clear tempnomfiles; tempnomfiles{1}=tt;end
                NomFiles{j}=tempnomfiles;
                save InputsTracking -append NomFiles

                disp(['Enter length of the first ',tempload.NomRef{j},' video file (check of framerate!)...'])
                answer = inputdlg({['Length of 1st ',tempload.NomRef{j},' videofile (hour)'],'(minute)','(second)'},NomFiles{j}{1},1,{'0','0','0'});
                lengthfile(j)= sum(str2double(answer').*[3600 60 1]);
                disp([num2str(lengthfile(j)),'s'])
                save InputsTracking -append lengthfile
            end
        end
        set(trackbutton(3),'enable','on','FontWeight','bold')
        set(trackbutton(4),'enable','on','FontWeight','bold')
        set(trackbutton(2),'FontWeight','normal');
    end

% -----------------------------------------------------------------
%% ComputeTracking
    function ComputeTracking(obj,event)
        
        tempload=load('InputsTracking.mat');
        shape_ratio2=tempload.shape_ratio;
        BW_threshold2=tempload.BW_threshold;
        smaller_object_size2=tempload.smaller_object_size;
        guireg_fig=OnlineGuiReglage(obj,event);
        
        for j=1:length(tempload.NomRef)
            % load (multiple) ref and mask
            Rtempload=load(['Ref',tempload.NomRef{j},tempload.NumR{1},'.mat']);
            refMouse1=Rtempload.ref; maskMouse1=Rtempload.mask;
            figure(Fig_Track),
            subplot(221), htrack = imagesc(refMouse1);axis image; colormap gray; xlabel('Mouse 1 - real','Color','w')
            subplot(223), htrackBW = imagesc(refMouse1./max(max(refMouse1)));axis image;caxis([0 1]); hold on, g = plot(0,0,'+m'); title('Mouse 1 - Processed','Color','w')
            if length(tempload.NumR)>1
                Rtempload=load(['Ref',tempload.NomRef{j},tempload.NumR{2},'.mat']);
                refMouse2=Rtempload.ref; maskMouse2=Rtempload.mask;
                TwoRef=1;
                subplot(222), htrack2 = imagesc(refMouse2);axis image; xlabel('Mouse 2 - real','Color','w')
                subplot(224), htrackBW2 = imagesc(refMouse2./max(max(refMouse2)));axis image; caxis([0 1]);hold on, g2 = plot(0,0,'+m'); title('Mouse 2 - Processed','Color','w')
            else
                TwoRef=0;
            end
            
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % loop on each video file
            for fi=1:length(tempload.NomFiles{j})
                tic
                clear tempIM1 tempIM2 Pos PosMat Movtsd PosMat2 Movtsd2 PosLoad immob_val immob_val2
                % names of file to save tracking
                filenameavi=tempload.NomFiles{j}{fi};
                disp(' ');disp(['        * * * ',filenameavi,' * * *'])
                goodname1=filenameavi(1:end-4);
                if TwoRef,
                    goodname1=[filenameavi(1:strfind(filenameavi,tempload.RmNumR{:})-1),tempload.NumR{1},filenameavi(strfind(filenameavi,tempload.RmNumR{:})+length(tempload.RmNumR{:}):end-4)];
                    goodname2=[filenameavi(1:strfind(filenameavi,tempload.RmNumR{:})-1),tempload.NumR{2},filenameavi(strfind(filenameavi,tempload.RmNumR{:})+length(tempload.RmNumR{:}):end-4)];
                end
                
                try
                    PosLoad=load(goodname1,'Pos','PosMat','Movtsd'); PosLoad.Pos; PosMat=PosLoad.PosMat; Movtsd=PosLoad.Movtsd;
                    try refMouse1=PosLoad.ref; maskMouse1=PosLoad.mask;end
                    disp([goodname1,' already exists...'])
                    if TwoRef
                        PosLoad=load(goodname2,'Pos','PosMat','Movtsd'); PosLoad.Pos; PosMat2=PosLoad.PosMat; Movtsd2=PosLoad.Movtsd;
                        try refMouse2=PosLoad.ref; maskMouse2=PosLoad.mask;end
                        disp([goodname2,' already exists...']);
                    end
                    disp('skipping tracking...')
                    
                catch
                    clear tempIM1 tempIM2 Pos PosMat Movtsd PosMat2 Movtsd2 
                    restartVideo=1;
                    % --------------------- Load video -----------------------
                    disp(['Loading ',filenameavi,'. WAIT...'])
                    set(inputDisplay(1),'string',['Loading ',filenameavi,'. WAIT...'],'Position',[0.01 0.5 0.75 0.02],'ForegroundColor','r')
                    try
                        OBJ = mmreader(filenameavi);
                    catch
                        OBJ = VideoReader(filenameavi);
                    end
                    numFrames = get(OBJ, 'numberOfFrames');
                    fcy=get(OBJ, 'FrameRate');
                    
                    disp(['number of frames=',num2str(numFrames)])
                    disp(['given frames per second=',num2str(fcy)])
                    try
                        if length(numFrames)==0
                            lastFrame = read(OBJ, inf);
                            numFrames = get(OBJ, 'numberOfFrames');
                        end
                    end
                    if fi==1, RealFrameRate=numFrames/tempload.lengthfile(j); save InputsTracking -append RealFrameRate; end
                    disp(['REAL frames per second=',num2str(round(RealFrameRate))])
                    
                    % ---------------------------------------------------------
                    
                    set(inputDisplay(1),'string',['Tracking ',filenameavi,'...'],'ForegroundColor','w')
                    set(trackbutton(5),'enable','on','FontWeight','bold')
                    set(trackbutton(6),'enable','on','FontWeight','bold')
                    set(trackbutton(7),'enable','on','FontWeight','bold')
                    
                    fr=1;t1=0;
                    while fr<numFrames
                        if restartVideo, fr=1;t1=0;restartVideo=0;end
                        set(inputDisplay(3),'string',['Time (s) in Video: ',num2str(floor(fr/RealFrameRate)),'/',num2str(floor(numFrames/RealFrameRate))])
                        t1=t1+1/RealFrameRate;
                        
                        % --------------
                        % get image
                        try vidFrames = read(OBJ,fr); catch; pause(5); try vidFrames = read(OBJ,fr);catch, keyboard;end;end
                        Mov=vidFrames(:,:,3,1);
                        IM=Mov; IM=single(IM);
                        
                        % --------------
                        % process image
                        if BadRef, subimage = abs(IM-max(max(IM))); else, subimage = abs(refMouse1-IM);end
                        subimage(find(maskMouse1==0))=0;
                        subimage=subimage./max(max(subimage));
                        diff_im = im2bw(subimage,BW_threshold2);
                        diff_im = bwareaopen(diff_im,smaller_object_size2);
                        try MovIM1=(diff_im-tempIM1); catch, MovIM1=single(zeros(size(diff_im)));end
                        tempIM1=diff_im;
                        immob_val(fr)=sqrt(sum(sum(((MovIM1).*(MovIM1)))))/12000/2*100;
                        if plot_images
                            set(htrack,'Cdata',IM.*maskMouse1);
                            set(htrackBW,'Cdata',diff_im-0.5*MovIM1./max(max(MovIM1)));
                        end
                        % --------------
                        % Label all the connected components in the image.
                        bw = bwlabel(diff_im, 8);
                        stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength');
                        centroids = cat(1, stats.Centroid);
                        maj = cat(1, stats.MajorAxisLength); mini = cat(1, stats.MinorAxisLength);
                        rap=maj./mini;
                        centroids=centroids(rap<shape_ratio2,:);
                        
                        % --------------
                        % find centroid
                        if size(centroids) == [1 2]
                            if plot_images, set(g,'Xdata',centroids(1),'YData',centroids(2));end
                            PosMat(fr,1)=t1;
                            PosMat(fr,2)=centroids(1);
                            PosMat(fr,3)=centroids(2);
                        else
                            if plot_images, set(g,'Xdata',0,'YData',0);end
                            PosMat(fr,:)=[t1;NaN;NaN];
                        end
                        
                        % --------------
                        % second mouse
                        if TwoRef
                            % Same processing
                            if BadRef, subimage2 = abs(IM-max(max(IM))); else, subimage2 = abs(refMouse2-IM);end
                            subimage2(find(maskMouse2==0))=0;
                            subimage2=subimage2./max(max(subimage2));
                            diff_im2 = im2bw(subimage2,BW_threshold2);
                            diff_im2 = bwareaopen(diff_im2,smaller_object_size2);
                            try MovIM2=(diff_im2-tempIM2); catch, MovIM2=single(zeros(size(diff_im2)));end
                            tempIM2=diff_im2;
                            immob_val2(fr)=sqrt(sum(sum(((MovIM2).*(MovIM2)))))/12000/2*100;
                            if plot_images
                                set(htrack2,'Cdata',IM.*maskMouse2);
                                set(htrackBW2,'Cdata',diff_im2-0.5*MovIM2./max(max(MovIM2)));
                            end
                            bw2 = bwlabel(diff_im2, 8);
                            stats2 = regionprops( bw2, 'Centroid','MajorAxisLength','MinorAxisLength');
                            centroids2 = cat(1, stats2.Centroid);
                            maj = cat(1, stats2.MajorAxisLength); mini = cat(1, stats2.MinorAxisLength);
                            rap2=maj./mini;
                            centroids2=centroids2(rap2<shape_ratio2,:);
                            
                            %set(htrack2,'Cdata',diff_im);
                            if size(centroids2) == [1 2]
                                if plot_images, set(g2,'Xdata',centroids2(1),'YData',centroids2(2));end
                                PosMat2(fr,1)=t1;
                                PosMat2(fr,2)=centroids2(1);
                                PosMat2(fr,3)=centroids2(2);
                            else
                                if plot_images, set(g2,'Xdata',0,'YData',0);end
                                PosMat2(fr,:)=[t1;NaN;NaN];
                            end
                            
%                         else
%                             if plot_images, set(htrackBW,'Cdata',IM);end
                        end
                        
                        fr=fr+1; pause(0.003)
                        if enableTrack==0, keyboard; enableTrack=1;end
                    end
                    shape_ratio=shape_ratio2; BW_threshold=BW_threshold2; smaller_object_size=smaller_object_size2;
                    
                    % -----------------------------------------------------
                    % ----------- save Pos, PosMat and Movtsd -------------
                    try
                        timeImposed=[min(PosMat(:,1)):1/15:max(PosMat(:,1))]; % at 15Hz
                        disp(['... Saving ',goodname1,'.mat']); indexpos=find(~isnan(PosMat(:,2)));
                        try
                            Pos=[timeImposed',interp1(PosMat(indexpos,1),PosMat(indexpos,2:3),timeImposed)];
                        catch
                            disp('ATTENTION !!!!! Pos is composed of NaN only!');
                            Pos=[timeImposed',nan(length(timeImposed),2)];
                        end
                        Movtsd=tsd(PosMat(:,1)*1E4',SmoothDec(immob_val',1));
                        ref=refMouse1; mask=maskMouse1;
                        save(goodname1,'Pos','PosMat','Movtsd','ref','mask','shape_ratio','BW_threshold','smaller_object_size');
                        if TwoRef
                            disp(['... Saving ',goodname2,'.mat']);indexpos=find(~isnan(PosMat2(:,2)));
                            Pos=[timeImposed',interp1(PosMat2(indexpos,1),PosMat2(indexpos,2:3),timeImposed)];
                            Movtsd2=tsd(PosMat2(:,1)*1E4',SmoothDec(immob_val2',1));
                            tempPosMat=PosMat; PosMat=PosMat2; Movtsd=Movtsd2;
                            ref=refMouse2; mask=maskMouse2;
                            save(goodname2,'Pos','PosMat','Movtsd','ref','mask','shape_ratio','BW_threshold','smaller_object_size');
                            PosMat=tempPosMat;
                        end
                        % ----------------- create files.pos ------------------
                        disp('... Generating files.pos');
                        file1 = fopen([goodname1,'.pos'],'w'); if TwoRef,file2 = fopen([goodname2,'.pos'],'w');end
                        for pp = 1:length(PosMat)
                            fprintf(file1,'%f\t',PosMat(pp,2)); fprintf(file1,'%f\n',PosMat(pp,3));
                            if TwoRef,fprintf(file2,'%f\t',PosMat2(pp,2)); fprintf(file2,'%f\n',PosMat2(pp,3));end
                        end
                        disp('Done')
                    catch
                        disp('Problem saving...');
                        keyboard;
                    end
                end
                
                % --------------------- final display ---------------------
                figure('Color',[1 1 1]), subplot(211), colormap gray
                imagesc(refMouse1), hold on, plot(PosMat(:,2),PosMat(:,3)); title(goodname1)
                subplot(212), plot(Range(Movtsd,'s'),Data(Movtsd)); title('Movtsd'); xlabel('Time (s)')
                if TwoRef
                    subplot(211), hold on, plot(PosMat2(:,2),PosMat2(:,3),'r'); xlabel(goodname2);
                    subplot(212), hold on,plot(Range(Movtsd2,'s'),Data(Movtsd2),'r');
                    index=strfind(goodname1,'Mouse');
                    legend({goodname1(index:index+9),goodname2(index:index+9)});
                end
                toc
            end
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        set(trackbutton(5),'enable','off')
        set(trackbutton(6),'enable','off')
        set(trackbutton(7),'enable','off')
        close(guireg_fig);
        set(trackbutton(8),'enable','on','FontWeight','bold')
    end

% -----------------------------------------------------------------
%% ReStartTracking
    function ReStartTracking(obj,event)
        pause(0.005)
        restartVideo=1;
        disp('Restart tracking')
        shape_ratio=shape_ratio2; BW_threshold=BW_threshold2; smaller_object_size=smaller_object_size2;
        save InputsTracking -append shape_ratio BW_threshold smaller_object_size
    end

% -----------------------------------------------------------------
%% ReStartTracking
    function MultipleRec(obj,event)
        disp(' ');
        disp('Set current session (select basename.xml)');
        SetCurrentSession
        SetCurrentSession('same')
        evt=GetEvents('output','Descriptions');
        if strcmp(evt{1},'0'), evt=evt(2:end);end
        tpsdeb=[]; tpsfin=[];
        for i=1:length(evt)
            tpsEvt{i}=GetEvents(evt{i});
            if evt{i}(1)=='b'
                tpsdeb=[tpsdeb,tpsEvt{i}];
            elseif evt{i}(1)=='e'
                tpsfin=[tpsfin,tpsEvt{i}];
            end
        end
        %evt=evt(2:end);
        try load('LengthPosCorrection.mat'); catch, LengthPosCorrection.name=[]; LengthPosCorrection.X=[]; LengthPosCorrection.delPos=[]; LengthPosCorrection.leni=[];end
        tempload=load('InputsTracking.mat');
        for j=1:length(tempload.NomRef)
            
            % loop on each video file
            for fi=1:length(tempload.NomFiles{j})
                filenameavi=tempload.NomFiles{j}{fi}; NamePrefix=filenameavi(1:4);
                disp(['        * * * ',filenameavi,' * * *'])
                set(inputDisplay(1),'string',['Multiple Rec in video ',filenameavi,'...'],'ForegroundColor','y')
                
                if (exist('LengthPosCorrection.mat','file')==2 && ~sum(strcmp(LengthPosCorrection.name,filenameavi))) || ~exist('LengthPosCorrection.mat','file')
                    answer = inputdlg({'Num of 1st recording session','2nd','3rd','4t','5th','6th'},'Video',1,{'1','NaN','NaN','NaN','NaN','NaN'});
                    X=str2double(answer(~isnan(str2double(answer))))';
                    for xx=1:length(X)
                        disp(['file',num2str(X(xx)),'= ',evt{X(xx)}(strfind(evt{X(xx)},NamePrefix):end),'.dat'])
                    end
                    
                    if length(tempload.NumR)>1
                        Posload=load([filenameavi(1:strfind(filenameavi,tempload.RmNumR{:})-1),tempload.NumR{1},filenameavi(strfind(filenameavi,tempload.RmNumR{:})+length(tempload.RmNumR{:}):end-4),'.mat'],'Pos');
                    else
                        Posload=load([filenameavi(1:end-4),'.mat'],'Pos');
                    end
                    AllPos=Posload.Pos;
                    len=max(AllPos(:,1));
                    disp(['       length of video = ',num2str(floor(10*len)/10),'s'])
                    
                    leni=[];
                    for xx=X
                        leni=[leni,tpsfin(xx)-tpsdeb(xx)];
                        disp(['       length of recording file ',num2str(xx),' = ',num2str(floor((tpsfin(xx)-tpsdeb(xx))*10)/10),'s'])
                    end
                    disp(['length of the ',num2str(length(X)),' recordings = ',num2str(floor(10*sum(leni))/10),'s'])
                    
                    if abs(sum(leni)-len)>1
                        
                        if sum(leni)<len-1
                            disp(['Video is ',num2str(floor(10*(len-sum(leni)))/10),'s longer than the ',num2str(length(X)),' recordings.'])
                            delPos=input('-> Enter the time in s to supress on .pos if needed [begin end], else [0 0]: ');
                        elseif sum(leni)>len+1
                            disp(['Video is ',num2str(floor(10*(sum(leni)-len))/10),'s shorter than the ',num2str(length(X)),' recordings.'])
                            disp('-> Consider the .dat and make sure video was not stopped before acquisition.');delPos=[0 0];
                        end
                    else
                        disp(['Video length corresponds well to the ',num2str(length(X)),' recordings.']);delPos=[0 0];
                    end
                    LengthPosCorrection.name=[LengthPosCorrection.name,{filenameavi}];
                    LengthPosCorrection.delPos=[LengthPosCorrection.delPos,{delPos}];
                    LengthPosCorrection.X=[LengthPosCorrection.X,{X}];
                    LengthPosCorrection.leni=[LengthPosCorrection.leni,{leni}];
                    save LengthPosCorrection LengthPosCorrection
                else
                    disp('LengthPosCorrection already defined for this file.')
                    X=LengthPosCorrection.X{strcmp(LengthPosCorrection.name,filenameavi)};
                    delPos=LengthPosCorrection.delPos{strcmp(LengthPosCorrection.name,filenameavi)};
                    leni=LengthPosCorrection.leni{strcmp(LengthPosCorrection.name,filenameavi)};
                end
                
                % ----------------------------------------------
            % ------- Ask new names for each session -------
             
             
                for r=1:length(tempload.NumR)
                    
                    clear nameX; try load(['nameX-',tempload.NumR{r},'.mat']);end
                    disp(['   new names ',tempload.NumR{r},' (check for correction):'])
                    for xx=X
                        try nameX{xx};
                        catch
                            if length(tempload.NumR)>1
                                nameX{xx}=[evt{xx}(strfind(evt{xx},NamePrefix):strfind(evt{xx},tempload.RmNumR{:})-1),tempload.NumR{r},evt{xx}(strfind(evt{xx},tempload.RmNumR{:})+length(tempload.RmNumR{:}):end)];
                            else
                                nameX{xx}=evt{xx}(strfind(evt{xx},NamePrefix):end);
                            end
                        end
                        disp([nameX{xx},'.pos'])
                    end
                    ok=input('names ok (y/n)? ','s');
                    if ok~='y', disp('Enter manually the names of new files (e.g. {''name1'' ''name2'' ''name3}'')');
                        nameX(X)=input(': ');
                    end
                    save(['nameX-',tempload.NumR{r},'.mat'],'nameX')
                    
                    NotDoIt=1;
                    % if only one rec, change name before resizing file
                    
                    for xx=X
                        if ~exist([nameX{xx},'.mat'],'file')
                            NotDoIt=NotDoIt*0;
                        else
                            NotDoIt=NotDoIt*1;
                        end
                    end
                    if length(X)==1, NotDoIt=0;end
                    
                    if NotDoIt
                        disp('all .mat already exist. skipping this step...')
                    else
                        disp('Creating new .pos and .mat files...')
                        % -----------------------------------------------
                        % ------ Resize .pos to match files length -------
                        clear Pos Movtsd
                        if length(tempload.NumR)>1
                            Posload=load([filenameavi(1:strfind(filenameavi,tempload.RmNumR{:})-1),tempload.NumR{r},filenameavi(strfind(filenameavi,tempload.RmNumR{:})+length(tempload.RmNumR{:}):end-4),'.mat']);
                        else
                            Posload=load([filenameavi(1:end-4),'.mat']);
                        end
                        Pos=Posload.Pos;Movtsd=Posload.Movtsd;
                        if exist('Pos','var')
                            AllPos=Pos(Pos(:,1)>=delPos(1) & Pos(:,1)<=Pos(end,1)-delPos(2),:);
                            PosResamp=AllPos(:,1)*sum(leni)/(AllPos(end,1)-AllPos(1,1));
                            AllPos(:,1)=PosResamp;
                        end
                        
                        if exist('Movtsd','var')
                            AllMovtsd=Restrict(Movtsd,intervalSet(delPos(1)*1E4,(Pos(end,1)-delPos(2))*1E4));
                            AllMovtsd=tsd(Range(AllMovtsd)*sum(leni)*1E4/(max(Range(AllMovtsd))-min(Range(AllMovtsd))),Data(AllMovtsd));
                        end
                        clear Pos Movtsd
                        
                        % -----------------------------------------------
                        % ------ create .pos & .mat for each file -------
                        
                        if length(X)==1
                            disp(['Renaming ',nameX{xx},'.mat into ',nameX{xx},'TRACK.mat'])
                            copyfile([nameX{xx},'.mat'],[nameX{xx},'TRACK.mat']);
                            pause(1); delete([nameX{xx},'.mat']);
                        end
                        for xx=X
                            
                            I=intervalSet((tpsdeb(xx)-tpsdeb(X(1)))*1E4,(tpsfin(xx)-tpsdeb(X(1)))*1E4);
                            
                            if exist('AllPos','var')
                                Pos=AllPos(AllPos(:,1)>=Start(I,'s') & AllPos(:,1)<Stop(I,'s'),:);
                                save(nameX{xx},'Pos')%,'ima'
                                
                                file = fopen([nameX{xx},'.pos'],'w');
                                
                                for p = 1:length(Pos),
                                    fprintf(file,'%f\t',Pos(p,2));
                                    fprintf(file,'%f\n',Pos(p,3));
                                end
                                fclose(file);
                            end
                            
                            if exist('AllMovtsd','var')
                                tempMovtsd=Restrict(AllMovtsd,I);
                                Movtsd=tsd(Range(tempMovtsd)-min(Range(tempMovtsd)),Data(tempMovtsd));
                                save(nameX{xx},'-append','Movtsd'),%'Perc'
                            end
                            
                            
                        end
                    end
                    
                end
            end
        end
    end


% -----------------------------------------------------------------
%% PauseTracking
    function PauseTracking(obj,event)
        enableTrack=0; pause(0.005);
        disp('PAUSE - keyboard - Enter ''return'' to continue');
    end

% -----------------------------------------------------------------
%% DisplayTracking
    function DisplayTracking(obj,event)
        plot_images=abs(plot_images-1);
         pause(0.005);
        if plot_images
            set(inputDisplay(2),'string','ON'); disp('Display ON');
        else
            set(inputDisplay(2),'string','OFF'); disp('Display OFF');
        end
    end


% -----------------------------------------------------------------
%% RemoveRef
    function RemoveRef(obj,event)
        BadRef=abs(BadRef-1); pause(0.005);
        if BadRef
            set(inputDisplay(4),'string','ON');
        else
            set(inputDisplay(4),'string','OFF');
        end
    end
% -----------------------------------------------------------------
%% Get_mask
    function Get_mask(filetosave)
        Rtempload=load(filetosave);
        global Mmask
        global Mref
        global ref2
        Mref=single(Rtempload.ref);
        Mmask=single(ones(size(Mref)));
        ref2=Mref;
        color_on = [ 0 0 0];
        
        %% graphical interface n�3
        mask_fig=figure('units','normalized',...
            'position',[0.15 0.1 0.8 0.8],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Setting Parameters',...
            'menubar','none',...
            'tag','figure mask');
        set(mask_fig,'Color',color_on);
        
        uicontrol(mask_fig,'style','text', ...
            'units','normalized',...
            'position',[0.25 0.02 0.06 0.03],...
            'string','click on maze edges');
        
        uicontrol(mask_fig,'style','text', ...
            'units','normalized',...
            'position',[0.70 0.02 0.06 0.03],...
            'string','satisfied?');
        
        maskbutton(1)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.08 0.08 0.05],...
            'string','Circle',...
            'callback', @Option_Circle);
        
        maskbutton(2)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.25 0.08 0.05],...s
            'string','save+close',...
            'callback', @save_mask);
        
        maskbutton(3)=uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.65 0.08 0.05],...
            'string','mask IN',...
            'callback', @Do_maskIN);
        
        maskbutton(4)= uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.75 0.08 0.05],...
            'string','Reset mask',...
            'callback', @Reset_mask);
        
        maskbutton(5)=uicontrol(mask_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.55 0.08 0.05],...
            'string','mask OUT',...
            'callback', @Do_maskOUT);
        
        figure(mask_fig),colormap gray
        subplot(1,2,1), imagesc(Mref),axis image
        Docircle=0; title('rectligne shape','Color','w')
        
        function Do_maskIN(obj,event)
            for var_boucle=1:5
                set(maskbutton(var_boucle),'Enable','off')
            end
            figure(mask_fig), subplot(1,2,1),axis image
            if Docircle
                h = imellipse;
                BW = createMask(h);
            else
                [x1,y1,BW,y2]=roipoly(Mref./max(max(Mref)));
            end
            maskint=uint8(BW);
            maskint=uint8(-(double(maskint)-1));
            try Mmask=uint8(double(Mmask).*double(maskint)); catch,keyboard;end
            
            colormap gray
            ref2((find(Mmask==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc(ref2),axis image
            for var_boucle=1:5
                set(maskbutton(var_boucle),'Enable','on')
            end
        end
        
        function Do_maskOUT(obj,event)
            for var_boucle=1:5
                set(maskbutton(var_boucle),'Enable','off')
            end
            figure(mask_fig), subplot(1,2,1), hold off
            if Docircle
                h = imellipse;
                BW = createMask(h);
            else
                [x1,y1,BW,y2]=roipoly(Mref./max(max(Mref)));
            end
            maskint=uint8(BW);
            Mmask=uint8(double(Mmask).*double(maskint));
            
            colormap gray
            ref2((find(Mmask==0)))=0;
            figure(mask_fig), subplot(1,2,2)
            imagesc(ref2),axis image
            for var_boucle=1:5
                set(maskbutton(var_boucle),'Enable','on')
            end
        end
        
        function Option_Circle(obj,event)
            if Docircle
                Docircle=0;
                subplot(1,2,1), title('rectligne shape','Color','w')
            else
                Docircle=1;
                subplot(1,2,1), title('CIRCLE ACITVATED','Color','w')
            end
            
        end
        
        function Reset_mask(obj,event)
            figure(mask_fig),colormap gray
            subplot(1,2,1), imagesc(Mref),axis image
            Docircle=0; title('rectligne shape','Color','w')
            Mmask=ones(size(ref2,1),size(ref2,2));
            ref2=Mref;
            subplot(122), imagesc(ref2), axis image
        end
        
        function save_mask(obj,event) % keep ref in memory
            MaskInProcessing=0;
            mask=single(Mmask); save(filetosave,'mask','MaskInProcessing','-append');
            disp('mask saved');
            msg_box=msgbox('Mask saved','save','modal');
            waitfor(msg_box);
            delete(mask_fig)
        end
        
    end




end