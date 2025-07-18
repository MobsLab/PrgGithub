%ComputeTrackingMarie new

erasepreviousfiles=0;
entete=23;%23 ICSS Sleep

lis=dir;
%NomRef={'Rond','Croix','Arena','Sleep'};
NomRef={''};

NomFile=[];  


for i=3:length(lis)
    filenameAvi=lis(i).name;
      
    if strcmp(filenameAvi(end-2:end),'avi')
        for j=1:length(NomRef)
            
            if  isempty(strfind(filenameAvi(entete:end-4), NomRef{j}))==0;
                if isempty(strfind(filenameAvi(entete:end-4), 'Ref'))==0;
                    
                    try
                        load(['Ref',num2str(NomRef{j})]);
                        ref; mask; siz;
                    catch
                        [ref,mask,siz]=ComputeImageRef(filenameAvi);
                        eval(['save Ref',num2str(NomRef{j}),' ref mask siz']);
                    end
                else
                    NomFile=[ NomFile, [i;j]];
                end
            end
        end
    end
end

for j=1:length(NomRef)
    try
    load(['Ref',num2str(NomRef{j})]);
    end
    filenameList=NomFile(NomFile(:,2)==j,1);
    for i=1:filenameList
        filename=filenameList(i);
        try
            if erasepreviousfiles
                [Pos,PosTh,Vit,ima,Fs]=TrackMouseLight(filename(1:end-4),5,ref,mask,siz);
            else
                if exist([filename(1:end-4),'.pos'])
                    error('File already exists. Aborting.')
                else
                    [Pos,PosTh,Vit,ima,Fs]=TrackMouseLight(filename(1:end-4),5,ref,mask,siz);
                end
            end
            
        catch
            disp('problem')
            disp(filename(1:end-4))
        end
    end
end

close all; clear all;
lis=dir;

for i=3:length(lis)
    filenameMat=lis(i).name;
      if length(filenameMat)>11
    if filenameMat(end-11:end)=='wideband.mat'
        load(filenameMat);
        figure, plot(Pos(:,2),Pos(:,3),'k');
        hold on, plot(PosTh(:,2),PosTh(:,3),'b');
        hold on, title(filenameMat(1:end-4))
    end
      end
end
        

    
    



% %ComputeTrackingMarie
% 
% lis=dir;
% %NomRef={'Rond','Croix','Arena','Sleep'};
% NomRef={''};NomFile=[];
% % for j=1:length(NomRef)
% %     eval(['NomFile',num2str(NomRef{j}),'= []']);
% % end
% 
% erasepreviousfiles=0;
% entete=23;%23 ICSS Sleep
% 
% 
% for i=3:length(lis)
%     filenameAvi=lis(i).name;
%       
%     if filenameAvi(end-2:end)=='avi'
%         
%         for j=1:length(NomRef)
%             
%             if  length(char(regexp(filenameAvi(entete:end-4), NomRef{j}, 'match')))==length(NomRef{j})
%                                 
%                 if length(char(regexp(filenameAvi(entete:end-4), 'Ref', 'match')))==3
%                     try
%                         load(['Ref',num2str(NomRef{j})]);
%                         ref; mask; siz;
%                     catch
%                         [ref,mask,siz]=ComputeImageRef(filenameAvi);
%                         eval(['save Ref',num2str(NomRef{j}),' ref mask siz']);
%                     end
%                 else
%                     eval(['NomFile',num2str(NomRef{j}),'= [NomFile',num2str(NomRef{j}),',i]']);
%                 end
%             end
%         end
%     end
% end
% 
% for j=1:length(NomRef)
%     eval(['NomFile= NomFile',num2str(NomRef{j})]);
%     try
%     load(['Ref',num2str(NomRef{j})]);
%     end
%     for i=1:length(NomFile)
%         filename=lis(NomFile(i)).name;
%         try
%             if erasepreviousfiles
%                 [Pos,PosTh,Vit,ima,Fs]=TrackMouseLight(filename(1:end-4),5,ref,mask,siz);
%             else
%                 if exist([filename(1:end-4),'.pos'])
%                     error('File already exists. Aborting.')
%                 else
%                     [Pos,PosTh,Vit,ima,Fs]=TrackMouseLight(filename(1:end-4),5,ref,mask,siz);
%                 end
%             end
%             
%         catch
%             disp('problem')
%             disp(filename(1:end-4))
%         end
%     end
% end
% 
% close all; clear all;
% lis=dir;
% 
% for i=3:length(lis)
%     filenameMat=lis(i).name;
%       if length(filenameMat)>11
%     if filenameMat(end-11:end)=='wideband.mat'
%         load(filenameMat);
%         figure, plot(Pos(:,2),Pos(:,3),'k');
%         hold on, plot(PosTh(:,2),PosTh(:,3),'b');
%         hold on, title(filenameMat(1:end-4))
%     end
%       end
% end
%         
% 
%     
    
    
