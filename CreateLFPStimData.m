%CreateLFPStimData


listdir=dir;

for i=1:length(listdir)
    namesession=listdir(i).name;
    le=length(namesession);
    if le>23&namesession(le-2:le)=='dat'
        numManipe=str2num(namesession(23:24));
        if namesession(28)~='-'
         manipe{numManipe}=namesession(26:28);   
        else
        manipe{numManipe}=namesession(26:27);
        end
    end
    
end

save ManipeName manipe

NbManipes=14;

for numSession=1:NbManipes
    
    filenameLFP=['LFPData',num2str(numSession)];
    eval(['load ',filenameLFP]) 

    filename=['behavResources',num2str(numSession)];
    eval(['load ',filename]) 

    filenameStim=['Newstim',num2str(numSession)];
    eval(['load ',filenameStim]) 

    filenameLFPStim=['NewLFPstimResamp',num2str(numSession)];

    for i=1:15
        
        try
        figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(sda*1E4), -10000, +15000,'BinSize',500);close

        tpsSTD{i}=resample(Range(matVal,'s'),1,10);
        MatSTD{i}=resample(Data(matVal),1,10)';
        
        catch
            tpsSTD{i}=[];
            MatSTD{i}=[];
        end
        
        
        try
        figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{i}, ts(MMN*1E4), -10000, +15000,'BinSize',500);close
        tpsMMN{i}=resample(Range(matVal,'s'),1,10);
        MatMMN{i}=resample(Data(matVal),1,10)';
        catch
          tpsMMN{i}=[];
          MatMMN{i}=[];  
        end
        

        eval(['save ',filenameLFPStim,' tpsSTD MatSTD tpsMMN MatMMN']) 
        %save LFPstim tpsSTD MatSTD tpsMMN MatMMN


    end
close all
    
    
end




