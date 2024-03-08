%% Caricamento script e inizializzazione
clc; close all; clear all;
addpath(genpath('/MATLAB Drive/matlab_image_segmentation'));

% Definizione dei percorsi e titoli delle immagini filtrate
imageFiles = {
    'gaussianFiltered.png',
    'medianFiltered.png',
    'gaussianSPFiltered.png',
    'medianSPFiltered.png',
    'medianGaussianSPFiltered.png'
};
imageTitles = {
    'GaussianFiltered',
    'MedianFiltered',
    'GaussianSPFiltered',
    'MedianSPFiltered',
    'MedianGaussianSPFiltered'
};

% Parametri per l'evoluzione del modello Chan-Vese
lambda1 = 1;
lambda2 = 1;
mu = 0.1;
epsilon = 1;
deltaX = 1;
deltaY = 1;
deltaT = 0.1;
maxIter = 500;

basePath = '/MATLAB Drive/matlab_image_segmentation/Results/';

%% Processamento e Segmentazione per ogni immagine filtrata
for i = 1:length(imageFiles)
    imagePath = strcat(basePath, imageFiles{i}); % Ensure path concatenation works correctly
    image = imread(imagePath);
    
    if size(image, 3) == 1
        % L'immagine è già in scala di grigi
        imageChannels = {image}; % Usa l'immagine direttamente
    else
        % L'immagine è RGB, separa i canali
        imageChannels = {image(:,:,1), image(:,:,2), image(:,:,3)};
    end
    
    segmentationResults = zeros(size(image, 1), size(image, 2), length(imageChannels));
    
    for channel = 1:length(imageChannels)
        imageChannel = double(imageChannels{channel});
        
        params.centerX = size(imageChannel, 2) / 2;
        params.centerY = size(imageChannel, 1) / 2;
        params.radius = min(size(imageChannel)) / 4;
        phi = initializeLevelSet ([size(imageChannel, 1), size(imageChannel, 2)], 'circle', params);
        
        phiChannel = evolveLevelSet(phi, imageChannel, lambda1, lambda2, mu, epsilon, deltaX, deltaY, deltaT, maxIter);
        
        segmentationResults(:,:,channel) = phiChannel >= 0;
    end

    finalSegmentationOR = any(segmentationResults, 3);
    finalSegmentationAND = all(segmentationResults, 3);
    votes = sum(segmentationResults, 3);
    finalSegmentationMajorityVote = votes > 1; % Voto di maggioranza
    
    imwrite(finalSegmentationOR, strcat(basePath, imageTitles{i}, '_OR.png'));
    imwrite(finalSegmentationAND, strcat(basePath, imageTitles{i}, '_AND.png'));
    imwrite(finalSegmentationMajorityVote, strcat(basePath, imageTitles{i}, '_MajorityVote.png'));
end
