function [wav,Nwav,mVal,mTim,dt,times]=loadSMR(nom,voie,keyb)


le=length(nom);
nom2=nom;

% for i=1:le
%     if nom(i)=='-'
%         nom2(i)='_';
%     end
% end

% 
% try
% data_dir = 'D:\My Dropbox\MasterMarie\Data\DataSmrAvi\';
% eval(['cd(''',data_dir,''')'])
% catch
% data_dir = '/Users/karimbenchenane/Dropbox/MasterMarie/Data/DataSmrAvi/';
% eval(['cd(''',data_dir,''')'])
% end

try
    
for i=1:length(voie);
            
        eval(['load ',nom,'.mat ',[nom2,'_Ch',num2str(voie(i))]])
        eval(['dt=',nom2,'_Ch',num2str(voie(i)),'.interval;'])
        
        %         try
            eval(['wav{i}=-double(',nom2,'_Ch',num2str(voie(i)),'.values);'])
            
            len(i)=length(wav{i});
            Nwav(i)=voie(i);
end
        times = dt*[0:1:max(len)-1]'*10000;

catch
    
    wav={};
    Nwav=0;
    times=0;
    dt=0;
    
end


%----------------------------------------------------------------
%----------------------------------------------------------------
% Resampling
%----------------------------------------------------------------
%----------------------------------------------------------------
     if 0   
        times=times(1:20:end);

        for i=1:length(wav)
            wav{i}=wav{i}(1:20:end);
        end
     end
        
%----------------------------------------------------------------
%----------------------------------------------------------------
%----------------------------------------------------------------        
        
        
        try
            eval(['load ',nom,'.mat ',[nom2,'_Ch',num2str(keyb)]])
            eval(['mTim=',nom2,'_Ch',num2str(keyb),'.times*10000;'])
        catch
            mTim=[];
        end

        try
            eval(['mVal=',nom2,'_Ch',num2str(keyb),'.codes;'])
        catch
            mVal=[];
        end

end


