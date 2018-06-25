function [group_entval, group_map] = plot_heatmap(x, y, screenX, screenY, sigma, save, outfile, outdir)
%Plots and saves heatmaps of 2D data by convolving a Gaussian kernel with specified
%sigma, returns entropy of the distribution and image file
%REQUIRED INPUT PARAMETERS
%x = x values, m columns of subjects by n rows of data
%y = y values, m columns of subjects by n rows of data
%screenX = max x value, e.g. 640
%screeny = max y value, e.g. 480
%sigma = sigma of gaussian kernel in pixels
%OPTIONAL PARAMETERS FOR SAVING
%save = 0 don't save files, 1 to save group file, 2 to save individual subject files and group file
%outfile = name of saved image files 
%outdir = save directory 
%OUTPUTS
%group_entval = entropy value of the grouped heatmap (individual subject if
%only one column of data is entered)
%group_map = image data for the group heatmap (individual subject if
%only one column of data is entered)
%Updated 5/10/2018 by franchak@gmail.com


if nargin < 1 %parameters for testing
    x = randn(100,1) * 5 + 5;
    y = randn(100,1) * 5 + 5;
    screenX = 40;
    screenY = 30;
    sigma = 15;
    save = 0;
    outfile = [];
    outdir = [];
elseif nargin < 6
    save = 0;
    outfile = [];
    outdir = [];
end
%
agg = 2;

%Check output directory
if exist(outdir) ~= 7 && save > 0
    mkdir(outdir);
end

group_map = zeros(screenY,screenX);
halfx = screenX/2;
halfy = screenY/2;
X = 1:screenX;
Y = 1:screenY;

%Create gaussian kernel
gauss = zeros(length(Y),length(X));
for i = 1:length(X)
    for j = 1:length(Y)
        gauss(j,i) = exp( -((((X(i)-halfx).^2)+((Y(j)-halfy).^2)) ./ (2* sigma.^2)) );
    end
end

%Ignore out-of-range values
numsubj = size(x,2);
x(x < 1 | x > screenX) = NaN;
y(y < 1 | y > screenY) = NaN;

for k = 1:numsubj
    screenmap = zeros(screenY, screenX);
    xm = round(x(:,k));
    ym = round(y(:,k));
    if agg == 1 %Brute force aggregation method
        for z = 1:length(xm)
            if isnan(ym(z)) == 0 & isnan(xm(z)) == 0
                screenmap(ym(z), xm(z)) = screenmap(ym(z), xm(z)) + 1;
            end
        end
    elseif agg == 2 %Histogram automation method
        screenmap = histcounts2(ym, xm, 1:screenY+1, 1:screenX+1);
    end
        submap = conv2(screenmap, gauss, 'same');
        submap = submap ./ length(xm); %normalize by number of samples
    %Save heatmaps for every column of data if selected
    if save == 2    
        heatmap=imagesc(submap);
        saveas(heatmap, strcat(outdir,'/', outfile,'_subj',num2str(k), '.png'), 'png');
    end
    group_map = group_map + submap; %aggregate individual maps into group map
end

group_map = group_map ./ numsubj; %normalize to number of subjects
heatmap=imagesc(group_map); %plot aggregate heatmap

%Save aggregate heatmap for all subjects
if save == 1 || save == 2
    saveas(heatmap, strcat(outdir,'/', outfile, '.png'), 'png');
end

%Calculate entropy of group distribution
dist = (group_map + eps) ./ nansum(nansum(group_map+eps));
l_dist = log2(dist);
group_entval = -nansum(nansum(dist .* l_dist));
