function [ classification ] = Classify( tree, attributes, instance )
% This function will classify the data instance given the tree
%   tree -          This will be the tree to traverse
%   attributes -    This is the string names of the attributes
%   instance -      This will be the single data instance to classify

classification = tree.value;
field = fieldnames(tree);
branches = size(field,1)-2;

if branches == 0
    return
end

attributeNum = find(ismember(attributes, tree.value));
for i = 1:branches
    branch = tree.(field{i+2});
    num = instance(1, attributeNum);
    if num >= branch.range{1}(1) & num <= branch.range{1}(2)
        classification = Classify(branch, attributes, instance);
        return
    end
end
% If we get to this point then we couldn't match it. Since we are using ID3
% not ID4 we can't just assign it the highest probability so this one will
% be wrong
end

