function [filteredImage] = gaussianFilter(image, sigma)
% Applica un filtro gaussiano a un'immagine
% image: Immagine da filtrare
% sigma: Deviazione standard del filtro gaussiano

kernelSize = 2*ceil(2*sigma)+1; % Calcola la dimensione del kernel
gaussianKernel = fspecial('gaussian', kernelSize, sigma);
filteredImage = imfilter(image, gaussianKernel, 'replicate');
end
