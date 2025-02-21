function output = curcontrol(input)

output=input;

for i=1:height(output)
    if not(and((output.QS1(i)<4700),(output.QS2(i)<4700)))
        output.RHEO1(i) = NaN;
        output.BASE1(i) = NaN;
        output.ECG(i) = 0;
        output.RHEO2(i) = NaN;
        output.BASE2(i) = NaN;
    end
end

end