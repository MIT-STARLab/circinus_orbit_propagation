function [utc] = mjd_to_utc_str(d)

%d = 57827.6861111111;
MJD_epoch='Nov 17, 1858,00:00';  %reference: https://en.wikipedia.org/wiki/Julian_day
datestr(d+datenum(MJD_epoch))

end