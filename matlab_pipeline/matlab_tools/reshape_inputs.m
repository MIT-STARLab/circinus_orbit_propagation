% Reshape cell array Matlab  inputs so that they are in the form expected by  the  Matlab processing code  (expects a cell matrix)

function [out] =  reshape_inputs(in_by_sat,dim_2_size)

out = cell (size(in_by_sat,2),dim_2_size);

%  Iterate over number of satellites
for i=1: size(out,1)
    by_sat= in_by_sat{i};

    %  iterate over number targets, gs, other sats...
    for j=1: size(out,2)
        out{i,j} =  by_sat {j};
    end
end