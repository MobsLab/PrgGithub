% MMNfilegenesis
%
% Protocol number 1 => start = 1
% Protocol number 2 => start = 9217
% Protocol number 3 => start = 18433
%
% This code use the differents .txt files, containing all informations 
% about the differents sound sequencies. It generate Tone variable,
% containing the time of each tone Block (AAAAA,AAAAB,BBBBB,BBBBA,...) and
% all the time of the tone correseponding to an omission, or a local/global
% standard/deviant

function [st]=MMNABABfilegenesis(protocole, start)

load behavResources
safe=0;

%% Import of the differents Stimulations Files
        newData1 = importdata('/media/DISK_1/Dropbox/GaetanPhD/Protocole LocalGlobal:MMN/Protocole ABABA/File1-Bloc-ABABA-BABAB-ABABB-BABAA.txt');%/media/DISK_1/
        File1=newData1; clear newData1;        
        File1(1)=[];

        newData2 = importdata('/media/DISK_1/Dropbox/GaetanPhD/Protocole LocalGlobal:MMN/Protocole ABABA/File2-Bloc-BABAB-BABAA-ABABA-ABABB.txt');
        File2=newData2; clear newData2;

        newData3 = importdata('/media/DISK_1/Dropbox/GaetanPhD/Protocole LocalGlobal:MMN/Protocole ABABA/File3-Bloc-BABAA-ABABA-ABABB-BABAB.txt');
        File3=newData3; clear newData3;

    %% Indexation of the stimulations (st) and determination of the InterBlock interval (default value=3500)
        st=Range(stim);
        % st(12449)=[];
        disp(['nombre de stimulations :   ', num2str(length(st))])
        stimVec=Range(stim);
        % stimVec(12449)=[];
        disp(['nombre de stimulations :   ', num2str(length(st))])

%% -------------------- Index for MegaBlock starts ------------------------
% ----------------------------- File(a,3) ---------------------------------
% -------- MegaBlock ABABA: value 1 
% -------- MegaBlock ABABB: value 2 
% -------- MegaBlock BABAB: value 3 
% -------- MegaBlock BABAA: value 4 

% File 1 : MegaBlock order => ABABA - BABAB - ABABB - BABAA 
        File1(1,3)=1;
        File1(701,3)=3;
        File1(1401,3)=2;
        File1(2101,3)=4;
        File1(1:length(File1),4)=0;
% File 2 : MegaBlock order => BABAB - BABAA - ABABA - ABABB 
        File2(1)=[];
        File2(1,3)=3;
        File2(701,3)=4;
        File2(1401,3)=1;
        File2(2101,3)=2;
        File2(3:length(File2),4)=0;
% File 3 : MegaBlock order => BABAA - ABABA - ABABB - BABAB 
        File3(1)=[];
        File3(1,3)=4;
        File3(701,3)=1;
        File3(1401,3)=2;
        File3(2101,3)=3;
        File3(1:length(File3),4)=0;

%% ------- Index for all Block start, regarding of the last tone ----------
% ---------------------------- File(a,2) ----------------------------------

% -------- Block ABABA: value 1 -> (local standard)
% -------- Block ABABB: value 2 -> (local deviant)
% --------  Block AAAA: value 3 -> (local omission)
% -------- Block BABAB: value 4 -> (local standard)
% -------- Block BABAA: value 5 -> (local deviant)
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
        File1(a,:)=[];
    end
    a=a+1;
end
a=1;
while a<=length(File2);
    if File2(a,1)==2;  
        File2(a,:)=[];
    end
    a=a+1;
end
a=1;
while a<=length(File3);
    if File3(a,1)==2;  
        File3(a,:)=[];
    end
    a=a+1;
end

%%          Preparation of the differents MegaBlock matrices (fixed)

