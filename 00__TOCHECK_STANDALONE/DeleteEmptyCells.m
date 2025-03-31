function Cnew=DeleteEmptyCells(C)
Cnew=C(~cellfun('isempty',C));

end