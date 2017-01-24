function tr = trace (a)
% [r_trace] = trace (a)
%   returns with the trace (sum of the main diagonal elements)
%   of a matrix 
% inputs:
%   a
%       Matrix
% outputs:
%   r_trace
%       trace of a
%

% Valdemir Carrara, Oct. 2010

tr = 0;
for nmin = 1:min(size(a))
    tr = tr + a(nmin, nmin);
end
return
    
    
