function IRLimits=CalibrationInfraRedCamera(vid)
% This function allows you to deal with the fact that the image given by
% the camera is not in degrees celsius. The function that allows for the
% conversion is very time consuming and the relationship is non linear so a look-up table is constructed so that you
% can do the conversion later



%% initialize varaibles
AllVals_IR_Calib=[];
go_calibration=1;
TempOutput=[12:0.01:45];
ValuesInput=[];
numfr=1;
lowLim=18;
highLim=39.5;

CalbMethod=questdlg('How do you want to do the calibration?','Calibration method','Load file','Manual','Manual');

switch CalbMethod
    case 'Load file'
        [Filename,Pathname]=uigetfile('*.mat','Select the file with the calibration info');
        load([Pathname,Filename],'TempOutput','ValuesInput')
        MinTemp=find(TempOutput>lowLim,1,'first');
        MaxTemp=find(TempOutput>highLim,1,'first');
        IRLimits=[ValuesInput(MinTemp),ValuesInput(MaxTemp)];
        if exist('InfoTrackingTemp.mat','file')
            save('InfoTrackingTemp.mat','TempOutput','ValuesInput','-append')
        else
            save('InfoTrackingTemp.mat','TempOutput','ValuesInput')
        end
    case 'Manual'
        
        Calibration_fig=figure('units','normalized',...
            'position',[0.15 0.1 0.5 0.8],...
            'numbertitle','off',...
            'name','Online Mouse Tracking : Calibrating the IR camera',...
            'menubar','none',...
            'tag','Calibration_fig');
        
        
        initbutton=uicontrol(Calibration_fig,'style','pushbutton',...
            'units','normalized',...
            'position',[0.01 0.2 0.08 0.05],...
            'string','Stop',...
            'callback', @stop_calibration);
        while (go_calibration == 1)
            %% loop activated
            im=(vid.ThermalImage.ImageProcessing.GetPixelsArray);
            figure(Calibration_fig)
            for kk=1:240
                for tt=1:320
                    NewMat(kk,tt)=vid.ThermalImage.GetValueFromSignal(im(kk,tt));
                end
            end
            im=double(im);
            AllVals_IR_Calib=[AllVals_IR_Calib;NewMat(:),im(:)];
            imagesc(NewMat)
            axis image
            colormap(redblue)
            title(num2str(numfr))
            colorbar
            caxis([15 45])
            numfr=numfr+1;
            pause(0.1)
        end
end



    function stop_calibration(obj,event)
        go_calibration=0;
        plot(AllVals_IR_Calib(:,1),AllVals_IR_Calib(:,2),'o'), hold on
        [C,IA,IC]=unique(AllVals_IR_Calib(:,1));
        X=AllVals_IR_Calib(IA,1);
        Y=AllVals_IR_Calib(IA,2);
        ValuesInput = interp1(X,Y,TempOutput);
        hold on
        plot(TempOutput,ValuesInput,'.')
        MinTemp=find(TempOutput>lowLim,1,'first');
        MaxTemp=find(TempOutput>highLim,1,'first');
        IRLimits=[ValuesInput(MinTemp),ValuesInput(MaxTemp)];
        legend({'RealData','Fit'})
        xlabel('Degrees'), ylabel('AU')
        pause(5)
        if exist('InfoTrackingTemp.mat','file')
            save('InfoTrackingTemp.mat','TempOutput','ValuesInput','AllVals_IR_Calib','-append')
        else
            save('InfoTrackingTemp.mat','TempOutput','ValuesInput','AllVals_IR_Calib')
        end
        close(Calibration_fig)
        delete(Calibration_fig)
    end

end

