%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%BilanManipeTotalMac
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%filename='/media/HardBackUp/DataAnalysis/';

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';
cd(filename)

ThSig=0.05;



try
    tr;
catch
    tr=3;
end

try
    LimiTrials;
catch
    LimiTrials=1;
end



try
    renorm;   % if 1 normalisation vs control values (default value 1)
catch
    renorm=1;
end
try
    renormAll;
catch
    renormAll=1;
end

if LimiTrials==0
    renormAll=0;
end

try
    DoSuite;
catch
    DoSuite=0;
end

try
    allBefore;
catch
    allBefore=0;
end

sav=0;
plo=0;

 % 1: (Analyse time spend in zone)
 % 2: (Analyse time spend to go into the zone)
 % 3: (Analyse cumulative distance to the zone)

 try 
     Analy;
 catch
 Analy=1; %disp('Analyse time spend in zone')
 %Analy=2; %disp('Analyse time spend to go into the zone')
 %Analy=3; %disp('Analyse cumulative distance to the zone')
 end

 
 
%--------------------------------------------------------------------------
try
    Protocol;
catch
    Protocol=1; % 1: sleep (n=2-3 ou 5);   2: wake place cell (n=2 ou 3);    3: Wake Manual (n=3); 4:  Wake (manuel and place cell)
end


switch Protocol
    case 1
    NumberofManipes=4;
    case 2
    NumberofManipes=2;
    case 3 
    NumberofManipes=2;    
    case 4 
    NumberofManipes=4;  
end


%NumberofManipes=4; %default 4 

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



ki=1;



%%
if Protocol==1

            %--------------------------------------------------------------------------    
            %--------------------------------------------------------------------------
            % Sleep
            %--------------------------------------------------------------------------
            %--------------------------------------------------------------------------

            cd([filename,'Mouse026/20120109'])
            %cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20120109/ICSS-Mouse-26-09012011


            load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

            Ccorr(1,ki)= CorrelationCoef(10,1);
            Pcorr(1,ki)= CorrelationCoef(11,1);
            Ccorr(2,ki)= CorrelationCoef(10,2);
            Pcorr(2,ki)= CorrelationCoef(11,2);

            Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
            Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
            Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
            Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);

            ICSSEff(ki)=ICSSefficiency(1);
            Homog(1,ki)=homogeneity(1,3);
            Homog(2,ki)=homogeneity(2,3);
            Homog(3,ki)=homogeneity(1,1);
            Homog(4,ki)=homogeneity(2,1);

            ki=ki+1;




            load AnalyseResourcesICSS Res

            Res1=Res;



            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim1=diStim;
            delZon1=delZon;


            load ParametersAnalyseICSS M o varargin

            if plo
            %VisuQuantifEpoxhTrial(M,o,1)
            %VisuQuantifEpochTrialNeuron(M,6,[7, 9 ,11],1)
            VisuQuantifEpochTrialNeuron(M,6,[7],1,30)
            end


            %--------------------------------------------------------------------------

            cd([filename,'Mouse029/20120207'])


            load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

            Ccorr(1,ki)= CorrelationCoef(10,1);
            Pcorr(1,ki)= CorrelationCoef(11,1);
            Ccorr(2,ki)= CorrelationCoef(10,2);
            Pcorr(2,ki)= CorrelationCoef(11,2);

            Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
            Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
            Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
            Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


            ICSSEff(ki)=ICSSefficiency(1);
            Homog(1,ki)=homogeneity(1,3);
            Homog(2,ki)=homogeneity(2,3);
            Homog(3,ki)=homogeneity(1,1);
            Homog(4,ki)=homogeneity(2,1);
            Homog(5,ki)=homogeneity(1,2);
            Homog(6,ki)=homogeneity(2,2);

            ki=ki+1;

            % try
            % fcd /media/DISK_1/Data1/creationData/20120207/ICSS-Mouse-29-07022012
            % catch
            %     cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120207
            % end



            load AnalyseResourcesICSS Res

            Res2=Res;

            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim2=diStim;
            delZon2=delZon;


            load ParametersAnalyseICSS M o varargin

            if plo
            %VisuQuantifEpoxhTrial(M,o,1)
            VisuQuantifEpochTrialNeuron(M,12,[1,2],1,20)
            end



            %--------------------------------------------------------------------------

            cd([filename,'Mouse035/20120515'])


            load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

            Ccorr(1,ki)= CorrelationCoef(10,1);
            Pcorr(1,ki)= CorrelationCoef(11,1);
            Ccorr(2,ki)= CorrelationCoef(10,2);
            Pcorr(2,ki)= CorrelationCoef(11,2);

            Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
            Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
            Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
            Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


            ICSSEff(ki)=ICSSefficiency(1);
            Homog(1,ki)=homogeneity(1,3);
            Homog(2,ki)=homogeneity(2,3);
            Homog(3,ki)=homogeneity(1,1);
            Homog(4,ki)=homogeneity(2,1);
            Homog(5,ki)=homogeneity(1,2);
            Homog(6,ki)=homogeneity(2,2);

            ki=ki+1;

            %cd /media/DISK_2/Data2/ICSS-Sleep/Mouse035/15052012/ICSS-Mouse-35-15052012
            load AnalyseResourcesICSS Res

            Res3=Res;

            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim3=diStim;
            delZon3=delZon;


            if plo
            %VisuQuantifEpoxhTrial(M,o,1)
            VisuQuantifEpochTrialNeuron(M,23,[4,13],1,15)
            end





            %--------------------------------------------------------------------------

            cd([filename,'Mouse042/20120801'])

            load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

            Ccorr(1,ki)= CorrelationCoef(10,1);
            Pcorr(1,ki)= CorrelationCoef(11,1);
            Ccorr(2,ki)= CorrelationCoef(10,2);
            Pcorr(2,ki)= CorrelationCoef(11,2);

            Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
            Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
            Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
            Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


            ICSSEff(ki)=ICSSefficiency(1);
            Homog(1,ki)=homogeneity(1,3);
            Homog(2,ki)=homogeneity(2,3);
            Homog(3,ki)=homogeneity(1,1);
            Homog(4,ki)=homogeneity(2,1);
            Homog(5,ki)=homogeneity(1,2);
            Homog(6,ki)=homogeneity(2,2);

            ki=ki+1;

            %cd /media/DISK_2/Data2/ICSS-Sleep/Mouse035/15052012/ICSS-Mouse-35-15052012
            load AnalyseResourcesICSS Res

            Res4=Res;


            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim4=diStim;
            delZon4=delZon;


            if plo
            %VisuQuantifEpoxhTrial(M,o,1)
            % VisuQuantifEpochTrialNeuron(M,23,[4,13],1,15)
            VisuQuantifEpochTrialNeuron(10:13,12,[4,12],2,15);
            end







            %--------------------------------------------------------------------------

            cd([filename,'Mouse029/20120208am'])


            % 
            % try
            % fcd /media/DISK_1/Data1/creationData/20120208/20120208am/ICSS-Mouse-29-08022012
            % catch
            % cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208am/
            % end

            load AnalyseResourcesICSS Res

            Res5=Res;


            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim5=diStim;
            delZon5=delZon;



            load ParametersAnalyseICSS M o varargin

            if plo
            %VisuQuantifEpoxhTrial(M,o,1)
            VisuQuantifEpochTrialNeuron(M,6,[1,2,8],1,20)

            end


            %--------------------------------------------------------------------------

            cd([filename,'Mouse029/20120208pm'])

            % 
            % try
            % fcd /media/DISK_1/Data1/creationData/20120208/20120208pm/ICSS-Mouse-29-08022012
            % catch
            % cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208pm/
            % end

            load AnalyseResourcesICSS Res


            Res6=Res;

            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim6=diStim;
            delZon6=delZon;


            load ParametersAnalyseICSS M o varargin

            if plo
            %VisuQuantifEpoxhTrial(M,o,1)

            VisuQuantifEpochTrialNeuron(M,28,[1,12],1,15)
            end





            %%



