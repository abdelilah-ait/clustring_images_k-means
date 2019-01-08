clc

 fold='C:/Program Files/MATLAB/R2018a/bin/img_mining/ClassificationReel/ISIC-2017_Training_Data';
 foldval='C:/Program Files/MATLAB/R2018a/bin/img_mining/ClassificationReel/ISIC-2017_Validation_Data';
t = readtable('ISIC-Training.csv');
v= readtable('ISIC-Validation.csv');


datavald=table2cell(v);
data = table2cell(t);
[n m] = size(t);
[nv mv] = size(v);
k=1;
k1=1;
%%%%%%%%%training : les labels et les images  %%%%%%%%%%
 for i=1:n
         etat(i,1)=data(i,2);
         Nams(i,1)=(data(i,1));         
 end
etat_arr=cell2mat(etat);

%%%%%%%%%%validation : les labels et les images  %%%%%%%%%%
 for i=1:nv
         etat_val(i,1)=datavald(i,2);
         Nams_val(i,1)=(datavald(i,1));         
 end
 etat_arr_val=cell2mat(etat_val);
 
 %%%%%%%%% training == extraire les features %%%%%%%%%%
 for i=1:n
     %%caster les nomes en des char
     Namescv{i,1}=char(Nams(i,1));
     IDB = imread(strcat(fold,'/',Namescv{i,1},'.jpg'));
     features_img(k,:)=getFeatures(IDB, 50);
     k=k+1;
 end
 
 %%%%%%%%%% validation == extraire les features %%%%%%%%%%
 for i=1:nv
     %%caster les nomes en des char
     Namesvalcv{i,1}=char(Nams_val(i,1));
     IDBval = imread(strcat(foldval,'/',Namesvalcv{i,1},'.jpg'));
     features_img_val(k1,:)=getFeatures(IDBval, 50);
     k1=k1+1;
 end
 
%%%%SVM
svmStruct =fitcsvm(features_img,etat_arr,'Standardize',true,'KernelFunction','rbf','KernelScale','auto');
C = predict(svmStruct,features_img_val );
conMat=confusionmat(etat_arr_val, C);
TP=conMat(1,1);
TN=conMat(2,2);
FP=conMat(2,1);
FN=conMat(1,2);
Accuracy=(TP+ TN)/(TP+TN+FP+FN)
errRate = sum(etat_arr_val~= C)/nv; 
Accuracy_SVM=(1-errRate)

%%%%knn
knn=fitcknn(features_img,etat_arr,'NumNeighbors',5,'Standardize',1);
C = predict(knn,features_img_val );
errRate = sum(etat_arr_val~= C)/nv; 
Accuracy_knn=(1-errRate)








 
 
 