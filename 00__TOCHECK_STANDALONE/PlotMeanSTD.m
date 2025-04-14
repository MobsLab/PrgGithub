function PlotMeanSTD(tps,val,smo,coulor,fig)

try
    coulor;
catch
    coulor='k';
end

try 
    smo;
catch
    smo=0;
end

try
    fig;
catch
    fig=1;
end

if fig==1
    figure('color',[1 1 1])
end

hold on
if smo==0
  
plot(tps,(nanmean(val)),'linewidth',2,'color',coulor)
plot(tps,(nanmean(val)-stdError(val(~isnan(val)))),'color',coulor)
plot(tps,(nanmean(val)+stdError(val(~isnan(val)))),'color',coulor)

else
    
plot(tps,smooth(nanmean(val),smo),'linewidth',2,'color',coulor)
plot(tps,smooth(nanmean(val)-stdError(val(~isnan(val))),smo),'color',coulor)
plot(tps,smooth(nanmean(val)+stdError(val(~isnan(val))),smo),'color',coulor)

end
