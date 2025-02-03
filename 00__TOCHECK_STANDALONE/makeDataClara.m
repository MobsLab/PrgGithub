%makeDataBulbe
clear all


%% Initiation
warning off
res=pwd;
try, setCu; catch, setCu=0;end


clear S LFP TT cellnames lfpnames

%% ------------------------------------------------------------------------
%------------------------- LFP --------------------------------------------
%--------------------------------------------------------------------------
if 1
    disp(' '); disp('LFP Data')
    
    try clear reverseData;load([res,'/LFPData/ErrorREVERSE.mat'],'reverseData'); disp('!!! Reversing LFP signal !');end
    
    try 
        load([res,'/LFPData/InfoLFP.mat'],'InfoLFP');
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))],'LFP');
        FragmentLFP='n';
    catch
        
        try
            load LFPData
            Range(LFP{1});
            FragmentLFP=input('LFPData.mat exists, do you want to fragment LFPData.mat in folder LFPData (y/n) ? ','s');
        catch
            FragmentLFP='y';
        end
    end
    
    if FragmentLFP=='y';
        try
          load('LFPData/InfoLFP.mat')

            % LFPs
            disp(' ');
            disp('...Creating LFPData.mat')
            
            if setCu==0
                SetCurrentSession
                SetCurrentSession('same')
                setCu=1;
            end
            
            for i=1:length(InfoLFP.channel)
                LFP_temp=GetLFP(InfoLFP.channel(i));
                disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
                LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                if exist('reverseData','var'), LFP=tsd(LFP_temp(:,1)*1E4,-LFP_temp(:,2));end
                save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'LFP');
                clear LFP LFP_temp
            end
            disp('Done')
        catch
            disp('problem for lfp')
            keyboard
        end
    else
        disp('Done')
    end
end

load('LFPData/LFP3.mat')
save('LFPData/LFP3old.mat','LFP')
LFP=FilterLFP(LFP,[0.1 30],1024);
save('LFPData/LFP3.mat','LFP')
filename=strcat(cd,filesep);
LowSpectrumSB(filename,3,'Respi');
disp('Bulb spectrum done')

fig=figure;
load('Respi_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
hold on
load('LFPData/LFP1.mat')
plot(Range(LFP,'s'),Data(LFP)/1e4)
load('LFPData/LFP2.mat')
hold on,plot(Range(LFP,'s'),Data(LFP)/1e4,'r')
saveas(fig,'BreathingAndSound.fig')
saveas(fig,'BreathingAndSound.png')



