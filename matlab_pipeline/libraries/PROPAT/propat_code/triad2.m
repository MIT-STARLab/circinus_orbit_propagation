function c_triad = triad2(vb, wb, vr, wr)
% [c_triad] = triad(vb, wb, vr, wr)
% purpose:
%   To calculate the rotation matrix (attitude) from two pairs of given 
%   vectors, known in two different reference frames, using the TRIAD 
%   algorithm.
% inputs:
%   vb, wb
%       Body vectors v and w (3x1)
%   vr, wr
%       Reference vectors v and w (3x1)
%
% Valdemir Carrara, Oct, 2012
%
    c_triad = triad(vb, wb)'*triad(vr, wr);
