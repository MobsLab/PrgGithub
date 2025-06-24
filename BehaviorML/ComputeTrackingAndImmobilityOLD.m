% ComputeTrackingAndImmobilityOLD
tic;

%% initialization
disp(' ');
try 
    load('InputsTracking.mat'); NomRef; NumR; RmNumR; plot_images;
    disp('InputsTracking.mat already defined, skipping this step')
catch
    impose_TrackMouseLight=input('       Use old TrackMouseLight (y for QExplo!!)? y/n: ','s');
    if impose_TrackMouseLight=='y',impose_TrackMouseLight=1; else impose_TrackMouseLight=0;end
    plot_images=input('       display image of tracking and immobility (y/n)? : ','s');
    if plot_images=='y', plot_images=1;else plot_images=0;end
    
    % ------------
    NomRef=input('Are there several environments in the experiment (y/n)? : ','s');
    if NomRef=='y', NomRef=input('       Enter names of the different reference files (e.g.{''Rond'',''Croix''}) : ');
    else NomRef={''};
    end
    
    NumR=input('Are there two animals recorded at the same time on the video (y/n)? ','s');
    if NumR=='y',
        NumR=input('       Give the two names (e.g. {''Mouse-60'',''Mouse-61''}): ');
        RmNumR=input('       Give the basename to replace (e.g. {''Mouse-60-61''}): ');
    else NumR={''}; RmNumR={''};
    end
    save InputsTracking NomRef NumR RmNumR plot_images impose_TrackMouseLight
end
NomFile=[]; 
erasepreviousfiles=0;
res=pwd;

%% Compute Image Ref

lis=dir;
for i=3:length(lis)
    filenameAvi=lis(i).name;
      
    if length(filenameAvi)>4 && (strcmp(filenameAvi(end-3:end),'.avi') || strcmp(filenameAvi(end-3:end),'.wmv'))
        for j=1:length(NomRef)
            
            if  isempty(strfind(filenameAvi, NomRef{j}))==0 || isempty(NomRef{j})
                
                if isempty(strfind(filenameAvi, 'Ref'))==0;
                    filenameRef{j}=filenameAvi;
                    for r=1:length(NumR)
                        try
                            load(['Ref',num2str(NomRef{j}),NumR{r},'.mat']);
                            ref; mask; siz; FreqVideoRec;
                        catch
                            disp(' ')
                            disp(['ComputingImageRef ',NumR{r},'...'])
                            disp(filenameAvi)
                            DoCircle=input('Is the exploring area a circle (y/n)? ','s');
                            if strcmp(DoCircle,'y'), DoCircle=1; else DoCircle=0;end
                            [ref,mask,siz,FreqVideoRec]=ComputeImageRef(filenameAvi,DoCircle);ref_im=ref;
                            save(['Ref',num2str(NomRef{j}),NumR{r},'.mat'],'ref','mask','siz','ref_im','FreqVideoRec');
                        end
                    end
                    
                else
                    NomFile=[ NomFile, [i;j]];
                end
            end
        end
    end
end

try filenameRef; catch, filenameRef={''};end

%% create Ref video if not defined

for j=1:length(NomRef)
    for r=1:length(NumR)

        try
            load(['Ref',num2str(NomRef{j}),NumR{r},'.mat']);
            ref; mask; siz;
        catch
            
            disp(' ')
            disp('No Reference File: Tracking and Immobility are without any RefImage Substraction.')
            ArtificialRefAvi=input('Create artificial Ref.avi file (y/n) ? ','s');
            if ArtificialRefAvi=='y'
                
                FreqVideoRef=Create_ArtificialRefAvi(res,[lis(NomFile(1,1)).name(1:findstr(lis(NomFile(1,1)).name,'Mouse')+17),'Ref']);
