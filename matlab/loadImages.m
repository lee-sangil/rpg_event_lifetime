function [timeList, imgList] = loadImages(BaseDir)
rgb = readtable([BaseDir 'images.txt'], 'Delimiter', ' ', 'ReadVariableNames', false);
List = table2cell(rgb);
timeList = cell2mat(List(:,1));
% imgList = List(:,2);
imgList = cellfun(@(x)[BaseDir x], List(:,2), 'un', 0);