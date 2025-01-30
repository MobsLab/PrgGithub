clear all
Mice = [666,667,668,669];
RemDurMin = [5,10,15,20,25,30];
WakeDurMin= 10;
for d = 1:length(RemDurMin)
    for mm=1:4
        
        FileName = {'/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Day',
            '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180221_Night',
            '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Day_saline',
            '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Night_saline',
            '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Day_fluoxetine',
            '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Night_fluoxetine',
            '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Day_fluoxetine48H',
            '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180224_Night_fluoxetine48H'};
        FileName = strrep(FileName,'MouseX',['Mouse',num2str(Mice(mm))]);
        
        
        for f = [3,5]
            cd(FileName{f})
            load('StateEpochSB.mat','REMEpoch','SWSEpoch','Wake')
            
            %         REM_ISI_Start{mm,f} = diff(Start(REMEpoch,'s'));
            %         REM_ISI_Stop{mm,f} = diff(Stop(REMEpoch,'s'));
            
            REMEpoch = mergeCloseIntervals(REMEpoch,60*1e4);
            REMEpoch = dropShortIntervals(REMEpoch,RemDurMin(d)*1e4);
            Wake = dropShortIntervals(Wake,WakeDurMin*1e4);
            AllRemStop = Stop(REMEpoch);
            clear BeginCycle EndCycle
            for k = 2:length(AllRemStop)
                LittleEpoch = intervalSet(Stop(subset(REMEpoch,k-1)),Stop(subset(REMEpoch,k)));
                DurWakeInEpoch = sum(Stop(and(Wake,LittleEpoch),'s')-Start(and(Wake,LittleEpoch),'s'));
                if DurWakeInEpoch>30
                    [aft_cell,beg_cell] = transEpoch(SWSEpoch,subset(REMEpoch,k));
                    if isempty(Start(aft_cell{1,2}))
                        BeginCycle(k-1) = AllRemStop(k-1);
                        EndCycle(k-1) = AllRemStop(k);
                    else
                        BeginCycle(k-1) = Start(aft_cell{1,2});
                        EndCycle(k-1) = AllRemStop(k);
                    end
                else
                    BeginCycle(k-1) = AllRemStop(k-1);
                    EndCycle(k-1) = AllRemStop(k);
                end
            end
            
            REM_ISI_New{mm,f} = (EndCycle-BeginCycle)'/60e4;
            
            REM_ISI_Start{mm,f} = diff(Start(REMEpoch,'min'));
            REM_ISI_Stop{mm,f} = diff(Stop(REMEpoch,'min'));
            
            RemDur{mm,f} = Stop(REMEpoch,'min')-Start(REMEpoch,'min');
            MeanCycle(mm,f) = mean(REM_ISI_New{mm,f});
            
        end
        
    end
    
    %     fig=figure;
    %     fig.Name = ['Min Rem' num2str(RemDurMin(d))]
    %     f= 3;
    %     for mm=1:4
    %         subplot(231)
    %         [Y,X] = hist(REM_ISI_Start{mm,f},[0:10:1000]);
    %         plot(X,Y/sum(Y))
    %         hold on
    %         title('REMstart')
    %         subplot(232)
    %         [Y,X] = hist(REM_ISI_Stop{mm,f},[0:10:1000]);
    %         plot(X,Y/sum(Y))
    %         hold on
    %         title('REMstop')
    %         subplot(233)
    %         [Y,X] = hist(RemDur{mm,f},[0:10:160]);
    %         plot(X,Y/sum(Y))
    %         hold on
    %         title('REMDur')
    %
    %     end
    %
    %
    %     f= 5;
    %
    %     for mm=1:4
    %         subplot(234)
    %         [Y,X] = hist(REM_ISI_Start{mm,f},[0:10:1000]);
    %         plot(X,Y/sum(Y))
    %         hold on
    %         title('REMstart')
    %         subplot(235)
    %         [Y,X] = hist(REM_ISI_Stop{mm,f},[0:10:1000]);
    %         plot(X,Y/sum(Y))
    %         hold on
    %         title('REMstop')
    %         subplot(236)
    %         [Y,X] = hist(RemDur{mm,f},[0:10:160]);
    %         plot(X,Y/sum(Y))
    %         hold on
    %         title('REMDur')
    %
    %     end
    
    
    fig=figure;
    fig.Name = ['Min Rem' num2str(RemDurMin(d))]
    f= 3;
    subplot(231)
    alldat = [];
    for mm=1:4
        alldat = [alldat;REM_ISI_New{mm,f}];
    end
    [Y,X] = hist(alldat,60);
    plot(X,Y)
    hold on
    title('Cycle')
    
    subplot(232)
    alldat = [];
    for mm=1:4
        alldat = [alldat;REM_ISI_Stop{mm,f}];
    end
    [Y,X] = hist(alldat,60);
    plot(X,Y)
    hold on
    title('REMstop')
    subplot(233)
    alldat = [];
    for mm=1:4
        alldat = [alldat;RemDur{mm,f}];
    end
    [Y,X] = hist(alldat,60);
    plot(X,Y/sum(Y))
    hold on
    title('REMDur')
    
    
    f= 5;
    
    subplot(234)
    alldat = [];
    for mm=1:4
        alldat = [alldat;REM_ISI_New{mm,f}];
    end
    [Y,X] = hist(alldat,60);
    plot(X,Y)
    hold on
    title('REMcycle')
    subplot(235)
    alldat = [];
    for mm=1:4
        alldat = [alldat;REM_ISI_Stop{mm,f}];
    end
    [Y,X] = hist(alldat,60);
    plot(X,Y)
    hold on
    title('REMstop')
    subplot(236)
    alldat = [];
    for mm=1:4
        alldat = [alldat;RemDur{mm,f}];
    end
    [Y,X] = hist(alldat,60);
    plot(X,Y/sum(Y))
    hold on
    title('REMDur')
    
end

%
% figure
% f= 3;
% for mm=1:4
%     subplot(221)
% [Y,X] = hist(REM_ISI_StartLong{mm,f},[0:10:1000]);
% plot(X,Y/sum(Y))
% hold on
% title('REMstart')
%     subplot(222)
% [Y,X] = hist(REM_ISI_StopLong{mm,f},[0:10:1000]);
% plot(X,Y/sum(Y))
% hold on
% title('REMstop')
%
% end
%
%
% f= 5;
%
% for mm=1:4
%     subplot(223)
% [Y,X] = hist(REM_ISI_StartLong{mm,f},[0:10:1000]);
% plot(X,Y/sum(Y))
% hold on
% title('REMstart')
%     subplot(224)
% [Y,X] = hist(REM_ISI_StopLong{mm,f},[0:10:1000]);
% plot(X,Y/sum(Y))
% hold on
% title('REMstop')
%
% end