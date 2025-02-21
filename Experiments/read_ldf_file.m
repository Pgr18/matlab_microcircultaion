%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: D:\МГТУ аспа\эксперименты\G (2)_1\DATA\2025-01-24\Лазма\F_01.txt
%
% Auto-generated by MATLAB on 01-Feb-2025 19:16:31

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["MC", "Time", "Var3", "Var4", "Date", "Start_time"];
opts.SelectedVariableNames = ["MC", "Time", "Date", "Start_time"];
opts.VariableTypes = ["double", "double", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% Specify variable properties
opts = setvaropts(opts, ["Var3", "Var4", "Date", "Start_time"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var3", "Var4", "Date", "Start_time"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable("D:\МГТУ аспа\эксперименты\G (2)_1\DATA\2025-01-24\Лазма\F_01.txt", opts);

%% Convert to output type
MC = tbl.MC;
Time = tbl.Time;
Date = tbl.Date;
Start_time = tbl.Start_time;

%% Clear temporary variables
clear opts tbl