%                 ok='n'; clear nom OBJ numFrames lengthavi FreqVideoRef vidFrames
%                 while ok~='y'
%                     try nom; OBJ;numFrames;lengthavi;FreqVideoRef;
%                     catch
%                         disp('Give name of the file to use to create artificial ref video')
%                         disp(['(Example ',lis(NomFile(1,1)).name,')'])
%                         nom=input(': ','s');
%                         OBJ = mmreader(nom);
%                         numFrames = get(OBJ, 'numberOfFrames');
%                         try
%                         if length(numFrames)==0
%                             lastFrame = read(OBJ, inf);
%                             numFrames = get(OBJ, 'numberOfFrames');
%                         end
%                         end
%                         
%                         lengthavi=input(['Enter length in second of ',nom,': ']);
%                         FreqVideoRef=round(numFrames/lengthavi);
%                     end
%                     for rr=1:length(NumR)
%                         disp(' ')
%                         okk='n';
%                         while okk~='y'
%                             a=input(['Give time in second of the two ',NumR{rr},' ref images (e.g. [1 200]): ']);
%                             prop=input('Give proportion of images to concatenate (default=1/2): ');
%                             vidFrames2 = read(OBJ,a(1)*FreqVideoRef);
%                             vidFrames3 = read(OBJ,a(2)*FreqVideoRef);
%                             [le1,le2,le3]=size(vidFrames2);
%                             Temp{1}=[vidFrames3(:,1:floor(le2*prop),:),vidFrames2(:,floor(le2*prop)+1:le2,:)];% horizontal catenation
%                             Temp{2}=[vidFrames2(:,1:floor(le2*prop),:),vidFrames3(:,floor(le2*prop)+1:le2,:)];
%                             Temp{3}=[vidFrames3(1:floor(le1*prop),:,:);vidFrames2(floor(le1*prop)+1:le1,:,:)];% vertical catenation
%                             Temp{4}=[vidFrames2(1:floor(le1*prop),:,:);vidFrames3(floor(le1*prop)+1:le1,:,:)];
%                             for i=1:4, subplot(2,2,i), imshow(Temp{i}); title(['ref image ',num2str(i)]); end
%                             i=input('Which is the good ref image? (give 1 if none) ');
%                             
%                             if length(NumR)==2 && exist('vidFrames','var')==1
%                                 vidFrames1=Temp{i}; clear Temp; subplot(1,1,1), imshow(vidFrames1), title(['Chosen Ref image ',NumR{rr}]);
%                             else
%                                 vidFrames=Temp{i}; clear Temp; subplot(1,1,1), imshow(vidFrames), title(['Chosen Ref image ',NumR{rr}]);
%                             end
%                             okk=input(['Are you satisfied with the ',NumR{rr},' image ref (y/n)? '],'s');
%                         end
%                     end
%                     if exist('vidFrames1','var')==1  
%                         vidFrames2 =vidFrames;
%                         vidFrames3 =vidFrames1;
%                         [le1,le2,le3]=size(vidFrames2);
%                         Temp{1}=[vidFrames3(:,1:floor(le2/2),:),vidFrames2(:,floor(le2/2)+1:le2,:)];% horizontal catenation
%                         Temp{2}=[vidFrames2(:,1:floor(le2/2),:),vidFrames3(:,floor(le2/2)+1:le2,:)];
%                         Temp{3}=[vidFrames3(1:floor(le1/2),:,:);vidFrames2(floor(le1/2)+1:le1,:,:)];% vertical catenation
%                         Temp{4}=[vidFrames2(1:floor(le1/2),:,:);vidFrames3(floor(le1/2)+1:le1,:,:)];
%                         for i=1:4, subplot(2,2,i), imshow(Temp{i}); title(['ref image ',num2str(i)]); end
%                         i=input('Which is the good ref image? ');
%                         vidFrames=Temp{i}; clear Temp; subplot(1,1,1), imshow(vidFrames), title('Chosen Ref image ');
%                     end
%                     
%                     if length(NumR)==2, ok=input('Are you satisfied with the image ref (y/n)? ','s'); else ok='y';end
%                     close;
%                 end
%                 try
%                     nom=[nom(1:findstr(nom,'Mouse')+17),'Ref'];
%                     aviobj=avifile(nom);
%                     aviobj = addframe(aviobj,vidFrames);
%                     aviobj=close(aviobj);
%                     disp(['        ->  ',nom,'.avi has been created.'])
%                 catch
%                     disp(['        Problem creating ',nom,'.avi !!'])
%                 end
%                 filenameRef{j}=[nom,'.avi'];
                
                filenameRef{j}=[lis(NomFile(1,1)).name(1:findstr(lis(NomFile(1,1)).name,'Mouse')+17),'Ref.avi'];
                for rr=1:length(NumR)
                    disp(' ')
                    disp(['ComputingImageRef ',NumR{rr},'... '])
                    DoCircle=input('Is the exploring area a circle (y/n)? ','s');
                    disp(['     give FreqVideo=',num2str(FreqVideoRef)])
                    disp('     and frames of the videoFile =[1 1 1]')
                    [ref,mask,siz,FreqVideoRec]=ComputeImageRef(filenameRef{j},DoCircle);ref_im=ref;
                    save(['Ref',num2str(NomRef{j}),NumR{rr},'.mat'],'ref','mask','siz','ref_im','FreqVideoRec');
                end
                
            elseif ArtificialRefAvi=='n'
                OBJ = mmreader(lis(NomFile(1,1)).name);
                vidFrames1 = read(OBJ,1);
                Mo1=vidFrames1(:,:,3,1);
                Mo1=single(Mo1);
                ref=zeros(size(Mo1,1),size(Mo1,2));ref_im=ref;
                mask=ones(size(Mo1,1),size(Mo1,2));
                siz='l';
                save Ref ref mask siz ref_im
                clear OBJ vidFrames1 Mo1
            end
        end
    end
