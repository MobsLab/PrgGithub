%%

CondExploSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondExplo')))));
CondShockSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondBlockedSh')))));
CondSafeSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondBlockedSa')))));

ExtShockSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'ExtinctionBlockedSh')))));
ExtSafeSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'ExtinctionBlockedSa')))));

if or(length(CondSess.(Mouse_names{mouse}))==9 , length(CondSess.(Mouse_names{mouse}))==12) % Perfect cases
    
    n=1; m=1; CondSess2.(Mouse_names{mouse})={}; ExtSess2.(Mouse_names{mouse})={};
    for j=1:ceil(sum(length(CondExploSess.(Mouse_names{mouse}))+length(CondShockSess.(Mouse_names{mouse}))+length(CondSafeSess.(Mouse_names{mouse})))/3)
        if ~isempty(CondSafeSess.(Mouse_names{mouse}){j})
            CondSess2.(Mouse_names{mouse}){n}=CondExploSess.(Mouse_names{mouse}){j};
            n=n+1;
        end
        if ~isempty(CondShockSess.(Mouse_names{mouse}){j})
            CondSess2.(Mouse_names{mouse}){n}=CondShockSess.(Mouse_names{mouse}){j};
            n=n+1;
        end
        if ~isempty(CondSafeSess.(Mouse_names{mouse}){j})
            CondSess2.(Mouse_names{mouse}){n}=CondSafeSess.(Mouse_names{mouse}){j};
            n=n+1;
        end
    end
    
    for j=1:ceil(sum(length(ExtShockSess.(Mouse_names{mouse}))+length(ExtSafeSess.(Mouse_names{mouse})))/2)
        try
            if ~isempty(ExtShockSess.(Mouse_names{mouse}){j})
                ExtSess2.(Mouse_names{mouse}){m}=ExtShockSess.(Mouse_names{mouse}){j};
                m=m+1;
            end
            
            if ~isempty(ExtSafeSess.(Mouse_names{mouse}){j})
                ExtSess2.(Mouse_names{mouse}){m}=ExtSafeSess.(Mouse_names{mouse}){j};
                m=m+1;
            end
        end
    end
    
    CondSess.(Mouse_names{mouse}) = CondSess2.(Mouse_names{mouse});
    ExtSess.(Mouse_names{mouse}) = ExtSess2.(Mouse_names{mouse});
    
    clear CondSess2 ExtSess2
    
else
    n=1;
    if length(CondSess.(Mouse_names{mouse}))>8
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PreDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PreDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PreDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PreDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PreDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PreDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PreDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PreDrug/Cond2/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PreDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PreDrug/Cond2/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PreDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PreDrug/Cond2/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond2/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond2/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond2/')))));
            n=n+1;
        end
                if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond3/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond3/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond3/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond3/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond3/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond3/')))));
            n=n+1;
        end
                if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond4/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond4/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond4/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond4/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond4/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond4/')))));
            n=n+1;
        end
        
        n=1;
        for i=1:4
            if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , ['ExtinctionBlockedShock_PostDrug/Ext' num2str(i)]))))))
                ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , ['ExtinctionBlockedShock_PostDrug/Ext' num2str(i)])))));
                n=n+1;
            end
            if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , ['ExtinctionBlockedSafe_PostDrug/Ext' num2str(i)]))))))
                ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , ['ExtinctionBlockedSafe_PostDrug/Ext' num2str(i)])))));
                n=n+1;
            end
        end
        
    else
        
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond1/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond1/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond2/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond2/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond2/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond2/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond3/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondExplo_PostDrug/Cond3/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond3/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedShock_PostDrug/Cond3/')))));
            n=n+1;
        end
        if ~isempty(CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond3/'))))))
            CondSess2.(Mouse_names{mouse})(n) = CondSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(CondSess.(Mouse_names{mouse}) , 'CondBlockedSafe_PostDrug/Cond3/')))));
            n=n+1;
        end
        
        n=1;
        if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedShock_PostDrug/Ext1'))))))
            ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedShock_PostDrug/Ext1')))));
            n=n+1;
        end
        if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedSafe_PostDrug/Ext1'))))))
            ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedSafe_PostDrug/Ext1')))));
            n=n+1;
        end
        if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedShock_PostDrug/Ext2'))))))
            ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedShock_PostDrug/Ext2')))));
            n=n+1;
        end
        if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedSafe_PostDrug/Ext2'))))))
            ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedSafe_PostDrug/Ext2')))));
            n=n+1;
        end
        if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedShock_PostDrug/Ext3'))))))
            ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedShock_PostDrug/Ext3')))));
            n=n+1;
        end
        if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedSafe_PostDrug/Ext3'))))))
            ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedSafe_PostDrug/Ext3')))));
            n=n+1;
        end
        if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedShock_PostDrug/Ext4'))))))
            ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedShock_PostDrug/Ext4')))));
            n=n+1;
        end
        if ~isempty(ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedSafe_PostDrug/Ext4'))))))
            ExtSess2.(Mouse_names{mouse})(n) = ExtSess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(ExtSess.(Mouse_names{mouse}) , 'ExtinctionBlockedSafe_PostDrug/Ext4')))));
            n=n+1;
        end
    end
    CondSess.(Mouse_names{mouse}) = CondSess2.(Mouse_names{mouse});
    ExtSess.(Mouse_names{mouse}) = ExtSess2.(Mouse_names{mouse});
    
    clear CondSess2 ExtSess2
end

