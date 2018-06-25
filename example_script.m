%% Read data from positive science data file and filter out bad values
clear all
[frame, gazex, gazey] = import_PosSci('example_PosSci_file.txt');

%Set FOV resolution
screenX = 640;
screenY = 480; 

%Filter out bad values
gazex(gazex < 0 | gazex > 640) = NaN;
gazey(gazey < 0 | gazey > 480) = NaN;
gazex(isnan(gazey)) = NaN;
gazey(isnan(gazex)) = NaN;

%Calculate proportion of valid data
valid_data = sum(not(isnan(gazex)))/length(gazex);

%% Visualize X data
ksdensity(gazex)

%% Visualize Y data
ksdensity(gazey)

%% Visualize 2D heatmap
plot_heatmap(gazex, gazey, screenX, screenY, 10)