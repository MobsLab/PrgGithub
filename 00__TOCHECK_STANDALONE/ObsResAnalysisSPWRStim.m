
%ObsResAnalysisSPWRStim
%%
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

Ti{1}='channel' ;
Ti{2}='DurationSWS' ;
Ti{3}='DurationREM' ;
Ti{4}='RatioREMSWS' ;
Ti{5}='NbStimREM' ;
Ti{6}='NbStimSWS' ;
Ti{7}='FreqStimTheta' ;  
Ti{8}='FreqStimSWS' ;
Ti{9}='PercStimRiplpes' ;
Ti{10}='NbIntactRipplesOutsideStim' ; 
Ti{11}='NbIntactRipplesDuringSWS' ;
Ti{12}='NbIntactRipplesDuringREM' ;
Ti{13}='FreqIntactRipplesDuringSWS' ;
Ti{14}='FreqIntactRipplesDuringREM' ;
Ti{15}='NbRipplesCorrectedDuringSWS' ;
Ti{16}='NbRipplesCorrectedDuringREM' ;
Ti{17}='FreqRipplesCorrectedDuringSWS' ;
Ti{18}='FreqRipplesCorrectedDuringREM' ;
Ti{19}='NbSpikeRipples' ;
Ti{20}='NombreRipples' ;
Ti{21}='NombreSpikes' ;
Ti{22}='DurationPeriodv' ;
Ti{23}='NbRipplesWithSpikes' ;




if 0


            %--------------------------------------------------------------------------

            clear
            close all

            cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012
                    MFBburst=1; num=1; choicTh=5;ControlStimMFBRipplesSleep
                    clear
                    close all


                    load behavResources
                    load SpikeData cellnames
                    PlaceCellTrig=35;
                    namePlaceCellTrig=cellnames{35};
                    endSleep=tpsfin{4}*1E4;
                    staSleep=tpsdeb{4}*1E4;
                    EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
                    save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig

                    MFBburst=0;
                    num=1; 
                    load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                    namePlaceCellTrig
                    choicTh=5;ControlStimMFBRipplesSleep
                       clear
                    close all     


                    if 0

                            load behavResources
                            load SpikeData cellnames
                            PlaceCellTrig=13;
                            namePlaceCellTrig=cellnames{13};
                            endSleep=tpsfin{4}*1E4;
                            staSleep=tpsdeb{4}*1E4;
                            EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
                            %save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                            MFBburst=0;
                            num=1;
                            %load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                            namePlaceCellTrig
                            choicTh=5;ControlStimMFBRipplesSleep


                            clear
                            close all 


                            load behavResources
                            load SpikeData cellnames
                            PlaceCellTrig=23;
                            namePlaceCellTrig=cellnames{23};
                            endSleep=tpsfin{4}*1E4;
                            staSleep=tpsdeb{4}*1E4;
                            EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
                            %save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                            MFBburst=0;
                            num=1;
                            %load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                            namePlaceCellTrig
                            choicTh=5;ControlStimMFBRipplesSleep


                    end


            cd /media/HardBackUp/DataSauvegarde/Mouse029/20120207
                    MFBburst=1; num=1; choicTh=5; ControlStimMFBRipplesSleep
                    clear
                    close all


                    load behavResources
                    load SpikeData cellnames
                    PlaceCellTrig=12;
                    namePlaceCellTrig=cellnames{12};
                    endSleep=tpsfin{7}*1E4;
                    staSleep=tpsdeb{7}*1E4;
                    EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
                    save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig

                    MFBburst=0;
                    num=1; 
                    load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                    namePlaceCellTrig
                    choicTh=5;ControlStimMFBRipplesSleep
                     clear
                    close all       






            cd /media/HardBackUp/DataSauvegarde/Mouse026/20120109/ICSS-Mouse-26-09012011
                    MFBburst=1; num=3; choicTh=3; ControlStimMFBRipplesSleep
                    clear
                    close all

                    load behavResources
                    load SpikeData cellnames
                    PlaceCellTrig=6;
                    namePlaceCellTrig=cellnames{6};
                    endSleep=tpsfin{3}*1E4;
                    staSleep=tpsdeb{3}*1E4;
                    EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
                    save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig

                    MFBburst=0;
                    num=3; 
                    load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                    namePlaceCellTrig
                    choicTh=3; 
                    ControlStimMFBRipplesSleep
                    clear
                    close all

            cd /media/HardBackUp/DataSauvegarde/Mouse035/20120515/ICSS-Mouse-35-15052012
                    MFBburst=1; num=1; choicTh=5; ControlStimMFBRipplesSleep
                    clear
                    close all


                    load behavResources
                    load SpikeData cellnames
                    PlaceCellTrig=23;
                    namePlaceCellTrig=cellnames{23};
                    endSleep=tpsfin{6}*1E4;
                    staSleep=tpsdeb{6}*1E4;
                    EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
                    save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig

                    MFBburst=0;
                    num=3; 
                    load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                    namePlaceCellTrig
                    choicTh=5;ControlStimMFBRipplesSleep

                      clear
                    close all      


            cd /media/HardBackUp/DataSauvegarde/Mouse042/20120801/ICSS-Mouse-42-01082012
                    MFBburst=1;
                    num=4; 
                    choicTh=4;ControlStimMFBRipplesSleep

                    clear
                    close all      

                    load SpikeData cellnames
                    PlaceCellTrig=12;
                    namePlaceCellTrig=cellnames{12};
                    endSleep=15255*1E4;
                    staSleep=14778*1E4;
                    EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
                    save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig

                    MFBburst=0;
                    num=4; 
                    load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                    namePlaceCellTrig
                    choicTh=4;ControlStimMFBRipplesSleep
                    clear
                    %close all

            %    
            % 
            % cd /media/GeorgeBackUp/DataDisk2/DataSLEEP/Mouse035/20120504/ICSS-Mouse-35-04052012
            %         clear
            %         close all      
            %         
            %         load behavResources
            %         load SpikeData cellnames
            %         PlaceCellTrig=15;
            %         namePlaceCellTrig=cellnames{15};
            %         endSleep=tpsfin{7}*1E4;
            %         staSleep=tpsdeb{7}*1E4;
            %         EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
            %         save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
            %        
            %         MFBburst=0;
            %         num=3; 
            %         load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
            %         namePlaceCellTrig
            %         ControlStimMFBRipplesSleep
            %         clear
                    %close all

                    close all

