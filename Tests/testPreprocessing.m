%% Caricamento script 
clc; close all; clear all;
% Aggiungi le directory che contengono gli script necessari al percorso di MATLAB
addpath('/MATLAB Drive/matlab_image_segmentation/Preprocessing');
% addpath('percorso/alla/directory/ChanVese'); % Se necessario in futuro
% addpath('percorso/alla/directory/LevelSet'); % Se necessario in futuro
% addpath('percorso/alla/directory/Tests'); % Se stai salvando i tuoi test qui

%% Inizio preprocessing
% Carichiamo immagine digitale
imagePath = '/MATLAB Drive/matlab_image_segmentation/dataset/cell.png'

%% PREPROCESSING

image = imread(imagePath); % Leggiamo immagine 
% RGB channels 128x128x3 -> R^3

% Mostriamo immagine originale e la salviamo
imshow(image); 
title('Original digital image');
imwrite(image, "/MATLAB Drive/matlab_image_segmentation/Results/original_image.png");
% Conversione di immagine in scala di grigio, se necessario

%% NOISE APPLICATION

% GAUSSIAN noise
% Applica rumore gaussiano
gaussianNoisyImage = addGaussianNoise(image,0.2, 0.01); % mean=0, variance=0.01
% Mostriamo immagine originale e la salviamo
imshow(gaussianNoisyImage)
title('Gaussian noise digital image'); 
imwrite(gaussianNoisyImage, "/MATLAB Drive/matlab_image_segmentation/Results/gaussianNoisyImage.svg");


% SALT&PEPPER
% Applica rumore salt-and-pepper
spNoisyImage = addSaltAndPepperNoise(image, 0.05); % density=0.05
% Mostriamo immagine originale e la salviamo
imshow(spNoisyImage)
title('Salt and pepper (noise) digital image'); 
imwrite(spNoisyImage, "/MATLAB Drive/matlab_image_segmentation/Results/spNoisyImage.svg");
%% NOISE REDUCTION

% GAUSSIAN FILTER
% Rimuovi rumore gaussiano con filtro gaussiano
gaussianFiltered = gaussianFilter(gaussianNoisyImage, 2); % sigma=2
% Mostriamo immagine originale e la salviamo
imshow(gaussianFiltered)
title('Gaussian filtered digital image'); 
imwrite(gaussianFiltered, "/MATLAB Drive/matlab_image_segmentation/Results/gaussianFiltered.svg");

% MEDIAN FILTER
% Rimuovi rumore salt-and-pepper con filtro mediano
% medianFiltered = medianFilter(spNoisyImage, 3); % kernelSize=3
% Gestione immagine a colori

R_channel = spNoisyImage(:,:,1); % prendo primo canale
G_channel = spNoisyImage(:,:,2); % Green channel
B_channel = spNoisyImage(:,:,3); % Blue channel

% gestisco medianFiltered per ognuno dei canali
medianFiltered(:,:,1) = medianFilter(R_channel, 3); % kernelSize=3
medianFiltered(:,:,2) = medianFilter(G_channel, 3); % kernelSize=3
medianFiltered(:,:,3) = medianFilter(B_channel, 3); % kernelSize=3

% Mostriamo immagine originale e la salviamo
imshow(medianFiltered)
title('Median filtered digital image'); 
imwrite(medianFiltered, "/MATLAB Drive/matlab_image_segmentation/Results/medianFiltered.svg");

%% Approccio ibrido 
% GAUSSIAN + S&P
gaussianNoisyImage = addGaussianNoise(image, 0, 0.01); % mean=0, variance=0.01
gaussianSPImage = addSaltAndPepperNoise(gaussianNoisyImage, 0.05); % density=0.05
imshow(gaussianSPImage)
title('Gaussian e S&P digitial image noise hybrid'); 
imwrite(gaussianSPImage, "/MATLAB Drive/matlab_image_segmentation/Results/gaussianSPImage.svg");

% GAUSSIAN + S&P -> GAUSSIAN FILTER
gaussianSPFiltered = gaussianFilter(gaussianSPImage, 2); % sigma=2
imshow(gaussianSPFiltered)
title('Gaussian-S&P gaussian filter'); 
imwrite(gaussianSPFiltered, "/MATLAB Drive/matlab_image_segmentation/Results/gaussianSPFiltered.svg");

