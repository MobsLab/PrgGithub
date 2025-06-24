function Dir=PathForExperimentFEAR(experiment,datatype,check)

% INPUTS
% experiment = name of the experiment.
%     possible choices:
%    'ManipDec14Bulbectomie' : EXT24h Pleth, EXT48H envB (nCTRL=7, nOBX =7)
%    'ManipFeb15Bulbectomie' : EXT24h  envC, EXT48H envB (nCTRL=8, nOBX =9)
%    'Fear-electrophy'
%    'Fear-electrophy-plethysmo'
%    'Fear-electrophy-opto'
%    'SleepStim'
% datatype = fear or explo
% check = 1 for debug mode, give info while generating structure Dir

% OUTPUT
% Dir = structure containing paths / names / strains / name of experiment
%
% example:
% Dir=PathForExperimentsML('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentsBULB.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m
% PathForExperimentsML.m

% -------------------------------------------------------------------------
%% strains inputs
MICEgroups={'OBX','hemiOBX','CTRL','GADchr2','GADgfp'};

nameSession={'HAB','COND','EXT-24h','EXT-48h','EXT-72h'};
nameEnvt={'envC','envB','pleth'};

nameTreatment={'control','CNO1','CNO2','laser4','laser10'};

OBX=[207 208 209 210 214 215 216 , 222 226 228 232 234 236 238 240 , 230 247,  249 250, 291 297 298,269,270:279];
hemiOBX=[245 246];
% 03.01.2017 correction gp : 269 est en fait OBX
CTRL=[211 212 213 217 218 219 220, 223 224 225 227 229 233 235 237 239 , 231 248, 241 242,  243 244, 253 254, 258 259 299,280:290, 363,367,458,459,394,395,402,403,450,451,493,471,470];
GADgfp=[497 498 504 505 506 537 610 611];
GADchr2=[363 367 458 459 465 466 468 468 496 502 540 542 543 612 613 614];

implanted=[230 231 241 242 247 248 245 246  243 244 249 250 253 254 291 297 298 258 259 299 363 367];

% -------------------------------------------------------------------------
%% Path
if ~exist('datatype','var'),datatype='fear';end
if ~exist('check','var'),check=0;end

% if strcmp(datalocation, 'server')
%     FolderPath='/media/DataMOBsRAID/ProjetAversion/';
% elseif strcmp(datalocation, 'DataMOBs14')
%     FolderPath='/media/DataMOBs14/ProjetAversion/';
% elseif strcmp(datalocation, 'manip')
%     FolderPath='C:\Users\Cl�mence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\';
% else
%     FolderPath='';
% end

a=0;
if strcmp(experiment, 'ManipFeb15Bulbectomie') %  ' : EXT24h  envC, EXT48H envB (nCTRL=8, nOBX =9)
    FolderPath='/media/DataMOBsRAID/ProjetAversion/';
    if strcmp(datatype,'fear')
        for m=222:229
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvC/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvB/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-04022015-HABenvA/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150204/FEAR-Mouse-' num2str(m), '-04022015-COND/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150205/FEAR-Mouse-' num2str(m), '-05022015-EXTenvC/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXTenvB/'];
        end
        
        for m=230:240
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvC/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvB/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-HABenvA/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-COND/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXTenvC/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXTenvB/'];
        end
    elseif strcmp(datatype,'explo')
        for m=222:229
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150202/FEAR-Mouse-' num2str(m), '-02022015-EXPLOpre/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXPLOpost'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXPLO+6j/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150302/FEAR-Mouse-' num2str(m), '-02032015-EXPLO+3wk/'];
        end
        for m=230:240
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150209/FEAR-Mouse-' num2str(m), '-09022015-EXPLOpre/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXPLOpost/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150219/FEAR-Mouse-' num2str(m), '-19022015-EXPLO+6j/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20150309/FEAR-Mouse-' num2str(m), '-09032015-EXPLO+3wk/'];
        end
    end
    
