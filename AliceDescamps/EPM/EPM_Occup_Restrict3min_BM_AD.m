

Dir_EPM_sal = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_sal = RestrictPathForExperiment(Dir_EPM_sal,'nMice',[1449,1450,1451])
Dir_EPM_cno = PathForExperiments_EPM_MC('EPM_Post_SD');
% Dir_EPM_cno = RestrictPathForExperiment(Dir_EPM_cno,'nMice',[1429,1430,1431,1432])

%%
for i = 1:length(Dir_EPM_sal.path)
    cd(Dir_EPM_sal.path{i}{1})
    load ('behavResources.mat')
    Xtsd_all(i) = Restrict(Xtsd , intervalSet(0,180e4));
    Ytsd_all(i) = Restrict(Ytsd , intervalSet(0,180e4));
    clear Above_Arm Below_Arm
    Above_Arm = thresholdIntervals(Ytsd_all(i) , 58 ,'Direction', 'Above');
    Below_Arm = thresholdIntervals(Ytsd_all(i) , 51 ,'Direction', 'Below');
    Prop(i) = length(Range(Restrict(Xtsd_all(i) , or(Above_Arm , Below_Arm))))/length(Range(Xtsd_all(i)));
end



for i=1:5
    subplot(2,3,i)
    plot(Data(Xtsd_all(i)) , Data(Ytsd_all(i)))
end




for i = 1:length(Dir_EPM_cno.path)
    cd(Dir_EPM_cno.path{i}{1})
    load ('behavResources.mat')
    Xtsd_all2(i) = Restrict(Xtsd , intervalSet(0,180e4));
    Ytsd_all2(i) = Restrict(Ytsd , intervalSet(0,180e4));
    clear D_X D_Y
    D_X = Data(Xtsd_all2(i));
    D_Y = Data(Ytsd_all2(i));
    if i==5
        ind= -D_X-D_Y+2>0; ind2 = -D_X-D_Y+60<0;
    else
        ind= -D_X-D_Y+52>0; ind2 = -D_X-D_Y+60<0;
    end
    Prop2(i) = length(D_X(or(ind,ind2)))/length(D_X);
end

figure
for i=1:5
    subplot(2,3,i)
    plot(Data(Xtsd_all2(i)) , Data(Ytsd_all2(i)))
end


PlotErrorBarN_KJ({Prop Prop2},'paired',0)



