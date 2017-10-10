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

maxAccuracies = [];
minAccuracies = [];
avgAccuracies = [];
for bins = 5:5:20
    accuracy = [];
    for j = 1:10
        % Split our data set into random training and testing sets
        randPermIris = iris(randperm(150),:);
        training = randPermIris(1:75, :);
        testing = randPermIris(76:end, :);
    
        attributes = [1, 1, 1, 1];
        % Run ID3 algorithm
        tree = ID3(training, attributeNames, attributes, bins);
    
        % Find accuracy of the tree
        correct = 0;
        for i = 1:size(testing,1)
            if Classify(tree, attributeNames, testing(i,:)) == testing(i,5)
                correct = correct + 1;
            end
        end
        accuracy = [accuracy correct/75];
    end
    maxAccuracies = [maxAccuracies max(accuracy)];
    minAccuracies = [minAccuracies min(accuracy)];
    avgAccuracies = [avgAccuracies mean(accuracy)];
end
x = [5, 10, 15, 20];
figure
plot(x,maxAccuracies,x,minAccuracies,x,avgAccuracies)
title('Accuracy of ID3')
xlabel('Number of Bins')
ylabel('Accuracy')
legend('Max Accuracy', 'Min Accuracy', 'Average Accuracy')
