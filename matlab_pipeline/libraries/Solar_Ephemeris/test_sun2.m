addpath('demo_sun2')

% t = datetime('now')
t = datetime([2017, 3, 15, 0, 0, 0])
jdate = juliandate(t)
[rasc, decl, rsun] = sun2 (jdate);

% rasc*180/pi

% decl*180/pi

[h, m, s, rastr] = hrs2hms (24.0 * rasc / (2.0 * pi));

[d, m, s, decstr] = deg2dms (180.0 * decl / pi);

fprintf('\nright ascension      ');

disp(rastr);

fprintf('\ndeclination          ');

disp(decstr);