elseif Protocol==2
%%

            %--------------------------------------------------------------------------
            % Wake Place cell
            %--------------------------------------------------------------------------


            %--------------------------------------------------------------------------

            cd([filename,'Mouse026/20111128'])

            load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

            Ccorr(1,ki)= CorrelationCoef(10,1);
            Pcorr(1,ki)= CorrelationCoef(11,1);
            Ccorr(2,ki)= CorrelationCoef(10,2);
            Pcorr(2,ki)= CorrelationCoef(11,2);

            Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
            Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
            Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
            Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


            ICSSEff(ki)=ICSSefficiency(1);
            Homog(1,ki)=homogeneity(1,3);
            Homog(2,ki)=homogeneity(2,3);
            Homog(3,ki)=homogeneity(1,1);
            Homog(4,ki)=homogeneity(2,1);
            Homog(5,ki)=homogeneity(1,2);
            Homog(6,ki)=homogeneity(2,2);

            ki=ki+1;

            %cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20111128/ICSS-Mouse-26-28112011

            load AnalyseResourcesICSS Res

            Res1=Res;


            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim1=diStim;
            delZon1=delZon;




            load ParametersAnalyseICSS M o varargin


            %--------------------------------------------------------------------------

            cd([filename,'Mouse029/20120209'])

            load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

            Ccorr(1,ki)= CorrelationCoef(10,1);
            Pcorr(1,ki)= CorrelationCoef(11,1);
            Ccorr(2,ki)= CorrelationCoef(10,2);
            Pcorr(2,ki)= CorrelationCoef(11,2);

            Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
            Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
            Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
            Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


            ICSSEff(ki)=ICSSefficiency(1);
            Homog(1,ki)=homogeneity(1,3);
            Homog(2,ki)=homogeneity(2,3);
            Homog(3,ki)=homogeneity(1,1);
            Homog(4,ki)=homogeneity(2,1);
            Homog(5,ki)=homogeneity(1,2);
            Homog(6,ki)=homogeneity(2,2);

            ki=ki+1;

            %cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120209

            load AnalyseResourcesICSS Res

            Res2=Res;

            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim2=diStim;
            delZon2=delZon;


            load ParametersAnalyseICSS M o


            %--------------------------------------------------------------------------

            cd([filename,'Mouse017/20110622'])

            %cd /media/DISK_1/Data1/creationData/Mouse017/ICSS-Mouse-17-22062011

            load AnalyseResourcesICSS Res

            Res3=Res;

            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim3=diStim;
            delZon3=delZon;


            load ParametersAnalyseICSS M o