end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%%

try 
    res=pwd;
    cd /Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok
    load DataObsResAnalysisSPWRStim
    eval(['cd(''',res,''')'])
catch
    
k=1;
l=1;
Res=[];
Res2={};
ResC=[];
ResC2={};

cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012
[Res,Res2,ResC,ResC2,k,l]=LoadResAnalysisSPWRStim(Res,Res2,ResC,ResC2,k,l);

cd /media/HardBackUp/DataSauvegarde/Mouse029/20120207
[Res,Res2,ResC,ResC2,k,l]=LoadResAnalysisSPWRStim(Res,Res2,ResC,ResC2,k,l);
cd /media/HardBackUp/DataSauvegarde/Mouse026/20120109/ICSS-Mouse-26-09012011
[Res,Res2,ResC,ResC2,k,l]=LoadResAnalysisSPWRStim(Res,Res2,ResC,ResC2,k,l);
cd /media/HardBackUp/DataSauvegarde/Mouse035/20120515/ICSS-Mouse-35-15052012
[Res,Res2,ResC,ResC2,k,l]=LoadResAnalysisSPWRStim(Res,Res2,ResC,ResC2,k,l);
cd /media/HardBackUp/DataSauvegarde/Mouse042/20120801/ICSS-Mouse-42-01082012
[Res,Res2,ResC,ResC2,k,l]=LoadResAnalysisSPWRStim(Res,Res2,ResC,ResC2,k,l);

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%%

disp(' ')
disp(' ')
disp(['channel: ',num2str(floor(mean(Res(1,:))))])
disp(['Duration SWS: ',num2str(floor(mean(Res(2,:)))),' s'])
disp(['Duration REM: ',num2str(floor(mean(Res(3,:)))),' s'])
disp(['Ratio REM/SWS: ' ,num2str(floor(mean(Res(4,:))*10)/10),' %'])
disp(['Number of stimulation during SWS : ',num2str(mean(Res(6,:)))])
disp(['Number of stimulation during REM sleep : ',num2str(mean(Res(5,:)))])

disp(['Frequency of stimulation during SWS : ',num2str(mean(Res(8,:))),' Hz'])
disp(['Frequency of stimulation during REM sleep : ',num2str(mean(Res(7,:))),' Hz'])

disp(['Percentage of stimulation during ripples : ',num2str(floor(10*mean(Res(9,:)))/10),' %'])
disp(['Number of intact ripples outside stimulation: ', num2str(mean(Res(10,:)))])
disp(['Number of intact ripples during SWS: ',num2str(mean(Res(11,:)))])
disp(['Number of intact ripples during REM: ',num2str(mean(Res(12,:)))])
disp(['Frequency of intact ripples during SWS: ',num2str(mean(Res(13,:))),' Hz'])
disp(['Frequency of intact ripples during REM: ',num2str(mean(Res(14,:))),' Hz'])
disp(['Number of ripples during SWS corrected: ',num2str(mean(Res(15,:)))])
disp(['Number of intact ripples during REM corrected: ',num2str(mean(Res(16,:)))])
disp(['Frequency of ripples during SWS corrected: ',num2str(mean(Res(17,:))),' Hz'])
disp(['Frequency of ripples during REM corrected: ',num2str(mean(Res(18,:))),' Hz'])

disp(' ')
disp(' ')
disp(' ')

disp('Control Experiments')
disp(' ')

disp(['channel: ',num2str(floor(mean(ResC(1,:))))])
disp(['Duration SWS: ',num2str(floor(mean(ResC(2,:)))),' s'])
disp(['Duration REM: ',num2str(floor(mean(ResC(3,:)))),' s'])
disp(['Ratio REM/SWS: ' ,num2str(floor(mean(ResC(4,:))*10)/10),' %'])

disp(['Number of stimulation during SWS : ',num2str(mean(ResC(6,:)))])
disp(['Number of stimulation during REM sleep : ',num2str(mean(ResC(5,:)))])
disp(['Frequency of stimulation during SWS : ',num2str(mean(ResC(8,:))),' Hz'])
disp(['Frequency of stimulation during REM sleep : ',num2str(mean(ResC(7,:))),' Hz'])

disp(['Percentage of stimulation during ripples : ',num2str(floor(10*mean(ResC(9,:)))/10),' %'])
disp(['Number of intact ripples outside stimulation: ', num2str(mean(ResC(10,:)))])
disp(['Number of intact ripples during SWS: ',num2str(mean(ResC(11,:)))])
disp(['Number of intact ripples during REM: ',num2str(mean(ResC(12,:)))])
disp(['Frequency of intact ripples during SWS: ',num2str(mean(ResC(13,:))),' Hz'])
disp(['Frequency of intact ripples during REM: ',num2str(mean(ResC(14,:))),' Hz'])
disp(['Number of ripples during SWS corrected: ',num2str(mean(ResC(15,:)))])
disp(['Number of intact ripples during REM corrected: ',num2str(mean(ResC(16,:)))])
disp(['Frequency of ripples during SWS corrected: ',num2str(mean(ResC(17,:))),' Hz'])
disp(['Frequency of ripples during REM corrected: ',num2str(mean(ResC(18,:))),' Hz'])
disp(' ')
disp(['Nb spike: ',num2str(mean(ResC(21,:)))])
disp(['Nb spike during ripples: ',num2str(mean(ResC(19,:)))]) 
disp(['Nb ripples: ',num2str(mean(ResC(20,:)))])
disp(['Nb ripples with spikes: ',num2str(mean(ResC(23,:)))])
disp(['Duration of recording: ',num2str(mean(ResC(22,:))), ' s'])
disp(' ')






Ti{1}='channel' ;
Ti{2}='DurationSWS' ;
Ti{3}='DurationREM' ;
Ti{4}='RatioREMSWS' ;
Ti{5}='NbStimREM' ;
Ti{6}='NbStimSWS' ;
Ti{7}='FreqStimTheta' ;  
Ti{8}='FreqStimSWS' ;
Ti{9}='PercStimRiplpes' ;
Ti{10}='NbIntactRipplesOutsideStim' ; 
Ti{11}='NbIntactRipplesDuringSWS' ;
Ti{12}='NbIntactRipplesDuringREM' ;
Ti{13}='FreqIntactRipplesDuringSWS' ;
Ti{14}='FreqIntactRipplesDuringREM' ;
Ti{15}='NbRipplesCorrectedDuringSWS' ;
Ti{16}='NbRipplesCorrectedDuringREM' ;
Ti{17}='FreqRipplesCorrectedDuringSWS' ;
Ti{18}='FreqRipplesCorrectedDuringREM' ;

Ti{19}='OccurenceBefore';
Ti{20}='FreqBefore';

Ti{21}='NbSpikeRipples' ;
Ti{22}='NombreRipples' ;
Ti{23}='NombreSpikes' ;
Ti{24}='DurationPeriod' ;
Ti{25}='NbRipplesWithSpikes' ;


if 0

    for a=1:18; 
        PlotErrorbar2(Res(a,:)', ResC(a,:)'), ylabel(Ti{a})
        set(gca,'xtick',[1,2])
        set(gca,'xticklabel',{'StimMFB','Ctrl'})
    end
    
end

% ((Res(5,:)+Res(6,:))'.*Res(9,:)'./100)./(Res(15,:)'+Res(16,:)')*100
% ((ResC(5,:)+ResC(6,:))'.*ResC(9,:)'./100)./(ResC(15,:)'+ResC(16,:)')*100
% 

    
%     a=9; PlotErrorBar2(Res(a,:)', ResC(a,:)'), ylabel('Perc Stim with Ripples (%)')
%     set(gca,'xtick',[1,2])
%     set(gca,'xticklabel',{'StimMFB','Ctrl'})
%     ylim([0 65])
%     
%     
%     PlotErrorBar2(100*((Res(5,:)+Res(6,:))'.*Res(9,:)'./100)./(Res(15,:)'+Res(16,:)'), 100*((ResC(5,:)+ResC(6,:))'.*ResC(9,:)'./100)./(ResC(15,:)'+ResC(16,:)')), ylabel('Perc Ripples with Stim')
%     set(gca,'xtick',[1,2])
%     set(gca,'xticklabel',{'StimMFB','Ctrl'})
%     %ylim([0 65])
%      
%     
%     A=100*((Res(5,:)+Res(6,:))'.*Res(9,:)'./100)./(Res(15,:)'+Res(16,:)');
%     B=100*((ResC(5,:)+ResC(6,:))'.*ResC(9,:)'./100)./(ResC(15,:)'+ResC(16,:)');
%     C=100*ResC(25,:)'./ResC(22,:)';
%     PlotErrorBar3(A, B,C), ylabel('Perc Ripples with Stim')
%     set(gca,'xtick',[1:3])
%     set(gca,'xticklabel',{'StimMFB','Ctrl', 'Ctrl (method 2)'})   
%     ylim([0 45])
% 
%         thSig=0.05;
% 
%         try
%         [h,p1]=ttest2(A,B);  
%         E=mean(B)+stdError(B);
%         if p1<thSig&p1>0.01
%             plot(2,3/2*E,'k*')
%         elseif p1<0.01
%             plot(1.9,3/2*E,'k*')
%             plot(2.1,3/2*E,'k*')
%         end
%         end
% 
%         try
%             [h,p2]=ttest2(A,C);
%                     E=mean(C)+stdError(C);
%         if p2<0thSig&p2>0.01
%             plot(3,3/2*E,'k*')
%         elseif p2<0.01
%             plot(2.9,3/2*E,'k*')
%             plot(3.1,3/2*E,'k*')
%         end
%         end

  

        for i=[4 7 8 9 17]  
  PlotErrorBar2(Res(i,[1 2 4 5])',ResC(i,[1 2 4 5])'), ylabel(Ti{i})
  set(gca,'xtick',[1,2])
    set(gca,'xticklabel',{'StimMFB','Ctrl'})
        end
    
        
 
    PlotErrorBar2(100*((Res(5,[1 2 4 5])+Res(6,[1 2 4 5]))'.*Res(9,[1 2 4 5])'./100)./(Res(15,[1 2 4 5])'+Res(16,[1 2 4 5])'), 100*((ResC(5,[1 2 4 5])+ResC(6,[1 2 4 5]))'.*ResC(9,[1 2 4 5])'./100)./(ResC(15,[1 2 4 5])'+ResC(16,[1 2 4 5])')), ylabel('Perc Ripples with Stim')
    set(gca,'xtick',[1,2])
    set(gca,'xticklabel',{'StimMFB','Ctrl'})
    %ylim([0 65])
            
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%%

% 
% 
% [Res,Res2,ResC,ResC2]=LoadResAnalysisSPWRStim;
% 
% load ResAnalysisSPWRStimMFBburst
% 
% Res(1,k)=channel ;
% Res(2,k)=DurationSWS ;
% Res(3,k)=DurationREM ;
% Res(4,k)=RatioREMSWS; 
% Res(5,k)=NbStimREM ;
% Res(6,k)=NbStimSWS  ;
% Res(7,k)=PercStimTheta;  
% Res(8,k)=PercStimSWS ;
% Res(9,k)=PercStimRiplpes ;
% Res(10,k)=NbIntactRipplesOutsideStim; 
% Res(11,k)=NbIntactRipplesDuringSWS ;
% Res(12,k)=NbIntactRipplesDuringREM ;
% Res(13,k)=FreqIntactRipplesDuringSWS ;
% Res(14,k)=FreqIntactRipplesDuringREM ;
% Res(15,k)=NbRipplesCorrectedDuringSWS ;
% Res(16,k)=NbRipplesCorrectedDuringREM ;
% Res(17,k)=FreqRipplesCorrectedDuringSWS ;
% Res(18,k)=FreqRipplesCorrectedDuringREM; 
% 
% Res2{1,k}='pwd';
% Res2{1,k}=freq ;
% Res2{1,k}=SpectrumSWS ;
% Res2{1,k}=SpectrumREM ;
% 
% 
% load ResAnalysisSPWRStimCtrl 
% ResC(1,l)=NbSpikeRipples ;
% ResC(1,l)=NombreRipples ;
% ResC(1,l)=NombreSpikes ;
% ResC(1,l)=DurationPeriod ;
% ResC(1,l)=NbRipplesWithSpikes;
% 
% Res2C{1,l}='pwd';
% 
% 
% 
% 
% 
% 
% 
% 
