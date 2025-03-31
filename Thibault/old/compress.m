%compress - 
%	compress into an .avi video all the frames included in a folder as classical .mat files
%	You can give the function the path to this folder, or execute it directly inside this folder
%
%----INPUT----
% (myFolder)						path of the folder with all the .mat files (optional). If nothing is given, the function will operate in the current directory
% (name)							name of the video you want to create (optional)
% 
%
%----OUTPUT----
% none
%
%
%
%
% Assumptions : 
% 	the frames are in a .mat file with a structure inside called datas
%	the frame itself should be an array in the field datas.image
%


% Copyright (C) 2017 by Thibault Balenbois
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.


function compress(varargin)

	if nargin == 0
		myFolder = pwd;
		Videoname = 'compressed_video';
	elseif nargin == 1
		myFolder = varargin{1};
		Videoname = 'compressed_video';
	elseif nargin == 2
		myFolder = varargin{1};
		Videoname = varargin{2};
	else
		myFolder = varargin{1};
		Videoname = varargin{2};
		warning('Too many arguments. Only two needed.');
	end

	if ~isdir(myFolder)
	    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
	    uiwait(warndlg(errorMessage));
	    return;
	end
	cd(myFolder);


	%%-- generates list of mat files
	filePattern = fullfile(myFolder, '*.mat');
	matFiles = dir(filePattern);

	%%-- the process of generating a video implies the creation of a Writer type object
	writerObj = VideoWriter([Videoname,'.avi']);
	open(writerObj);


	for frameNumber = 1 : length(matFiles)
		%%-- we generate the full name of this frame's file and load it.
	    baseFileName = matFiles(frameNumber).name;
	    fullFileName = fullfile(myFolder, baseFileName);
	    load(fullFileName);

	    %%-- We format the matrix into an image and save it for the video
		frame.cdata = cat(3,datas.image,datas.image,datas.image);
		frame.colormap = [];
	    writeVideo(writerObj,frame);
	    fprintf(1, 'Now reading %s\n', fullFileName);
	end

	close(writerObj);
	clearvars