%---------------------------- 4 MegaBlocks --------------------------------
    MegaBlockAAAAA=ones(688*3,4);
    MegaBlockAAAAA(1:688,4)=1;             % indice des sons du File 1
    MegaBlockAAAAA(689:1376,4)=2;          % indice des sons du File 2
    MegaBlockAAAAA(1377:2064,4)=3;         % indice des sons du File 3

    MegaBlockAAAAB=ones(688*3,4);
    MegaBlockAAAAB(1:688,4)=1;             % indice des sons du File 1
    MegaBlockAAAAB(689:1376,4)=2;          % indice des sons du File 2
    MegaBlockAAAAB(1377:2064,4)=3;         % indice des sons du File 3

    MegaBlockBBBBB=ones(688*3,4);
    MegaBlockBBBBB(1:688,4)=1;             % indice des sons du File 1
    MegaBlockBBBBB(689:1376,4)=2;          % indice des sons du File 2
    MegaBlockBBBBB(1377:2064,4)=3;         % indice des sons du File 3

    MegaBlockBBBBA=ones(688*3,4);
    MegaBlockBBBBA(1:688,4)=1;             % indice des sons du File 1
    MegaBlockBBBBA(689:1376,4)=2;          % indice des sons du File 2
    MegaBlockBBBBA(1377:2064,4)=3;         % indice des sons du File 3

    ToneMegaBlockAAAAA=ones(688*3,1);
    ToneMegaBlockAAAAB=ones(688*3,1);
    ToneMegaBlockBBBBB=ones(688*3,1);
    ToneMegaBlockBBBBA=ones(688*3,1);

%%          Preparation of the differents Omissions matrices (moveable)

%---------------------------- 4 Omissions --------------------------------
    OmiAAAA=st((start+length(File1)):(start+length(File1)+479),1);
    for i=1:4:(length(OmiAAAA)-4);
        Omiaaaa(i)=OmiAAAA(i);
    end
    Omiaaaa=Omiaaaa';
    for i=1:length(Omiaaaa);
        try
            if Omiaaaa(i)==0;
                Omiaaaa(i)=[];
            end
        end
    end
        for i=1:length(Omiaaaa);
        try
            if Omiaaaa(i)==0;
                Omiaaaa(i)=[];
            end
        end
    end
    OmiBBBB=st(start+length(File1)+length(OmiAAAA)+length(File2):(start+length(File1)+length(OmiAAAA)+length(File2)+479),1);
for i=1:4:(length(OmiBBBB)-4);
        Omibbbb(i)=OmiBBBB(i);
end
    Omibbbb=Omibbbb';
for i=1:length(Omibbbb);
    try
        if Omibbbb(i)==0;
             Omibbbb(i)=[];
        end
    end
end
for i=1:length(Omibbbb);
    try
        if Omibbbb(i)==0;
             Omibbbb(i)=[];
        end
    end
end
    
