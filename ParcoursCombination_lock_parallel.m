%ParcoursCombination_lock_parallel





%try
    
    
    for NumMouse=1:5

        matlabpool open local 6

        combination_lock_parallel

        matlabpool close

    end
    
% 
% catch
%     
%     matlabpool close
%     
% end

