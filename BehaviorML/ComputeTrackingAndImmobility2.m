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

% default values for tracking :
shape_ratio=5; % dafault 5
BW_threshold=0.2;
smaller_object_size=11;
plot_images=0;

% anoying problems
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% graphical interface n�1 with all the pushbuttons

Fig_Track=figure('units','normalized','position',[0.1 0.08 0.3 0.6],...
    'numbertitle','off','name','Define Odor Locations','menubar','none','tag','figure Odor');
set(Fig_Track,'Color',color_on);

trackbutton(1)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.1 0.9 0.2 0.05],...
    'string','1- Inputs for Tracking','callback', @InputTracking);

trackbutton(2)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.4 0.9 0.2 0.05],...
    'string','2- Compute References','callback', @ComputeRef);
set(trackbutton(2),'enable','off')

trackbutton(3)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.7 0.9 0.2 0.05],...
    'string','3- Compute Tracking','callback', @ComputeTracking);
set(trackbutton(3),'enable','off')

trackbutton(4)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.07 0.2 0.15 0.04],...
    'string','Display Tracking','callback', @DisplayTracking);
set(trackbutton(4),'enable','off')

trackbutton(5)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.4 0.2 0.15 0.04],...
    'string','Restart Tracking','callback', @ReStartTracking);
set(trackbutton(5),'enable','off')

trackbutton(6)= uicontrol(Fig_Track,'style','pushbutton',...
    'units','normalized','position',[0.7 0.2 0.15 0.04],...
    'string','Pause/Play','callback', @PauseTracking);
set(trackbutton(6),'enable','off')

