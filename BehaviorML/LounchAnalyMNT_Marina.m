%% INPUTS
MotherFolder='C:\Users\Karim\Desktop\Data-Electrophy\ProjetOpto';
% toujours construire : ProjetOpto\Mouse127\MNT\Day1
erasePreviousA=0; % 0 to keep existing files, 1 otherwise
A_Mice=[136 138 139];
%A_Mice=[119 127 128 129];
A_Days=[1 2 3 4 5 6];
nameManipe='MNT';

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
                tempMAT(1,11)=100*tempMAT(1,7)./(tempMAT(1,6)+tempMAT(1,7));
              
                MATTT=[MATTT;tempMAT];
            
            
            end
        end
    end
end

U_Mice=unique(MATTT(:,1));
U_Days=unique(MATTT(:,2));
U_Sessions=unique(MATTT(:,3));

colori={'r' 'k' 'b' 'g' 'm'};
figure ('Color',[1 1 1])
warning off
for mi=1:length(U_Mice)
    % Mouse Day Session nbStim LengthSession NbEntryR NbEntryNR TimeInR TimeInNR TimeStim
    indexMice=find(MATTT(:,1)==U_Mice(mi));
    subplot(2,3,1), hold on, title('Nb stim','fontsize',12,'fontweight','b'), xlabel('                                                Sessions')
    axis([1 25 0 7])
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,4),['.-',colori{mi}])

    subplot(2,3,2), hold on, title('Session duration','fontsize',12,'fontweight','b'), xlabel('                                                Sessions')
    axis([1 25 0 300])
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,5),['.-',colori{mi}])

    subplot(2,3,3), hold on, title('Nb Entry in Rewarded ports','fontsize',12,'fontweight','b'), xlabel('                                                Sessions')
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,6),['.-',colori{mi}])

    subplot(2,3,4), hold on, title('Nb ERROR (Entry in nonR ports)','fontsize',12,'fontweight','b'), xlabel('                                                Sessions')
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,7),['.-',colori{mi}])

    subplot(2,3,5), hold on, title('Time spent in NonR ports','fontsize',12,'fontweight','b'), xlabel('                                                Sessions')
    axis([1 25 0 20])
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,9),['.-',colori{mi}])

    subplot(2,3,6), hold on, title('% ERROR (Entry in nonR/nb entry)','fontsize',12,'fontweight','b'), xlabel('                                                Sessions')
    axis([1 25 0 100])
    plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),100*MATTT(indexMice,7)./sum([MATTT(indexMice,7),MATTT(indexMice,6)],2),['.-',colori{mi}])
    
    
end
legend(num2str(U_Mice))

for i=1:6
    subplot(2,3,i)
    for da=1:length(U_Days)
        yl=ylim;
        hold on, line([4*(da-1)+0.5 4*(da-1)+0.5],yl,'Color',[0.5 0.5 0.5])
    end
end



%Mean sessions for each day and each mouse

colori={'r' 'k' 'b' 'g' 'm'};
figure ('Color',[1 1 1]),
Av_Mice=[];
Av_mice4=[];Av_mice5=[];Av_mice6=[];Av_mice7=[];Av_mice8=[];
for mi=1:length(U_Mice)
    %mean nb stim
    for da=1:length(U_Days)
        Av_mice4(mi,da)=mean(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),4));
        std_mice4(mi,da)=stdError(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),4));
    end
    indexMice=find(MATTT(:,1)==U_Mice(mi));
    subplot(2,2,1), hold on, title ('mean nb stim')
    axis([1 length(U_Days) 0 7])
    plot(1:length(U_Days),Av_mice4(mi,:),['.-',colori{mi}])
    hold on, errorbar(1:length(U_Days),Av_mice4(mi,:),std_mice4(mi,:),colori{mi})

    % mean session duration
    for da=1:length(U_Days)
        Av_mice5(mi,da)=mean(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),5));
        std_mice5(mi,da)=stdError(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),5));
    end
    subplot(2,2,2), hold on, title ('mean session duration')
    axis([1 length(U_Days) 0 300])
    plot(1:length(U_Days),Av_mice5(mi,:),['.-',colori{mi}])
    hold on, errorbar(1:length(U_Days),Av_mice5(mi,:),std_mice5(mi,:),colori{mi})
  
    
%     %mean nb entry RP
%     for da=1:length(U_Days)
%         Av_mice6(mi,da)=mean(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),6));
%         std_mice6(mi,da)=stdError(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),6));
%     end
%     subplot(2,2,3), hold on, title ('mean nb entry RP')
%     plot([1:length(U_Days)],Av_mice6(mi,:),['.-',colori{mi}])
%     hold on, errorbar([1:length(U_Days)],Av_mice6(mi,:),std_mice6(mi,:),colori{mi})
    
    %mean nb entry NRP
    for da=1:length(U_Days)
        Av_mice7(mi,da)=mean(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),7));
        std_mice7(mi,da)=stdError(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),7));
    end
    subplot(2,2,3), hold on, title ('mean nb entry NRP')
    axis([1 length(U_Days) 0 20])
    plot([1:length(U_Days)],Av_mice7(mi,:),['.-',colori{mi}])
    hold on, errorbar([1:length(U_Days)],Av_mice7(mi,:),std_mice7(mi,:),colori{mi})
    
    %mean % Errors
    for da=1:length(U_Days)
        Av_mice8(mi,da)=mean(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),11));
        std_mice8(mi,da)=stdError(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),11));
    end
    subplot(2,2,4), hold on, title ('mean % ERRORS')
    axis([1 length(U_Days) 0 100])
    plot([1:length(U_Days)],Av_mice8(mi,:),['.-',colori{mi}])
    hold on, errorbar([1:length(U_Days)],Av_mice8(mi,:),std_mice8(mi,:),colori{mi})
end     
legend(num2str(U_Mice))

%Mean sessions for all the mice and for each day 
figure ('Color',[1 1 1]),
subplot(2,2,1), hold on, title ('nb stim','fontsize',12,'fontweight','b'), xlabel ('                                                Days')
axis([1 length(U_Days) 0 7]) 
plot(1:6,nanmean(Av_mice4(mi,da)))
hold on, errorbar([1:length(U_Days)],Av_mice4(mi,:),std_mice4(mi,:))

subplot(2,2,2), hold on, title ('session duration','fontsize',12,'fontweight','b'), xlabel ('                                                Days')
axis([1 length(U_Days) 0 300])
plot(1:6,nanmean(Av_mice5(mi,da)))
hold on, errorbar([1:length(U_Days)],Av_mice5(mi,:),std_mice5(mi,:))

subplot(2,2,3), hold on, title ('nb entry NRP','fontsize',12,'fontweight','b'), xlabel ('                                                Days')
axis([1 length(U_Days) 0 20])
plot(1:6,nanmean(Av_mice7(mi,da)))
hold on, errorbar([1:length(U_Days)],Av_mice7(mi,:),std_mice7(mi,:))


subplot(2,2,4), hold on, title ('% Errors','fontsize',12,'fontweight','b'), xlabel ('                                                Days')
axis([1 length(U_Days) 0 100])
plot(1:6,nanmean(Av_mice8(mi,da)))
hold on, errorbar([1:length(U_Days)],Av_mice8(mi,:),std_mice8(mi,:))



%i=i+1; p= ranksum(Av_mice4(:,1),Av_mice4(:,i))


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