% GAUSSIAN + S&P -> MEDIAN FILTER
R_channel_SP = gaussianSPImage(:,:,1); % prendo primo canale
G_channel_SP = gaussianSPImage(:,:,2); % Green channel
B_channel_SP = gaussianSPImage(:,:,3); % Blue channel

% gestisco medianFiltered per ognuno dei canali
medianSPFiltered(:,:,1) = medianFilter(R_channel_SP, 3); % kernelSize=3
medianSPFiltered(:,:,2) = medianFilter(G_channel_SP, 3); % kernelSize=3
medianSPFiltered(:,:,3) = medianFilter(B_channel_SP, 3); % kernelSize=3

imshow(medianSPFiltered)
title('Gaussian-S&P median filtered '); 
imwrite(medianSPFiltered, "/MATLAB Drive/matlab_image_segmentation/Results/medianSPFiltered.svg");

% GAUSSIAN + S&P -> GAUSSIAN FILTER + MEDIAN FILTER
% GAUSSIAN + S&P
gaussianNoisyImage2 = addGaussianNoise(image, 0, 0.01); % mean=0, variance=0.01
gaussianSPImage2 = addSaltAndPepperNoise(gaussianNoisyImage2, 0.05); % density=0.05

gaussianMedianSPFiltered = gaussianFilter(gaussianSPImage2, 2); % sigma=2
R_channel_SPG = gaussianSPImage(:,:,1); % prendo primo canale
G_channel_SPG = gaussianSPImage(:,:,2); % Green channel
B_channel_SPG = gaussianSPImage(:,:,3); % Blue channel

% gestisco medianFiltered per ognuno dei canali
medianGaussianSPFiltered(:,:,1) = medianFilter(R_channel_SPG, 3); % kernelSize=3
medianGaussianSPFiltered(:,:,2) = medianFilter(G_channel_SPG, 3); % kernelSize=3
medianGaussianSPFiltered(:,:,3) = medianFilter(B_channel_SPG, 3); % kernelSize=3

imshow(medianGaussianSPFiltered)
title('Gaussian-S&P hybrid: gaussian + median filtered'); 
imwrite(medianGaussianSPFiltered, "/MATLAB Drive/matlab_image_segmentation/Results/medianGaussianSPFiltered.svg");

% Calcolo loss wrt immagine originale (qui image)
% Converti le immagini in formato double
originalImageDouble = im2double(image);
gaussianFilteredDouble = im2double(gaussianFiltered);
medianFilteredDouble = im2double(medianFiltered);
gaussianSPFilteredDouble = im2double(gaussianSPFiltered);
medianSPFilteredDouble = im2double(medianSPFiltered);
medianGaussianSPFilteredDouble = im2double(medianGaussianSPFiltered);

% Calcola le differenze quadrate
diff_gaussianFiltered = (originalImageDouble - gaussianFilteredDouble).^2;
diff_medianFiltered = (originalImageDouble - medianFilteredDouble).^2;
diff_gaussianSPFiltered = (originalImageDouble - gaussianSPFilteredDouble).^2;
diff_medianSPFiltered = (originalImageDouble - medianSPFilteredDouble).^2;
diff_medianGaussianSPFiltered = (originalImageDouble - medianGaussianSPFilteredDouble).^2;

% Calcola l'MSE
mse_gaussianFiltered = mean(diff_gaussianFiltered(:));
mse_medianFiltered = mean(diff_medianFiltered(:));
mse_gaussianSPFiltered = mean(diff_gaussianSPFiltered(:));
mse_medianSPFiltered = mean(diff_medianSPFiltered(:));
mse_medianGaussianSPFiltered = mean(diff_medianGaussianSPFiltered(:));

% Calcola l'RMSE
rmse_gaussianFiltered = sqrt(mse_gaussianFiltered);
rmse_medianFiltered = sqrt(mse_medianFiltered);
rmse_gaussianSPFiltered = sqrt(mse_gaussianSPFiltered);
rmse_medianSPFiltered = sqrt(mse_medianSPFiltered);
rmse_medianGaussianSPFiltered = sqrt(mse_medianGaussianSPFiltered);

