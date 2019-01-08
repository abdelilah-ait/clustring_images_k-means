clc
%lire le fichier csv de training data
M = readtable('ISIC-Training.csv');
%lire le fichier csv de test data
V=  readtable('ISIC-Validation.csv');



%img training pour extraire le nom avec l extension de l image
fold='C:/Program Files/MATLAB/R2018a/bin/img_mining/ClassificationReel/ISIC-2017_Training_Data';
list=dir(fold);
k=1;
etatcill=cell(2000,1);
for i=1:2000  
    cur_img = (strcat('ISIC-2017_Training_Data/',list(i+3).name));
    IDB=imread(cur_img);
    features_img(k,:)=getFeatures(IDB, 50);
    etat(k,:)=M(i,2);
    k=k+1;

end

etatarray=table2array(etat);
for n=1:2000
    etatconv(n,1)=(double2num(etatarray(n,1)));
end
%etatnum=array2int(etatarray);
%A_cell = cellstr(str2double(etatcill));
%B=string(etatcill);


foldtst='C:/Program Files/MATLAB/R2018a/bin/img_mining/ClassificationReel/ISIC-2017_Validation_Data';
list_tst=dir(foldtst);
k1=1;
%etatcill=cell(150,1);
for i=1:150
    cur_imgtst = (strcat('ISIC-2017_Validation_Data/',list_tst(i+3).name));
    IDB_tst=imread(cur_img);
    features_imgtst(k1,:)=getFeatures(IDB, 50);
    etat_tst(k1,:)=V(i,2);
    %etatcill=table2cell(etat)
    k1=k1+1;
end



svmStruct =fitcsvm(features_img,etatcill,'Standardize',true,'KernelFunction','rbf','KernelScale','auto');
%knn=fitcknn(features_img,etatcill,'NumNeighbors',5,'Standardize',1);



%C = predict(svmStruct, features);
%%conMat=confusionmat(etat, C);
%%TP=conMat(1,1);
%%TN=conMat(2,2);
%FP=conMat(2,1);
%FN=conMat(1,2);
%Accuracy=(TP+ TN)/(TP+TN+FP+FN);





