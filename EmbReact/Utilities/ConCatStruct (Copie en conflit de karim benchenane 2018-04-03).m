function Struct=ConCatStruct(Struct_1,Struct_2)

Table_1=struct2table(Struct_1);
Table_2=struct2table(Struct_2);
Struct=table2struct([Table_1,Table_2]);

end
