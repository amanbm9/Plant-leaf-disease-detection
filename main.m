close all
clear all
clc
%%
%  Select an image from the 'Disease Dataset' folder by opening the folder
[filename,pathname] = uigetfile({'*.*';'*.bmp';'*.tif';'*.gif';'*.png'},'Pick a Leaf Image','C:\Users\Ruthvik Bangera\MATLAB Drive\Plant-Leaf-Disease-Detection-main\Images');
I = imread([pathname,filename]);

%%

%figure, imshow(I);title('leaf Image');

 image = imresize(I, [384 256]);
 
       
if size(image,3) == 3
   img = rgb2gray(image);
end
%figure, imshow(img);
%title('Grayscale Image');
imgh = adapthisteq(img,'clipLimit',0.02,'Distribution','rayleigh');
%figure, imshow(imgh);title('Adaptive Histogram Image');

subplot(2,3,2);
imshow(I)
title('Leaf Image');
subplot(2,3,4);
imshow(img)
title('Grayscale Image');
subplot(2,3,6);
imshow(imgh);title('Adaptive Histogram Image');
%%
% Create the Gray Level Cooccurance Matrices (GLCMs)
glcms = graycomatrix(imgh);

%Evaluate 13 features from the disease affected region only
% Derive Statistics from GLCM
stats = graycoprops(glcms,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
Mean = mean2(image);
Standard_Deviation = std2(image);
Entropy = entropy(image);
RMS = mean2(rms(image));
%Skewness = skewness(img)
Variance = mean2(var(double(image)));
a = sum(double(image(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(image(:)));
Skewness = skewness(double(image(:)));
% Inverse Difference Movement
m = size(image,1);
n = size(image,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = image(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);

% Put the 13 features in an array
 feature= [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];

 load dataset11.mat
% 'diasesefeat' contains the features of the disease affected leaves of both
% the types
% 'diseasetype' contains the corresponding label
% Train the classifier 
%svmStruct = svmtrain(dataset,diseasetype);
% Classify the test leaf
%species_name = svmclassify(svmStruct,feature)
l=0;
 for k=1:size(dataset,1)
    m=isequal(feature,dataset(k,:));
    if m==1
      l=1;
    end
 end
if l==0
   error('Grape Leaf Not found')
end

% Then this code will set up the preferences properly:
setpref('Internet','E_mail','vruddhi.sjec@gmail.com');
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username','vruddhi.sjec'); 
setpref('Internet','SMTP_Password','qpfkkuptudsffgny');


% The following four lines are necessary only if you are using GMail as
% your SMTP server. Delete these lines wif you are using your own SMTP
% server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

%% Send the email
mail = 'adityarao16220@gmail.com';
%mail='sathwikbangera285@gmail.com';
result= multisvm(dataset,diseasetype,feature)
switch result
    case 1
        disp('The disease detected is Anthracnose,Do not worry farmer,keep the vines off the farm to prevent this disease')
        sendmail(mail,'Vrudhhi Product','The disease detected is Anthracnose, Do not worry farmer. SOLUTION:      [1] Keep the vines off the farm to prevent this disease.[2]Plant your plants in well-drained soil.[3] You can also enrich the soil with compost in order to help plants resist diseases.[4] Water your plants with a drip sprinkler, as opposed to an overhead sprinkler.')
        disp('Message sent sucessfully')
        
     case 2
        disp('The disease detected is Bacterial, Do not worry farmer,reduce the pathogen levels by doing crop rotation to prevent this disease')
        sendmail(mail,'Vrudhhi Product','The disease detected is Bacterial, Do not worry farmer. SOLUTION:        [1]reduce the pathogen levels by doing crop rotation to prevent this disease.   [2]Practice good sanitation.   [3]Branches that have died due to bacterial leaf scorch should be routinely removed.')  
        disp('Message sent sucessfully')
     case 3
        disp('The disease detected is Citrus Canker, Do not worry farmer,remove the dead limbs well below the infected area to prevent this disease')
        sendmail(mail,'Vrudhhi Product','The disease detected is Citrus Canker, Do not worry farmer....! SOLUTION:    [1]remove the dead limbs well below the infected area to prevent this disease.  [2]Copper hydroxide is sprayed every 3 weeks (or more) ')  
        disp('Message sent sucessfully')
     case 4
        disp('The leaf is normal, Do not worry farmer, Your leaf is not infected')
        sendmail(mail,'Vrudhhi Product','The leaf is normal, Do not worry farmer, Your leaf is not infected')  
        disp('Message sent sucessfully')
     case 5
        disp('The disease detected is powdery mild, Do not worry farmer, prune the plant and remove weeds to prevent this disease  ')
        sendmail(mail,'Vrudhhi Product','The disease detected is powdery mild.     Do not worry farmer...!            SOLUTION: [1]prune the plant and remove weeds to prevent this disease.   [2]Cut and remove infected leaves    [3]Spray the plant with baking soda.    [4]Use potassium bicarbonate.    [5]Spray Neem oil')  
        disp('Message sent sucessfully')
     case 6
        disp('The disease detected is gray mold, DO not worry farmer, use vinegar to kill mold thus prevent the disease')
        sendmail(mail,'Vrudhhi Product','The disease detected is gray mold, DO not worry farmer....! SOLUTION:    [1]use vinegar to kill mold thus prevent the disease.   [2]start spraying at early bloom and continue to apply once a week.')  
        disp('Message sent sucessfully')
        
end