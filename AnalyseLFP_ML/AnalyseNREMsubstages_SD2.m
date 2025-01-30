% AnalyseNREMsubstages_SD2.m
%
% see also
% 1. AnalyseNREMsubstagesML.m
% 2. AnalyseNREMsubstages_transitionML.m
% 3. AnalyseNREMsubstages_transitionprobML.m
% 4. AnalyseNREMsubstages_EvolRescaleML.m
% 5. AnalyseNREMsubstages_OBslowOscML.m
% 6. AnalyseNREMsubstages_EvolSlowML.m
% 7. AnalyseNREMsubstages_mergeDropML.m
% 8. AnalyseNREMsubstages_SpikesML.m
% 9. AnalyseNREMsubstages_MultiParamMatrix.m
% 10. AnalyseNREMsubstages_SpikesAndRhythms.m
% 11. AnalyseNREMsubstages_SpectrumML.m
% 12. AnalyseNREMsubstages_Rhythms.m
% 13. AnalyseNREMsubstages_N1evalML.m
% 14. AnalyseNREMsubstages_TrioTransitionML.m
% 15. AnalyseNREMsubstages_TrioTransRescaleML.m
% 16. AnalyseNREMsubstages_OBX.m
% 17. AnalyseNREMsubstages_SpikesInterPyrML.m
% 18. AnalyseNREMsubstagesdKOML.m
% 19. AnalyseNREMsubstages_SD.m
% 20. AnalyseNREMsubstages_SWA.m
% 21. AnalyseNREMsubstages_OR.m
% 22. AnalyseNREMsubstages_SD24h.m
% 23. AnalyseNREMsubstages_ORspikes.m
% CaracteristicsSubstagesML.m

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

analyFolder='/media/DataMOBsRAID/ProjetNREM/AnalysisNREM';
%analyFolder='/media/DataMOBsRAID/ProjetNREM/AnalysisNREM/OLD';
%t_step=30*60; % in second
t_step=60*60; % in second
colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 0.5];

saveFolder='/media/DataMOBsRAID/ProjetNREM/Figures/SleepDeprivation';
savFigure=0;
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
nameSessions{1}='nightPre';
nameSessions{2}='dayBSL';
nameSessions{3}='nightBSL';
nameSessions{4}='daySD';
nameSessions{5}='nightSD';
nameSessions{6}='day+24h';
nameSessions{7}='night+24h';

% ------------ 294 ------------ 
Dir{1,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160627-night';
Dir{1,2}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160628';%ok
Dir{1,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160628-night'; % pourrie
Dir{1,4}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160629';% refait->Run
Dir{1,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160629-night'; 
Dir{1,6}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160630';%ok
Dir{1,7}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160630-night';

% ------------ 330 ------------ 
Dir{2,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160627-night';
Dir{2,2}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160628';% refait->Run
Dir{2,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160628-night';
Dir{2,4}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160629';% ->Run
Dir{2,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160629-night';
Dir{2,6}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160630';%ok
Dir{2,7}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160630-night';

% ------------ 393 ------------ 
% en cours Dir{3,1}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160710-night';
aDir{3,2}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160711';
%Dir{3,2}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160718'; % pas de signaux début rec
Dir{3,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160718-night';
Dir{3,4}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160719';% refait->Run
Dir{3,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160719-night';
Dir{3,6}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160720';% refait->Run
Dir{3,7}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160720-night';

% ------------ 394 ------------ 
% en cours Dir{4,1}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160717-night';
Dir{4,2}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160718';%ok
Dir{4,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160718-night';
Dir{4,4}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160719';% refait->Run
Dir{4,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160719-night';
Dir{4,6}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160720';% refait->Run
Dir{4,7}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160720-night';

% ------------ 395 ------------ 
Dir{5,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160725-night';
Dir{5,2}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160726';% refait->Run
Dir{5,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160726-night';
Dir{5,4}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160727';% refait
Dir{5,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160727-night';
Dir{5,6}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160728';%ok
Dir{5,7}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160728-night';

% ------------ 400 ------------ 
Dir{6,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160725-night';
Dir{6,2}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160726';%ok
Dir{6,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160726-night';
Dir{6,4}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160727';% refait
Dir{6,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160727-night';
Dir{6,6}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160728';%ok
Dir{6,7}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160728-night';

% ------------ 402 ------------ 
%Dir{7,1}=
Dir{7,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160830';% 
%Dir{7,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160830-night';
Dir{7,4}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160831';% 
%Dir{7,5}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160831-night';
Dir{7,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160901';% 
%Dir{7,7}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160901-night';
% ------------ 403 ------------ 

%Dir{8,1}=
Dir{8,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160830';%
%Dir{8,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160830-night';
Dir{8,4}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160831';%
%Dir{8,5}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160831-night';
Dir{8,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160901';%
%Dir{8,7}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160901-night';
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< LOAD DATA IF EXIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
DoAnalysis=0;
try
    temp=load([analyFolder,'/AnalyNREMsubstagesSD2.mat'],'Epochs','Dir');
    temp.Epochs; disp('/AnalyNREMsubstagesSD2.mat already exists...')
    DoAnalysis=input('Redo analysis ? 1/0 :');
catch 
    DoAnalysis=1;
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< GET EXPERIMENTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

if DoAnalysis
    % -------------------------------------------------------------
    % initiate
    nameMouse={};
    Stages={'WAKE','REM','N1','N2','N3','NREM','Total'};
    for a=1:size(Dir,1), for nn=1:length(Stages); Epochs{a,nn}=intervalSet([],[]);end;end
    
    % -------------------------------------------------------------
    % compute
    for a=1:size(Dir,1)
        nameMouse{a}=Dir{a,4}(max(strfind(Dir{a,4},'Mouse'))+[0:7]);
        
        for i=1:7
            disp(Dir{a,i});
            try
                cd(Dir{a,i});
                % -------------------------------------------------------------
                % get substages
                clear WAKE REM N1 N2 N3 NREM Total
                [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise]=RunSubstages(Dir{a,i}); close;
                %WAKE=or(WAKE,noise); % optional !!
                NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,1);
                Total=or(or(NREM,REM),WAKE); mergeCloseIntervals(Total,1);
                
                % -------------------------------------------------------------
                % get time of the day
                NewtsdZT=GetZT_ML(Dir{a,i});
                h_deb(a,i)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
                
                % -------------------------------------------------------------
                % save substages
                for nn=1:length(Stages)
                    eval(['epoch=',Stages{nn},';']);
                    disp(Stages{nn})
                    for e=1:length(Start(epoch))
                        sta=min(Data(Restrict(NewtsdZT,subset(epoch,e))))+ceil(i/2)*24*3600;
                    end
                    temp=Epochs{a,nn};
                    epoch=
                   =epoch;
                end
                
                disp('Done');
            catch
                disp('PROBLEM ! skip'); %keyboard
            end
        end
    end
end