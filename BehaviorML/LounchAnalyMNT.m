%% INPUTS
MotherFolder='C:\Users\Karim\Desktop\Data-Electrophy\ProjetOpto';
% toujours construire : ProjetOpto\Mouse127\MNT\Day1
erasePreviousA=0; % 0 to keep existing files, 1 otherwise
A_Mice=[136 137 138 139];
A_Days=[1 2 3 4 5];
nameManipe='MNT2';

%% initiate
if sum(strfind(MotherFolder,'/'))==0
    mark='\';
else
    mark='/';
end

MATTT=[];
% % Mouse Day Session nbStim LengthSession NbEntryR NbEntryNR TimeInR TimeInNR TimeStim

for mi=1:length(A_Mice)
    disp(' ')
    disp(['          *   Mouse ',num2str(A_Mice(mi)),'   * ']);
    
    for da=1:length(A_Days)
        disp(['                  - day ',num2str(A_Days(da)),' - '])
        directName=[MotherFolder,mark,'Mouse',num2str(A_Mice(mi)),mark,nameManipe,mark,'Day',num2str(A_Days(da))];
        lis=dir(directName);
        
        for i=3:length(lis)
            temp=lis(i).name;
            if strcmp(temp(end-12:end),'-wideband.mat')
                clear StimInPorts TimeInPorts RewardedPorts TpsStop TpsStart
                temp=temp(1:end-13);
                disp(temp)
                n_Session=str2double(temp(strfind(temp,'Session')+7));
                
                %----------------------------------------------------------
                % is the analysis already performed?
                Do_analysis=1;
                if exist([directName,mark,temp,'-A.mat'],'file') && erasePreviousA==0
                    load([directName,mark,temp,'-A.mat'],'StimInPorts','TpsStart','TpsStop');
                    if exist('StimInPorts','var') && exist('TpsStart','var') && exist('TpsStop','var') 
                        disp('           -> AnalyseMNT already done')
                        Do_analysis=0;
                    end
                end
                
                %----------------------------------------------------------
                % perform analysis
                if Do_analysis
                    try
                        AnalyseMNT(directName,lis(i).name,nameManipe)
                    catch
                        disp(['Problem with ',lis(i).name])
                        keyboard
                    end
                end
                
                %----------------------------------------------------------
                % TrueVisit
                % = port / delayWithLastPort / lasting 
                load([directName,mark,temp,'-A.mat'],'TrueVisit','TrueVisit_5sDelay');

                %----------------------------------------------------------
                % fill a tab
                load([directName,mark,temp,'-A.mat'],'StimInPorts','TimeInPorts','RewardedPorts','TpsStop','TpsStart');
                % Mouse Day Session nbStim LengthSession NbEntryR NbEntryNR TimeInR TimeInNR TimeStim
                NRports=find(~ismember([1:8],RewardedPorts));
                
                tempMAT(1,1:3)=[A_Mice(mi) A_Days(da) n_Session];
                tempMAT(1,4:5)=[sum(StimInPorts) TpsStop-TpsStart ];
                tempMAT(1,6:7)=[sum(ismember(TrueVisit_5sDelay(:,1),RewardedPorts)) sum(ismember(TrueVisit_5sDelay(:,1),NRports))];
                tempMAT(1,8:10)=[sum(TimeInPorts(1,RewardedPorts)) sum(TimeInPorts(1,NRports)) sum(TimeInPorts(2,RewardedPorts))];
              
                MATTT=[MATTT;tempMAT];
            
            
            end
        end
    end
end

U_Mice=unique(MATTT(:,1));
U_Days=unique(MATTT(:,2));
U_Sessions=unique(MATTT(:,3));

colori={'r' 'k' 'b' 'g' 'm'};
figure('Color',[1 1 1])
warning off
for mi=1:length(U_Mice)
    % Mouse Day Session nbStim LengthSession NbEntryR NbEntryNR TimeInR TimeInNR TimeStim
    indexMice=find(MATTT(:,1)==U_Mice(mi));
    subplot(2,3,1), hold on, title('Nb stim')
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,4),['.-',colori{mi}])

    subplot(2,3,2), hold on, title('Session duration')
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,5),['.-',colori{mi}])
    
    subplot(2,3,3), hold on, title('Nb Entry in Rewarded ports')
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,6),['.-',colori{mi}])

    subplot(2,3,4), hold on, title('Nb ERROR (Entry in nonR ports)')
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,7),['.-',colori{mi}])

    subplot(2,3,5), hold on, title('Time spent in NonR ports')
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,9),['.-',colori{mi}])

    subplot(2,3,6), hold on, title('% ERROR (Entry in nonR/nb entry)')
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),100*MATTT(indexMice,7)./sum([MATTT(indexMice,7),MATTT(indexMice,6)],2),['.-',colori{mi}])
    
end
legend(num2str(U_Mice))


% temp=OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch11; %'Di_D1_6'
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch11.times=temp.times(3:end);
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch11.level=temp.level(3:end);
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch11.length=36;
% 
% 
% temp=OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch15; %'Di_D1_10'
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch15.times=temp.times([1:4,9:28]);
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch15.level=temp.level([1:4,9:28]);
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch15.length=24;
% 
% temp=OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch5; %'Di_D1_0'
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch5.times=temp.times([1:60,121:420]);
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch5.level=temp.level([1:60,121:420]);
% OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch5.length=length(OPTO_Mouse_127_22052014_03_MNT2Day4Session3_wideband_Ch5.level);