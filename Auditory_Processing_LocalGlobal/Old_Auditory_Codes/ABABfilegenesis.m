% MMNfilegenesis
%
% Protocol number 1 => start = 1
% Protocol number 2 => start = 9217
% Protocol number 3 => start = 18433
%
% This code use the differents .txt files, containing all informations 
% about the differents sound sequencies. It generate Tone variable,
% containing the time of each tone Block (ABABA,ABABB,BABAB,BABAA,...) and
% all the time of the tone correseponding to an omission, or a local/global
% standard/deviant

function [LFP,st]=MMNfilegenesis(start)

load behavResources

% load LFPData
% try  
%     load SpikeData
% end

%% Import of the differents Stimulations Files
        newData1 = importdata('/media/KARIMBACKUP/DataMMN/Mouse-55-63/File1-Bloc-AAAAA-BBBBA-BBBBB-AAAAB.txt');
        vars = fieldnames(newData1);
for i = 1:length(vars)
        assignin('base', vars{i}, newData1.(vars{i}));
end
        File1=newData1.data; 
        clear data; clear colheaders; clear i; clear newData1; clear vars; clear textdata;

        newData2 = importdata('/media/KARIMBACKUP/DataMMN/Mouse-55-63/File2-Bloc-AAAAB-BBBBB-AAAAA-BBBBA.txt');
        File2=newData2; clear newData2;

        newData3 = importdata('/media/KARIMBACKUP/DataMMN/Mouse-55-63/File3-Bloc-BBBBB-BBBBA-AAAAB-AAAAA.txt');
        File3=newData3; clear newData3;

    %% Indexation of the stimulations (st) and determination of the InterBlock interval (default value=3500)
        st=Range(stim);
        disp(['nombre de stimulations :   ', num2str(length(st))])

%% -------------------- Index for MegaBlock starts ------------------------
% ----------------------------- File(a,3) ---------------------------------
% -------- MegaBlock ABAB/A: value 1 
% -------- MegaBlock BABA/B: value 2 
% -------- MegaBlock ABAB/B: value 3 
% -------- MegaBlock BABA/A: value 4 

% File 1 : MegaBlock order => ABAB/A - BABA/B - ABAB/B - BABA/A 
        File1(1,3)=1;
        File1(701,3)=4;
        File1(1401,3)=3;
        File1(2101,3)=2;
        File1(1:length(File1),4)=0;
% File 2 : MegaBlock order => BABA/B - BABA/A - ABAB/A - ABAB/B 
        File2(1)=[];
        File2(1,3)=2;
        File2(701,3)=4;
        File2(1401,3)=1;
        File2(2101,3)=3;
        File2(3:length(File2),4)=0;
% File 3 : MegaBlock order => BABA/A - ABAB/A - ABAB/B - BABA/B 
        File3(1)=[];
        File3(1,3)=4;
        File3(701,3)=1;
        File3(1401,3)=3;
        File3(2101,3)=2;
        File3(1:length(File3),4)=0;

%% ------- Index for all Block start, regarding of the last tone ----------
% ---------------------------- File(a,2) ----------------------------------

% -------- Block ABABA: value 1 -> (standard)
% -------- Block ABABB: value 2 -> (deviant)
% --------  Block ABAB: value 3 -> (omission)
% -------- Block BABAB: value 4 -> (standard)
% -------- Block BABAA: value 5 -> (deviant)
% --------  Block BABA: value 6 -> (omission)


% Index of all block start ABABA and BABAB with value 1 or 4
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

% Index of all block start ABABB and BABAA with value 2 or 5
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
% Index of all block start ABAB and BABA with value 3 or 6
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
    MegaBlockABABA=ones(688*3,4);
    MegaBlockABABA(1:688,4)=1;             % indice des sons du File 1
    MegaBlockABABA(689:1376,4)=2;          % indice des sons du File 2
    MegaBlockABABA(1377:2064,4)=3;         % indice des sons du File 3

    MegaBlockABABB=ones(688*3,4);
    MegaBlockABABB(1:688,4)=1;             % indice des sons du File 1
    MegaBlockABABB(689:1376,4)=2;          % indice des sons du File 2
    MegaBlockABABB(1377:2064,4)=3;         % indice des sons du File 3

    MegaBlockBABAB=ones(688*3,4);
    MegaBlockBABAB(1:688,4)=1;             % indice des sons du File 1
    MegaBlockBABAB(689:1376,4)=2;          % indice des sons du File 2
    MegaBlockBABAB(1377:2064,4)=3;         % indice des sons du File 3

    MegaBlockBABAA=ones(688*3,4);
    MegaBlockBABAA(1:688,4)=1;             % indice des sons du File 1
    MegaBlockBABAA(689:1376,4)=2;          % indice des sons du File 2
    MegaBlockBABAA(1377:2064,4)=3;         % indice des sons du File 3

    ToneMegaBlockABABA=ones(688*3,1);
    ToneMegaBlockABABB=ones(688*3,1);
    ToneMegaBlockBABAB=ones(688*3,1);
    ToneMegaBlockBABAA=ones(688*3,1);