%%

elseif Protocol==3
%%
%--------------------------------------------------------------------------
% wake manual
%--------------------------------------------------------------------------
% 
% 

%--------------------------------------------------------------------------


            cd([filename,'Mouse013/20110420'])
            %cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse013/20110420/ICSS-Mouse-13-20042011



            load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

            Ccorr(1,ki)= CorrelationCoef(10,1);
            Pcorr(1,ki)= CorrelationCoef(11,1);
            Ccorr(2,ki)= CorrelationCoef(10,2);
            Pcorr(2,ki)= CorrelationCoef(11,2);

            Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
            Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
            Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
            Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


            ICSSEff(ki)=ICSSefficiency(1);
            Homog(1,ki)=homogeneity(1,3);
            Homog(2,ki)=homogeneity(2,3);
            Homog(3,ki)=homogeneity(1,1);
            Homog(4,ki)=homogeneity(2,1);
            Homog(5,ki)=homogeneity(1,2);
            Homog(6,ki)=homogeneity(2,2);

            ki=ki+1;

            load AnalyseResourcesICSS Res

            Res1=Res;

            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim1=diStim;
            delZon1=delZon;


            load ParametersAnalyseICSS M o



            %--------------------------------------------------------------------------

            cd([filename,'Mouse015/20110615'])

            %cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse015/ICSS-Mouse-15-15062011
            load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

            Ccorr(1,ki)= CorrelationCoef(10,1);
            Pcorr(1,ki)= CorrelationCoef(11,1);
            Ccorr(2,ki)= CorrelationCoef(10,2);
            Pcorr(2,ki)= CorrelationCoef(11,2);

            Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
            Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
            Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
            Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


            ICSSEff(ki)=ICSSefficiency(1);
            Homog(1,ki)=homogeneity(1,3);
            Homog(2,ki)=homogeneity(2,3);
            Homog(3,ki)=homogeneity(1,1);
            Homog(4,ki)=homogeneity(2,1);
            Homog(5,ki)=homogeneity(1,2);
            Homog(6,ki)=homogeneity(2,2);

            ki=ki+1;


            load AnalyseResourcesICSS Res

            Res2=Res;

            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim2=diStim;
            delZon2=delZon;


            load ParametersAnalyseICSS M o

            %--------------------------------------------------------------------------

            cd([filename,'Mouse017/20110614'])
            %cd
            %/media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110614/ICSS-Mouse-17-14062011


            load AnalyseResourcesICSS Res

            Res3=Res;

            load AnalyseResourcesICSS

            diStim{1}=DistanceToStimZonePre;
            diStim{2}=DistanceToStimZonePost;
            diStim{3}=DistanceToStimZonePre;
            diStim{4}=DistanceToStimZonePost;

            delZon{1}=DelayToStimZonePre;
            delZon{2}=DelayToStimZonePost;
            delZon{3}=DelayToStimZonePre;
            delZon{4}=DelayToStimZonePost;


            diStim3=diStim;
            delZon3=delZon;


            load ParametersAnalyseICSS M o


            %--------------------------------------------------------------------------
            %--------------------------------------------------------------------------
            %--------------------------------------------------------------------------
            %--------------------------------------------------------------------------
            %--------------------------------------------------------------------------





            %%



elseif Protocol==4
    
    %%
    
