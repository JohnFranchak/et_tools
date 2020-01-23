function [frame,gazex,gazey,confidence] = import_Pupil(filename, resolution_X, resolution_Y)

dataArray = readtable(filename);

frame = dataArray.index;
gazex = dataArray.norm_pos_x .* resolution_X;
gazey = dataArray.norm_pos_y .* resolution_Y;
confidence = dataArray.confidence;

