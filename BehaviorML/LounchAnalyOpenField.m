% Lounch AnalyOpenField


%% INPUTS
%be in /media/DataMOBs16/ProjetBULB

erasePreviousA=0; % 0 to keep existing files, 1 otherwise
OrderLabel={'CTRL','VARIANT','FIXED'};
MatName = {'numMouse' 'nPhase' 'Tctrl' 'Tvari' 'Tfixa'};
%% INITIALISATION
res=pwd;
lis=dir(res);
scrsz = get(0,'ScreenSize');

if isempty(strfind(res,'/')),mark='\'; else mark='/';end


%% SCREEN FOR UNDONE OFFLINE TRACKING
if 1
MATData=[];
for i=3:length(lis)
    
    if length(lis(i).name)>4 && strcmp(lis(i).name(1:5),'Mouse')
        % number of the mouse
        nameMouse=lis(i).name(7:end);
        k=1; numMouse=[]; 
        while isempty(numMouse), 
            try 
                numMouse=str2num(nameMouse(k:end)); 
                k=k+1;
            end
        end
        
        disp(' ')
        disp(['           * * * Mouse ',nameMouse,' * * *'])
        listi=dir([res,mark,lis(i).name]);
        
        for j=3:length(listi)
            
            if strcmp(listi(j).name,'OdorRecognition')
                listiji=dir([res,mark,lis(i).name,mark,listi(j).name]);
                
                for k=3:length(listiji)
                    if ~isempty(strfind(listiji(k).name,'MOO'))
                        disp(listiji(k).name)
                        filename=[res,mark,lis(i).name,mark,listi(j).name,mark,listiji(k).name];
                        
%                         % -------------------------------------------------
%                         % If not done, run AnalyzeOdorRecognition
%                         clear MatOdor Distance
%                         DoAnalysis=1;
%                         try
%                             load([filename,mark,'OdorAnalysis.mat'],'MatOdor','Distance')
%                             MatOdor; Distance;
%                             DoAnalysis=0;
%                         end
%                         
%                         if DoAnalysis || erasePreviousA
%                             [Distance,MatOdor]=AnalyzeOdorRecognition(filename);
%                         end


                        disp('  -> done')
                        % -------------------------------------------------
                        
                        
                        % Analyze time within Odor Zone
                        nPhase = str2num(filename(strfind(filename,'Phase')+5));
                        Tctrl = sum(MatOdor(MatOdor(:,1)==1,2));
                        Tvari = sum(MatOdor(MatOdor(:,1)==2,2));
                        Tfixa = sum(MatOdor(MatOdor(:,1)==3,2));
                        
                        % MatName = {numMouse nPhase Tctrl Tvari Tfixa}
                        MATData=[MATData; [numMouse nPhase Tctrl Tvari Tfixa] ];
                    end
                end
                
            end
        end
    end
end
end

%% AUTRE

if 1
    namegroups={'WT','dKO'};
    MATDist=[];
    MATPerc=[];
    for i=3:length(lis)
        
        if length(lis(i).name)>15 && strcmp(lis(i).name(1:15),'BULB-dKOvsCTRLN')
            
            disp(['Analyzing ',lis(i).name,'...'])
            temp=load([lis(i).name,mark,'AnalyzeOpenField-A.mat']);
            
            try 
                group=temp.group; 
            catch
                group=input('Give strain of the Mouse (WT or dKO): ','s');
                save([lis(i).name,mark,'AnalyzeOpenField-A.mat'],'-append','group')
            end
            ngroup=strcmp(group,namegroups);
            
            
            MATDist=[MATDist; [ngroup, temp.Distance]];
            MATPerc=[MATPerc; [ngroup, temp.PercTime]];
        end
    end
    
    
end

%% DISPLAY

%figure('Color',[1 1 1],'Position',scrsz/2)