end


if isempty(strfind(lis(NomFile(1,1)).name,'EIB'))==0
    basename='EIB';
elseif isempty(strfind(lis(NomFile(1,1)).name,'wideband'))==0
    basename='wideband';
else
    basename='';
end


%% Compute tracking and immobility

if exist('CorrectionPos.mat','file')==2
    load('CorrectionPos.mat')
    Correction=1;
else
    Correction=0;
end

for j=1:length(NomRef)
    
    for r=1:length(NumR)
        %keyboard
        load(['Ref',num2str(NomRef{j}),NumR{r},'.mat']);
        if length(NumR)>1, disp(' '); disp(['            * * *    Tracking ',NomRef{j},' ',NumR{r},'    * * *']);end
        filenameList=NomFile(1,NomFile(2,:)==j);
        
        for i=1:length(filenameList)
            filename=lis(filenameList(i)).name;
            if strcmp(filename(end-5:end-4),'-1') || strcmp(filename(end-5:end-4),'-2')
                suffixe=6;
            else suffixe=4;
            end
            if length(NumR)>1, NewName=[filename(1:strfind(filename,RmNumR{:})-1),NumR{r},filename(strfind(filename,RmNumR{:})+length(RmNumR{:}):end-suffixe)];end
            
            disp(' ');
            disp(filename);
            
            
            % ------------------------------
            % --- File length correction ---
            correc=0;
            if Correction
                for cc=1:length(CorrectionPos.name)
                    if strcmp(CorrectionPos.name{cc},filename)
                        correc=cc;
                        
                    end
                end
            end
            
            % --------------------------------------------
            % ---------- TRACKING and IMMOBILITY ----------
            
            disp(['   into ',filename(1:end-suffixe),'.mat'])
