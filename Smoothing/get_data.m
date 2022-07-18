function [c_data, c_idx] = get_data(I)
% return a 1x9 column at a time from the Image

smax = 9;

[nrows, ncols] = size(I);

persistent col_idx;
persistent row_idx;

if isempty(row_idx)
    row_idx = uint32(1);
    col_idx = uint32(1);
end

c_idx = col_idx;

c_data = uint8(zeros(1,smax));

for ii=1:smax
    c_data(ii) = I(row_idx+ii-1, c_idx);
end


if (col_idx == ncols)
    col_idx = uint32(1);
    if (row_idx == nrows-smax+1)
        row_idx = uint32(1);
    else
        row_idx = row_idx+1;
    end
else
    col_idx = col_idx+1;
end






        