elseif strcmp(experiment, 'ManipDec14Bulbectomie')   % : EXT24h Pleth, EXT48H envB (nCTRL=7, nOBX =7)
    FolderPath='/media/DataMOBsRAID/ProjetAversion/';
    if strcmp(datatype,'fear')
        for m=207:213
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141209/FEAR-Mouse-' num2str(m), '-09122014-HABpleth/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141209/FEAR-Mouse-' num2str(m), '-09122014-HABenvB/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141210/FEAR-Mouse-' num2str(m), '-10122014-HABenvA/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141210/FEAR-Mouse-' num2str(m), '-10122014-COND/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141211/FEAR-Mouse-' num2str(m), '-11122014-EXTpleth/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' ,num2str(m),'/20141212/FEAR-Mouse-' num2str(m), '-12122014-EXTenvB/'];
        end
        for m=214:220
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141216/FEAR-Mouse-' num2str(m) '-16122014-HABpleth/'];
            %a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141216/FEAR-Mouse-' num2str(m) '-16122014-HABenvB/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141217/FEAR-Mouse-' num2str(m) '-17122014-HABenvA/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141217/FEAR-Mouse-' num2str(m) '-17122014-COND/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141218/FEAR-Mouse-' num2str(m) '-18122014-EXTpleth/'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '/20141219/FEAR-Mouse-' num2str(m) '-19122014-EXTenvB/'];
        end
        
    elseif strcmp(datatype,'explo')
        for m=207:213
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141208\FEAR-Mouse-' num2str(m) '-08122014-EXPLOpre'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141212\FEAR-Mouse-' num2str(m) '-12122014-EXPLOpost'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141218\FEAR-Mouse-' num2str(m) '-18122014-EXPLO+6j'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20150105\FEAR-Mouse-' num2str(m) '-05012015-EXPLO+3wk'];
        end
        for m=214:220
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141215\FEAR-Mouse-' num2str(m) '-15122014-EXPLOpre'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141219\FEAR-Mouse-' num2str(m) '-19122014-EXPLOpost'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20141225\FEAR-Mouse-' num2str(m) '-25122014-EXPLO+6j'];
            a=a+1; Dir.path{a}=[FolderPath experiment '/M' num2str(m) '\20150112\FEAR-Mouse-' num2str(m) '-12012015-EXPLO+3wk'];
        end
    end
    
elseif strcmp(experiment, 'FearMLavr2015')
    FolderPath='/media/DataMOBsRAID/ProjetAstro/';
    %mouse 245-246 hemiOBX-hemiOcclusion
    for m=245:246;
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20151125/FEAR-Mouse-270-25112015-01-COND'];
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150410/EXTenvB/BULB-Mouse-' num2str(m) '-10042015'];
        %a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150414/EXTenvB/BULB-Mouse-' num2str(m) '-14042015'];
        %a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150420/EXTenvC/BULB-Mouse-' num2str(m) '-20042015'];
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150508/EXTenvB/BULB-Mouse-' num2str(m) '-08052015'];
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150509/EXTenvC/BULB-Mouse-' num2str(m) '-09052015'];
    end
    
elseif strcmp(experiment, 'FearCBNov15')
    FolderPath='/media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/';
    %mouse 269, 270-279 big BBX mice and 280-290 sham
    for m=269:290
        %         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151123/FEAR-Mouse-' num2str(m) '23112015-01-EXPLOpre'];
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151124/FEAR-Mouse-' num2str(m) '-24112015-01-HABenvB'];
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151124/FEAR-Mouse-' num2str(m) '-24112015-01-HABenvC'];
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151125/FEAR-Mouse-' num2str(m) '-25112015-01-COND'];
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151125/FEAR-Mouse-' num2str(m) '-25112015-01-HABgrille'];
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151126/FEAR-Mouse-' num2str(m) '-26112015-01-EXT24-envC'];
        a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151127/FEAR-Mouse-' num2str(m) '-27112015-01-EXT48-envB'];
        %         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151127/FEAR-Mouse-' num2str(m) '27112015-01-ExploPOST'];
        %         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151203/FEAR-Mouse-' num2str(m) '03122015-01-EXPLO+6d'];
        %         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151210/FEAR-Mouse-' num2str(m) '10122015-01-EXPLO+2wk'];
        %         a=a+1; Dir.path{a}=[FolderPath  'M' num2str(m) '/20151221/FEAR-Mouse-' num2str(m) '21122015-01-EXPLO+3wk'];
    end
    
