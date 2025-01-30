disp(' ');
disp('Get INTAN Accelerometer')
try
    load('LFPData/InfoLFP.mat')
    cha=InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
    
    if isempty(cha)
        disp('No Accelero found in InfoLFP.mat')
    else
        clear X Y Z
        disp('... Loading LFP.mat (wait!)')
        X=load(['LFPData/LFP',num2str(cha(1)),'.mat'],'LFP');
        Y=load(['LFPData/LFP',num2str(cha(2)),'.mat'],'LFP');
        Z=load(['LFPData/LFP',num2str(cha(3)),'.mat'],'LFP');
        
        
        disp('... Creating movement Vector')
        MX=Data(X.LFP);
        MY=Data(Y.LFP);
        MZ=Data(Z.LFP);
        Rg=Range(X.LFP);
        Acc=MX.*MX+MY.*MY+MZ.*MZ;
        %Acc=sqrt(MX.*MX+MY.*MY+MZ.*MZ);
        disp('... DownSampling at 50Hz');
        MovAcctsd=tsd(Rg(1:25:end),double(abs([0;diff(Acc(1:25:end))])));
        
        try
            save('behavResources','MovAcctsd','-append')
        catch
            save('behavResources','MovAcctsd')
        end
        disp('Done')
    end
catch
    disp('problem for accelero')
end
clear MovAcctsd useMovAcctsd X Y Z MX MY MZRg Acc cha InfoLFP