%             
%             try
                if length(NumR)>1 && erasepreviousfiles==0 && exist([NewName,'.mat'],'file')==2 && exist([NewName,'.pos'],'file')==2
                    disp(['   ',NewName,'.pos already exists - aborting']);
                    load([NewName,'.mat'])
                elseif exist([filename(1:end-suffixe),'.pos'],'file')==2 && erasepreviousfiles==0 && exist([filename(1:end-suffixe),'.mat'],'file')==2
                    disp(['   ',filename(1:end-suffixe),'.pos already exists - aborting']);
                    load([filename(1:end-suffixe),'.mat'])
                else
                    if impose_TrackMouseLight
                        warning off
                        [Pos,PosTh,Vit,ima,Fs]=TrackMouseLight(filename,5,ref,mask,siz,1,plot_images);
                        warning on
                        Movtsd=tsd([],[]);
                    else
                        [Pos,PosTh,Vit,Movtsd,Fs]=Tracking_Immobility_ML(filename,plot_images,['Ref',num2str(NomRef{j}),NumR{r},'.mat'],5);
                    end
                end
                
                % ------- Correction ------
                if correc>0 && exist([NewName,'.mat'],'file')==0
                    disp('   Correcting .pos and Movtsdaccording to CorrectionPos.mat');
                    
                    % tracking
                    Pos(Pos(:,1)<CorrectionPos.deb(correc) | Pos(:,1)>CorrectionPos.fin(correc) ,:)=[];
                    Vit(Pos(2:end,1)<CorrectionPos.deb(correc) | Pos(2:end,1)>CorrectionPos.fin(correc) ,:)=[];
                    PosTh(PosTh(:,1)<CorrectionPos.deb(correc) | PosTh(:,1)>CorrectionPos.fin(correc) ,:)=[];
                    
                    file = fopen([filename(1:end-suffixe),'.pos'],'w');
                    for pp = 1:length(Pos)
                        fprintf(file,'%f\t',Pos(pp,2));
                        fprintf(file,'%f\t',Pos(pp,3));
                        fprintf(file,'%f\n',Pos(pp,4));
                    end
                    
                    % immmob
                    MovRestrict=intervalSet(CorrectionPos.deb(correc)*1E4,CorrectionPos.fin(correc)*1E4);
                    Movtsd=Restrict(Movtsd,MovRestrict);
                    save([filename(1:end-suffixe),'.mat'],'Pos','PosTh','Vit','Movtsd','-append')
                end
                
                if length(NumR)>1 && exist([filename(1:end-suffixe),'.mat'],'file')==2 && exist([filename(1:end-suffixe),'.pos'],'file')==2
                    disp(['renaming file into ',NewName,'.mat'])
                    movefile([filename(1:end-suffixe),'.mat'],[NewName,'.mat']);
                    movefile([filename(1:end-suffixe),'.pos'],[NewName,'.pos']);
                end
%             catch
%                 disp('   Problem...')
%                 keyboard
%             end
        end
        
    end
end

toc;
     

