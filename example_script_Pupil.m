%% Read data from pupil data file and filter out bad values
clear all

%Set FOV resolution
screenX = 1280;
screenY = 720; 

[frame, gazex, gazey, confidence] = import_Pupil('example_Pupil_file.csv', screenX, screenY);

%Filter out bad values
gazex(gazex < 0 | gazex > screenX) = NaN;
gazey(gazey < 0 | gazey > screenY) = NaN;
gazex(isnan(gazey)) = NaN;
gazey(isnan(gazex)) = NaN;
gazex(confidence < .6) = NaN;
gazey(confidence < .6) = NaN;

%Calculate proportion of valid data
valid_data = sum(not(isnan(gazex)))/length(gazex);

%% Visualize X data
ksdensity(gazex)

%% Visualize Y data
ksdensity(gazey)

%% Visualize 2D heatmap
plot_heatmap(gazex, gazey, screenX, screenY, 30)