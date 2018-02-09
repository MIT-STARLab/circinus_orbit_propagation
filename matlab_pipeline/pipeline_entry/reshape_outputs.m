% Reshape cell array Matlab outputs so that they can be exported to Python

function [obs_new,obsaer_new,gslink_new,gsaer_new,sunecl_new,xlink_new,xrange_new ] =  reshape_outputs(obs,obsaer,gslink,gsaer,sunecl,xlink,xrange)

obs_new = {};
for i=1: size(obs,1)
    obs_new {i} = obs (1,:);
end

obsaer_new = {};
for i=1: size(obsaer,1)
    obsaer_new {i} = obsaer (1,:);
end

gslink_new = {};
for i=1: size(gslink,1)
    gslink_new {i} = gslink(1,:);
end

gsaer_new = {};
for i=1: size(gsaer,1)
    gsaer_new {i} = gsaer(1,:);
end

sunecl_new = sunecl;

xlink_new = {};
for i=1: size(xlink,1)
    xlink_new {i} = xlink(1,:);
end

xrange_new = {};
for i=1: size(xrange,1)
    xrange_new {i} = xrange(1,:);
end