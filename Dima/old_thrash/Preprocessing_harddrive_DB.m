%Preprocessing_harddrive_DB
% 08.03.2018 DB

function Preprocessing_harddrive_DB(dirin, indir, indir_beh, postorpre)

try
   dirin;
catch
   dirin={'/media/mobsrick/DataMOBS87/Mouse-798/10012019/BaselineSleep/'
   };
end

try
   postorpre;
catch
   postorpre = 0;
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
   indir = 'ERC-Mouse-798-20190110-BaselineSleep_190110_145248/';
end

try
   indir_beh;
catch
   indir_beh= 'SLEEP-Mouse-798-10012019-Sleep_00/';
end
    
    %% NDM shit
    if postorpre == 0
        NDM_DB(Dir, indir, indir_beh)
    else
        NDM_DB_pre_post(Dir, indir, indir_beh, postorpre)
    end
end
end