%% Multiple recording video
disp(' ')
ok='n';
%ok=input('Do the video files include several Data recordings (multichannel system)? (y/n) : ','s');
NamePrefix=filenameRef{1}(1:4);
if ok=='y'
   
    % ----------------------------------------------
    % ------- Get recording files length -----------
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
    cd(res);
    try load('LengthPosCorrection.mat'); catch, LengthPosCorrection.name=[]; LengthPosCorrection.X=[]; LengthPosCorrection.delPos=[]; LengthPosCorrection.leni=[];end
    for i=3:length(lis)
        
        if (isempty(strfind(lis(i).name,'.avi'))==0 || isempty(strfind(lis(i).name,'.wmv'))==0) && isempty(strfind(lis(i).name,'Ref'))
            %if isempty(strfind(lis(i).name,'.pos'))==0 && (exist([OldName,'.wmv'],'file')==2 || exist([OldName,'.avi'],'file')==2 || exist([OldName,'-1.wmv'],'file')==2 || exist([OldName,'-1.avi'],'file')==2)
            
            disp(' ')
            disp(['... ',lis(i).name]);
            
            if (exist('LengthPosCorrection.mat','file')==2 && sum(strcmp(LengthPosCorrection.name,lis(i).name))==0) || exist('LengthPosCorrection.mat','file')==0
                
                X=input('Enter the numbers of the recording sessions included in the video (e.g [1 2 3]): ');
                for j=X
                    disp(['file',num2str(j),'= ',evt{j}(strfind(evt{j},NamePrefix):end),'.dat'])
                end
                if strcmp(lis(i).name(end-5:end-4),'-1') || strcmp(lis(i).name(end-5:end-4),'-2'), suffixe=6; else suffixe=4; end
                
                if length(NumR)>1 
                    load([lis(i).name(1:strfind(lis(i).name,RmNumR{:})-1),NumR{1},lis(i).name(strfind(lis(i).name,RmNumR{:})+length(RmNumR{:}):end-suffixe),'.mat'],'Pos')
                else
                    load([lis(i).name(1:end-suffixe),'.mat'],'Pos')
                end
                        
                
                AllPos=Pos;
                len=max(AllPos(:,1));
                disp(['       length of video = ',num2str(floor(10*len)/10),'s'])
                
                % ----------------------------------------------
                % ------- Check files length concordance -------
                leni=[];
                for j=X
                    leni=[leni,tpsfin(j)-tpsdeb(j)];
                    disp(['       length of recording file ',num2str(j),' = ',num2str(floor((tpsfin(j)-tpsdeb(j))*10)/10),'s'])
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
                
                LengthPosCorrection.name=[LengthPosCorrection.name,{lis(i).name}];
                LengthPosCorrection.delPos=[LengthPosCorrection.delPos,{delPos}];
                LengthPosCorrection.X=[LengthPosCorrection.X,{X}];
                LengthPosCorrection.leni=[LengthPosCorrection.leni,{leni}];
                save LengthPosCorrection LengthPosCorrection
            else
                disp('LengthPosCorrection already defined for this file.')
                X=LengthPosCorrection.X{strcmp(LengthPosCorrection.name,lis(i).name)};
                delPos=LengthPosCorrection.delPos{strcmp(LengthPosCorrection.name,lis(i).name)};
                leni=LengthPosCorrection.leni{strcmp(LengthPosCorrection.name,lis(i).name)};
            end
            
            % ----------------------------------------------
            % ------- Ask new names for each session -------
             
             
                for r=1:length(NumR)
                    
                    clear nameX; try load(['nameX-',NumR{r},'.mat']);end
                    disp(['   new names ',NumR{r},' (check for correction):'])
                    for j=X
                        try nameX{j};
                        catch
                            if length(NumR)>1
                                nameX{j}=[evt{j}(strfind(evt{j},NamePrefix):strfind(evt{j},RmNumR{:})-1),NumR{r},evt{j}(strfind(evt{j},RmNumR{:})+length(RmNumR{:}):end)];
                            else
                                nameX{j}=evt{j}(strfind(evt{j},NamePrefix):end);
                            end
                        end
                        disp([nameX{j},'.pos'])
                    end
                    ok=input('names ok (y/n)? ','s');
                    if ok~='y', disp('Enter manually the names of new files (e.g. {''name1'' ''name2'' ''name3}'')');
                        nameX(X)=input(': ');
                    end
                    save(['nameX-',NumR{r},'.mat'],'nameX')
                    
                    NotDoIt=1;
                    for j=X
                        if exist([nameX{j},'.mat'],'file')==0 ||  (exist([nameX{j},'.mat'],'file')==2 && erasepreviousfiles==1)
                            NotDoIt=NotDoIt*0;
                        else
                            NotDoIt=NotDoIt*1;
                        end
                    end
                    
                    if NotDoIt
                        disp('all .mat already exist. skipping this step...')
                    else
                        disp('Creating new .pos and .mat files...')
                        % -----------------------------------------------
                        % ------ Resize .pos to match files length -------
                        clear Pos Movtsd
                        if length(NumR)>1
                            load([lis(i).name(1:strfind(lis(i).name,RmNumR{:})-1),NumR{r},lis(i).name(strfind(lis(i).name,RmNumR{:})+length(RmNumR{:}):end-suffixe),'.mat'])
                        else
                            load([lis(i).name(1:end-suffixe),'.mat'])
                        end
                        
                        if exist('Pos','var')
                            AllPos=Pos(Pos(:,1)>=delPos(1) & Pos(:,1)<=Pos(end,1)-delPos(2),:);
                            AllVit=Vit(Pos(1:end-1,1)>=delPos(1) & Pos(1:end-1,1)<=Pos(end,1)-delPos(2));
                            PosResamp=AllPos(:,1)*sum(leni)/(AllPos(end,1)-AllPos(1,1));
                            AllPos(:,1)=PosResamp;
                            
                            AllPosTh=PosTh(PosTh(:,1)>=delPos(1) & PosTh(:,1)<=PosTh(end,1)-delPos(2),:);
                            PosResamp=AllPosTh(:,1)*sum(leni)/(AllPosTh(end,1)-AllPosTh(1,1));
                            AllPosTh(:,1)=PosResamp;
                        end
                        
                        if exist('Movtsd','var')
                            AllMovtsd=Restrict(Movtsd,intervalSet(delPos(1)*1E4,(Pos(end,1)-delPos(2))*1E4));
                            AllMovtsd=tsd(Range(AllMovtsd)*sum(leni)*1E4/(max(Range(AllMovtsd))-min(Range(AllMovtsd))),Data(AllMovtsd));
                            
                            AllFreeze=and(Freeze,intervalSet(delPos(1)*1E4,(Pos(end,1)-delPos(2))*1E4));
                            AllFreeze2=and(Freeze2,intervalSet(delPos(1)*1E4,(Pos(end,1)-delPos(2))*1E4));
                        end
                        clear Pos Vit PosTh Movtsd Freeze Freeze2
                        
                        % -----------------------------------------------
                        % ------ create .pos & .mat for each file -------
                        for j=X
                            
                            I=intervalSet((tpsdeb(j)-tpsdeb(X(1)))*1E4,(tpsfin(j)-tpsdeb(X(1)))*1E4);
                            
                            if exist('AllPos','var')
                                Pos=AllPos(AllPos(:,1)>=Start(I,'s') & AllPos(:,1)<Stop(I,'s'),:);
                                Vit=AllVit(AllPos(1:end-1,1)>=Start(I,'s') & AllPos(1:end-1,1)<Stop(I,'s'),:);
                                PosTh=AllPosTh(AllPosTh(:,1)>=Start(I,'s') & AllPosTh(:,1)<Stop(I,'s'),:);
                                save(nameX{j},'Pos','PosTh','Vit','Fs','LowTh','HighTh')%,'ima'
                                
                                file = fopen([nameX{j},'.pos'],'w');
                                
                                for p = 1:length(Pos),
                                    fprintf(file,'%f\t',Pos(p,2));
                                    fprintf(file,'%f\t',Pos(p,3));
                                    fprintf(file,'%f\n',Pos(p,4));
                                end
                                fclose(file);
                            end
                            
                            if exist('AllMovtsd','var')
                                tempMovtsd=Restrict(AllMovtsd,I);
                                Movtsd=tsd(Range(tempMovtsd)-min(Range(tempMovtsd)),Data(tempMovtsd));
                                Freeze=and(AllFreeze,I);
                                Freeze2=and(AllFreeze2,I);
                                save(nameX{j},'Movtsd','Freeze','Freeze2'),%'Perc'
                            end
                            
                            
                        end
                    end
                    
                end
        end
    end
end

%% Display 

lis=dir;
for i=3:length(lis)
     if length(lis(i).name)>length(basename)+3 && strcmp(lis(i).name(end-length(basename)-3:end),[basename,'.mat'])
        load(lis(i).name);
        figure, try subplot(2,1,1), plot(Pos(:,2),Pos(:,3),'k');
         hold on, plot(PosTh(:,2),PosTh(:,3),'b'); end
        hold on, title([lis(i).name(1:end-4),' TRACKING'])
        subplot(2,1,2),try plot(Range(Movtsd,'s'),Data(Movtsd));end %xlim([min(Range(Movtsd,'s')) max(Range(Movtsd,'s'))]);ylim([0 10]);
        hold on, title([lis(i).name(1:end-4),' IMMOBILITY'])
     end
end  

%% Next step
disp('   ')
disp('------------------------------')
disp(['... Now run makeDataBulbe in the folder ',res(max(strfind(res,'/'))+1:end-length(basename)-1),': '])
disp('To do so, enter the following statements:')
disp(['                cd(''',res(1:end-length(basename)-1),''')']);
disp('                clear')
disp('                makeDataBulbe')
toc
  