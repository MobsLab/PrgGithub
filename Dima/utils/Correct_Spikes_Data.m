dirin = {'/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/01042018/UMaze/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/01042018/UMaze2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/15032018/FindSleep/SLEEP-Mouse-711-15032018-Sleep_00/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/15032018/Hab/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-0,5V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-0V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-1,5V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-1V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-2,5V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/Calib-2V/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/PostSleep/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/16032018/PreSleep/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/Cond1/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/Cond2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/Cond3/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/Cond4/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Hab/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/PostSleep/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/PreSleep/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPost/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPost/TestPost1/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPost/TestPost2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPost/TestPost3/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPost/TestPost4/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/TestPre1/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/TestPre2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/TestPre3/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/TestPre/TestPre4/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/18032018/TestPost/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/18032018/TestPost/TestPost1/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/18032018/TestPost/TestPost2/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/18032018/TestPost/TestPost3/';
    '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/18032018/TestPost/TestPost4/'
};

a=1;
for i=1:length(dirin)
    disp(dirin{i});
        cd(dirin{i})
            
        if exist('SpikeData.mat') == 2
            %% corect S
            disp(['Correction ' dirin{i}]);
            clear S
            load('SpikeData.mat','S');
            S = tsdArray(S);
            save('SpikeData.mat','S','-append')                    
                
            clear S
        end

end