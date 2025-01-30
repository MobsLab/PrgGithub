function AmyphysStimCodes

load AmyphysLookupTables

lookups = {'Amyphys', 'Phys1', 'Phys2'};


for li = 1:3
    l = lookups{li};
    lu = eval([l '_StimLookup']);
    k = keys(lu);   
    mk = strmatch( 'Monkey', k);   
    me = strmatch('Expr', k);
    
    stims = [];
    stimsId = [];
    for i = 1:length(mk)
        stimsId = [stimsId (i*ones(size(lu{k{i}})))];
        
        stims = [stims lu{k{i}}];
    end
    
    stimsExpr = [];
    for i = 1:length(stims)
        
        for e = me'

            if ismember(stims(i), lu{k{e}})
                if findstr(k{e}, 'Neutral')
                    stimsExpr(i) = 1;
                elseif  findstr(k{e}, 'Lipsmack')
                    stimsExpr(i) = 2;
                elseif findstr(k{e}, 'Threat')
                    stimsExpr(i) = 3;
                elseif findstr(k{e}, 'Fullbody')
                    stimsExpr(i) = 4;
                end
                break
            end
        end
    end
    
    
    mh = strmatch('Human',k);
    sh = lu{k{mh}};
    shi = 100+ (1:length(sh));
    she = zeros(size(sh));
    
    stims = [stims sh];
    stimsId = [stimsId shi];
    stimsExpr = [stimsExpr she];
    
    
    mo = strmatch('Object', k);
    
    so = [];
    for i = 1:length(mo)
        so = [so lu{k{mo(i)}}];
    end
    
    soi = 200 + (1:length(so));
    soe = zeros(size(so));
    
    stims = [stims so];
    stimsId = [stimsId soi];
    stimsExpr = [stimsExpr soe];
    
    mak = strmatch('Animal', k);
    if ~isempty(mak)
        sa = lu{k{mak}};
        sai = 300+ (1:length(sa));
        sae = zeros(size(sa));
        stims = [stims sa];
        stimsId = [stimsId sai];
        stimsExpr = [stimsExpr sae];
        
    end

    if li == 1;
        ix = ~(stimsId < 100 & stims > 30);
        stims = stims(ix);
        stimsId = stimsId(ix);
        stimsExpr = stimsExpr(ix);
    end
    
    
    
    lookups{li}
    stims
    stimsExpr
    stimsId
    
    
    
    eval([l 'Stims = stims;']);
    eval([l 'StimsExpr = stimsExpr;']);
    eval([l 'StimsId = stimsId;']);
    
end

save AmyphysStimCodes AmyphysStims* Phys1Stim* Phys2Stim*

    
    
    