%%          Preparation of the differents Omissions matrices (moveable)

%---------------------------- 4 Omissions --------------------------------
    OmiABAB=st((start+length(File1)):(start+length(File1)+479),1);
    OmiBABA=st(start+length(File1)+length(OmiABAB)+length(File2):(start+length(File1)+length(OmiABAB)+length(File2)+479),1);

%%     Repartition of the tone in the differents MegaBlock, based on MBs index :FileX(-,3)
% -------------------------- MegaBlock 1 : ABABA --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,3)==1
        startMegaBlockABABAFile1=a;
        EndMegaBlockABABAFile1=startMegaBlockABABAFile1+687;
        disp(['    ----->  debut du MegaBlock ABABA du File1 au rang n°', num2str(startMegaBlockABABAFile1)])
        disp(['    ----->  fin du MegaBlock ABABA du File1 au rang n°', num2str(EndMegaBlockABABAFile1)])
        MegaBlockABABA(1:688,1:3)=File1((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockABABA(1:688,1)=st(startMegaBlockABABAFile1:EndMegaBlockABABAFile1,1);
    end
    if File2((a+1)-start,3)==1
        startMegaBlockABABAFile2=a+length(OmiABAB)+length(File1);
        EndMegaBlockABABAFile2=startMegaBlockABABAFile2+687;
        disp(['    ----->  debut du MegaBlock ABABA du File2 au rang n°', num2str(startMegaBlockABABAFile2)])
        disp(['    ----->  fin du MegaBlock ABABA du File2 au rang n°', num2str(EndMegaBlockABABAFile2)])
        MegaBlockABABA(689:1376,1:3)=File2((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockABABA(689:1376,1)=st(startMegaBlockABABAFile2:EndMegaBlockABABAFile2,1);
    end
    if File3((a+1)-start,3)==1
        startMegaBlockABABAFile3=a+length(OmiBABA)+length(File2)+length(OmiABAB)+length(File1);
        EndMegaBlockABABAFile3=startMegaBlockABABAFile3+687;
        disp(['    ----->  debut du MegaBlock ABABA du File3 au rang n°', num2str(startMegaBlockABABAFile3)])
        disp(['    ----->  fin du MegaBlock ABABA du File3 au rang n°', num2str(EndMegaBlockABABAFile3)])
        MegaBlockABABA(1377:2064,1:3)=File3((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockABABA(1377:2064,1)=st(startMegaBlockABABAFile3:EndMegaBlockABABAFile3,1);
    end
end
% -------------------------- MegaBlock 2 : ABABB --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,3)==2
        startMegaBlockABABBFile1=a;
        EndMegaBlockABABBFile1=startMegaBlockABABBFile1+687;
        disp(['    ----->  debut du MegaBlock ABABB du File1 au rang n°', num2str(startMegaBlockABABBFile1)])
        disp(['    ----->  fin du MegaBlock ABABB du File1 au rang n°', num2str(EndMegaBlockABABBFile1)])
        MegaBlockABABB(1:688,1:3)=File1((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockABABB(1:688,1)=st(startMegaBlockABABBFile1:EndMegaBlockABABBFile1,1);
        
    end
    if File2((a+1)-start,3)==2
        startMegaBlockABABBFile2=a+length(OmiABAB)+length(File1);
        EndMegaBlockABABBFile2=startMegaBlockABABBFile2+687;
        disp(['    ----->  debut du MegaBlock ABABB du File2 au rang n°', num2str(startMegaBlockABABBFile2)])
        disp(['    ----->  fin du MegaBlock ABABB du File2 au rang n°', num2str(EndMegaBlockABABBFile2)])
        MegaBlockABABB(689:1376,1:3)=File2((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockABABB(689:1376,1)=st(startMegaBlockABABBFile2:EndMegaBlockABABBFile2,1);
    end
    if File3((a+1)-start,3)==2
        startMegaBlockABABBFile3=a+length(OmiBABA)+length(File2)+length(OmiABAB)+length(File1);
        EndMegaBlockABABBFile3=startMegaBlockABABBFile3+687;
        disp(['    ----->  debut du MegaBlock ABABB du File3 au rang n°', num2str(startMegaBlockABABBFile3)])
        disp(['    ----->  fin du MegaBlock ABABB du File3 au rang n°', num2str(EndMegaBlockABABBFile3)])
        MegaBlockABABB(1377:2064,1:3)=File3((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockABABB(1377:2064,1)=st(startMegaBlockABABBFile3:EndMegaBlockABABBFile3,1);
    end
end
% -------------------------- MegaBlock 3 : BABAB --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,3)==3
        startMegaBlockBABABFile1=a;
        EndMegaBlockBABABFile1=startMegaBlockBABABFile1+687;
        disp(['    ----->  debut du MegaBlock BABAB du File1 au rang n°', num2str(startMegaBlockBABABFile1)])
        disp(['    ----->  fin du MegaBlock BABAB du File1 au rang n°', num2str(EndMegaBlockBABABFile1)])
        MegaBlockBABAB(1:688,1:3)=File1((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBABAB(1:688,1)=st(startMegaBlockBABABFile1:EndMegaBlockBABABFile1,1);
        
    end
    if File2((a+1)-start,3)==3
        startMegaBlockBABABFile2=a+length(OmiABAB)+length(File1);
        EndMegaBlockBABABFile2=startMegaBlockBABABFile2+687;
        disp(['    ----->  debut du MegaBlock BABAB du File2 au rang n°', num2str(startMegaBlockBABABFile2)])
        disp(['    ----->  fin du MegaBlock BABAB du File2 au rang n°', num2str(EndMegaBlockBABABFile2)])
        MegaBlockBABAB(689:1376,1:3)=File2((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBABAB(689:1376,1)=st(startMegaBlockBABABFile2:EndMegaBlockBABABFile2,1);
    end
    if File3((a+1)-start,3)==3
        startMegaBlockBABABFile3=a+length(OmiBABA)+length(File2)+length(OmiABAB)+length(File1);
        EndMegaBlockBABABFile3=startMegaBlockBABABFile3+687;
        disp(['    ----->  debut du MegaBlock BABAB du File3 au rang n°', num2str(startMegaBlockBABABFile3)])
        disp(['    ----->  fin du MegaBlock BABAB du File3 au rang n°', num2str(EndMegaBlockBABABFile3)])
        MegaBlockBABAB(1377:2064,1:3)=File3((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBABAB(1377:2064,1)=st(startMegaBlockBABABFile3:EndMegaBlockBABABFile3,1);
    end
end
% -------------------------- MegaBlock 4 : BABAA --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,3)==4
        startMegaBlockBABAAFile1=a;
        EndMegaBlockBABAAFile1=startMegaBlockBABAAFile1+687;
        disp(['    ----->  debut du MegaBlock BABAA du File1 au rang n°', num2str(startMegaBlockBABAAFile1)])
        disp(['    ----->  fin du MegaBlock BABAA du File1 au rang n°', num2str(EndMegaBlockBABAAFile1)])
        MegaBlockBABAA(1:688,1:3)=File1((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBABAA(1:688,1)=st(startMegaBlockBABAAFile1:EndMegaBlockBABAAFile1,1);      
    end
    if File2((a+1)-start,3)==4
        startMegaBlockBABAAFile2=a+length(OmiABAB)+length(File1);
        EndMegaBlockBABAAFile2=startMegaBlockBABAAFile2+687;
        disp(['    ----->  debut du MegaBlock BABAA du File2 au rang n°', num2str(startMegaBlockBABAAFile2)])
        disp(['    ----->  fin du MegaBlock BABAA du File2 au rang n°', num2str(EndMegaBlockBABAAFile2)])
        MegaBlockBABAA(689:1376,1:3)=File2((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBABAA(689:1376,1)=st(startMegaBlockBABAAFile2:EndMegaBlockBABAAFile2,1);
    end
    if File3((a+1)-start,3)==4
        startMegaBlockBABAAFile3=a+length(OmiBABA)+length(File2)+length(OmiABAB)+length(File1);
        EndMegaBlockBABAAFile3=startMegaBlockBABAAFile3+687;
        disp(['    ----->  debut du MegaBlock BABAA du File3 au rang n°', num2str(startMegaBlockBABAAFile3)])
        disp(['    ----->  fin du MegaBlock BABAA du File3 au rang n°', num2str(EndMegaBlockBABAAFile3)])
        MegaBlockBABAA(1377:2064,1:3)=File3((a+1)-start:(a+1)-start+687,1:3);
        ToneMegaBlockBABAA(1377:2064,1)=st(startMegaBlockBABAAFile3:EndMegaBlockBABAAFile3,1);
    end
end


%% %%   Separation of the differents Block, based on local-vs-global differentiation, based on Local-Globals index :MegaBlockXXXX(-,2) and File index : MegaBlockXXXX(-,4)
% ------------------------------ Local Standard / Global Standard  ----------------
LocalStdGlobStdA=[];
i=1;
for a=1:(length(MegaBlockABABA)-1);
    if MegaBlockABABA(a,2)==1 & MegaBlockABABA(a,4)==1
        LocalStdGlobStdA(i,1)=st((a+start+(startMegaBlockABABAFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockABABA(a,2)==1 && MegaBlockABABA(a,4)==2
        LocalStdGlobStdA(i,1)=st((a+start-687)+(startMegaBlockABABAFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockABABA(a,2)==1 && MegaBlockABABA(a,4)==3
        LocalStdGlobStdA(i,1)=st((a+start-1377)+(startMegaBlockABABAFile3-start),1);
        i=i+1;  
    end
end
LocalStdGlobStdB=[];
i=1;
for a=1:(length(MegaBlockBABAB)-1);
    if MegaBlockBABAB(a,2)==4 & MegaBlockBABAB(a,4)==1
        LocalStdGlobStdB(i,1)=st((a+start+(startMegaBlockBABABFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockBABAB(a,2)==4 && MegaBlockBABAB(a,4)==2
        LocalStdGlobStdB(i,1)=st((a+start-687)+(startMegaBlockBABABFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockBABAB(a,2)==4 & MegaBlockBABAB(a,4)==3
        LocalStdGlobStdB(i,1)=st((a+start-1377)+(startMegaBlockBABABFile3-start),1);
        i=i+1;  
    end
end

% ---------------------- Local Deviant / Global Standard  ----------------
LocalDvtGlobStdB=[];
i=1;
for a=1:(length(MegaBlockABABB)-1);
    if MegaBlockABABB(a,2)==2 & MegaBlockABABB(a,4)==1
        LocalDvtGlobStdB(i,1)=st((a+start+(startMegaBlockABABBFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockABABB(a,2)==2 & MegaBlockABABB(a,4)==2
        LocalDvtGlobStdB(i,1)=st((a+start-687)+(startMegaBlockABABBFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockABABB(a,2)==2 & MegaBlockABABB(a,4)==3
        LocalDvtGlobStdB(i,1)=st((a+start-1377)+(startMegaBlockABABBFile3-start),1);
        i=i+1;  
    end
end
LocalDvtGlobStdA=[];
i=1;
for a=1:(length(MegaBlockBABAA)-1);
    if MegaBlockBABAA(a,2)==5 & MegaBlockBABAA(a,4)==1
        LocalDvtGlobStdA(i,1)=st((a+start+(startMegaBlockBABAAFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockBABAA(a,2)==5 & MegaBlockBABAA(a,4)==2
        LocalDvtGlobStdA(i,1)=st((a+start-687)+(startMegaBlockBABAAFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockBABAA(a,2)==5 & MegaBlockBABAA(a,4)==3
        LocalDvtGlobStdA(i,1)=st((a+start-1377)+(startMegaBlockBABAAFile3-start),1);
        i=i+1;  
    end
end

% ---------------------- Local Standard / Global Deviant  ----------------
LocalStdGlobDvtA=[];
i=1;
for a=1:(length(MegaBlockABABB)-1);
    if MegaBlockABABB(a,2)==1 & MegaBlockABABB(a,4)==1
        LocalStdGlobDvtA(i,1)=st((a+start+(startMegaBlockABABBFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockABABB(a,2)==1 & MegaBlockABABB(a,4)==2
        LocalStdGlobDvtA(i,1)=st((a+start-687)+(startMegaBlockABABBFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockABABB(a,2)==1 & MegaBlockABABB(a,4)==3
        LocalStdGlobDvtA(i,1)=st((a+start-1377)+(startMegaBlockABABBFile2-start),1);
        i=i+1;  
    end
end
LocalStdGlobDvtB=[];
i=1;
for a=1:(length(MegaBlockBABAA)-1);
    if MegaBlockBABAA(a,2)==4 & MegaBlockBABAA(a,4)==1
        LocalStdGlobDvtB(i,1)=st((a+start+(startMegaBlockBABAAFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockBABAA(a,2)==4 & MegaBlockBABAA(a,4)==2
        LocalStdGlobDvtB(i,1)=st((a+start-687)+(startMegaBlockBABAAFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockBABAA(a,2)==4 & MegaBlockBABAA(a,4)==3
        LocalStdGlobDvtB(i,1)=st((a+start-1377)+(startMegaBlockBABAAFile3-start),1);
        i=i+1;  
    end
end

% ---------------------- Local Deviant / Global Deviant  ----------------
LocalDvtGlobDvtB=[];
i=1;
for a=1:(length(MegaBlockABABA)-1);
    if MegaBlockABABA(a,2)==2 & MegaBlockABABA(a,4)==1
        LocalDvtGlobDvtB(i,1)=st((a+start+(startMegaBlockABABAFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockABABA(a,2)==2 & MegaBlockABABA(a,4)==2
        LocalDvtGlobDvtB(i,1)=st((a+start-687)+(startMegaBlockABABAFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockABABA(a,2)==2 & MegaBlockABABA(a,4)==3
        LocalDvtGlobDvtB(i,1)=st((a+start-1377)+(startMegaBlockABABAFile3-start),1);
        i=i+1;  
    end
end
LocalDvtGlobDvtA=[];
i=1;
for a=1:(length(MegaBlockBABAB)-1);
    if MegaBlockBABAB(a,2)==5 & MegaBlockBABAB(a,4)==1
        LocalDvtGlobDvtA(i,1)=st((a+start+(startMegaBlockBABABFile1-start))-1,1);
        i=i+1;
    elseif MegaBlockBABAB(a,2)==5 & MegaBlockBABAB(a,4)==2
        LocalDvtGlobDvtA(i,1)=st((a+start-687)+(startMegaBlockBABABFile2-start)-2,1);
        i=i+1;
    elseif MegaBlockBABAB(a,2)==5 & MegaBlockBABAB(a,4)==3
        LocalDvtGlobDvtA(i,1)=st((a+start-1377)+(startMegaBlockBABABFile3-start),1);
        i=i+1;  
    end
end

% % ----------------------  Omission Rare A -------------------------------
OmissionRareABAB=zeros(384,1);
i=1;
for a=start:length(File1)+start-1;
        if File1((a+1)-start,2)==3
           OmissionRareABAB(i,1)=st(a,1);
        end
    i=i+1;
end
OmissionRareABAB(find(OmissionRareABAB(:,1)==0))=[];
i=length(OmissionRareABAB)+1;

for a=start:length(File2)+start-1;
        if File2((a+1)-start,2)==3
           OmissionRareABAB(i,1)=st(a+length(OmiABAB)+length(File1),1);
        end
    i=i+1;
end
OmissionRareABAB(find(OmissionRareABAB(:,1)==0))=[];
i=length(OmissionRareABAB)+1;

for a=start:length(File1)+start-1;
        if File3((a+1)-start,2)==3
           OmissionRareABAB(i,1)=st(a+2*length(OmiABAB)+2*length(File1),1);
        end
    i=i+1;
end
OmissionRareABAB(find(OmissionRareABAB(:,1)==0))=[];

% % ----------------------  Omission Rare B -------------------------------
OmissionRareBABA=zeros(384,1);
i=1;
for a=start:length(File1)+start-1;
        if File1((a+1)-start,2)==6
           OmissionRareBABA(i,1)=st(a,1);
        end
    i=i+1;
end
OmissionRareBABA(find(OmissionRareBABA(:,1)==0))=[];
i=length(OmissionRareBABA)+1;

for a=start:length(File2)+start-1;
        if File2((a+1)-start,2)==6
        OmissionRareBABA(i,1)=st(a+length(OmiABAB)+length(File1),1);
        end
    i=i+1;
end
OmissionRareBABA(find(OmissionRareBABA(:,1)==0))=[];
i=length(OmissionRareBABA)+1;

for a=start:length(File1)+start-1;
        if File3((a+1)-start,2)==6
        OmissionRareBABA(i,1)=st(a+2*length(OmiABAB)+2*length(File1),1);
        end
    i=i+1;
end
OmissionRareBABA(find(OmissionRareBABA(:,1)==0))=[];

%%       Save of the different LocalGlobal assignements 

if start<9200;
    save LocalGlobalAssignment LocalStdGlobStdA LocalStdGlobStdB LocalDvtGlobStdA LocalDvtGlobStdB LocalStdGlobDvtA LocalStdGlobDvtB LocalDvtGlobDvtA LocalDvtGlobDvtB OmiABAB OmissionRareABAB OmiBABA OmissionRareBABA st
end
if start>9200;
    save LocalGlobalAssignment2 LocalStdGlobStdA LocalStdGlobStdB LocalDvtGlobStdA LocalDvtGlobStdB LocalStdGlobDvtA LocalStdGlobDvtB LocalDvtGlobDvtA LocalDvtGlobDvtB OmiABAB OmissionRareABAB OmiBABA OmissionRareBABA st
end


%%       Visualisation of the differents MegaBlock, based on MBs index :FileX(-,3)

figure, plot(Range(stim,'s'),ones(length(Range(stim)),1),'ko')
hold on, plot(ToneMegaBlockABABA/1E4,ones(length(ToneMegaBlockABABA),2),'bo','markerfacecolor','b');
hold on, plot(ToneMegaBlockABABB/1E4,ones(length(ToneMegaBlockABABB),2),'go','markerfacecolor','g');
hold on, plot(ToneMegaBlockBABAB/1E4,ones(length(ToneMegaBlockBABAB),2),'ro','markerfacecolor','r');
hold on, plot(ToneMegaBlockBABAA/1E4,ones(length(ToneMegaBlockBABAA),2),'mo','markerfacecolor','m');
hold on, plot(OmiBABA/1E4,ones(length(OmiBABA),2),'co','markerfacecolor','c');
hold on, plot(OmiABAB/1E4,ones(length(OmiABAB),2),'co','markerfacecolor','c');
hold on, title(['Differents tone sequencies - start=',num2str(start)]);

%%           Visualisation of the different local-global Std-vs-Dvt block

figure, plot(Range(stim,'s'),ones(length(Range(stim)),1),'k.')
hold on, plot(LocalStdGlobStdA/1E4,ones(length(LocalStdGlobStdA),2),'ro','markerfacecolor','r','MarkerSize',5);
hold on, plot(LocalStdGlobStdB/1E4,ones(length(LocalStdGlobStdB),2),'rd','markerfacecolor','r','MarkerSize',5);
hold on, plot(LocalDvtGlobStdA/1E4,ones(length(LocalDvtGlobStdA),2),'bo','markerfacecolor','b','MarkerSize',5);
hold on, plot(LocalDvtGlobStdB/1E4,ones(length(LocalDvtGlobStdB),2),'bd','markerfacecolor','b','MarkerSize',5);
hold on, plot(LocalStdGlobDvtA/1E4,ones(length(LocalStdGlobDvtA),2),'mo','markerfacecolor','m','MarkerSize',5);
hold on, plot(LocalStdGlobDvtB/1E4,ones(length(LocalStdGlobDvtB),2),'md','markerfacecolor','m','MarkerSize',5);
hold on, plot(LocalDvtGlobDvtA/1E4,ones(length(LocalDvtGlobDvtA),2),'go','markerfacecolor','g','MarkerSize',5);
hold on, plot(LocalDvtGlobDvtB/1E4,ones(length(LocalDvtGlobDvtB),2),'gd','markerfacecolor','g','MarkerSize',5);
hold on, plot(OmissionRareABAB/1E4,ones(length(OmissionRareABAB),2),'co','markerfacecolor','k','MarkerSize',5);
hold on, plot(OmissionRareBABA/1E4,ones(length(OmissionRareBABA),2),'cd','markerfacecolor','k','MarkerSize',5);
hold on, title(['Differents tone sequencies - start=',num2str(start)]);

end
