function out = matchEuc(test, input)
%test = zeros(rows,col);
%input = zeros(rows,col);
[row,col]= size(input);
for i=1:row
    for j=1:col
        if test == input
            out = 1;
        else
            out = 0;
        end
    end
end
end

