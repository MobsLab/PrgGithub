function Output = ConvertNanToZero_SB(Input)

Input(isnan(Input)) = 0;
Output = Input;
end