elseif strcmp(experiment, 'Fear-electrophy-plethysmo')
    FolderPath='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear';
    a=a+1; Dir.path{a}=[FolderPath,'/Mouse493/FEAR-Mouse-493-Ext-24-Plethysmo-20161227/'];
    a=a+1; Dir.path{a}=[FolderPath,'/Mouse471/FEAR-Mouse-471-Ext-24-Plethysmo-20161227/'];
    a=a+1; Dir.path{a}=[FolderPath,'/Mouse470/FEAR-Mouse-470-Ext-24-Plethysmo-20161227/'];
    a=a+1; Dir.path{a}=[FolderPath,'/Mouse402/FEAR-Mouse-402-EXT-24-Plethysmo-20161228/'];
    a=a+1; Dir.path{a}=[FolderPath,'/Mouse450/FEAR-Mouse-450-Ext-24-Plethysmo-20161228/'];
    a=a+1; Dir.path{a}=[FolderPath,'/Mouse395/FEAR-Mouse-395-Ext-24-Plethysmo-20161228/'];
    
elseif strcmp(experiment, 'Fear-electrophy')
    
    FolderPath='/media/DataMOBsRAID/ProjetAstro/';
    % HemiOBX-HemiOccl
    for m=245:246;
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150410/EXTenvB/BULB-Mouse-' num2str(m) '-10042015'];
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150414/EXTenvB/BULB-Mouse-' num2str(m) '-14042015'];
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150508/EXTenvB/BULB-Mouse-' num2str(m) '-08052015'];
        a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m) '/20150509/EXTenvC/BULB-Mouse-' num2str(m) '-09052015'];
        %a=a+1; Dir.path{a}=[FolderPath  'Mouse' num2str(m)
        %'/20150420/EXTenvB/BULB-Mouse-' num2str(m) '-20042015'];
        
    end

        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse242/20150417/EXT-24h-plethy';
        a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse242/20150509/EXTenvB/BULB-Mouse-242-09052015';
        /media/DataMOBsRAID/ProjetAstro/Mouse242/20150418/EXT-48h-envB/BULB-Mouse-242-18042015


    /media/DataMOBsRAID/ProjetAstro/Mouse242/20150418/EXTenvB/BULB-Mouse-242-18042015
    
    
    
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse241/20150509-EXT-24h-envB'; % reprocessed with RefSub
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse241/20150418-EXT-48h-envB/'; % reprocessed with RefSub
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse242/20150508/EXT-24h-plethy/BULB-Mouse-242-08052015'
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAstro/Mouse242/20150509/EXT-48h-envB/BULB-Mouse-242-09052015';
    
    
    
    
    /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse241/20150417-EXT-24h-pleth/BULB-Mouse-241-17042015/
        
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse230/20150212-EXT-24h-envC'; % ref intan soustraite
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse231/20150212-EXT-24h-envC'; % ref intan soustraite
    
    % a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse247/20150326-EXT-24h-envC';% souris sans hippocampe droit- à exclure des analyses
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC'; % pas de ref à sourstraire - analyser que pendant freezing
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150327-EXT-48h-envB'; % pas de ref à sourstraire - analyser que pendant freezing
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150508-EXT-48h-envC';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150507-EXT-24h-envB';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150508-EXT-48h-envC';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150507-EXT-24h-envB';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150508-EXT-48h-envC';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150507-EXT-24h-envB';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150508-EXT-48h-envC';
    
    
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150704-EXT-48h-envB/FEAR-Mouse-253-04072015';
    

