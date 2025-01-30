dirin = {
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-05V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-0V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-1V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-2V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-15V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/Calib/Calib-25V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/PostSleep/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/16072018/PreSleep/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Cond/Cond1/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Cond/Cond2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Cond/Cond3/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Cond/Cond4/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/Hab/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/PostSleep/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/PostSleep2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/PreSleep/';
%     '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPost/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPost/TestPost1/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPost/TestPost2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPost/TestPost3/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPost/TestPost4/';
%     '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPre/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPre/TestPre1/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPre/TestPre2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPre/TestPre3/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/17072018/TestPre/TestPre4/';
%     '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/18072018/TestPost/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/18072018/TestPost/TestPost1/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/18072018/TestPost/TestPost2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/18072018/TestPost/TestPost3/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/18072018/TestPost/TestPost4/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/20072018/SleepManual/';
%     '/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/28022018/TestPost/TestPost3/';
%     '/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/28022018/TestPost/TestPost3/';
%     '/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/28022018/TestPost/TestPost4/';
};

a=1;
for i=1:length(dirin)
    disp(dirin{i});
        cd(dirin{i})
            
        if exist('behavResources.mat') == 2
            %% corect Vtsd
            disp(['Correction ' dirin{i}]);
            clear Vtsd Ytsd
            load('behavResources.mat','Ytsd','Vtsd');
            tps = Range(Ytsd);
            Vtsd=tsd(Range(Vtsd),Data(Vtsd)./diff(Range(Ytsd,'s')));
            save('behavResources.mat','Vtsd','-append')                    
                
            clear Vtsd Ytsd
                
            SpeedCorrected=1;
            save('SpeedCorrected.mat','SpeedCorrected')
        end

end