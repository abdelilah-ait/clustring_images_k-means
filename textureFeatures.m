function texture_features= textureFeatures(img)
% Basée sur l'analayse de textures par la GLCM (Gray-Level Co-Occurrence
% Matrix)
% Le vecteur de taille 1x4 contiendra [Contrast, Correlation, Energy,
% Homogeneity]
glcm = graycomatrix(rgb2gray(img),'Symmetric', true);
stats = graycoprops(glcm);
texture_features=[stats.Contrast, stats.Correlation, stats.Energy, stats.Homogeneity];
texture_features=texture_features/sum(texture_features);
end