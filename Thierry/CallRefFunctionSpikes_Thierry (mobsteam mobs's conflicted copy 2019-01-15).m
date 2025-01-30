if ExpeInfo.nmouse==645
    
    % subtraction of left hemisphere
    AllChans=[0:15];% all recorded channels
    TetVLPO1=[8:11]; % tetrode to be subtracted
    RefVLPO1=9; % electrode used for subtraction
    AllChans(TetVLPO1+1)=[];
    RefSubtraction_multi('amplifier_M645.dat',16,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
    
    % subtraction of right hemisphere
    AllChans=[0:15];
    TetVLPO2=[12:15];
    RefVLPO2=12;
    AllChans(TetVLPO2+1)=[];
    RefSubtraction_multi_AverageChans('amplifier_M645_SpikeRef.dat',16,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
    
    delete('amplifier_M645_SpikeRef_original.dat')
    movefile('amplifier_M645_SpikeRef_SpikeRef.dat','amplifier_M645_SpikeRef.dat')
    movefile('amplifier_M645_original.dat','amplifier_M645.dat')
   
   elseif ExpeInfo.nmouse==766
        
        % subtraction of left hemisphere
        AllChans=[0:31];% all recorded channels
        TetVLPO1=[16:19]; % tetrode to be subtracted
        RefVLPO1=17; % electrode used for subtraction
        AllChans(TetVLPO1+1)=[];
        RefSubtraction_multi('amplifier_M766.dat',32,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
        
        % subtraction of right hemisphere
        AllChans=[0:31];
        TetVLPO2=[20:23];
        RefVLPO2=20;
        AllChans(TetVLPO2+1)=[];
        RefSubtraction_multi_AverageChans('amplifier_M766_SpikeRef.dat',32,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
        
        delete('amplifier_M766_SpikeRef_original.dat')
        movefile('amplifier_M766_SpikeRef_SpikeRef.dat','amplifier_M766_SpikeRef.dat')
        movefile('amplifier_M766_original.dat','amplifier_M766.dat') 
        
%          elseif ExpeInfo.nmouse==781
%         
%         % subtraction of left hemisphere
%         AllChans=[0:31];% all recorded channels
%         TetVLPO1=[20:23]; % tetrode to be subtracted
%         RefVLPO1=20; % electrode used for subtraction
%         AllChans(TetVLPO1+1)=[];
%         RefSubtraction_multi('amplifier_M781.dat',32,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
%         
%         % subtraction of right hemisphere
%         AllChans=[0:31];
%         TetVLPO2=[24:27];
%         RefVLPO2=24;
%         AllChans(TetVLPO2+1)=[];
%         RefSubtraction_multi_AverageChans('amplifier_M781_SpikeRef.dat',32,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
%         
%         delete('amplifier_M781_SpikeRef_original.dat')
%         movefile('amplifier_M781_SpikeRef_SpikeRef.dat','amplifier_M781_SpikeRef.dat')
%         movefile('amplifier_M781_original.dat','amplifier_M781.dat') 
        
         elseif ExpeInfo.nmouse==733
        
        % subtraction of left hemisphere
        AllChans=[0:31];% all recorded channels
        TetVLPO1=[16:19]; % tetrode to be subtracted
        RefVLPO1=17; % electrode used for subtraction
        AllChans(TetVLPO1+1)=[];
        RefSubtraction_multi('amplifier_M733.dat',32,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
        
        % subtraction of right hemisphere
        AllChans=[0:31];
        TetVLPO2=[20:23];
        RefVLPO2=20;
        AllChans(TetVLPO2+1)=[];
        RefSubtraction_multi_AverageChans('amplifier_M733_SpikeRef.dat',32,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
        
        delete('amplifier_M733_SpikeRef_original.dat')
        movefile('amplifier_M733_SpikeRef_SpikeRef.dat','amplifier_M733_SpikeRef.dat')
        movefile('amplifier_M733_original.dat','amplifier_M733.dat') 
        
         elseif ExpeInfo.nmouse==723
        
        % subtraction of left hemisphere
        AllChans=[0:31];% all recorded channels
        TetVLPO1=[16:19]; % tetrode to be subtracted
        RefVLPO1=17; % electrode used for subtraction
        AllChans(TetVLPO1+1)=[];
        RefSubtraction_multi('amplifier_M723.dat',32,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
        
        % subtraction of right hemisphere
        AllChans=[0:31];
        TetVLPO2=[20:23];
        RefVLPO2=20;
        AllChans(TetVLPO2+1)=[];
        RefSubtraction_multi_AverageChans('amplifier_M723_SpikeRef.dat',32,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
        
        delete('amplifier_M723_SpikeRef_original.dat')
        movefile('amplifier_M723_SpikeRef_SpikeRef.dat','amplifier_M723_SpikeRef.dat')
        movefile('amplifier_M723_original.dat','amplifier_M723.dat')
        
        elseif ExpeInfo.nmouse==724
        
        % subtraction of left hemisphere
        AllChans=[0:31];% all recorded channels
        TetVLPO1=[16:19]; % tetrode to be subtracted
        RefVLPO1=17; % electrode used for subtraction
        AllChans(TetVLPO1+1)=[];
        RefSubtraction_multi('amplifier_M723.dat',32,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
        
        % subtraction of right hemisphere
        AllChans=[0:31];
        TetVLPO2=[20:23];
        RefVLPO2=20;
        AllChans(TetVLPO2+1)=[];
        RefSubtraction_multi_AverageChans('amplifier_M723_SpikeRef.dat',32,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
        
        delete('amplifier_M723_SpikeRef_original.dat')
        movefile('amplifier_M723_SpikeRef_SpikeRef.dat','amplifier_M723_SpikeRef.dat')
        movefile('amplifier_M723_original.dat','amplifier_M723.dat')
        
%         elseif ExpeInfo.nmouse==782
%         
%         % subtraction of left hemisphere
%         AllChans=[0:31];% all recorded channels
%         TetVLPO1=[20:23]; % tetrode to be subtracted
%         RefVLPO1=20; % electrode used for subtraction
%         AllChans(TetVLPO1+1)=[];
%         RefSubtraction_multi('amplifier_M782.dat',32,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
%         
%         % subtraction of right hemisphere
%         AllChans=[0:31];
%         TetVLPO2=[24:27];
%         RefVLPO2=26;
%         AllChans(TetVLPO2+1)=[];
%         RefSubtraction_multi_AverageChans('amplifier_M782_SpikeRef.dat',32,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
%         
%         delete('amplifier_M782_SpikeRef_original.dat')
%         movefile('amplifier_M782_SpikeRef_SpikeRef.dat','amplifier_M782_SpikeRef.dat')
%         movefile('amplifier_M782_original.dat','amplifier_M782.dat') 
        
        elseif ExpeInfo.nmouse==781
        
        disp('for 2 mice')
        pause
        
        %subtraction of left hemisphere
        AllChans=[0:35];% all recorded channels
        TetVLPO1=[20:23]; % tetrode to be subtracted
        RefVLPO1=20; % electrode used for subtraction
        AllChans(TetVLPO1+1)=[];
        RefSubtraction_multi('amplifier_M781.dat',36,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
        
        % subtraction of right hemisphere
        AllChans=[0:35];
        TetVLPO2=[24:27];
        RefVLPO2=24;
        AllChans(TetVLPO2+1)=[];
        RefSubtraction_multi_AverageChans('amplifier_M781_SpikeRef.dat',36,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
        
        delete('amplifier_M781_SpikeRef_original.dat')
        movefile('amplifier_M781_SpikeRef_SpikeRef.dat','amplifier_M781_SpikeRef.dat')
        movefile('amplifier_M781_original.dat','amplifier_M781.dat') 

%         elseif ExpeInfo.nmouse==782
%                     
%         disp('for 2 mice')
%         pause
%         
%         % subtraction of left hemisphere
%         AllChans=[0:35];% all recorded channels
%         TetVLPO1=[20:23]; % tetrode to be subtracted
%         RefVLPO1=20; % electrode used for subtraction
%         AllChans(TetVLPO1+1)=[];
%         RefSubtraction_multi('amplifier_M782.dat',36,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
%         
%         % subtraction of right hemisphere
%         AllChans=[0:35];
%         TetVLPO2=[24:27];
%         RefVLPO2=26;
%         AllChans(TetVLPO2+1)=[];
%         RefSubtraction_multi_AverageChans('amplifier_M782_SpikeRef.dat',36,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
%         
%         delete('amplifier_M782_SpikeRef_original.dat')
%         movefile('amplifier_M782_SpikeRef_SpikeRef.dat','amplifier_M782_SpikeRef.dat')
%         movefile('amplifier_M782_original.dat','amplifier_M782.dat') 

 elseif ExpeInfo.nmouse==796
                    
        disp('for 2 mice')
        pause
%         
%         % subtraction of left hemisphere
        AllChans=[0:35];% all recorded channels
%         TetVLPO1=[20:23]; % tetrode to be subtracted
%         RefVLPO1=20; % electrode used for subtraction
%         AllChans(TetVLPO1+1)=[];
%         RefSubtraction_multi('amplifier_M782.dat',36,1,'SpikeRef',TetVLPO1,RefVLPO1,AllChans);
%         
%         % subtraction of right hemisphere
%         AllChans=[0:35];
%         TetVLPO2=[24:27];
%         RefVLPO2=26;
%         AllChans(TetVLPO2+1)=[];
%         RefSubtraction_multi_AverageChans('amplifier_M782_SpikeRef.dat',36,1,'SpikeRef',TetVLPO2,RefVLPO2,AllChans);
%         
%         delete('amplifier_M782_SpikeRef_original.dat')
%         movefile('amplifier_M782_SpikeRef_SpikeRef.dat','amplifier_M782_SpikeRef.dat')
%         movefile('amplifier_M782_original.dat','amplifier_M782.dat') 
% 
% 
end



        
        
        
        
        