% utilisé pendant les analyses : 
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150701-04-manip-control/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150701-04-manip-control/20150704-EXT-48h-envB/FEAR-Mouse-253-04072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150706-09-manip-CNO1/20150707-EXT-24h-envC/FEAR-Mouse-253-07072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150706-09-manip-CNO1/20150708-EXT-48h-envB/FEAR-Mouse-253-08072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150713-15_manip-CNO2/20150714-EXT-24h-envC/FEAR-Mouse-253-14072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M253/20150713-15_manip-CNO2/20150715-EXT-48h-envB/FEAR-Mouse-253-15072015';
    
% copie finale sur le serveur
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150706-09-manip-CNO1/20150707-EXT-24h-envC/FEAR-Mouse-253-07072015/';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150706-09-manip-CNO1/20150708-EXT-48h-envB/FEAR-Mouse-253-08072015/';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150713-15-manip-CNO2/20150714-EXT-24h-envC/FEAR-Mouse-253-14072015/';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150713-15-manip-CNO2/20150715-EXT-48h-envB/FEAR-Mouse-253-15072015/';

    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150704-EXT-48h-envB/FEAR-Mouse-254-04072015';
% utilisé pendant les analyses : 
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150701-04-manip-control/20150703-EXT-24h-envC/FEAR-Mouse-254-03072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150701-04-manip-control/20150704-EXT-48h-envB/FEAR-Mouse-254-04072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150706-09-manip-CNO1/20150714-EXT-24h-envC/FEAR-Mouse-254-07072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150706-09-manip-CNO1/20150715-EXT-48h-envC/FEAR-Mouse-254-08072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150713-15-manip-CNO2/20150714-EXT-24h-envC/FEAR-Mouse-254-14072015';
%     %     a=a+1; Dir.path{a}='/media/DataMOBs29/M254/20150713-15-manip-CNO2/20150715-EXT-48h-envB/FEAR-Mouse-254-15072015';
    
% copie finale sur le serveur
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150706-09-manip-CNO1/20150708-EXT-24h-envC/FEAR-Mouse-254-07072015/';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150706-09-manip-CNO1/20150709-EXT-48h-envB/FEAR-Mouse-254-08072015/';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150713-15-manip-CNO2/20150714-EXT-24h-envC/FEAR-Mouse-254-14072015/';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150713-15-manip-CNO2/20150715-EXT-48h-envB/FEAR-Mouse-254-15072015/';
    
    % % % Manip Sophie Dec 2015 :
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151203-HABgrille';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151204-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151205-EXT-48h-envB';
    
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151203-HABgrille';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151205-EXT-48h-envB'; % a refaire
    
    
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151203-HABgrille'; %%
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151204-EXT-24h-envC';%
    %a=a+1;Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151205-EXT-48h-envB';% crise d'epilepsie
    
    
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151216-HABgrille'; %
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151217-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151218-EXT-48h-envB';%
    
    %a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151216-HABgrille';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151217-EXT-24h-envC';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151218-EXT-48h-envB';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151217-EXT-24h-envC';%
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151218-EXT-48h-envB';
    
    % M394
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse394/FEAR-Mouse-394-EXT-24-envBraye_161020_163239/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse394/FEAR-Mouse-394-EXT-48_envC_blanc_161021_153620/';
    
    % M395
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse395/FEAR-Mouse-395-EXT-24-envBraye_161020_155350/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse395/FEAR-Mouse-395-EXT-48_envC_blanc_161021_160944/';
    
    % M402
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse402/FEAR-Mouse-402-EXT-24-envB_raye_161026_164106/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse402/FEAR-Mouse-402-EXT-48-envC_blanc_161027_170226/';
    
    % M403
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse403/FEAR-Mouse-403-EXT-24-envB_raye_161026_171611/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse403/FEAR-Mouse-403-EXT-48-envC_blanc_161027_173548/';
    
    %M450
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-EXT-24-envB_161026_174952/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse450/FEAR-Mouse-450-EXT-48-envC_blanc_161027_180804/';
    
    %M451
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse451/FEAR-Mouse-451-EXT-24-envB_161026_182307/';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse451/FEAR-Mouse-451-EXT-48-envC_blanc_161027_183807/';
    
