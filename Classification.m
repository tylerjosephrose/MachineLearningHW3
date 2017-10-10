% This program creates and ID3 and a naive Bayes Classification
% classification tree for the data from fisheriris to classify the
% different types of iris's.
% Tyler Rose and Seth Dippold
% October 10, 2017

clear all, close all
load fisheriris
[a,b,c] = unique(species);
iris = [meas c];
attributeNames = {'petalLength' 'petalWidth' 'sepalLength' 'sepalWidth'};

% Split our data set into random training and testing sets
randPermIris = iris(randperm(150),:);
training = randPermIris(1:75, :);
testing = randPermIris(76:end, :);

attributes = [1, 1, 1, 1];
tree = ID3(training, attributeNames, attributes, 10);