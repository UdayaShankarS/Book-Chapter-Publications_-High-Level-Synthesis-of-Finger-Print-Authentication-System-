function outI  = reconstruct_data(I, new_pixel, dvalid)

smax = 9;

% center pixel
cp = uint32(ceil(smax/2));

[nrows, ncols] = size(I);

persistent newI;
if isempty(newI)
    newI = I;
end

persistent col_idx;
persistent row_idx;

if isempty(row_idx)
    row_idx = cp;
    col_idx = cp;
end

outI = newI;

if dvalid == true
    newI(row_idx, col_idx) = new_pixel;
    
    if (col_idx == ncols-cp+1)
        col_idx = cp;
        if (row_idx == nrows-cp+1)
            row_idx = cp;
        else
            row_idx = row_idx+1;
        end
    else
        col_idx = col_idx+1;
    end
end


