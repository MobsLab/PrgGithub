

% 1) delete bad spectrograms, bad LFP.mat in /session_that_you_want_to_correct

% 2) choose a session with not this issue : /good_session

% 3) cd(/good_session)

clear all
load('ExpeInfo.mat')
BaseFileName = ['M' num2str(ExpeInfo.nmouse) '_' ExpeInfo.date '_' ExpeInfo.SessionType];
FinalFolder = cd;
is_OpenEphys = false;

SetCurrentSession([BaseFileName '.xml'])

% 4)
% cd(/session_that_you_want_to_correct)

SessLength = MakeData_LFP(pwd);

% do you spectrograms

LowSpectrumSB([pwd filesep],1,'Ref');










