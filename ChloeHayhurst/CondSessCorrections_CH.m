
CondExploSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondExplo')))));
CondShockSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondBlockedSh')))));
CondSafeSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondBlockedSa')))));
ExtShockSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'ExtinctionBlockedSh')))));
ExtSafeSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'ExtinctionBlockedSa')))));


if length(CondSess.(Mouse_names{mouse}))==15 % Long Protocol Sleep Rip
    n=1; m=1; CondSess2.(Mouse_names{mouse})={};
    for j=1:ceil(sum(length(CondExploSess.(Mouse_names{mouse}))+length(CondShockSess.(Mouse_names{mouse}))+length(CondSafeSess.(Mouse_names{mouse})))/3)
        if ~isempty(CondExploSess.(Mouse_names{mouse}){j})
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
    
    n=1; m=1; ExtSess2.(Mouse_names{mouse})={};
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
    CondPreSess.(Mouse_names{mouse}) = CondSess2.(Mouse_names{mouse})(1:9);
    CondPostSess.(Mouse_names{mouse}) = CondSess2.(Mouse_names{mouse})(10:length(CondSess2.(Mouse_names{mouse})));
    ExtPreSess.(Mouse_names{mouse}) = ExtSess2.(Mouse_names{mouse})(1:6);
    ExtPostSess.(Mouse_names{mouse}) = ExtSess2.(Mouse_names{mouse})(7:length(ExtSess2.(Mouse_names{mouse})));
    FirstExtPreSess.(Mouse_names{mouse}) = ExtSess2.(Mouse_names{mouse})(1,4);
    clear CondSess2 ExtSess2
    
    
elseif length(CondSess.(Mouse_names{mouse}))==9 % Short Protocol
    n=1; m=1; CondSess2.(Mouse_names{mouse})={};
    for j=1:ceil(sum(length(CondExploSess.(Mouse_names{mouse}))+length(CondShockSess.(Mouse_names{mouse}))+length(CondSafeSess.(Mouse_names{mouse})))/3)
        if ~isempty(CondExploSess.(Mouse_names{mouse}){j})
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
    
    n=1; m=1; ExtSess2.(Mouse_names{mouse})={};
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
    CondPreSess.(Mouse_names{mouse}) = CondSess2.(Mouse_names{mouse})(1:9);
    ExtPreSess.(Mouse_names{mouse}) = ExtSess2.(Mouse_names{mouse})(1:6);
    FirstExtPreSess.(Mouse_names{mouse}) = ExtSess2.(Mouse_names{mouse})(1,4);
    clear CondSess2 ExtSess2
end