elseif strcmp(experiment, 'Sleep-OBX')
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150527-SLEEP-post/';
    
elseif strcmp(experiment, 'Fear-electrophy-opto')
    % Juillet 2016
    a=a+1; Dir.path{a}='/media/DataMobs31/OPTO_CHR2_DATA/Mouse-363/20160714-HAB-envB-laser10/FEAR-Mouse-363-14072016';
    a=a+1; Dir.path{a}='/media/DataMobs31/OPTO_CHR2_DATA/Mouse-363/20160714-HAB-envC-laser4/FEAR-Mouse-363-14072016';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160718-EXT-48h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160719-EXT-72h-laser4';
    
    a=a+1; Dir.path{a}='/media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160704-HAB-envB-laser10/FEAR-Mouse-367-14072016';
    a=a+1; Dir.path{a}='/media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160704-HAB-envC-laser4/FEAR-Mouse-367-14072016';    
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160717-EXT-24h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160718-EXT-48h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160719-EXT-72h-laser4';
    
    % Octobre 2016
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161016-HAB-envC-laser4';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161017-HAB-envB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161018-HABgrille';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161020-EXT-48h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161021-EXT-72h-laser4';
    
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161017-HAB-envC-laser4';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161018-HAB-envB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161018-HABgrille';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161020-EXT-48h-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161021-EXT-72h-laser4';
%     
    % Decembre 2016
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161218-HABenvC-laser4';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161219-HABenvB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161220-EXT-24h-envB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161221-EXT-48h-envC-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161222-EXT-72h-envC-laser4';

    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161218-HABenvC-laser4';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161219-HABenvB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161220-EXT-24h-envB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161221-EXT-48h-envC-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161222-EXT-72h-envC-laser4';

    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161218-HABenvC-laser4';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161219-HABenvB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161220-EXT-24h-envB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161221-EXT-48h-envC-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161222-EXT-72h-envC-laser4';

    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161218-HABenvC-laser4';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161219-HABenvB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161220-EXT-24h-envB-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161221-EXT-48h-envC-laser10';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161222-EXT-72h-envC-laser4';
    
    
%     % Decembre 2016
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-465/20161218-HAB-envC-laser4/FEAR-Mouse-465-18122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-465/20161219-HAB-envB-laser10/FEAR-Mouse-465-19122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-465/20161220-EXT-24h-envB-laser10/FEAR-Mouse-465-20122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-465/20161221-EXT-48h-envC-laser10/FEAR-Mouse-465-21122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-465/20161222-EXT-72h-envC-laser4/FEAR-Mouse-465-22122016';  
%     
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-466/20161218-HAB-envC-laser4/FEAR-Mouse-466-18122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-466/20161219-HAB-envB-laser10/FEAR-Mouse-466-19122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-466/20161220-EXT-24h-envB-laser10/FEAR-Mouse-466-20122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-466/20161221-EXT-48h-envC-laser10/FEAR-Mouse-466-21122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-466/20161222-EXT-72h-envC-laser4/FEAR-Mouse-466-22122016';  
%     
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-467/20161218-HAB-envC-laser4/FEAR-Mouse-467-18122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-467/20161219-HAB-envB-laser10/FEAR-Mouse-467-19122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-467/20161220-EXT-24h-envB-laser10/FEAR-Mouse-467-20122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-467/20161221-EXT-48h-envC-laser10/FEAR-Mouse-467-21122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-467/20161222-EXT-72h-envC-laser4/FEAR-Mouse-467-22122016';  
%     
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-468/20161218-HAB-envC-laser4/FEAR-Mouse-468-18122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-468/20161219-HAB-envB-laser10/FEAR-Mouse-468-19122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-468/20161220-EXT-24h-envB-laser10/FEAR-Mouse-468-20122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-468/20161221-EXT-48h-envC-laser10/FEAR-Mouse-468-21122016';  
%     a=a+1; Dir.path{a}='/media/DATAMobs55/Mouse-468/20161222-EXT-72h-envC-laser4/FEAR-Mouse-468-22122016';  
    
