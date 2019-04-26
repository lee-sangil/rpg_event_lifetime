%% Event Lifetime Estimation
% E. Mueggler, C. Forster, N. Baumli, G. Gallego, D. Scaramuzza
% "Lifetime Estimation of Events from Dynamic Vision Sensors"
% In: IEEE International Conference on Robotics and Automation (ICRA), 
% Seattle, 2015.
% PDF: http://rpg.ifi.uzh.ch/docs/ICRA15_Mueggler.pdf

addpath('../../similarity-for-edge-image/');

%% Load data
data_folder = 'D:\Datasets\DAVIS-240C\2019-04-23T17-21-54\';
dataset = '2019-04-23T17-21-54';

% load data
% event = readtable([BaseDir 'events.txt'], 'Delimiter', ' ', 'ReadVariableNames', false);
% event = table2array(event);

events = loadEvents([data_folder 'events.txt']);
% [image_timestamp, imagesName] = loadImages([data_folder, '/', dataset, '.txt']);
[image_timestamp, imagesName] = loadImages(data_folder);

%% Parameters
% Window Size
N = 5;
% Estimated fraction of outliers for RANSAC algorithm
epsilon = 0.4;
% Euclidian distance threshold for RANSAC algorithm
mu = 0.0001;
% Regularization
reg = true;
% Visualization during computation
vis = false;
% Show velocity on visualization
show_vel = false;
% Size of image frame
switch dataset
	case {'building', 'flip', 'garfield', 'stripes'}
		imSize = [128,128];
	otherwise
		imSize = [180,240];
end

%% Compute lifetime
% events_with_lifetime = calcVelocity(events(1:900000,:), N, epsilon, mu, reg, vis);
[events_with_lifetime, t_dist, success] = calcVelocity(events, N, epsilon, mu, reg, vis, imSize);

%% Create video
% % visualization parameter for lifetime
% if strcmp(dataset, 'flip')
%     cmax = 500;
% else
%     cmax = 14000;
% end
% 
% % video using lifetime
% dispOutput(events_with_lifetime, show_vel, -1, [dataset, '_lifetime'], cmax);
% % video using fixed time interval of 30ms
% dispOutput(events_with_lifetime, show_vel, 30, [dataset, '_dt30']);
recordVideoSync;
