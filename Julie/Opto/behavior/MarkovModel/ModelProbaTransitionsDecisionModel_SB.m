clear all
Paramstepsize = 0.005;
for stepsize = [0.5,1,1.5,2,3,4]
    
    MinFzstepsize = ceil(2/stepsize);
    DurSimu = 1000/stepsize;
    
    for Pdec = [Paramstepsize:Paramstepsize:1-Paramstepsize]
        for Pfz = [Paramstepsize:Paramstepsize:1-Paramstepsize]
            
            clear State
            
            State(1) = 1; % Act
            
            
            for k=2:DurSimu
                
                randnum = rand;
                if randnum < Pdec % make a decision
                    
                    % actually make the decision
                    randnum = rand;
                    if randnum<=Pfz
                        State(k) = 0;
                    else
                        State(k) = 1;
                    end
                    
                else
                    State(k) = State(k-1);
                end
           
                
            end
            
            StartFz = find(diff(State)==-1);
            StartAct = [0,find(diff(State)==1)];
            
            FreqInit(floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)) = length(find(diff(State)==1))./(length(State)*stepsize);
            PercFz(floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)) = (DurSimu-sum(State))./length(State);
            
            if State(end)==1
                DurActEp(floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)) = mean(StartFz - StartAct(1:end-1))*stepsize;
                DurFzEp(floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)) = mean(StartAct(2:end-1) - StartFz(1:end-1))*stepsize;
                
                DistribFzEpisodes{floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)} = (StartAct(2:end-1) - StartFz(1:end-1))*stepsize;
                DistribActEpisodes{floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)} = (StartFz - StartAct(1:end-1))*stepsize;

            else
                DurActEp(floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)) = mean(StartFz - StartAct)*stepsize;
                DurFzEp(floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)) = mean(StartAct(2:end) - StartFz(1:end-1))*stepsize;
                
                DistribFzEpisodes{floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)} = (StartAct(2:end) - StartFz(1:end-1))*stepsize;
                DistribActEpisodes{floor(Pdec/Paramstepsize+0.001),floor(Pfz/Paramstepsize+0.001)} = (StartFz - StartAct)*stepsize;

            end
            

            
        end
    end
    save(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'DecisionModel.mat'],...
        'DurActEp','DurFzEp','PercFz','FreqInit','DistribFzEpisodes','DistribActEpisodes')
    clear DurActEp DurFzEp PercFz FreqInit
    
end