%--------------------------------------------------------------------------

        cd([filename,'Mouse026/20111128'])

        %cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20111128/ICSS-Mouse-26-28112011

        load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

        Ccorr(1,ki)= CorrelationCoef(10,1);
        Pcorr(1,ki)= CorrelationCoef(11,1);
        Ccorr(2,ki)= CorrelationCoef(10,2);
        Pcorr(2,ki)= CorrelationCoef(11,2);

        Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
        Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
        Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
        Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


        ICSSEff(ki)=ICSSefficiency(1);
        Homog(1,ki)=homogeneity(1,3);
        Homog(2,ki)=homogeneity(2,3);
        Homog(3,ki)=homogeneity(1,1);
        Homog(4,ki)=homogeneity(2,1);
        Homog(5,ki)=homogeneity(1,2);
        Homog(6,ki)=homogeneity(2,2);

        ki=ki+1;

        load AnalyseResourcesICSS Res

        Res1=Res;


        load AnalyseResourcesICSS

        diStim{1}=DistanceToStimZonePre;
        diStim{2}=DistanceToStimZonePost;
        diStim{3}=DistanceToStimZonePre;
        diStim{4}=DistanceToStimZonePost;

        delZon{1}=DelayToStimZonePre;
        delZon{2}=DelayToStimZonePost;
        delZon{3}=DelayToStimZonePre;
        delZon{4}=DelayToStimZonePost;


        diStim1=diStim;
        delZon1=delZon;




        load ParametersAnalyseICSS M o varargin


        %--------------------------------------------------------------------------

        cd([filename,'Mouse029/20120209'])

        %cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120209

        load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

        Ccorr(1,ki)= CorrelationCoef(10,1);
        Pcorr(1,ki)= CorrelationCoef(11,1);
        Ccorr(2,ki)= CorrelationCoef(10,2);
        Pcorr(2,ki)= CorrelationCoef(11,2);

        Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
        Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
        Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
        Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


        ICSSEff(ki)=ICSSefficiency(1);
        Homog(1,ki)=homogeneity(1,3);
        Homog(2,ki)=homogeneity(2,3);
        Homog(3,ki)=homogeneity(1,1);
        Homog(4,ki)=homogeneity(2,1);
        Homog(5,ki)=homogeneity(1,2);
        Homog(6,ki)=homogeneity(2,2);

        ki=ki+1;

        load AnalyseResourcesICSS Res

        Res2=Res;

        load AnalyseResourcesICSS

        diStim{1}=DistanceToStimZonePre;
        diStim{2}=DistanceToStimZonePost;
        diStim{3}=DistanceToStimZonePre;
        diStim{4}=DistanceToStimZonePost;

        delZon{1}=DelayToStimZonePre;
        delZon{2}=DelayToStimZonePost;
        delZon{3}=DelayToStimZonePre;
        delZon{4}=DelayToStimZonePost;


        diStim2=diStim;
        delZon2=delZon;


        load ParametersAnalyseICSS M o


        %--------------------------------------------------------------------------



        cd([filename,'Mouse013/20110420'])
        %cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse013/20110420/ICSS-Mouse-13-20042011

        load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

        Ccorr(1,ki)= CorrelationCoef(10,1);
        Pcorr(1,ki)= CorrelationCoef(11,1);
        Ccorr(2,ki)= CorrelationCoef(10,2);
        Pcorr(2,ki)= CorrelationCoef(11,2);

        Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
        Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
        Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
        Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


        ICSSEff(ki)=ICSSefficiency(1);
        Homog(1,ki)=homogeneity(1,3);
        Homog(2,ki)=homogeneity(2,3);
        Homog(3,ki)=homogeneity(1,1);
        Homog(4,ki)=homogeneity(2,1);
        Homog(5,ki)=homogeneity(1,2);
        Homog(6,ki)=homogeneity(2,2);

        ki=ki+1;

        load AnalyseResourcesICSS Res

        Res3=Res;

        load AnalyseResourcesICSS

        diStim{1}=DistanceToStimZonePre;
        diStim{2}=DistanceToStimZonePost;
        diStim{3}=DistanceToStimZonePre;
        diStim{4}=DistanceToStimZonePost;

        delZon{1}=DelayToStimZonePre;
        delZon{2}=DelayToStimZonePost;
        delZon{3}=DelayToStimZonePre;
        delZon{4}=DelayToStimZonePost;


        diStim3=diStim;
        delZon3=delZon;


        load ParametersAnalyseICSS M o



        %--------------------------------------------------------------------------

        cd([filename,'Mouse015/20110615'])

        %cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse015/ICSS-Mouse-15-15062011
        load AnalyseResourcesICSS CorrelationCoef CorrelationCoefCorrected ICSSefficiency homogeneity

        Ccorr(1,ki)= CorrelationCoef(10,1);
        Pcorr(1,ki)= CorrelationCoef(11,1);
        Ccorr(2,ki)= CorrelationCoef(10,2);
        Pcorr(2,ki)= CorrelationCoef(11,2);

        Ccorrc(1,ki)= CorrelationCoefCorrected(10,1);
        Pcorrc(1,ki)= CorrelationCoefCorrected(11,1);
        Ccorrc(2,ki)= CorrelationCoefCorrected(10,2);
        Pcorrc(2,ki)= CorrelationCoefCorrected(11,2);


        ICSSEff(ki)=ICSSefficiency(1);
        Homog(1,ki)=homogeneity(1,3);
        Homog(2,ki)=homogeneity(2,3);
        Homog(3,ki)=homogeneity(1,1);
        Homog(4,ki)=homogeneity(2,1);
        Homog(5,ki)=homogeneity(1,2);
        Homog(6,ki)=homogeneity(2,2);

        ki=ki+1;

        load AnalyseResourcesICSS Res

        Res4=Res;

        load AnalyseResourcesICSS

        diStim{1}=DistanceToStimZonePre;
        diStim{2}=DistanceToStimZonePost;
        diStim{3}=DistanceToStimZonePre;
        diStim{4}=DistanceToStimZonePost;

        delZon{1}=DelayToStimZonePre;
        delZon{2}=DelayToStimZonePost;
        delZon{3}=DelayToStimZonePre;
        delZon{4}=DelayToStimZonePost;


        diStim4=diStim;
        delZon4=delZon;


        load ParametersAnalyseICSS M o


    

