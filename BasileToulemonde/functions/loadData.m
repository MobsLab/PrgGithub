% 1161
% dir = '/media/mobs/DimaERC2/DataERC2/M1161'
%1199
% dir = '/media/mobs/DimaERC2/TEST1_Basile'
% 905
% dir = '/media/mobs/DimaERC2/DataERC2/M905'
% 1336
% dir = '/media/mobs/DimaERC2/Known_M1336'

function [X,Y,V,preSleep,hab,testPre,cond,postSleep,testPost,exploFinal,sleep,wake,tot,Stsd,tRipples] = loadData(dir)
   
    % IMPORTANT : Change the LFP channel (line 42) for each mouse !

    %% MAKING SURE THE TSD TOOLS ARE USABLE
%     addpath(genpath('/home/mobs/Dropbox/Kteam/PrgMatlab/FMAtoolbox/'))
%     addpath(genpath('/home/mobs/Dropbox/Kteam/Fra'))
%     addpath(genpath('/home/mobs/Dropbox/Kteam/PrgMatlab'))
%     addpath('/home/mobs/Dropbox/Kteam/PrgMatlab')

    %% GOING TO THE RIGHT DIRECTORY
    cd(dir)
%     cd('/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated')
    
%     nasResultsDecoding = strcat(nasdir,'/resultsDecoding')
    %% LOADING BEHAVIOR DATA
   cd ..
   load behavResources.mat

    X=AlignedXtsd;
    Y=AlignedYtsd;
    V=Vtsd;

    % Assigning the epochs
    preSleep=SessionEpoch.PreSleep;
    try
        hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
    catch
        hab = SessionEpoch.Hab;
    end
    testPre=or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4));
    cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
    postSleep=SessionEpoch.PostSleep;
    testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
    try
        try
            exploFinal = SessionEpoch.Extinct;
        catch
            exploFinal = SessionEpoch.ExploAfter;
    %         exploFinal = SessionEpoch.Ext;
        end
    catch
        exploFinal = testPost;
    end
    sleep = or(preSleep,postSleep);
    wake = or(or(hab,cond),or(testPre,testPost));
    try
        tot=or(or(hab,or(testPre,or(testPost,or(cond,exploFinal)))),sleep);
    catch
        tot=or(or(hab,or(testPre,or(testPost,or(cond,exploFinal)))),sleep);
    end

    %% LOADING SPIKE DATA
    load SpikeData.mat
    Stsd=S;
    %% LOADING SWR DATA
    load SWR
    tRipples = tRipples;
    cd(dir)
%     %% LOADING LFP DATA 
%     % To know which channel, go to /ChannelsToAnalyse/dHPC_rip.mat
%     cd('/media/nas6/ProjetERC2/Mouse-K199/20210408/_Concatenated')
%     load LFPData/LFP14
%     stimEpoch=stimEpoch;
%     tRipples=tRipples;
%     cd(dir)
end