function [frame,gazex,gazey] = import_PosSci(filename, startRow, endRow)
%Matlab auto-generated script to import Positive Science HMET data files
%NOTE: User must delete the header from the text file--this script does not
%deal with header information. See example data file for correct format.
delimiter = ' ';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

formatSpec = '%f%*s%*s%*s%*s%f%f%*s%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

fclose(fileID);

frame = dataArray{:, 1};
gazex = dataArray{:, 2};
gazey = dataArray{:, 3};


