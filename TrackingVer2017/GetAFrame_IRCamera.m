function im=GetAFrame_IRCamera(vid,IRLimits)
im=double(vid.ThermalImage.ImageProcessing.GetPixelsArray);
im=(im-IRLimits(1))./(IRLimits(2)-IRLimits(1));
end