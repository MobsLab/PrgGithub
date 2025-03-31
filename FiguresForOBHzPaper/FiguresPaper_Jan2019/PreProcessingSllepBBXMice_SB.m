%%%%%%%%%%%%
% 291 - 258 259

% %% Day1
% cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151201/SleepPre
%
% Files = dir;
%
% for ff = 5:length(Files)
%
%     if not(isempty(findstr('291',Files(ff).name)))
%         cd(Files(ff).name)
%         system('ndm_mergedat amplifier')
%         RefSubtraction_multi('amplifier.dat',73,3,'M291',[0:6,8:31],7,[7,64,65,66],...
%             'M258',[32:42,44:47],43,[43],...
%             'M259',[48,50:63],49,[49]);
%         cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151201/SleepPre
%
%     end
%
% end



%% Day 2
%
% cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151202/SleepPre/
%
% Files = dir;
%
% for ff = 1:length(Files)
%     if not(isempty(findstr('291',Files(ff).name)))
%        cd(Files(ff).name)
%        system('ndm_mergedat amplifier')
%        RefSubtraction_multi('amplifier.dat',73,3,'M291',[0:6,8:31],7,[7,64,65,66],...
%            'M258',[32:42,44:47],43,[43],...
%            'M259',[48,50:63],49,[49]);
%        cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151202/SleepPre/
%
%     end
%
% end


%% Day 3 - sleep pre

cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151203/SleepPre/

Files = dir;

for ff = 1:length(Files)
    if not(isempty(findstr('291',Files(ff).name)))
        cd(Files(ff).name)
        disp(Files(ff).name)
        system('ndm_mergedat amplifier')
        RefSubtraction_multi('amplifier.dat',67,3,'M291',[0:6,8:31],7,[7,64,65,66],...
            'M258',[32:42,44:47],43,[43],...
            'M259',[48,50:63],49,[49]);
        cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151203/SleepPre/
        
    end
    
end


%
% %% Day 3 - sleep post
%
% cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151203/SleepPost/
%
% Files = dir;
%
% for ff = 1:length(Files)
%     if not(isempty(findstr('291',Files(ff).name)))
%        cd(Files(ff).name)
%        system('ndm_mergedat amplifier')
%        RefSubtraction_multi('amplifier.dat',68,3,'M291',[0:6,8:31],7,[7,65,66,67],...
%            'M258',[33:43,45:48],44,[44],...
%            'M259',[49,51:64],50,[50]);
%        cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151203/SleepPost/
%
%    end
%
% end
%
%% Day 4 - sleep pre
cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151204/SleepPre/

Files = dir;

for ff = 4:length(Files)
    if not(isempty(findstr('291',Files(ff).name)))
        cd(Files(ff).name)
        disp(Files(ff).name)
        movefile('amplifier_original.dat','amplifier-wideband.dat')
                movefile('auxiliary.dat','amplifier-accelero.dat')

        system('ndm_mergedat amplifier')
        RefSubtraction_multi('amplifier.dat',67,3,'M291',[0:6,8:31],7,[7,64,65,66],...
            'M258',[32:42,44:47],43,[43],...
            'M259',[48,50:63],49,[49]);
        cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151204/SleepPre/
        
    end
    
end


%% Day 4 - sleep post
cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151204/SleepPost/

Files = dir;

for ff = 1:length(Files)
    if not(isempty(findstr('291',Files(ff).name)))
        cd(Files(ff).name)
        disp(Files(ff).name)
                movefile('amplifier_original.dat','amplifier-wideband.dat')
                movefile('auxiliary.dat','amplifier-accelero.dat')

        system('ndm_mergedat amplifier')
        RefSubtraction_multi('amplifier.dat',68,3,'M291',[0:6,8:31],7,[7,65,66,67],...
            'M258',[32:42,44:47],43,[43],...
            'M259',[49,51:64],50,[50]);
        cd /media/mobsmorty/DataMOBS33/M291258259_ProjetAversion/20151204/SleepPost/
        
    end
    
end


%%%%%%
%M 298-298-299


% Day 1
cd /media/mobsmorty/DataMOBS33/M298297299_ProjetAversion/20151214/Sleep/

Files = dir;

for ff = 5:length(Files)
    if not(isempty(findstr('298',Files(ff).name)))
        cd(Files(ff).name)
        disp(Files(ff).name)
        
        movefile('amplifier.dat','amplifier-wideband.dat')
        movefile('auxiliary.dat','amplifier-accelero.dat')
        
        system('ndm_mergedat amplifier')
        
        RefSubtraction_multi('amplifier.dat',105,2,'M298',[0:23,25:31],24,[24,96,97,98],...
            'M297',[32:55,57:63],56,[56,99,100,101]);
        cd /media/mobsmorty/DataMOBS33/M298297299_ProjetAversion/20151214/Sleep/
    end
    
end

% Day 2
cd /media/mobsmorty/DataMOBs57bis/M298297299_ProjetAversion/20151215/Sleep/

Files = dir;

for ff = 6:length(Files)
    if not(isempty(findstr('298',Files(ff).name)))
        cd(Files(ff).name)
        disp(Files(ff).name)
        
        movefile('amplifier.dat','amplifier-wideband.dat')
        movefile('auxiliary.dat','amplifier-accelero.dat')
        
        system('ndm_mergedat amplifier')
        
        RefSubtraction_multi('amplifier.dat',70,2,'M298',[0:23,25:31],24,[24,64,65,66],...
            'M297',[32:39,41:63],40,[40,67,68,69]);
cd /media/mobsmorty/DataMOBs57bis/M298297299_ProjetAversion/20151215/Sleep/

    end
    
end

% Day 3
cd /media/mobsmorty/DataMOBs57bis/M298297299_ProjetAversion/20151216/Sleep/

Files = dir;

for ff = 1:length(Files)
    if not(isempty(findstr('298',Files(ff).name)))
        cd(Files(ff).name)
        disp(Files(ff).name)
%         
%         movefile('amplifier.dat','amplifier-wideband.dat')
%         movefile('auxiliary.dat','amplifier-accelero.dat')
%         
%         system('ndm_mergedat amplifier')
%         
        RefSubtraction_multi('amplifier.dat',105,3,'M298',[0:23,25:31],24,[24,96,97,98],...
            'M297',[32:39,41:63],40,[40,99,100,101],...
            'M299',[83],[83],[64:95,102,103,104]);
        cd /media/mobsmorty/DataMOBs57bis/M298297299_ProjetAversion/20151216/Sleep/

    end
    
end
