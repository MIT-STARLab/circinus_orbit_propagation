% demo_sun2.m        November 21, 2012

% this script demonstrates how to interact with the
% sun2 Matlab function which computes a precision
% ephemeris of the sun

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global suncoef

% initialize sun ephemeris

suncoef = 1;

% begin simulation

clc; home;

fprintf('\ndemo_sun2 - precision sun ephemeris\n');

[month, day, year] = getdate;

[ethr, etmin, etsec] = gettime;

day = day + ethr / 24 + etmin / 1440 + etsec / 86400;

jdet = julian(month, day, year);

[cdstr, utstr] = jd2str(jdet);

[rasc, decl, rsun] = sun2 (jdet);

fprintf('\ncalendar date        ');

disp(cdstr);

fprintf('\nephemeris time       ');

disp(utstr);

[h, m, s, rastr] = hrs2hms (24.0 * rasc / (2.0 * pi));

[d, m, s, decstr] = deg2dms (180.0 * decl / pi);

fprintf('\nright ascension      ');

disp(rastr);

fprintf('\ndeclination          ');

disp(decstr);

fprintf('\ngeocentric position vector and magnitude (kilometers)\n');

fprintf('\nrx    %14.8f', rsun(1));
fprintf('\nry    %14.8f', rsun(2));
fprintf('\nrz    %14.8f', rsun(3));

fprintf('\n\nrmag  %14.8f \n\n', norm(rsun));