end

%%


if Analy==1 %(Analyse time spend in zone)

elseif Analy==2 %(Analyse time spend to go into the zone)

    Res1=delZon1;
    Res2=delZon2;
    try
    Res3=delZon3;
    end
    try
    Res4=delZon4;
    end
    try
    Res5=delZon5;
    end
    try
    Res6=delZon6;    
    end
    
    
elseif Analy==3  %(Analyse cumulative distance to the zone)


    Res1=diStim1;
    Res2=diStim2;
    try
    Res3=diStim3;
    end
    try
    Res4=diStim4;
    end
    try
    Res5=diStim5;
    end
    try
    Res6=diStim6;    
    end
    
end



Res1{1}
Res1{3}


if NumberofManipes==2
BilanManipeFor2

elseif NumberofManipes==3
BilanManipeFor3

elseif NumberofManipes==4
if Bis
    BilanManipeFor4Bis
else
    BilanManipeFor4
end

elseif NumberofManipes==5
BilanManipeFor5

elseif NumberofManipes==6
BilanManipeFor6

end


disp(' ')
disp(' ')
disp(' ')

Res1{1}
Res1{3}


cd(filename)


if LimiTrials & tr<5

%     AtotS=reshape(Asi,NumberofManipes, tr);
%     BtotS=reshape(Bsi,NumberofManipes, tr);
%     AtotL=reshape(Ali,NumberofManipes, tr);
%     BtotL=reshape(Bli,NumberofManipes, tr);

    AtotS=reshape(Asi,tr, NumberofManipes)';
    BtotS=reshape(Bsi,tr, NumberofManipes)';
    AtotL=reshape(Ali,tr, NumberofManipes)';
    BtotL=reshape(Bli,tr, NumberofManipes)';
    
    figure('color',[1 1 1]), 
    
    subplot(2,1,1), hold on
    errorbar(mean(BtotS),stdError(BtotS),'k','linewidth',2)
    hold on, errorbar(mean(AtotS),stdError(AtotS),'r','linewidth',2)
    
    for ind=1:tr
    [h,p1]=ttest2(AtotS(:,ind),BtotS(:,ind));
    E=max(3/2*mean(BtotS(:,ind))+stdError(BtotS(:,ind)),3/2*mean(AtotS(:,ind))+stdError(AtotS(:,ind)));
    
    if p1<ThSig&p1>0.01
    plot(ind,E,'k*')
    elseif p1<0.01
    plot(ind-0.1,E,'k*')
    plot(ind+0.1,E,'k*')
    end
    
    end


    
    subplot(2,1,2), hold on
    errorbar(mean(BtotL),stdError(BtotL),'k','linewidth',2)
    hold on, errorbar(mean(AtotL),stdError(AtotL),'r','linewidth',2)
    for ind=1:tr
    [h,p1]=ttest2(AtotL(:,ind),BtotL(:,ind));
    E=max(3/2*mean(BtotL(:,ind))+stdError(BtotL(:,ind)),3/2*mean(AtotL(:,ind))+stdError(AtotL(:,ind)));
    
    if p1<ThSig&p1>0.01
    plot(ind,E,'k*')
    elseif p1<0.01
    plot(ind-0.1,E,'k*')
    plot(ind+0.1,E,'k*')
    end
    
    end

     if Analy==1 
         subplot(2,1,1), ylabel('Time spend in zone')
         subplot(2,1,2), ylabel('Time spend in zone')

     elseif Analy==2
         subplot(2,1,1), ylabel('Time spend to go into the zone')
         subplot(2,1,2), ylabel('Time spend to go into the zone')     
     elseif Analy==3
         subplot(2,1,1),ylabel('Cumulative distance to the zone')
         subplot(2,1,2),ylabel('Cumulative distance to the zone')     
     end

     if Protocol==1
         subplot(2,1,1),title('Sleep')
     else
         subplot(2,1,1),title('Wake')
     end
     
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    
    if renorm==0;
        
    figure('color',[1 1 1]), 
    
    subplot(2,1,1), hold on
    errorbar(mean(BtotS)/mean(mean(BtotS)),stdError(BtotS)/mean(mean(BtotS)),'k','linewidth',2)
    hold on, errorbar(mean(AtotS)/mean(mean(BtotS)),stdError(AtotS)/mean(mean(BtotS)),'r','linewidth',2)
    for ind=1:tr
    [h,p1]=ttest2(AtotS(:,ind),BtotS(:,ind));
    E=max(3/2*mean(BtotS(:,ind))+stdError(BtotS(:,ind)),3/2*mean(AtotS(:,ind))+stdError(AtotS(:,ind)))/mean(mean(BtotS));
    
    if p1<ThSig&p1>0.01
    plot(ind,E,'k*')
    elseif p1<0.01
    plot(ind-0.1,E,'k*')
    plot(ind+0.1,E,'k*')
    end
    
    end
    
    subplot(2,1,2), hold on
    errorbar(mean(BtotL)/mean(mean(BtotL)),stdError(BtotL)/mean(mean(BtotL)),'k','linewidth',2)
    hold on, errorbar(mean(AtotL)/mean(mean(BtotL)),stdError(AtotL)/mean(mean(BtotL)),'r','linewidth',2)
    for ind=1:tr
    [h,p1]=ttest2(AtotL(:,ind),BtotL(:,ind));
    E=max(3/2*mean(BtotL(:,ind))+stdError(BtotL(:,ind)),3/2*mean(AtotL(:,ind))+stdError(AtotL(:,ind)))/mean(mean(BtotL));
    
    if p1<ThSig&p1>0.01
    plot(ind,E,'k*')
    elseif p1<0.01
    plot(ind-0.1,E,'k*')
    plot(ind+0.1,E,'k*')
    end
    
    end

     if Analy==1 
         subplot(2,1,1), ylabel('Time spend in zone')
         subplot(2,1,2), ylabel('Time spend in zone')

     elseif Analy==2
         subplot(2,1,1), ylabel('Time spend to go into the zone')
         subplot(2,1,2), ylabel('Time spend to go into the zone')     
     elseif Analy==3
         subplot(2,1,1),ylabel('Cumulative distance to the zone')
         subplot(2,1,2),ylabel('Cumulative distance to the zone')     
     end
     
     if Protocol==1
         subplot(2,1,1),title('Sleep')
     else
         subplot(2,1,1),title('Wake')
     end
    end
     
     
    
