clear all
close all

Dir{1} = PathForExperimentsSleepWithDrugs('FLX_Ch_Baseline');
mouse = 3
for day=1:2
    try cd(Dir{1}.path{mouse}{day})
        if isfile('H_Low_Spectrum.mat') & isfile('SleepSubstages.mat')
            load('H_Low_Spectrum.mat')
            load('SleepSubstages.mat')
            Sptsd= tsd(Spectro{2}*1e4,Spectro{1});
            subplot(1,2,1)
            plot(nanmean(Data(Restrict(Sptsd,Epoch{5}))))
            hold on
            subplot(1,2,2)
            plot(nanmean(Data(Restrict(Sptsd,Epoch{4}))))
            hold on
        else
        end
    catch
    end
end

Dir{2} = PathForExperimentsSleepWithDrugs('FLX_Ch_Admin');
for day = 1:size(Dir{2}.path{1,mouse},2)
    cd(Dir{2}.path{mouse}{day})
    if isfile('H_Low_Spectrum.mat') & isfile('SleepSubstages.mat')
        load('H_Low_Spectrum.mat')
        load('SleepSubstages.mat')
        Sptsd= tsd(Spectro{2}*1e4,Spectro{1});
        subplot(1,2,1)
        plot(nanmean(Data(Restrict(Sptsd,Epoch{5}))))
        subplot(1,2,2)
        plot(nanmean(Data(Restrict(Sptsd,Epoch{4}))))
    else
    end
end

    
    title('875 HPC spectrum Wake')
    
        title('875 HPC spectrum REM')

legend({'Baseline','Flx5','Flx11','Flx18'})


Ep
                    Sptsd2= Data(Restrict(Sptsd,Epoch{4})
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
