function [classified] = ID3Driver(example_data, attribute_data, target_data, decisionFunction, N)
    
    troot = tnode.empty(length(unique(target_data)), 0);
    for i=1:length(unique(target_data))
        binary_targets = binaryFromMultiple(target_data, i);
        % create a tree for each thing we're classifying
        troot{i} = ID3(example_data, attribute_data, binary_targets);
    end
    
    % combine results from each binary tree to give output
    % algorithm 1: sum information gain down the tree
    classified = classify(test_data, troot, decisionFunction);
    
    % N-fold validation to measure error rate
    for i=1:N
        
    end