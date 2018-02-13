% Reshape cell array Matlab outputs so that they can be exported to Python
%  takes a cell matrix and turns the second dimension of that matrix into a nested cell within a one-dimensional cell  array

function [out_by_sat] =  reshape_outputs(in)

out_by_sat = {};
for i=1: size( in,1)
    out_by_sat {i} =  in (1,:);
end