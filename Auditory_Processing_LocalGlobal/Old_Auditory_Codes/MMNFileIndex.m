%% Importation of recording data (LFP-Spike-Tracking-Event)
load behavResources
load LFPData
load SpikeData

%% Import of the differents Stimulations Files
newData1 = importdata('File1-Bloc-AAAAA-BBBBA-BBBBB-AAAAB.txt');
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end
File1=data; 
clear data; clear colheaders; clear i; clear newData1; clear vars; clear textdata;
%
newData2 = importdata('File2-Bloc-AAAAB-BBBBB-AAAAA-BBBBA.txt');
File2=newData2; clear newData2;
%
newData3 = importdata('File3-Bloc-BBBBB-BBBBA-AAAAB-AAAAA.txt');
File3=newData3; clear newData3;


%% -------------------- Index for MegaBlock Starts ------------------------
% ----------------------------- File(a,3) ---------------------------------

% -------- MegaBlock AAAAA: value 1 
% -------- MegaBlock AAAAB: value 2 
% -------- MegaBlock BBBBB: value 3 
% -------- MegaBlock BBBBA: value 4 

% File 1 : MegaBlock order => AAAAA - BBBBA - BBBBB - AAAAB 
File1(1,3)=1;
File1(701,3)=4;
File1(1401,3)=2;
File1(2101,3)=3;

% File 2 : MegaBlock order => AAAAB - BBBBB - AAAAA - BBBBA 
File2(1)=[];
File2(1,3)=2;
File2(701,3)=3;
File2(1401,3)=1;
File2(2101,3)=4;

% File 3 : MegaBlock order => BBBBB - BBBBA - AAAAB - AAAAA 
File3(1)=[];
File3(1,3)=3;
File3(701,3)=4;
File3(1401,3)=2;
File3(2101,3)=1;



%% ------- Index for all Block Start, regarding of the last tone ----------
% ---------------------------- File(a,2) ----------------------------------

% -------- Block AAAAA: value 1 -> (local standard)
% -------- Block AAAAB: value 2 -> (local deviant)
% --------  Block AAAA: value 3 -> (local omission)
% -------- Block BBBBB: value 4 -> (local standard)
% -------- Block BBBBA: value 5 -> (local deviant)
% --------  Block BBBB: value 6 -> (local omission)


% Index of all block start AAAAA and BBBBB with value 1 or 4
a=1;
while a<=length(File1);
    if File1(a,1)==File1(a+4,1)
        if File1(a,1)==1;
         File1(a,2)=1;
        else File1(a,2)=4;
        end
    end
    a=a+5;
end
a=1;
while a<=length(File2);
    if File2(a,1)==File2(a+4,1)
        if File2(a,1)==1;
         File2(a,2)=1;
        else File2(a,2)=4;
        end
    end
    a=a+5;
end 
a=1;
while a<=length(File3);
    if File3(a,1)==File3(a+4,1)
        if File3(a,1)==1;
         File3(a,2)=1;
        else File3(a,2)=4;
        end
    end
    a=a+5;
end

% Index of all block start AAAAB and BBBBA with value 2 or 5
a=1;
while a<=length(File1);
    if File1(a,1)~=File1(a+4,1)
        if File1(a+4,1)==0;
            File1(a,2)=2;
        elseif File1(a+4,1)==1;
            File1(a,2)=5;
        end
    end
    a=a+5;
end
a=1;
while a<=length(File2);
    if File2(a,1)~=File2(a+4,1)
        if File2(a+4,1)==0;
            File2(a,2)=2;
        elseif File2(a+4,1)==1;
            File2(a,2)=5;
        end
    end
    a=a+5;
end
a=1;
while a<=length(File3);
    if File3(a,1)~=File3(a+4,1)
        if File3(a+4,1)==0;
            File3(a,2)=2;
        elseif File3(a+4,1)==1;
            File3(a,2)=5;
        end
    end
    a=a+5;
end
% Index of all block start AAAA and BBBB with value 3 or 6
a=1;
while a<=length(File1);
    if File1(a+4,1)==2
        if File1(a,1)==1;
            File1(a,2)=3;
        elseif File1(a,1)==0;
            File1(a,2)=6;
        end
    end
    a=a+5;
end
a=1;
while a<=length(File2);
    if File2(a+4,1)==2
        if File2(a,1)==1;
            File2(a,2)=3;
        elseif File2(a,1)==0;
            File2(a,2)=6;
        end
    end
    a=a+5;
end
a=1;
while a<=length(File3);
    if File3(a+4,1)==2
        if File3(a,1)==1;
            File3(a,2)=3;
        elseif File3(a,1)==0;
            File3(a,2)=6;
        end
    end
    a=a+5;
end


%% Suppression of the ommission value on Stimulations Files
a=1;
while a<=length(File1);
    if File1(a,1)==2;  
        File1(a,)=[];
    end
    a=a+1;
end
a=1;
while a<=length(File2);
    if File2(a,1)==2;  
        File2(a,)=[];
    end
    a=a+1;
end
a=1;
while a<=length(File3);
    if File3(a,1)==2;  
        File3(a,)=[];
    end
    a=a+1;
end

%% Indexation of the stimulations (st) and determination of the InterBlock interval (default value=3500)
st=Range(stim);
disp(['nombre de stimulations :   ', num2str(length(st))])

idx=find(diff(st)>3500);
debBlock=st([1;idx+1]);                 % determine les debuts de blocks
IdxdebBlock=[1;idx+1];                  % index les debuts de block
disp(['nombre total de blocks :   ', num2str(  length(IdxdebBlock))])


%% ------------------------ sons A vs B  ----------------------------
SonAF1=st(find(File1==1));
IdxSonAF1=find(File1==1);                 % index les sons A
SonBF1=st(find(File1==0));
IdxSonBF1=find(File1==0);                 % index les sons B

SonAF2=st(find(File2==1));
IdxSonAF2=find(File2==1);                 % index les sons A
SonBF2=st(find(File2==0));
IdxSonBF2=find(File2==0);                 % index les sons B

SonAF3=st(find(File3==1));
IdxSonAF3=find(File3==1);                 % index les sons A
SonBF3=st(find(File3==0));
IdxSonBF3=find(File3==0);                 % index les sons B

