% Delta Quantity
for i=1:4
    for j=1:5
        M(i,j)=length(Delta_M243_basal{i,j});
    end
end
for i=1:5
    for j=1:5
        M2(i,j)=length(Delta_M244_basal{i,j});
    end
end
for i=1:5
    for j=1:5
        T(i,j)=length(Delta_M243_Tone{i,j});
        T2(i,j)=length(Delta_M244_Tone{i,j});
    end
end


% SWS Duration
for i=1:4
    for j=1:5
        SWS_basal(i,j)=DurDeltaEpoch_M243_basal{i,j};
    end
end
for i=1:5
    for j=1:5
        SWS_basal2(i,j)=DurDeltaEpoch_M244_basal{i,j};
    end
end
for i=1:5
    for j=1:5
        SWS_Tone(i,j)=DurDeltaEpoch_M243_Tone{i,j};
        SWS_Tone2(i,j)=DurDeltaEpoch_M244_Tone{i,j};
    end
end
% REM Duration
for i=1:4
    for j=1:5
        SWS_basal(i,j)=DurDeltaEpoch_M243_basal{i,j};
    end
end
for i=1:5
    for j=1:5
        SWS_basal2(i,j)=DurDeltaEpoch_M244_basal{i,j};
    end
end
for i=1:5
    for j=1:5
        SWS_Tone(i,j)=DurDeltaEpoch_M243_Tone{i,j};
        SWS_Tone2(i,j)=DurDeltaEpoch_M244_Tone{i,j};
    end
end

% Delta Frequency
for i=1:4
    for j=1:5
        Mf(i,j)=length(Delta_M243_basal{i,j})/DurDeltaEpoch_M243_basal{i,j};
    end
end
for i=1:5
    for j=1:5
        Mf2(i,j)=length(Delta_M244_basal{i,j})/DurDeltaEpoch_M244_basal{i,j};
    end
end
for i=1:5
    for j=1:5
        Tf(i,j)=length(Delta_M243_Tone{i,j})/DurDeltaEpoch_M243_Tone{i,j};
        Tf2(i,j)=length(Delta_M244_Tone{i,j})/DurDeltaEpoch_M244_Tone{i,j};
    end
end

% Delta Quantity (mean & normalized)
mf=(Mf./(Mf(:,1)*ones(1,5))+Mf2./(Mf2(:,1)*ones(1,5)))/2;
tf=(Tf./(Tf(:,1)*ones(1,5))+Tf2./(Tf2(:,1)*ones(1,5)))/2;