if LimiTrials
 
 if Analy==1 
     subplot(2,1,2), title('Analyse time spend in zone')
      elseif Analy==2
     subplot(2,1,2), title('Analyse time spend to go into the zone')
 elseif Analy==3
     subplot(2,1,2), title('Analyse cumulative distance to the zone')
 end
 
end
   
     
end
 

 disp('  ')
 
 if Analy==1 
     disp('Analyse time spend in zone')
      elseif Analy==2
     disp('Analyse time spend to go into the zone')
 elseif Analy==3
     disp('Analyse cumulative distance to the zone')
 end
 
 disp('  ')
 
 

 
 
 
 
 if LimiTrials==1&tr==4
 
 A=AtotS(:,1);
 B=AtotS(:,2); 
 C=AtotS(:,3); 
 D=AtotS(:,4);
 
 E=BtotS(:,1);
 F=BtotS(:,2);
 G=BtotS(:,3);
 H=BtotS(:,4);
 
GA=[ones(size(A,1),1); 2*ones(size(B,1),1);3*ones(size(C,1),1);4*ones(size(D,1),1); ones(size(E,1),1); 2*ones(size(F,1),1); 3*ones(size(G,1),1); 4*ones(size(H,1),1)];
GB=[ones(size(A,1)+size(B,1)+size(C,1)+size(D,1),1); 2*ones(size(E,1)+size(F,1)+size(G,1)+size(H,1),1)];
X=[A;B;C;D;E;F;G;H];

%PlotErrorBar([A,B,C,D,E,F,G,H])

group{1}=GA;
group{2}=GB;
[p,t,st] = anovan(X, group,'model','interaction', 'display','off');
% [anvA, anvB, anvAB] = TwoWayAnova(X, GA, GB);

disp(['trial number effect: ',num2str(p(1)), ', Before/After effect: ', num2str(p(2)), ', Interaction: ',num2str(p(3))])
disp(' ')




figure('color',[1 1 1]),

A=AtotS(:,1:2);A=A(:);

if allBefore
B=Bsi(:);    
else
B=BtotS(:,1:2);B=B(:);
end


