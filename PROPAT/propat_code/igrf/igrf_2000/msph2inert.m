function [Bx,By,Bz] = msph2inert(Br,Bt,Bp,LST,lat)
% Inputs
% Br B in radial direction | Magnetic field strength (B)
% Bt B in theta direction | in local tangential coordinates
% Bp B in phi direction |
% LST Local sidereal time of location (in degrees)
% lat Latitude measured positive north from equator (in degrees)
% Outputs
% Bx B in x-direction | Magnetic field strength (B)
% By B in y-direction | in geocentric inertial coordinates
% Bz B in z-direction |

    % Angle conversion to radians
    lat=lat*pi/180; LST=LST*pi/180;
    
    % Coordinate transformation
    Bx = (Br*cos(lat)+Bt*sin(lat))*cos(LST) - Bp*sin(LST);
    By = (Br*cos(lat)+Bt*sin(lat))*sin(LST) + Bp*cos(LST);
    Bz = (Br*sin(lat)+Bt*cos(lat));