% Visualizza i risultati
disp('MSE e RMSE per immagini filtrate:');
disp(['Gaussian Filtered - MSE: ', num2str(mse_gaussianFiltered), ', RMSE: ', num2str(rmse_gaussianFiltered)]);
disp(['Median Filtered - MSE: ', num2str(mse_medianFiltered), ', RMSE: ', num2str(rmse_medianFiltered)]);
disp(['Gaussian S&P Filtered - MSE: ', num2str(mse_gaussianSPFiltered), ', RMSE: ', num2str(rmse_gaussianSPFiltered)]);
disp(['Median S&P Filtered - MSE: ', num2str(mse_medianSPFiltered), ', RMSE: ', num2str(rmse_medianSPFiltered)]);
disp(['Median Gaussian S&P Filtered - MSE: ', num2str(mse_medianGaussianSPFiltered), ', RMSE: ', num2str(rmse_medianGaussianSPFiltered)]);

% Definisci i nomi delle immagini filtrate
names = {'Gaussian Filtered', 'Median Filtered', 'Gaussian S&P Filtered', 'Median S&P Filtered', 'Median Gaussian S&P Filtered'};

% Definisci i valori MSE e RMSE corrispondenti
mse_values = [0.029759, 0.00061407, 0.0030896, 0.0030237, 0.0030237];
rmse_values = [0.17251, 0.02478, 0.055584, 0.054988, 0.054988];

% Crea un nuovo grafico
figure;
bar([mse_values; rmse_values]');
legend('MSE', 'RMSE');
set(gca, 'xticklabel', names);
ylabel('Value');
title('MSE and RMSE Comparison of Filtered Images');

saveas(gcf, '/MATLAB Drive/matlab_image_segmentation/Results/comparisonPreprocessing.png');

% Aggiungi linee per indicare i valori delle immagini originali
% hold on;
% hline_mse = refline([0 mse_values(1)]);
% hline_rmse = refline([0 rmse_values(1)]);
% hline_mse.Color = 'r';
% hline_rmse.Color = 'b';

% Load all the images
% clc; clear all; close all;
originalimage = imread('/MATLAB Drive/matlab_image_segmentation/Results/original_image.png');
gaussiannoisyimage = imread('/MATLAB Drive/matlab_image_segmentation/Results/gaussianNoisyImage.png');
saltandpeppernoisyimage = imread('/MATLAB Drive/matlab_image_segmentation/Results/spNoisyImage.png');
gaussianfiltered = imread('/MATLAB Drive/matlab_image_segmentation/Results/gaussianFiltered.png');
medianfiltered = imread('/MATLAB Drive/matlab_image_segmentation/Results/medianFiltered.png');
gaussiansaltandpepperimage = imread('/MATLAB Drive/matlab_image_segmentation/Results/gaussianSPImage.png');
gaussiansaltandpepperfiltered = imread('/MATLAB Drive/matlab_image_segmentation/Results/gaussianSPFiltered.png');
mediansaltandpepperfiltered = imread('/MATLAB Drive/matlab_image_segmentation/Results/medianSPFiltered.png');
mediangaussiansaltandpepperfiltered = imread('/MATLAB Drive/matlab_image_segmentation/Results/medianGaussianSPFiltered.png');

% Define titles for each image
titles = {'Original Image', 'Gaussian Noisy Image', 'Salt and Pepper Noisy Image', 'Gaussian Filtered', 'Median Filtered', 'Gaussian Salt and Pepper Image', 'Gaussian  Salt and Pepper Filtered', 'Median Salt and Pepper Filtered', 'Median Gaussian Salt and Pepper Filtered'};

% Create a new figure
figure('Units', 'pixels', 'Position', [100, 100, 1200, 800]);

% Plot each image with its title
for i = 1:numel(titles)
    subplot(3, 3, i);
    imshow(eval([lower(strrep(titles{i}, ' ', ''))]));
    title(titles{i}, 'FontSize', 3.5, 'HorizontalAlignment', 'center');
end

% HorizontalAlignment = 'left';  
% Save the figure as an SVG file
saveas(gcf, '/MATLAB Drive/matlab_image_segmentation/Results/preprocessing_images_comparison_centered.png');