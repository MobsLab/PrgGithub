%GetCommonGlobalVariables
clear -global ref Ratio_IMAonREAL mask enableTrack intermed
global a vid frame_rate IRLimits
global PixelsUsed;  % maxsize in pixels
global se;
global maxth_immob; maxth_immob=0.05;
global intermed
intermed=load('InfoTrackingTemp.mat');
global ref; ref=intermed.ref;
global mask; mask=intermed.mask;
global Ratio_IMAonREAL; Ratio_IMAonREAL=intermed.Ratio_IMAonREAL;
global BW_threshold; if isfield(intermed,'BW_threshold'), BW_threshold=intermed.BW_threshold; else, BW_threshold=0.5; end
global smaller_object_size; if isfield(intermed,'smaller_object_size'), smaller_object_size=intermed.smaller_object_size; else, smaller_object_size=30; end
global sm_fact; if isfield(intermed,'sm_fact'), sm_fact=intermed.sm_fact; else, sm_fact=1; end
global strsz; if isfield(intermed,'strsz'), strsz=intermed.strsz; else, strsz=4; end, se= strel('disk',strsz);
global SrdZone; if isfield(intermed,'SrdZone'), SrdZone=intermed.SrdZone; else, SrdZone=20; end
global th_immob; if isfield(intermed,'th_immob'), th_immob=intermed.th_immob; else, th_immob=20; end
global guireg_fig
global TrackingFunctions
global time_image;time_image = 1/frame_rate;
global UpdateImage; UpdateImage=ceil(frame_rate/10); % update every n frames the picture shown on screen to show at 10Hz