[h,psi]=ttest2(A,B); 
subplot(1,2,1), PlotErrorBar2(B,A,0)
title(['Small Area around place field trials 1-2, p=',num2str(floor(psi*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
    ylabel('Normalized time spent in the small Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})





A=AtotS(:,3:4);A=A(:);

if allBefore
B=Bsi(:);    
else
B=BtotS(:,3:4);B=B(:);
end

[h,psi]=ttest2(A,B); 
subplot(1,2,2), PlotErrorBar2(B,A,0)
title(['Small Area around place field trials 3-4, p=',num2str(floor(psi*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
    ylabel('Normalized time spent in the small Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})


subplot(1,2,1)
yl1=ylim;
subplot(1,2,2)
yl2=ylim;
subplot(1,2,1), ylim([0, max(yl1(2), yl2(2))])
subplot(1,2,2), ylim([0, max(yl1(2), yl2(2))])

set(gcf,'Position',[560 510 766 418])




figure('color',[1 1 1]),

A=AtotL(:,1:2);A=A(:);
if allBefore
B=Bli(:);    
else
B=BtotL(:,1:2);B=B(:);
end

[h,psi]=ttest2(A,B); 
subplot(1,2,1), PlotErrorBar2(B,A,0)
title(['Large Area around place field trials 1-2, p=',num2str(floor(psi*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the Large Place Field')
else
    ylabel('Normalized time spent in the Large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})


A=AtotL(:,3:4);A=A(:);
if allBefore
B=Bli(:);    
else
B=BtotL(:,3:4);B=B(:);
end
[h,psi]=ttest2(A,B); 
subplot(1,2,2), PlotErrorBar2(B,A,0)
title(['Large Area around place field trials 3-4, p=',num2str(floor(psi*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the Large Place Field')
else
    ylabel('Normalized time spent in the Large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})


subplot(1,2,1)
yl1=ylim;
subplot(1,2,2)
yl2=ylim;
subplot(1,2,1), ylim([0, max(yl1(2), yl2(2))])
subplot(1,2,2), ylim([0, max(yl1(2), yl2(2))])


set(gcf,'Position',[560 510 766 418])





if allBefore==0

        figure('color',[1 1 1]),

        B=BtotS(:,1:2);Btemp=B(:);B=Btemp/mean(Btemp);
        A=AtotS(:,1:2);A=A(:)/mean(Btemp);
        [h,psi]=ttest2(A,B); 
        subplot(1,2,1), PlotErrorBar2(B,A,0)
        title(['Small Area around place field, trials 1-2, p=',num2str(floor(psi*1000)/1000)])

            ylabel('Normalized time spent (vs control)')

        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})


        B=BtotS(:,3:4);Btemp=B(:);B=Btemp/mean(Btemp);
        A=AtotS(:,3:4);A=A(:)/mean(Btemp);

        [h,psi]=ttest2(A,B); 
        subplot(1,2,2), PlotErrorBar2(B,A,0)
        title(['Small Area, trials 3-4, p=',num2str(floor(psi*1000)/1000)])
        ylabel('Normalized time spent (vs control)')
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})


        subplot(1,2,1)
        yl1=ylim;
        subplot(1,2,2)
        yl2=ylim;
        subplot(1,2,1), ylim([0, max(yl1(2), yl2(2))])
        subplot(1,2,2), ylim([0, max(yl1(2), yl2(2))])

        set(gcf,'Position',[560 510 766 418])


        figure('color',[1 1 1]),

        B=BtotL(:,1:2);Btemp=B(:);B=Btemp/mean(Btemp);
        A=AtotL(:,1:2);A=A(:)/mean(Btemp);
        [h,psi]=ttest2(A,B); 
        subplot(1,2,1), PlotErrorBar2(B,A,0)
        title(['Large Area, trials 1-2, p=',num2str(floor(psi*1000)/1000)])
        ylabel('Normalized time spent (vs control)')
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})


        B=BtotL(:,3:4);Btemp=B(:);B=Btemp/mean(Btemp);
        A=AtotL(:,3:4);A=A(:)/mean(Btemp);

        [h,psi]=ttest2(A,B); 
        subplot(1,2,2), PlotErrorBar2(B,A,0)
        title(['Large Area, trials 3-4, p=',num2str(floor(psi*1000)/1000)])
        ylabel('Normalized time spent (vs control)')
        set(gca,'xtick',[1 2])
        set(gca,'xticklabel',{'before','after'})


        subplot(1,2,1)
        yl1=ylim;
        subplot(1,2,2)
        yl2=ylim;
        subplot(1,2,1), ylim([0, max(yl1(2), yl2(2))])
        subplot(1,2,2), ylim([0, max(yl1(2), yl2(2))])


        set(gcf,'Position',[560 510 766 418])


end



 elseif tr==3
     

 A=AtotS(:,1);
 B=AtotS(:,2); 
 C=AtotS(:,3);
 
 D=BtotS(:,1);
 E=BtotS(:,2);
 F=BtotS(:,3);
 
GA=[ones(size(A,1),1); 2*ones(size(B,1),1);3*ones(size(C,1),1); ones(size(D,1),1); 2*ones(size(E,1),1); 3*ones(size(F,1),1)];
GB=[ones(size(A,1)+size(B,1)+size(C,1),1); 2*ones(size(D,1)+size(E,1)+size(F,1),1)];
X=[A;B;C;D;E;F];

%PlotErrorBar([A,B,C,D,E,F])

group{1}=GA;
group{2}=GB;
[p,t,st] = anovan(X, group,'model','interaction', 'display','off');
% [anvA, anvB, anvAB] = TwoWayAnova(X, GA, GB);


disp(['trial number effect: ',num2str(p(1)), ', Before/After effect: ', num2str(p(2)), ', Interaction: ',num2str(p(3))])
disp(' ')
     
     
 end
 
 
 
 
%--------------------------------------------------------------------------
%-------------------------------------------------------------------------- 
%-------------------------------------------------------------------------- 
 
 

figure('color',[1 1 1]),

A=Ccorr(2,:)';
B=Ccorr(1,:)';
[h,psi]=ttest2(A,B); 
PlotErrorBar2(B,A,0)
title(['Correlation, p=',num2str(floor(psi*1000)/1000)])
ylabel('Correlation between Occupation and place field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})
 
 
 
 
 
%--------------------------------------------------------------------------
%-------------------------------------------------------------------------- 
%-------------------------------------------------------------------------- 
 
 
figure('color',[1 1 1]),
plot(ICSSEff, mean(AtotS')./mean(BtotS'),'ko','markerfacecolor','k')

title(['Efficiency of ICSS vs. Efficiency of memory creation'])
xlabel('Efficiency of ICSS')
ylabel('Ratio Occupation in PF (After vs. Before')
xlim([0 1])

 

figure('color',[1 1 1]),
plot(ICSSEff, mean(AtotL')./mean(BtotL'),'ko','markerfacecolor','k')

title(['Efficiency of ICSS vs. Efficiency of memory creation'])
xlabel('Efficiency of ICSS')
ylabel('Ratio Occupation in PF (After vs. Before')
xlim([0 1])




A=Ccorr(2,:)';
B=Ccorr(1,:)';
C=ICSSEff';
PlotErrorBar3(B,A,C)
ylabel('Correlation between Occupation and place field')
set(gca,'xtick',[1 2 3])
set(gca,'xticklabel',{'before','after','Wake ICSS'})
 

thSig=0.05;

try
[h,p1]=ttest2(A,B);  
E=mean(A)+stdError(A);
if p1<thSig&p1>0.01
    plot(2,3/2*E,'k*')
elseif p1<0.01
    plot(1.9,3/2*E,'k*')
    plot(2.1,3/2*E,'k*')
end
end

try
    [h,p2]=ttest2(B,C);
    E=mean(C)+stdError(C);
if p2<0thSig&p2>0.01
    plot(3,3/2*E,'k*')
elseif p2<0.01
    plot(2.9,3/2*E,'k*')
    plot(3.1,3/2*E,'k*')
end
end
        
        
        

%--------------------------------------------------------------------------
%-------------------------------------------------------------------------- 
%-------------------------------------------------------------------------- 

if 0
    
    figure('color',[1 1 1]),

    A=Homog(4,:)';
    B=Homog(3,:)';
    [h,psi]=ttest2(A,B); 
    PlotErrorBar2(B,A,0)
    title(['Homogeneity of Occupation, p=',num2str(floor(psi*1000)/1000)])
    ylabel('Homogeneity of Occupation')
    set(gca,'xtick',[1 2])
    set(gca,'xticklabel',{'before','after'})


    figure('color',[1 1 1]),

    A=Homog(6,:)';
    B=Homog(5,:)';
    [h,psi]=ttest2(A,B); 
    PlotErrorBar2(B,A,0)
    title(['Homogeneity of Occupation, p=',num2str(floor(psi*1000)/1000)])
    ylabel('Homogeneity of Occupation')
    set(gca,'xtick',[1 2])
    set(gca,'xticklabel',{'before','after'})

end

%-------------------------------------------------------------------------- 


%  
% vecsig=[-50:0.5: -1];
% figure('color',[1 1 1]),hold on
% a=1;
% for psig=[-50:0.5: -1]
% A(a)=sum(find(Homog(2,:)<10^psig));
% B(a)=sum(find(Homog(1,:)<10^psig));
% %[h,psi]=ttest2(A,B); 
% a=a+1;
% end
% plot((vecsig), A,'r')
% plot((vecsig), B)
% 
% title(['Percentage of mice with significant inhomogeneity of Occupation, p=',num2str(floor(psi*1000)/1000)])
% ylabel('Percentage of mice with significant inhomogeneity of Occupation')
% set(gca,'xtick',[1 2])
% set(gca,'xticklabel',{'before','after'})
%  



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%







%set(gca,'xtick',[1 2])
%set(gca,'xticklabel',{'before','after'})
 





% 
% 
% figure('color',[1 1 1]),
% 
% A=Ccorrc(2,:)';
% B=Ccorrc(1,:)';
% [h,psi]=ttest2(A,B); 
% PlotErrorBar2(B,A,0)
% title(['Correlation, p=',num2str(floor(psi*1000)/1000)])
% ylabel('Correlation between Occupation and place field')
% set(gca,'xtick',[1 2])
% set(gca,'xticklabel',{'before','after'})
%  






