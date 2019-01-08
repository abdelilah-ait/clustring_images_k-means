function features = getFeatures(img, fsize)
% fonction pour créer le vecteur descripteur
features = zeros(fsize-1,1);
% features = shapeFeatures(img);
% return;
if (fsize>=7)
features=color_Moments(img);
end
if (fsize>=39)
features = [features, hsvHistogramFeatures(img)];
end
if (fsize>=43)
features = [features, textureFeatures(img)];
end
if (fsize>=50)
 features = [features, shapeFeatures(img)];
end
end
