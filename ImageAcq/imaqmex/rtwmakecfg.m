function makeInfo=rtwmakecfg()
%RTWMAKECFG Add include and source directories to RTW make files.
%  makeInfo=RTWMAKECFG returns a structured array containing
%  following fields:
%
%     makeInfo.includePath - cell array containing additional include
%                            directories. Those directories will be 
%                            expanded into include instructions of rtw 
%                            generated make files.
%     
%     makeInfo.sourcePath  - cell array containing additional source
%                            directories. Those directories will be
%                            expanded into rules of rtw generated make
%                            files.
%
%     makeInfo.library     - structure containing additional runtime library
%                            names and module objects.  This information
%                            will be expanded into rules of rtw generated make
%                            files.

% Copyright 2001-2010 The MathWorks, Inc.
% $Revision: 1.1.6.10 $ $Date: 2010/04/21 21:29:03 $
  
makeInfo.includePath = {...
    fullfile(matlabroot, 'toolbox', 'imaq', 'imaqblks', 'include')};
makeInfo.sourcePath = {};
makeInfo.precompile = 0;
makeInfo.library = [];
