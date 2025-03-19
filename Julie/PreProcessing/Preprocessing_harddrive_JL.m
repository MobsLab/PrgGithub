%Preprocessing_harddrive_DB
% 08.03.2018 DB

function Preprocessing_harddrive_JL(dirin, indir, indir_beh, postorpre)

try
   dirin;
catch
   dirin={'/media/mobsmorty/DataMOBS79NEW/test/'
   };
end

try
   postorpre;
catch
   postorpre = 0';
end
 
for i=1:length(dirin)
    Dir=dirin{1};
    cd(Dir);
    
    %% Get info about the dataset
    GetBasicInfoRecord
    
    
%%    
try
   indir;
catch
   indir = 'PAG-Mouse-783-09092018-ContextC-Calib-0V_180909_201328/';
end

try
   indir_beh;
catch
   indir_beh='ERC-Mouse-783-09092018-Calibration_00/';
end
    
    %% NDM shit
    if postorpre == 0
        NDM_DB(Dir, indir, indir_beh)
    else
        NDM_DB_pre_post(Dir, indir, indir_beh, postorpre)
    end
end
end