inputDisplay(1)=uicontrol(Fig_Track,'style','text','units','normalized','position',[0.01 0.82 0.75 0.02],'string','filename = TO DEFINE');
set(inputDisplay(1),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')

inputDisplay(2)=uicontrol(Fig_Track,'style','text','units','normalized','position',[0.09 0.16 0.1 0.03],'string','OFF');
set(inputDisplay(2),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')

inputDisplay(3)=uicontrol(Fig_Track,'style','text','units','normalized','position',[0.3 0.16 0.25 0.03],'string','Time in Video: NaN');
set(inputDisplay(3),'BackgroundColor',color_on,'ForegroundColor','w','FontWeight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLED FUNCTIONS

% -----------------------------------------------------------------
%% select files and inputs
    function InputTracking(obj,event)
        try
            tempload=load('InputsTracking.mat'); tempload.NomRef; tempload.NumR; tempload.RmNumR; tempload.plot_images;
            disp('InputsTracking.mat already defined, skipping this step')
            
        catch
            prompt = {'Use old TrackMouseLight (y for QExplo!!)? (y/n)',...
                'Number of Environment in the experiment',...
                'Number of Animals recorded at the same time'};
            answer = inputdlg(prompt,'Change InputsTracking',1,{'n','1','1'});
            
            if answer{1}=='y',impose_TrackMouseLight=1; else impose_TrackMouseLight=0;end
            
            if answer{2}~='1',
                ExempleRefNames={'Rond','Croix','Carre','Triangle','Rond','Croix','Carre','Triangle'}; clear prompt
                for aa=1:str2num(answer{2}), prompt{aa}=['Reference File Environment ',num2str(aa)];end
                NomRef= inputdlg(prompt,'Name for Reference files',1,ExempleRefNames(1:str2num(answer{2})));
            else NomRef={''};
            end
            
            if answer{3}~='1',
                ExempleRefNames={'Mouse-100','Mouse-101','Mouse-102','Mouse-103'}; 
                prompt={'basename to replace'};
                for aa=1:str2num(answer{3}), prompt{aa+1}=['name mouse ',num2str(aa)];end
                RmNumR=inputdlg(prompt,'Names of mice',1,['Mouse-100-101',ExempleRefNames(1:str2num(answer{3}))]);
                NumR=RmNumR(2:end);RmNumR=RmNumR(1);
            else NumR={''}; RmNumR={''};
            end
            save InputsTracking NomRef NumR RmNumR plot_images impose_TrackMouseLight shape_ratio BW_threshold smaller_object_size
        end
        h = msgbox('InputsTracking Done!','InputsTracking'); pause(1);try close(h);end
        set(trackbutton(2),'enable','on','FontWeight','bold')
    end

% -----------------------------------------------------------------
%% select files and inputs
    function ComputeRef(obj,event)
        tempload=load('InputsTracking.mat'); 
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
                            subplot(1,2,1), imagesc(Rtempload.ref),axis image; title('Ref')
                            subplot(1,2,2), imagesc(Rtempload.ref.*Rtempload.mask),axis image; title('masked Ref')
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
                        end
                        
                        if DoRef==1
                            set(inputDisplay(1),'string',['COMPUTING Ref',num2str(tempload.NomRef{j}),tempload.NumR{r},'. Load Ref Video or cancel to create one.']);
                            RefVideo=uigetfile('*.wmv;*.avi',['Get video Ref',num2str(tempload.NomRef{j}),tempload.NumR{r}]');
                            if RefVideo==0,
                                choice = questdlg('Create video Ref?', 'No existing video Ref' ,'Yes','No','Yes');
                                switch choice
                                    case 'Yes'
                                        artRefVideo=uigetfile('*.wmv;*.avi',['Get video Ref',num2str(tempload.NomRef{j}),tempload.NumR{r}]');
                                        ref=Create_ArtificialRefAvi(res,[tempload.RmNumR,'Ref']);mask=zeros(size(ref));
                                        save(['Ref',num2str(tempload.NomRef{j}),tempload.NumR{rr},'.mat'],'ref','mask')
                                    case 'No'
                                        warndlg('Carreful! No reference computed!!')
                                end
                                
                            end
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
                        subplot(1,2,2), imagesc(Rtempload.ref.*Rtempload.mask),axis image; title('masked Ref')
                        
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
                tempnomfiles=uigetfile('*.wmv;*.avi',['Get video corresponding to Ref',tempload.NomRef{j}],'MultiSelect','on');
                NomFiles{j}=tempnomfiles;
                save InputsTracking -append NomFiles
            end
        end
        set(trackbutton(3),'enable','on','FontWeight','bold')
        set(trackbutton(4),'enable','on','FontWeight','bold')
    end

% -----------------------------------------------------------------
%% ComputeTracking
    function ComputeTracking(obj,event)
        
        tempload=load('InputsTracking.mat'); 
        shape_ratio2=tempload.shape_ratio;
        BW_threshold2=tempload.BW_threshold;
        smaller_object_size2=tempload.smaller_object_size;
        
        for j=1:length(tempload.NomRef)
            
            % load (multiple) ref and mask
            Rtempload=load(['Ref',tempload.NomRef{j},tempload.NumR{1},'.mat']);
            refMouse1=Rtempload.ref; maskMouse1=Rtempload.mask;
            figure(Fig_Track), 
            subplot(221), htrack = imagesc(refMouse1);axis image; colormap gray
            subplot(223), htrackBW = imagesc(refMouse1);axis image; hold on, g = plot(0,0,'+w');
            if length(tempload.NumR)>1
                Rtempload=load(['Ref',tempload.NomRef{j},tempload.NumR{2},'.mat']);
                refMouse2=Rtempload.ref; maskMouse2=Rtempload.mask;
                TwoRef=1;
                subplot(222), htrack2 = imagesc(refMouse2);axis image; 
                subplot(222), htrackBW2 = imagesc(refMouse2);axis image;hold on, g2 = plot(0,0,'+w');
            end
            
            % loop on each video file
            for fi=1:length(tempload.NomFiles{j})
                
                restartVideo=1;
                filenameavi=tempload.NomFiles{j}(fi);
                set(inputDisplay(1),'string',['Tracking ',filenameavi,'...'])
                
                % -------------------
                if ~isempty(strfind(filenameavi,'EIB')),basename='EIB';
                elseif ~isempty(strfind(filenameavi,'wideband')), basename='wideband';
                else basename='';
                end
                
                % --------------------- Load video -----------------------
                OBJ = mmreader(filenameavi);
                numFrames = get(OBJ, 'numberOfFrames');
                fcy=get(OBJ, 'FrameRate');
                disp(['number of frames=',num2str(numFrames)])
                disp(['frames per second=',num2str(fcy)])
                try
                    if length(numFrames)==0
                        lastFrame = read(OBJ, inf);
                        numFrames = get(OBJ, 'numberOfFrames');
                    end
                end
                % ---------------------------------------------------------
               
               fr=1;t1=0;
               while fr<numFrames 
                   if restartVideo, fr=1;t1=0;restartVideo=0;end
                   set(inputDisplay(3),'string',['Time in Video: ',num2str(fr),'/',num2str(numFrames)])
                   t1=t1+1/fcy;
                   
                   %get image
                   vidFrames = read(OBJ,fr);
                   Mov=vidFrames(:,:,3,1);
                   IM=Mov; IM=single(IM);
                   
                    
                   %Soustrait l'image de r�f�rence & use mask to clear image
                   subimage = abs(refMouse1-IM);
                   subimage(find(maskMouse1==0))=0;
                   % Convert the resulting grayscale image into a binary image.
                   diff_im = im2bw(subimage,BW_threshold2);
                   % Remove all the objects less large than smaller_object_size
                   diff_im = bwareaopen(diff_im,smaller_object_size2);
                   if plot_images 
                       set(htrack,'Cdata',subimage);
                       set(htrackBW,'Cdata',diff_im);
                   end
                   % Label all the connected components in the image.
                   bw = bwlabel(diff_im, 8);
                   stats = regionprops( bw, 'Centroid','MajorAxisLength','MinorAxisLength');
                   centroids = cat(1, stats.Centroid);
                   maj = cat(1, stats.MajorAxisLength); mini = cat(1, stats.MinorAxisLength);
                   rap=maj./mini;
                   centroids=centroids(rap<shape_ratio2,:);
                   
                   %set(htrack2,'Cdata',diff_im);
                   if size(centroids) == [1 2]
                       if plot_images, set(g,'Xdata',centroids(1),'YData',centroids(2));end
                       PosMat(fr,1)=Timeframe;
                       PosMat(fr,2)=centroids(1);
                       PosMat(fr,3)=centroids(2);
                   else
                       if plot_images, set(g,'Xdata',0,'YData',0);end
                       PosMat(fr,:)=[Timeframe;NaN;NaN];
                   end
                   
                   if TwoRef
                       % Same processing
                       subimage2 = abs(refMouse2-IM);
                       subimage2(find(maskMouse2==0))=0;
                       diff_im2 = im2bw(subimage2,BW_threshold2);
                       diff_im2 = bwareaopen(diff_im2,smaller_object_size2);
                       if plot_images
                           set(htrack2,'Cdata',subimage2);
                           set(htrackBW2,'Cdata',diff_im2);
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
                           PosMat2(fr,1)=Timeframe;
                           PosMat2(fr,2)=centroids2(1);
                           PosMat2(fr,3)=centroids2(2);
                       else
                           if plot_images, set(g2,'Xdata',0,'YData',0);end
                           PosMat2(fr,:)=[Timeframe;NaN;NaN];
                       end
                       
                   else
                       if plot_images, set(htrack2,'Cdata',IM);end
                   end
                   
               end
               
            end
        end
        
        
    end

% -----------------------------------------------------------------
%% ReStartTracking
    function ReStartTracking(obj,event)
        pause(0.001)
        enableTrack=0;
        restartVideo=1;
    end

% -----------------------------------------------------------------
%% ReStartTracking
    function PauseTracking(obj,event)
        pause(0.001)
        enableTrack=abs(enableTrack-1);
    end

% -----------------------------------------------------------------
%% DisplayTracking
    function DisplayTracking(obj,event)
        plot_images=abs(plot_images-1);
        if plot_images
            set(inputDisplay(2),'string','ON');
        else
            set(inputDisplay(2),'string','OFF');
        end
    end



% -----------------------------------------------------------------
%% Get_mask
    function Get_mask(filetosave)
        Rtempload=load(filetosave);
        global Mmask
        global Mref
        global ref2
        Mref=Rtempload.ref;
        Mmask=ones(size(Mref));
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
            'position',[0.25 0.85 0.08 0.05],...
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
            figure(mask_fig), subplot(1,2,1)
            if Docircle
                h = imellipse;
                BW = createMask(h);
            else
                [x1,y1,BW,y2]=roipoly(Mref);
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
                [x1,y1,BW,y2]=roipoly(Mref);
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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        


% 
%        
% %% Compute tracking and immobility
% 
% for j=1:length(NomRef)
%     
%     for r=1:length(NumR)
%         %keyboard
%         load(['Ref',num2str(NomRef{j}),NumR{r},'.mat']);
%         if length(NumR)>1, disp(' '); disp(['            * * *    Tracking ',NomRef{j},' ',NumR{r},'    * * *']);end
%         
%         filenameList=NomFile(1,NomFile(2,:)==j);
%         
%         for i=1:length(filenameList)
%             filename=lis(filenameList(i)).name;
%             if strcmp(filename(end-5:end-4),'-1') || strcmp(filename(end-5:end-4),'-2')
%                 suffixe=6;
%             else suffixe=4;
%             end
%             if length(NumR)>1, NewName=[filename(1:strfind(filename,RmNumR{:})-1),NumR{r},filename(strfind(filename,RmNumR{:})+length(RmNumR{:}):end-suffixe)];end
%             
%             disp(' ');
%             disp(filename);
%             
%             
%             % --------------------------------------------
%             % ---------- TRACKING and IMMOBILITY ----------
%             
%             disp(['   into ',filename(1:end-suffixe),'.mat'])
% %             
% %             try
%                 if length(NumR)>1 && erasepreviousfiles==0 && exist([NewName,'.mat'],'file')==2 && exist([NewName,'.pos'],'file')==2
%                     disp(['   ',NewName,'.pos already exists - aborting']);
%                     load([NewName,'.mat'])
%                 elseif exist([filename(1:end-suffixe),'.pos'],'file')==2 && erasepreviousfiles==0 && exist([filename(1:end-suffixe),'.mat'],'file')==2
%                     disp(['   ',filename(1:end-suffixe),'.pos already exists - aborting']);
%                     load([filename(1:end-suffixe),'.mat'])
%                 else
%                     if impose_TrackMouseLight
%                         warning off
%                         [Pos,PosTh,Vit,ima,Fs]=TrackMouseLight(filename,5,ref,mask,siz,1,plot_images);
%                         warning on
%                         Movtsd=tsd([],[]);
%                     else
%                         [Pos,PosTh,Vit,Movtsd,Fs]=Tracking_Immobility_ML(filename,plot_images,['Ref',num2str(NomRef{j}),NumR{r},'.mat'],5);
%                     end
%                 end
%                 
%                 % ------- Correction ------
%                 if correc>0 && exist([NewName,'.mat'],'file')==0
%                     disp('   Correcting .pos and Movtsdaccording to CorrectionPos.mat');
%                     
%                     % tracking
%                     Pos(Pos(:,1)<CorrectionPos.deb(correc) | Pos(:,1)>CorrectionPos.fin(correc) ,:)=[];
%                     Vit(Pos(2:end,1)<CorrectionPos.deb(correc) | Pos(2:end,1)>CorrectionPos.fin(correc) ,:)=[];
%                     PosTh(PosTh(:,1)<CorrectionPos.deb(correc) | PosTh(:,1)>CorrectionPos.fin(correc) ,:)=[];
%                     
%                     file = fopen([filename(1:end-suffixe),'.pos'],'w');
%                     for pp = 1:length(Pos)
%                         fprintf(file,'%f\t',Pos(pp,2));
%                         fprintf(file,'%f\t',Pos(pp,3));
%                         fprintf(file,'%f\n',Pos(pp,4));
%                     end
%                     
%                     % immmob
%                     MovRestrict=intervalSet(CorrectionPos.deb(correc)*1E4,CorrectionPos.fin(correc)*1E4);
%                     Movtsd=Restrict(Movtsd,MovRestrict);
%                     save([filename(1:end-suffixe),'.mat'],'Pos','PosTh','Vit','Movtsd','-append')
%                 end
%                 
%                 if length(NumR)>1 && exist([filename(1:end-suffixe),'.mat'],'file')==2 && exist([filename(1:end-suffixe),'.pos'],'file')==2
%                     disp(['renaming file into ',NewName,'.mat'])
%                     movefile([filename(1:end-suffixe),'.mat'],[NewName,'.mat']);
%                     movefile([filename(1:end-suffixe),'.pos'],[NewName,'.pos']);
%                 end
% %             catch
% %                 disp('   Problem...')
% %                 keyboard
% %             end
%         end
%         
%     end
% end
% 
% toc;
%      
% 
% %% Multiple recording video
% disp(' ')
% ok='n';
% %ok=input('Do the video files include several Data recordings (multichannel system)? (y/n) : ','s');
% NamePrefix=filenameRef{1}(1:4);
% if ok=='y'
%    
%     % ----------------------------------------------
%     % ------- Get recording files length -----------
%     disp('Set current session (select basename.xml)');
%     SetCurrentSession
%     SetCurrentSession('same')
%     
%     evt=GetEvents('output','Descriptions');
%     if strcmp(evt{1},'0'), evt=evt(2:end);end
%     tpsdeb=[]; tpsfin=[];
%     for i=1:length(evt)
%         tpsEvt{i}=GetEvents(evt{i});
%         if evt{i}(1)=='b'
%             tpsdeb=[tpsdeb,tpsEvt{i}];
%         elseif evt{i}(1)=='e'
%             tpsfin=[tpsfin,tpsEvt{i}];
%         end
%     end
%     %evt=evt(2:end);
%     cd(res);
%     try load('LengthPosCorrection.mat'); catch, LengthPosCorrection.name=[]; LengthPosCorrection.X=[]; LengthPosCorrection.delPos=[]; LengthPosCorrection.leni=[];end
%     for i=3:length(lis)
%         
%         if (isempty(strfind(lis(i).name,'.avi'))==0 || isempty(strfind(lis(i).name,'.wmv'))==0) && isempty(strfind(lis(i).name,'Ref'))
%             %if isempty(strfind(lis(i).name,'.pos'))==0 && (exist([OldName,'.wmv'],'file')==2 || exist([OldName,'.avi'],'file')==2 || exist([OldName,'-1.wmv'],'file')==2 || exist([OldName,'-1.avi'],'file')==2)
%             
%             disp(' ')
%             disp(['... ',lis(i).name]);
%             
%             if (exist('LengthPosCorrection.mat','file')==2 && sum(strcmp(LengthPosCorrection.name,lis(i).name))==0) || exist('LengthPosCorrection.mat','file')==0
%                 
%                 X=input('Enter the numbers of the recording sessions included in the video (e.g [1 2 3]): ');
%                 for j=X
%                     disp(['file',num2str(j),'= ',evt{j}(strfind(evt{j},NamePrefix):end),'.dat'])
%                 end
%                 if strcmp(lis(i).name(end-5:end-4),'-1') || strcmp(lis(i).name(end-5:end-4),'-2'), suffixe=6; else suffixe=4; end
%                 
%                 if length(NumR)>1 
%                     load([lis(i).name(1:strfind(lis(i).name,RmNumR{:})-1),NumR{1},lis(i).name(strfind(lis(i).name,RmNumR{:})+length(RmNumR{:}):end-suffixe),'.mat'],'Pos')
%                 else
%                     load([lis(i).name(1:end-suffixe),'.mat'],'Pos')
%                 end
%                         
%                 
%                 AllPos=Pos;
%                 len=max(AllPos(:,1));
%                 disp(['       length of video = ',num2str(floor(10*len)/10),'s'])
%                 
%                 % ----------------------------------------------
%                 % ------- Check files length concordance -------
%                 leni=[];
%                 for j=X
%                     leni=[leni,tpsfin(j)-tpsdeb(j)];
%                     disp(['       length of recording file ',num2str(j),' = ',num2str(floor((tpsfin(j)-tpsdeb(j))*10)/10),'s'])
%                 end
%                 disp(['length of the ',num2str(length(X)),' recordings = ',num2str(floor(10*sum(leni))/10),'s'])
%                 
%                 
%                 if abs(sum(leni)-len)>1
%                     
%                     if sum(leni)<len-1
%                         disp(['Video is ',num2str(floor(10*(len-sum(leni)))/10),'s longer than the ',num2str(length(X)),' recordings.'])
%                         delPos=input('-> Enter the time in s to supress on .pos if needed [begin end], else [0 0]: ');
%                     elseif sum(leni)>len+1
%                         disp(['Video is ',num2str(floor(10*(sum(leni)-len))/10),'s shorter than the ',num2str(length(X)),' recordings.'])
%                         disp('-> Consider the .dat and make sure video was not stopped before acquisition.');delPos=[0 0];
%                     end
%                 else
%                     disp(['Video length corresponds well to the ',num2str(length(X)),' recordings.']);delPos=[0 0];
%                 end
%                 
%                 LengthPosCorrection.name=[LengthPosCorrection.name,{lis(i).name}];
%                 LengthPosCorrection.delPos=[LengthPosCorrection.delPos,{delPos}];
%                 LengthPosCorrection.X=[LengthPosCorrection.X,{X}];
%                 LengthPosCorrection.leni=[LengthPosCorrection.leni,{leni}];
%                 save LengthPosCorrection LengthPosCorrection
%             else
%                 disp('LengthPosCorrection already defined for this file.')
%                 X=LengthPosCorrection.X{strcmp(LengthPosCorrection.name,lis(i).name)};
%                 delPos=LengthPosCorrection.delPos{strcmp(LengthPosCorrection.name,lis(i).name)};
%                 leni=LengthPosCorrection.leni{strcmp(LengthPosCorrection.name,lis(i).name)};
%             end
%             
%             % ----------------------------------------------
%             % ------- Ask new names for each session -------
%              
%              
%                 for r=1:length(NumR)
%                     
%                     clear nameX; try load(['nameX-',NumR{r},'.mat']);end
%                     disp(['   new names ',NumR{r},' (check for correction):'])
%                     for j=X
%                         try nameX{j};
%                         catch
%                             if length(NumR)>1
%                                 nameX{j}=[evt{j}(strfind(evt{j},NamePrefix):strfind(evt{j},RmNumR{:})-1),NumR{r},evt{j}(strfind(evt{j},RmNumR{:})+length(RmNumR{:}):end)];
%                             else
%                                 nameX{j}=evt{j}(strfind(evt{j},NamePrefix):end);
%                             end
%                         end
%                         disp([nameX{j},'.pos'])
%                     end
%                     ok=input('names ok (y/n)? ','s');
%                     if ok~='y', disp('Enter manually the names of new files (e.g. {''name1'' ''name2'' ''name3}'')');
%                         nameX(X)=input(': ');
%                     end
%                     save(['nameX-',NumR{r},'.mat'],'nameX')
%                     
%                     NotDoIt=1;
%                     for j=X
%                         if exist([nameX{j},'.mat'],'file')==0 ||  (exist([nameX{j},'.mat'],'file')==2 && erasepreviousfiles==1)
%                             NotDoIt=NotDoIt*0;
%                         else
%                             NotDoIt=NotDoIt*1;
%                         end
%                     end
%                     
%                     if NotDoIt
%                         disp('all .mat already exist. skipping this step...')
%                     else
%                         disp('Creating new .pos and .mat files...')
%                         % -----------------------------------------------
%                         % ------ Resize .pos to match files length -------
%                         clear Pos Movtsd
%                         if length(NumR)>1
%                             load([lis(i).name(1:strfind(lis(i).name,RmNumR{:})-1),NumR{r},lis(i).name(strfind(lis(i).name,RmNumR{:})+length(RmNumR{:}):end-suffixe),'.mat'])
%                         else
%                             load([lis(i).name(1:end-suffixe),'.mat'])
%                         end
%                         
%                         if exist('Pos','var')
%                             AllPos=Pos(Pos(:,1)>=delPos(1) & Pos(:,1)<=Pos(end,1)-delPos(2),:);
%                             AllVit=Vit(Pos(1:end-1,1)>=delPos(1) & Pos(1:end-1,1)<=Pos(end,1)-delPos(2));
%                             PosResamp=AllPos(:,1)*sum(leni)/(AllPos(end,1)-AllPos(1,1));
%                             AllPos(:,1)=PosResamp;
%                             
%                             AllPosTh=PosTh(PosTh(:,1)>=delPos(1) & PosTh(:,1)<=PosTh(end,1)-delPos(2),:);
%                             PosResamp=AllPosTh(:,1)*sum(leni)/(AllPosTh(end,1)-AllPosTh(1,1));
%                             AllPosTh(:,1)=PosResamp;
%                         end
%                         
%                         if exist('Movtsd','var')
%                             AllMovtsd=Restrict(Movtsd,intervalSet(delPos(1)*1E4,(Pos(end,1)-delPos(2))*1E4));
%                             AllMovtsd=tsd(Range(AllMovtsd)*sum(leni)*1E4/(max(Range(AllMovtsd))-min(Range(AllMovtsd))),Data(AllMovtsd));
%                             
%                             AllFreeze=and(Freeze,intervalSet(delPos(1)*1E4,(Pos(end,1)-delPos(2))*1E4));
%                             AllFreeze2=and(Freeze2,intervalSet(delPos(1)*1E4,(Pos(end,1)-delPos(2))*1E4));
%                         end
%                         clear Pos Vit PosTh Movtsd Freeze Freeze2
%                         
%                         % -----------------------------------------------
%                         % ------ create .pos & .mat for each file -------
%                         for j=X
%                             
%                             I=intervalSet((tpsdeb(j)-tpsdeb(X(1)))*1E4,(tpsfin(j)-tpsdeb(X(1)))*1E4);
%                             
%                             if exist('AllPos','var')
%                                 Pos=AllPos(AllPos(:,1)>=Start(I,'s') & AllPos(:,1)<Stop(I,'s'),:);
%                                 Vit=AllVit(AllPos(1:end-1,1)>=Start(I,'s') & AllPos(1:end-1,1)<Stop(I,'s'),:);
%                                 PosTh=AllPosTh(AllPosTh(:,1)>=Start(I,'s') & AllPosTh(:,1)<Stop(I,'s'),:);
%                                 save(nameX{j},'Pos','PosTh','Vit','Fs','LowTh','HighTh')%,'ima'
%                                 
%                                 file = fopen([nameX{j},'.pos'],'w');
%                                 
%                                 for p = 1:length(Pos),
%                                     fprintf(file,'%f\t',Pos(p,2));
%                                     fprintf(file,'%f\t',Pos(p,3));
%                                     fprintf(file,'%f\n',Pos(p,4));
%                                 end
%                                 fclose(file);
%                             end
%                             
%                             if exist('AllMovtsd','var')
%                                 tempMovtsd=Restrict(AllMovtsd,I);
%                                 Movtsd=tsd(Range(tempMovtsd)-min(Range(tempMovtsd)),Data(tempMovtsd));
%                                 Freeze=and(AllFreeze,I);
%                                 Freeze2=and(AllFreeze2,I);
%                                 save(nameX{j},'Movtsd','Freeze','Freeze2'),%'Perc'
%                             end
%                             
%                             
%                         end
%                     end
%                     
%                 end
%         end
%     end
% end
% 
% %% Display 
% 
% lis=dir;
% for i=3:length(lis)
%      if length(lis(i).name)>length(basename)+3 && strcmp(lis(i).name(end-length(basename)-3:end),[basename,'.mat'])
%         load(lis(i).name);
%         figure, try subplot(2,1,1), plot(Pos(:,2),Pos(:,3),'k');
%          hold on, plot(PosTh(:,2),PosTh(:,3),'b'); end
%         hold on, title([lis(i).name(1:end-4),' TRACKING'])
%         subplot(2,1,2),try plot(Range(Movtsd,'s'),Data(Movtsd));end %xlim([min(Range(Movtsd,'s')) max(Range(Movtsd,'s'))]);ylim([0 10]);
%         hold on, title([lis(i).name(1:end-4),' IMMOBILITY'])
%      end
% end  
% 
% %% Next step
% disp('   ')
% disp('------------------------------')
% disp(['... Now run makeDataBulbe in the folder ',res(max(strfind(res,'/'))+1:end-length(basename)-1),': '])
% disp('To do so, enter the following statements:')
% disp(['                cd(''',res(1:end-length(basename)-1),''')']);
% disp('                clear')
% disp('                makeDataBulbe')
% toc




end