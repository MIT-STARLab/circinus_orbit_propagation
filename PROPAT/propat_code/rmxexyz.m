function [euler_angles] = rmxexyz (rot_mat)
% [euler_angles] = rmxexyz (rot_mat)
%   To compute the Euler angles of a X-Y-Z rotation, given 
%   the attitude matrix.
% inputs:
%   rot_mat
%       rotation matrix (3, 3)
% outputs:
%   euler_angles
%       Euler angles from a X-Y-Z rotation, in radians (3)
%       such that:
%           -pi   < euler_angle(1) <= pi
%           -pi/2 < euler_angle(2) <= pi/2
%           -pi   < euler_angle(3) <= pi
% Valdemir Carrara, Sep, 1998

a11    = rot_mat(1,1);
a12    = rot_mat(1,2);
a22    = rot_mat(2,2);
a21    = rot_mat(2,1);
a31    = rot_mat(3,1);
a32    = rot_mat(3,2);
a33    = rot_mat(3,3);
      
if abs(a31) <= 1 
    eul2 = asin(a31);
elseif a31 < 0 
    eul2 = -pi/2;
else
    eul2 = pi/2;
end

if abs(a31) <= 0.99999 
    if a33 ~= 0 
        eul1 = atan2(-a32, a33);
        if (eul1 > pi)
            eul1 = eul1 - 2*pi;
        end
    else
        eul1 = pi/2*sign(-a32);
    end

    if a11 ~= 0
        eul3 = atan2(-a21, a11);
        if (eul3 > pi)
            eul3 = eul3 - 2*pi;
        end
    else
        eul3 = pi/2*sign(-a21);
    end
else
    eul1 = 0;
    if a22 ~= 0
        eul3 = atan2(a12, a22);
        if (eul3 > pi)
            eul3 = eul3 - 2*pi;
        end
    else
        eul3 = pi/2*sign(a12);
    end
end

euler_angles = [eul1; eul2; eul3];

       
