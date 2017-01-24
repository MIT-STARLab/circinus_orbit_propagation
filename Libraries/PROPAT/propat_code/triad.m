function c_triad = triad(v, w)
% [c_triad] = triad(v, w)
% purpose:
%   To calculate the attitude matrix from a frame in which a pair of 
%   non aligned vectors v and w are known, to reference system such that 
%   the x axis is aligned to v, the y axis lies in the v-w plane and z is
%   orthogonal to the v-w plane. If v is aligned to w then a identity 
%   matrix is returned.
% inputs:
%   v, w
%       Body vectors v and w (3x1)
%
% Valdemir Carrara, April, 2015
%
    nz = norm(v);
    if (nz == 0)
        c_triad = eye(3);
    else
        x = v/norm(v);
        z = cross(x, w);
        z = z/norm(z);
        y = cross(z, x);
        c_triad = [x'; y'; z'];
    end
