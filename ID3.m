function [ tree ] = ID3( data, attributeNames, activeAttributes, numOfBins )
% ID3 Creates a decision tree from the given data based on the ID3
% algorithm
%   dataAttributes -        dataset to be used
%   attributeNames -        names of each attribute column to distinguish
%                           the branch in the tree
%   activeAttributes -      marks each attribute. If the attribute was
%                           already used in the tree then it is marked as 0
%   numOfBins-              designates the number of bins to use to
%                           discretize the data

% Tree node that will be returned
tree = struct('value', 'null');

% If all datapoints left are the same classification then we will return
if size(unique(data(:,5))) == 1
    tree.value = unique(data(:,5));
    return
end

m = size(data,1);
% Probability of each classification in the training set
%   1: setosa
%   2: versicolor
%   3: virginica
prob = [sum(data(:,5) == 1) sum(data(:,5) == 2) sum(data(:,5) == 3) ]./m;
parentEntropy = (prob.*-1).*log2(prob);
parentEntropy(isnan(parentEntropy)) = 0;
parentEntropy = sum(parentEntropy);

% If we have no more attributes left then we will return the highest prob
if sum(activeAttributes) == 0
    [x,i] = max(prob);
    tree.value = attributeNames{i};
    return
end

informationGain = [];
for i = 1:4
    if activeAttributes(i) == 1
        [n, x] = hist(data(:,i), numOfBins);
        prob = n/sum(n);
        optionEntropy = (prob.*-1).*log2(prob);
        optionEntropy(isnan(optionEntropy)) = 0;
        attrEntropy = prob*optionEntropy.';
        informationGain = [informationGain parentEntropy-attrEntropy];
    else
        informationGain = [informationGain -Inf()];
    end
end
[~,i] = max(informationGain);
tree.value = attributeNames{i};

% prepare all branches of the tree
branches = [];
total = 0;
[n,x] = hist(data(:,i));
branchCount = 1;
for j = 1:numOfBins
    name = strcat('b', num2str(branchCount));
    % split data for the branch
    if n(j) == 0
        continue;
    end
    margin = (x(2)- x(1))/2;
    if j == 1
        newData = data( data(:,i)<x(j)+margin,:);
    elseif j == numOfBins
        newData = data( data(:,i)>=x(j)-margin,:);
    else
        newData = data( data(:,i)>=x(j)-margin & data(:,i)<x(j)+margin,:);
    end
    total = total + size(newData, 1);
    activeAttributes(i) = 0;
    tree.(name) = ID3(newData, attributeNames, activeAttributes, numOfBins);
    branchCount = branchCount + 1;
end
return
end