% 
%     a=a+1; Dir.path{a}='/media/DataMOBs57/Fear_July2017/Mouse-537/20170727-EXT24-laser13/FEAR-Mouse-537-27072017';
%     a=a+1; Dir.path{a}='/media/DataMOBs57/Fear_July2017/Mouse-540/20170727-EXT24-laser13/FEAR-Mouse-540-27072017';
%     a=a+1; Dir.path{a}='/media/DataMOBs57/Fear_July2017/Mouse-542/20170727-EXT24-laser13/FEAR-Mouse-542-27072017';
%     a=a+1; Dir.path{a}='/media/DataMOBs57/Fear_July2017/Mouse-543/20170727-EXT24-laser13/FEAR-Mouse-543-27072017';
%     
%     a=a+1; Dir.path{a}='/media/DataMOBs57/Fear_July2017/Mouse-537/20170728-EXT48-laser13/FEAR-Mouse-537-28072017';
%     a=a+1; Dir.path{a}='/media/DataMOBs57/Fear_July2017/Mouse-540/20170728-EXT48-laser13/FEAR-Mouse-540-28072017';
%     a=a+1; Dir.path{a}='/media/DataMOBs57/Fear_July2017/Mouse-542/20170728-EXT48-laser13/FEAR-Mouse-542-28072017';
%     a=a+1; Dir.path{a}='/media/DataMOBs57/Fear_July2017/Mouse-543/20170728-EXT48-laser13/FEAR-Mouse-543-28072017';
%     
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-611/20171005-EXT-24/FEAR-Mouse-611-05102017';
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-612/20171005-EXT-24/FEAR-Mouse-612-05102017';
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-613/20171005-EXT-24/FEAR-Mouse-613-05102017';
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-614/20171005-EXT-24/FEAR-Mouse-614-05102017';
% 
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-610/20171006-EXT-48/FEAR-Mouse-610-06102017';
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-611/20171006-EXT-48/FEAR-Mouse-611-06102017';
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-612/20171006-EXT-48/FEAR-Mouse-612-06102017';
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-613/20171006-EXT-48/FEAR-Mouse-613-06102017';
% a=a+1; Dir.path{a}='/media/DataMOBs57/Fear-Oct2017/Mouse-614/20171006-EXT-48/FEAR-Mouse-614-06102017';

% july 2017
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse540/20170727-EXT24-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse542/20170727-EXT24-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse543/20170727-EXT24-laser13';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse540/20170728-EXT48-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse542/20170728-EXT48-laser13';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse543/20170728-EXT48-laser13';

% Octobre 2017
% a=a+1; Dir.path{a}='';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse611/20171005-EXT-24';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse612/20171005-EXT-24';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse613/20171005-EXT-24';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse614/20171005-EXT-24';


a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse610/20171006-EXT-48';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse611/20171006-EXT-48';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse612/20171006-EXT-48';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse613/20171006-EXT-48';
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse614/20171006-EXT-48';

elseif strcmp(experiment, 'SleepStim')
    % oct 16
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
    % dec 16
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
    a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
    % march17
    a=a+1; Dir.path{a}='/media/DataMOBs61/Mouse496/20170404/FEAR-Mouse-496-04042017';  
    a=a+1; Dir.path{a}='/media/DataMOBs61/Mouse496/20170407/FEAR-Mouse-496-07042017';
    a=a+1; Dir.path{a}='/media/DataMOBs61/Mouse497/20170405/FEAR-Mouse-497-05042017';
    a=a+1; Dir.path{a}='/media/DataMOBs61/Mouse497/20170409_attention_rec_du_20170410/FEAR-Mouse-497-09042017';
    % july17
    a=a+1; Dir.path{a}='/media/DataMOBs61/Mouse-540/FEAR-Mouse-540-21092017';  
    a=a+1; Dir.path{a}='/media/DataMOBs61/Mouse-542/FEAR-Mouse-542-20092017';
    a=a+1; Dir.path{a}='/media/DataMOBs61/Mouse-543/FEAR-Mouse-543-19092017';
