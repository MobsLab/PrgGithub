function Mod = GetModIndex(X,Y)

if isempty(Y)
    Mod=X;
else
Mod=(X-Y)./(X+Y);
end
end