% Reshape cell array Matlab outputs so that they can be exported to Python
%  takes a cell matrix and turns the second dimension of that matrix into a nested cell within a one-dimensional cell  array

function [out_by_sat] =  reshape_outputs(in, trim_empty)

out_by_sat = {};
for i=1: size( in,1)
    out_by_sat {i} =  in (i,:);
end

% the below will trim out any trailing empty elements from all of the rows of out_by_sat
if trim_empty
    temp = out_by_sat;
    out_by_sat= {};
    for i=1: size( temp,2)
        array =temp {i};
        new_array= {};
        for j=1: size( array,2)
            if size(array{j},1) >0
                new_array {j}=array{j};
            end
        end
        out_by_sat{i}=new_array;
    end
end
