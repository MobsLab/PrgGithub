function IM=GetAFrame_Webcam(vid,IRLimits)
trigger(vid);
IM=double(getdata(vid,1,'uint8'))/256;
end
