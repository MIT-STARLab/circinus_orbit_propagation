function [n_data, n_year, n_order, n_index, igrf_data] = igrf_read_data(igrf_data_file)
% function to read the igrf.dat file
% igrf_read_data display an error message if the igrf_data_file coudn't be
% opened.
%
% inputs:
%   igrf_data_file
%       data file name ('igrf.dat')
% outputs:
%   n_data
%       number of geomagnetic data set (25 in present version)
%   n_year(n_data)
%       vector of the reference year for the data set (starting with 1900)
%   n_order(n_data)
%       vector with the order of each data set
%   n_prov(n_data)
%       vector of the reference year for the provisional data set
%   n_index(n_data)
%       vector with the starting index of each set in the igfr_data vector,
%       with length of each data set given by n_order*(n_order + 2)
%   igrf_data()
%       vector with the concatenated data set
%
% model:
%   10th generation (9th revision) 1900 - 2010
%
% author:
%   Valdemir Carrara, may 2009
%
[funit, message] = fopen(igrf_data_file, 'r');
if funit < 0
    disp(message)
    stop
end
n_data = fscanf(funit, '%d', 1);
n_year = fscanf(funit, '%d', n_data)';
n_order = fscanf(funit, '%d', n_data)';
%n_prov = fscanf(funit, '%d', n_data)';
n_index = fscanf(funit, '%d', n_data)';
igrf_data = [];
for i = 1:n_data-1
    temp_array = fscanf(funit, '%g', n_index(i))';
    igrf_data = cat(2, igrf_data, temp_array);
end
fclose (funit);
