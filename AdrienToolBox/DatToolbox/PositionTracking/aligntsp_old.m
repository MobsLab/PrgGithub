function aligntsp(file)
% get timestamps and positions from tsp file
tspdata=load([file '.tsp']);


%get start and end timestamp of dat file
fid=fopen([file '.meta']);
tline= fgetl(fid);
while ischar(tline)
    try
    if strcmp(tline(1:20),'TimeStamp of the end')
        tline=tline(59:end);
        EndTimestamp=sscanf(tline,'%d',1);
    end
    catch end
    try
    if strcmp(tline(1:22),'TimeStamp of the start')
        tline=tline(61:end);
        StartTimestamp=sscanf(tline,'%d',1);
    end
    catch
    end
    try
    if strcmp(tline(1:9),'Number of')
        tline=tline(31:end);
        ChanNum=sscanf(tline,'%d',1);
    end
    catch end
    try
    if strcmp(tline(1:9),'File size')
        tline=tline(21:end);
        DatSize=sscanf(tline,'%lu',1);
    end
    catch end
    
    tline= fgetl(fid);
end
fclose(fid);
    
%Calculate file length from dat file sample rat
DatLength=DatSize/(ChanNum*2*20); %Dat file size in ms
TspLength=EndTimestamp-StartTimestamp;
LEDchannels=size(tspdata,2)-1;

if (LEDchannels>0)
    
    %interpolate to 1 kHz
    interpTsp1kHz(:,1)=tspdata(1,1):tspdata(end,1);
    for j=1:LEDchannels
        interpTsp1kHz(:,j+1)=floor(interp1(tspdata(:,1),tspdata(:,j+1),interpTsp1kHz(:,1)));
    end

    for j=1:LEDchannels/2   
        minusones=find(tspdata(:,j*2)==-1),1;
        ranges(:,1)= minusones(find((minusones>1) & (minusones < size(tspdata,1))))-1;
        ranges(:,2)= minusones(find((minusones>1) & (minusones < size(tspdata,1))))+1;
        for k=1:size(ranges,1)
                interpTsp1kHz(tspdata(ranges(k,1),1)-tspdata(1,1):tspdata(ranges(k,2),1)-tspdata(1,1),j*2)=-1;
                interpTsp1kHz(tspdata(ranges(k,1),1)-tspdata(1,1):tspdata(ranges(k,2),1)-tspdata(1,1),j*2+1)=-1;
        end
    end

    %align the beginning
    if (StartTimestamp<tspdata(1,1)) 
        i=1:tspdata(1,1)-StartTimestamp;
        tspnew(i,1)=StartTimestamp+i-1;
        tspnew(i,2:LEDchannels+1)=-1;
        tspnew=[tspnew; interpTsp1kHz];
    else
        tspnew=interpTsp1kHz(StartTimestamp-tspdata(1,1)+1:end,:);
    end
    clear i

    %adjust the end
    if (TspLength<size(tspnew,1)) 
        tspnew=tspnew(1:TspLength,:);
    else
        
        for i=1:TspLength-size(tspnew,1);
        tspnew=[tspnew; [tspnew(end,1)+1 repmat(-1,1,LEDchannels)]];
        end
    end
    clear i

    clear interpTsp1kHz

    
    interpTsp(:,1)=tspnew(1,1):size(tspnew,1)/DatLength:tspnew(end,1);
    interpTsp(:,2:7)=-1;
    for j=1:LEDchannels
        interpTsp(:,j+1)=floor(interp1(tspnew(:,1),tspnew(:,j+1),interpTsp(:,1),'nearest'));
    end

    %get rid of those segments where LED is not visible
    
    %find -1's
%     rangetodelete=50; %
%     for j=1:LEDchannels/2   
%         minusones=find(interpTsp(:,j*2)==-1 );
%         for k=1:size(minusones)
%             if ((minusones(k)>rangetodelete) && (minusones(k)<size(interpTsp,1)-rangetodelete))
%                 interpTsp(minusones(k)-rangetodelete:minusones(k)+rangetodelete,j*2)=-1;
%                 interpTsp(minusones(k)-rangetodelete:minusones(k)+rangetodelete,j*2+1)=-1;
%             end
%         end
%     end
    if (0)
        fid=fopen([file '.whl1k'],'w');
        for i=1:size(interpTsp,1)
            fprintf (fid,'%i %i %i %i %i %i\n',interpTsp(i,2:end));
        end
        fclose(fid);
    end
    disp(['Samples in .dat file per channel: ' int2str(DatLength)]);
    disp(['Lines in .whl1k file:' int2str(size(interpTsp,1))]);


    %resample to 39.0625 Hz
    for j=1:LEDchannels
        whldatatemp(:,j)=floor(resample(interpTsp(:,j+1),390625,10000000,0));
    end
    whldata=zeros(size(whldatatemp,1),6)-1;
    whldata(:,1:size(whldatatemp,2))=whldatatemp;
    
    %save it
    fid=fopen([file '.whl'],'w');
    for i=1:size(whldata,1)
        fprintf (fid,'%i %i %i %i %i %i\n',whldata(i,:));
    end

    fclose(fid);
else
    disp('No LED position data in the tsp file!');
end
end
