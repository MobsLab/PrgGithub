%readFrames - 
%	reads an AVI video and extract all frames, than saves them in the usual MOBS way.
%	It requires the exact name of the video.
%	
%
%----INPUT----
% VideoName						Name of the video you want to extract
% (Path)						path of the folder where you want to see the frames (optional)
% 
%
%----OUTPUT----
% none
%
%
%
%
% Assumptions : 
% 	this was never tested on another video than a .avi file, but it should work on other format (provided you're not using Linux)
%	the video has to be black and white. Anyway we're only using the first color so you better hope it's black and white
%
%
%
% Copyright (C) 2017 by Thibault Balenbois
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.


function readFrames(VideoName, varargin)

	ReaderObj = VideoReader(VideoName);

	idx_frame = 0;
	while hasFrame(ReaderObj)
		idx_frame = idx_frame +1;
		frame = readFrame(ReaderObj);
		datas.image = frame(:,:,1);

		fileName = 'frame';
		fileName(1,11-floor(log10(idx_frame)):11)=num2str(idx_frame);
		fileName(1,6:11-1-floor(log10(idx_frame)))=num2str(0);
		if nargin>1
			fileName = [varargin{1},'/',fileName];
		end
		save(fileName,'datas','-v7.3');

		if floor(idx_frame/10)==idx_frame/10
			disp(['reading video, current frame is ',num2str(idx_frame)]);
		end
	end
