function BehStateScoring(dset,state)

% USAGE:
%     BehStateScoring(fabasename,state)
%     
% Manual (and possibly automatic) sleep scoring using animal speed as additional info
% 
% INPUT:
%     - fbasename: file base name (could be 'pwd' for pratical use)
%     - state: state to be identified (e.g. 'SWS, 'REM',...)
%         
% Adrien Peyrache, 2012
% calling Anton Sirota's function CheckEEGStates

[rootdir fbasename dummy] = fileparts(dset);
[X,Y,V,GoodRanges,ep] = LoadPosition_Wrapper(fbasename);

CheckEegStates(fbasename,state, {Range(X,'s'),[],V,'plot'})