end



% -------------------------------------------------------------------------
%% names

for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i},'Mouse-');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}(strfind(Dir.path{i},'Mouse'):strfind(Dir.path{i},'Mouse')+7);
    else
        Dir.name{i}=['Mouse',Dir.path{i}(temp+6:temp+8)];
    end
    %fprintf(Dir.name{i});
end

% -------------------------------------------------------------------------
%% Strain
try
for i=1:length(Dir.path)
    for mi=1:length(MICEgroups)
        eval(['temp(mi)=sum(ismember(str2double(Dir.name{i}(6:8)),',MICEgroups{mi},'));']);
    end
    
    if sum(temp)==0
        Dir.group{i}=nan;
    else
        Dir.group{i}=MICEgroups{temp==1};
    end
    
end
catch
    keyboard
end
% -------------------------------------------------------------------------
%% session / environment

for i=1:length(Dir.path)
    %     nameSession={'HAB','COND','EXT'};
    %     nameEnvt={'envC','envB','pleth'};
    
    for mi=1:length(nameSession)
        if ~isempty(strfind(lower(Dir.path{i}),lower(nameSession{mi})))
            tempS{i}=nameSession{mi};
        end
    end
    
    try tempS{i};
    catch
        if ~isempty(strfind(lower(Dir.path{i}),lower('Ext')))
            if ~isempty(strfind(lower(Dir.path{i}),lower('24')))
                tempS{i}='EXT-24h';
            elseif ~isempty(strfind(lower(Dir.path{i}),lower('48')))
                tempS{i}='EXT-48h';
                %% added by SB
            elseif  ~isempty(strfind(lower(Dir.path{i}),lower('Pleth')))
                tempS{i}='EXT-Pleth';
                %%
            end
        end
    end
    
    try tempS{i};
    catch
        if ~isempty(strfind(lower(Dir.path{i}),lower('Ext')))
            
            if ~isempty(strfind(lower(Dir.path{i}),lower('envC')))
                tempS{i}='EXT-24h';
            elseif ~isempty(strfind(lower(Dir.path{i}),lower('envB')))
                tempS{i}='EXT-48h';
            end
        end
    end
    
    
    
    for mi=1:length(nameEnvt)
        if ~isempty(strfind(lower(Dir.path{i}),lower(nameEnvt{mi})))
            Environment{i}=nameEnvt{mi};
        end
        try
            Environment{i};
        catch
            if exist('tempS','var') && strcmp(tempS{i},'COND')
                Environment{i}='grille';
            else
                Environment{i}='NaN';
            end
        end
    end
    
    if exist('tempS','var') ,
        Dir.Session{i}=[tempS{i} '-' Environment{i}];
    else
        Dir.Session{i}='';
    end
end


% -------------------------------------------------------------------------
%% Treatment
for i=1:length(Dir.path)
    %     nameSession={'HAB','COND','EXT'};
    %     nameEnvt={'envC','envB','pleth'};
    
    for mi=1:length(nameTreatment)
        if ~isempty(strfind(Dir.path{i},nameTreatment{mi}))
            tempT{i}=nameTreatment{mi};
        end
    end
    
    if exist('tempT{i}','var') ,
        Dir.Treatment{i}=[tempT{i}];
    else
        Dir.Treatment{i}='control';
    end
end

% -------------------------------------------------------------------------
%% checks
if check,
    for i=1:length(Dir.path)
        disp([Dir.name{i},' -> ',Dir.group{i},'  ',Dir.Session{i} ]);
    end
end

% -------------------------------------------------------------------------
%% change '\' into '/'
for man =1:length(Dir.path)
    Dir.path{man}(strfind(Dir.path{man},'\'))='/';
end