%%     Repartition of the tone in the differents MegaBlock, based on MBs index :FileX(-,3)
% -------------------------- MegaBlock 1 : AAAAA --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,3)==1
        startMegaBlockAAAAAFile1=a;
        EndMegaBlockAAAAAFile1=startMegaBlockAAAAAFile1+687;
        disp(['    ----->  debut du MegaBlock AAAAA du File1 au rang n°', num2str(startMegaBlockAAAAAFile1)])
        disp(['    ----->  fin du MegaBlock AAAAA du File1 au rang n°', num2str(EndMegaBlockAAAAAFile1)])
        MegaBlockAAAAA(1:688,1:3)=File1((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockAAAAA(1:688,1)=st(startMegaBlockAAAAAFile1:EndMegaBlockAAAAAFile1,1);
    end
    if File2((a+1)-start,3)==1
        startMegaBlockAAAAAFile2=a+length(OmiAAAA)+length(File1);
        EndMegaBlockAAAAAFile2=startMegaBlockAAAAAFile2+687;
        disp(['    ----->  debut du MegaBlock AAAAA du File2 au rang n°', num2str(startMegaBlockAAAAAFile2)])
        disp(['    ----->  fin du MegaBlock AAAAA du File2 au rang n°', num2str(EndMegaBlockAAAAAFile2)])
        MegaBlockAAAAA(689:1376,1:3)=File2((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockAAAAA(689:1376,1)=st(startMegaBlockAAAAAFile2:EndMegaBlockAAAAAFile2,1);
    end
    if File3((a+1)-start,3)==1
        startMegaBlockAAAAAFile3=a+length(OmiBBBB)+length(File2)+length(OmiAAAA)+length(File1);
        EndMegaBlockAAAAAFile3=startMegaBlockAAAAAFile3+687;
        disp(['    ----->  debut du MegaBlock AAAAA du File3 au rang n°', num2str(startMegaBlockAAAAAFile3)])
        disp(['    ----->  fin du MegaBlock AAAAA du File3 au rang n°', num2str(EndMegaBlockAAAAAFile3)])
        MegaBlockAAAAA(1377:2064,1:3)=File3((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockAAAAA(1377:2064,1)=st(startMegaBlockAAAAAFile3:EndMegaBlockAAAAAFile3,1);
    end
end
% -------------------------- MegaBlock 2 : AAAAB --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,3)==2
        startMegaBlockAAAABFile1=a;
        EndMegaBlockAAAABFile1=startMegaBlockAAAABFile1+687;
        disp(['    ----->  debut du MegaBlock AAAAB du File1 au rang n°', num2str(startMegaBlockAAAABFile1)])
        disp(['    ----->  fin du MegaBlock AAAAB du File1 au rang n°', num2str(EndMegaBlockAAAABFile1)])
        MegaBlockAAAAB(1:688,1:3)=File1((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockAAAAB(1:688,1)=st(startMegaBlockAAAABFile1:EndMegaBlockAAAABFile1,1);
        
    end
    if File2((a+1)-start,3)==2
        startMegaBlockAAAABFile2=a+length(OmiAAAA)+length(File1);
        EndMegaBlockAAAABFile2=startMegaBlockAAAABFile2+687;
        disp(['    ----->  debut du MegaBlock AAAAB du File2 au rang n°', num2str(startMegaBlockAAAABFile2)])
        disp(['    ----->  fin du MegaBlock AAAAB du File2 au rang n°', num2str(EndMegaBlockAAAABFile2)])
        MegaBlockAAAAB(689:1376,1:3)=File2((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockAAAAB(689:1376,1)=st(startMegaBlockAAAABFile2:EndMegaBlockAAAABFile2,1);
    end
    if File3((a+1)-start,3)==2
        startMegaBlockAAAABFile3=a+length(OmiBBBB)+length(File2)+length(OmiAAAA)+length(File1);
        EndMegaBlockAAAABFile3=startMegaBlockAAAABFile3+687;
        disp(['    ----->  debut du MegaBlock AAAAB du File3 au rang n°', num2str(startMegaBlockAAAABFile3)])
        disp(['    ----->  fin du MegaBlock AAAAB du File3 au rang n°', num2str(EndMegaBlockAAAABFile3)])
        MegaBlockAAAAB(1377:2064,1:3)=File3((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockAAAAB(1377:2064,1)=st(startMegaBlockAAAABFile3:EndMegaBlockAAAABFile3,1);
    end
end
% -------------------------- MegaBlock 3 : BBBBB --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,3)==3
        startMegaBlockBBBBBFile1=a;
        EndMegaBlockBBBBBFile1=startMegaBlockBBBBBFile1+687;
        disp(['    ----->  debut du MegaBlock BBBBB du File1 au rang n°', num2str(startMegaBlockBBBBBFile1)])
        disp(['    ----->  fin du MegaBlock BBBBB du File1 au rang n°', num2str(EndMegaBlockBBBBBFile1)])
        MegaBlockBBBBB(1:688,1:3)=File1((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBBBBB(1:688,1)=st(startMegaBlockBBBBBFile1:EndMegaBlockBBBBBFile1,1);
        
    end
    if File2((a+1)-start,3)==3
        startMegaBlockBBBBBFile2=a+length(OmiAAAA)+length(File1);
        EndMegaBlockBBBBBFile2=startMegaBlockBBBBBFile2+687;
        disp(['    ----->  debut du MegaBlock BBBBB du File2 au rang n°', num2str(startMegaBlockBBBBBFile2)])
        disp(['    ----->  fin du MegaBlock BBBBB du File2 au rang n°', num2str(EndMegaBlockBBBBBFile2)])
        MegaBlockBBBBB(689:1376,1:3)=File2((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBBBBB(689:1376,1)=st(startMegaBlockBBBBBFile2:EndMegaBlockBBBBBFile2,1);
    end
    if File3((a+1)-start,3)==3
        startMegaBlockBBBBBFile3=a+length(OmiBBBB)+length(File2)+length(OmiAAAA)+length(File1);
        EndMegaBlockBBBBBFile3=startMegaBlockBBBBBFile3+687;
        disp(['    ----->  debut du MegaBlock BBBBB du File3 au rang n°', num2str(startMegaBlockBBBBBFile3)])
        disp(['    ----->  fin du MegaBlock BBBBB du File3 au rang n°', num2str(EndMegaBlockBBBBBFile3)])
        MegaBlockBBBBB(1377:2064,1:3)=File3((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBBBBB(1377:2064,1)=st(startMegaBlockBBBBBFile3:EndMegaBlockBBBBBFile3,1);
    end
end
% -------------------------- MegaBlock 4 : BBBBA --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,3)==4
        startMegaBlockBBBBAFile1=a;
        EndMegaBlockBBBBAFile1=startMegaBlockBBBBAFile1+687;
        disp(['    ----->  debut du MegaBlock BBBBA du File1 au rang n°', num2str(startMegaBlockBBBBAFile1)])
        disp(['    ----->  fin du MegaBlock BBBBA du File1 au rang n°', num2str(EndMegaBlockBBBBAFile1)])
        MegaBlockBBBBA(1:688,1:3)=File1((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBBBBA(1:688,1)=st(startMegaBlockBBBBAFile1:EndMegaBlockBBBBAFile1,1);      
    end
    if File2((a+1)-start,3)==4
        startMegaBlockBBBBAFile2=a+length(OmiAAAA)+length(File1);
        EndMegaBlockBBBBAFile2=startMegaBlockBBBBAFile2+687;
        disp(['    ----->  debut du MegaBlock BBBBA du File2 au rang n°', num2str(startMegaBlockBBBBAFile2)])
        disp(['    ----->  fin du MegaBlock BBBBA du File2 au rang n°', num2str(EndMegaBlockBBBBAFile2)])
        MegaBlockBBBBA(689:1376,1:3)=File2((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBBBBA(689:1376,1)=st(startMegaBlockBBBBAFile2:EndMegaBlockBBBBAFile2,1);
    end
    if File3((a+1)-start,3)==4
        startMegaBlockBBBBAFile3=a+length(OmiBBBB)+length(File2)+length(OmiAAAA)+length(File1);
        EndMegaBlockBBBBAFile3=startMegaBlockBBBBAFile3+687;
        disp(['    ----->  debut du MegaBlock BBBBA du File3 au rang n°', num2str(startMegaBlockBBBBAFile3)])
        disp(['    ----->  fin du MegaBlock BBBBA du File3 au rang n°', num2str(EndMegaBlockBBBBAFile3)])
        MegaBlockBBBBA(1377:2064,1:3)=File3((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBBBBA(1377:2064,1)=st(startMegaBlockBBBBAFile3:EndMegaBlockBBBBAFile3,1);
    end
end


%% %%   Separation of the differents Block, based on local-vs-global differentiation, based on Local-Globals index :MegaBlockXXXX(-,2) and File index : MegaBlockXXXX(-,4)
% ------------------------------ Local Standard / Global Standard  ----------------
LocalStdGlobStdA=[];
i=1;
for a=1:(length(MegaBlockAAAAA)-1);
    if MegaBlockAAAAA(a,2)==1 & MegaBlockAAAAA(a,4)==1
        LocalStdGlobStdA(i,1)=st((a+start+(startMegaBlockAAAAAFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockAAAAA(a,2)==1 && MegaBlockAAAAA(a,4)==2
        LocalStdGlobStdA(i,1)=st((a+start-687)+(startMegaBlockAAAAAFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockAAAAA(a,2)==1 && MegaBlockAAAAA(a,4)==3
        LocalStdGlobStdA(i,1)=st((a+start-1377)+(startMegaBlockAAAAAFile3-start),1);
        i=i+1;  
    end
end
LocalStdGlobStdB=[];
i=1;
for a=1:(length(MegaBlockBBBBB)-1);
    if MegaBlockBBBBB(a,2)==4 & MegaBlockBBBBB(a,4)==1
        LocalStdGlobStdB(i,1)=st((a+start+(startMegaBlockBBBBBFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockBBBBB(a,2)==4 && MegaBlockBBBBB(a,4)==2
        LocalStdGlobStdB(i,1)=st((a+start-687)+(startMegaBlockBBBBBFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockBBBBB(a,2)==4 & MegaBlockBBBBB(a,4)==3
        LocalStdGlobStdB(i,1)=st((a+start-1377)+(startMegaBlockBBBBBFile3-start),1);
        i=i+1;  
    end
end

% ---------------------- Local Deviant / Global Standard  ----------------
LocalDvtGlobStdB=[];
i=1;
for a=1:(length(MegaBlockAAAAB)-1);
    if MegaBlockAAAAB(a,2)==2 & MegaBlockAAAAB(a,4)==1
        LocalDvtGlobStdB(i,1)=st((a+start+(startMegaBlockAAAABFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockAAAAB(a,2)==2 & MegaBlockAAAAB(a,4)==2
        LocalDvtGlobStdB(i,1)=st((a+start-687)+(startMegaBlockAAAABFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockAAAAB(a,2)==2 & MegaBlockAAAAB(a,4)==3
        LocalDvtGlobStdB(i,1)=st((a+start-1377)+(startMegaBlockAAAABFile3-start),1);
        i=i+1;  
    end
end
LocalDvtGlobStdA=[];
i=1;
for a=1:(length(MegaBlockBBBBA)-1);
    if MegaBlockBBBBA(a,2)==5 & MegaBlockBBBBA(a,4)==1
        LocalDvtGlobStdA(i,1)=st((a+start+(startMegaBlockBBBBAFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockBBBBA(a,2)==5 & MegaBlockBBBBA(a,4)==2
        LocalDvtGlobStdA(i,1)=st((a+start-687)+(startMegaBlockBBBBAFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockBBBBA(a,2)==5 & MegaBlockBBBBA(a,4)==3
        LocalDvtGlobStdA(i,1)=st((a+start-1377)+(startMegaBlockBBBBAFile3-start),1);
        i=i+1;  
    end
end

% ---------------------- Local Standard / Global Deviant  ----------------
LocalStdGlobDvtA=[];
i=1;
for a=1:(length(MegaBlockAAAAB)-1);
    if MegaBlockAAAAB(a,2)==1 & MegaBlockAAAAB(a,4)==1
        LocalStdGlobDvtA(i,1)=st((a+start+(startMegaBlockAAAABFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockAAAAB(a,2)==1 & MegaBlockAAAAB(a,4)==2
        LocalStdGlobDvtA(i,1)=st((a+start-687)+(startMegaBlockAAAABFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockAAAAB(a,2)==1 & MegaBlockAAAAB(a,4)==3
        LocalStdGlobDvtA(i,1)=st((a+start-1377)+(startMegaBlockAAAABFile2-start),1);
        i=i+1;  
    end
end
LocalStdGlobDvtB=[];
i=1;
for a=1:(length(MegaBlockBBBBA)-1);
    if MegaBlockBBBBA(a,2)==4 & MegaBlockBBBBA(a,4)==1
        LocalStdGlobDvtB(i,1)=st((a+start+(startMegaBlockBBBBAFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockBBBBA(a,2)==4 & MegaBlockBBBBA(a,4)==2
        LocalStdGlobDvtB(i,1)=st((a+start-687)+(startMegaBlockBBBBAFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockBBBBA(a,2)==4 & MegaBlockBBBBA(a,4)==3
        LocalStdGlobDvtB(i,1)=st((a+start-1377)+(startMegaBlockBBBBAFile3-start),1);
        i=i+1;  
    end
end

% ---------------------- Local Deviant / Global Deviant  ----------------
LocalDvtGlobDvtB=[];
i=1;
for a=1:(length(MegaBlockAAAAA)-1);
    if MegaBlockAAAAA(a,2)==2 & MegaBlockAAAAA(a,4)==1
        LocalDvtGlobDvtB(i,1)=st((a+start+(startMegaBlockAAAAAFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockAAAAA(a,2)==2 & MegaBlockAAAAA(a,4)==2
        LocalDvtGlobDvtB(i,1)=st((a+start-687)+(startMegaBlockAAAAAFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockAAAAA(a,2)==2 & MegaBlockAAAAA(a,4)==3
        LocalDvtGlobDvtB(i,1)=st((a+start-1377)+(startMegaBlockAAAAAFile3-start),1);
        i=i+1;  
    end
end
LocalDvtGlobDvtA=[];
i=1;
for a=1:(length(MegaBlockBBBBB)-1);
    if MegaBlockBBBBB(a,2)==5 & MegaBlockBBBBB(a,4)==1
        LocalDvtGlobDvtA(i,1)=st((a+start+(startMegaBlockBBBBBFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockBBBBB(a,2)==5 & MegaBlockBBBBB(a,4)==2
        LocalDvtGlobDvtA(i,1)=st((a+start-687)+(startMegaBlockBBBBBFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockBBBBB(a,2)==5 & MegaBlockBBBBB(a,4)==3
        LocalDvtGlobDvtA(i,1)=st((a+start-1377)+(startMegaBlockBBBBBFile3-start),1);
        i=i+1;  
    end
end

% % ----------------------  Omission Rare A -------------------------------
OmissionRareA=zeros(384,1);
i=1;
for a=start:length(File1)+start-1;
        if File1((a+1)-start,2)==3
           OmissionRareA(i,1)=st(a,1);
        end
    i=i+1;
end
OmissionRareA(find(OmissionRareA(:,1)==0))=[];
i=length(OmissionRareA)+1;

for a=start:length(File2)+start-1;
        if File2((a+1)-start,2)==3
           OmissionRareA(i,1)=st(a+length(OmiAAAA)+length(File1),1);
        end
    i=i+1;
end
OmissionRareA(find(OmissionRareA(:,1)==0))=[];
i=length(OmissionRareA)+1;

for a=start:length(File1)+start-1;
        if File3((a+1)-start,2)==3
           OmissionRareA(i,1)=st(a+2*length(OmiAAAA)+2*length(File1),1);
        end
    i=i+1;
end
OmissionRareA(find(OmissionRareA(:,1)==0))=[];

% % ----------------------  Omission Rare B -------------------------------
OmissionRareB=zeros(384,1);
i=1;
for a=start:length(File1)+start-1;
        if File1((a+1)-start,2)==6
           OmissionRareB(i,1)=st(a,1);
        end
    i=i+1;
end
OmissionRareB(find(OmissionRareB(:,1)==0))=[];
i=length(OmissionRareB)+1;

for a=start:length(File2)+start-1;
        if File2((a+1)-start,2)==6
        OmissionRareB(i,1)=st(a+length(OmiAAAA)+length(File1),1);
        end
    i=i+1;
end
OmissionRareB(find(OmissionRareB(:,1)==0))=[];
i=length(OmissionRareB)+1;

for a=start:length(File1)+start-1;
        if File3((a+1)-start,2)==6
        OmissionRareB(i,1)=st(a+2*length(OmiAAAA)+2*length(File1),1);
        end
    i=i+1;
end
OmissionRareB(find(OmissionRareB(:,1)==0))=[];

%%       Save of the different LocalGlobal assignements 
OmiAAAA=Omiaaaa;
OmiBBBB=Omibbbb;
if safe==1;
    if protocole==1;
        save LocalGlobalAssignment1 LocalStdGlobStdA LocalStdGlobStdB LocalDvtGlobStdA LocalDvtGlobStdB LocalStdGlobDvtA LocalStdGlobDvtB LocalDvtGlobDvtA LocalDvtGlobDvtB OmiAAAA OmissionRareA OmiBBBB OmissionRareB st 
    end
    if protocole==2;
        save LocalGlobalAssignment2 LocalStdGlobStdA LocalStdGlobStdB LocalDvtGlobStdA LocalDvtGlobStdB LocalStdGlobDvtA LocalStdGlobDvtB LocalDvtGlobDvtA LocalDvtGlobDvtB OmiAAAA OmissionRareA OmiBBBB OmissionRareB st
    end
    if protocole==3;
        save LocalGlobalAssignment3 LocalStdGlobStdA LocalStdGlobStdB LocalDvtGlobStdA LocalDvtGlobStdB LocalStdGlobDvtA LocalStdGlobDvtB LocalDvtGlobDvtA LocalDvtGlobDvtB OmiAAAA OmissionRareA OmiBBBB OmissionRareB st
    end
    if protocole==4;
        save LocalGlobalAssignment4 LocalStdGlobStdA LocalStdGlobStdB LocalDvtGlobStdA LocalDvtGlobStdB LocalStdGlobDvtA LocalStdGlobDvtB LocalDvtGlobDvtA LocalDvtGlobDvtB OmiAAAA OmissionRareA OmiBBBB OmissionRareB st
    end
end

%%       Visualisation of the differents MegaBlock, based on MBs index :FileX(-,3)

figure, plot(Range(stim,'s'),0,'ko'); 
axis([(stimVec(1)*0.0001-1000) (stimVec(end)*0.0001+1000) -0.1 0.1])

hold on, plot(ToneMegaBlockAAAAA/1E4,0.001,'bo','markerfacecolor','b');
hold on, plot(ToneMegaBlockAAAAB/1E4,0.001,'go','markerfacecolor','g');
hold on, plot(ToneMegaBlockBBBBB/1E4,0.001,'ro','markerfacecolor','r');
hold on, plot(ToneMegaBlockBBBBA/1E4,0.001,'mo','markerfacecolor','m');
hold on, plot(OmiBBBB/1E4,2,'co','markerfacecolor','c');
hold on, plot(OmiAAAA/1E4,2,'co','markerfacecolor','c');
hold on, title(['Differents tone sequencies - Protocole=> n°',num2str(protocole)]);


%%           Visualisation of the different local-global Std-vs-Dvt block

figure, plot(Range(stim,'s'),0,'k.')
axis([(stimVec(1)*0.0001-1000) (stimVec(end)*0.0001+1000) -0.1 0.1])

hold on, plot(LocalStdGlobStdA/1E4,0.001,'ro','markerfacecolor','r','MarkerSize',5);
hold on, plot(LocalStdGlobStdB/1E4,0.001,'rd','markerfacecolor','r','MarkerSize',5);
hold on, plot(LocalDvtGlobStdA/1E4,0.001,'bo','markerfacecolor','b','MarkerSize',5);
hold on, plot(LocalDvtGlobStdB/1E4,0.001,'bd','markerfacecolor','b','MarkerSize',5);
hold on, plot(LocalStdGlobDvtA/1E4,0.001,'mo','markerfacecolor','m','MarkerSize',5);
hold on, plot(LocalStdGlobDvtB/1E4,0.001,'md','markerfacecolor','m','MarkerSize',5);
hold on, plot(LocalDvtGlobDvtA/1E4,0.001,'go','markerfacecolor','g','MarkerSize',5);
hold on, plot(LocalDvtGlobDvtB/1E4,0.001,'gd','markerfacecolor','g','MarkerSize',5);
hold on, plot(OmissionRareA/1E4,0.001,'co','markerfacecolor','k','MarkerSize',5);
hold on, plot(OmissionRareB/1E4,0.001,'cd','markerfacecolor','k','MarkerSize',5);
hold on, title(['Differents tone sequencies - Protocole=> n°',num2str(protocole)]);

end
