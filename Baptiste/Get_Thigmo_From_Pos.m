

function Thigmo_tsd = Get_Thigmo_From_Pos(AlignedPosition)

D = Data(AlignedPosition);
R = Range(AlignedPosition);
for i=1:size(D,1)
    [Thigmo_score(i), ~] = Thigmo_From_Position_BM(tsd(R(i) , [D(i,1) D(i,2)]));
end

Thigmo_tsd = tsd(R , Thigmo_score);








