% Reshape cell array Matlab  inputs so that they are in the form expected by  the  Matlab processing code  (expects a cell matrix)

function [out] =  reshape_inputs(in_by_sat,dim_2_size)

out = {size(in_by_sat,1),dim_2_size};
for i=1: size(out,1)
    by_sat= in_by_sat(i);
    for j=1: size(out,1)
        out{i,j} =  by_sat (j);
    end
end