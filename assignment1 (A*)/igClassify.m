function cl = igClassify(answer, ~, ig, ~, ~)
%% this function determines the tree to use based on sum of information gain
% down the branches of each tree given the attributes of the example
% answer - result array from walking down each tree
% ig - sum of information gain array from walking down each tree
    if ( length(answer(answer==1))==1 ) 
        cl = find(answer==1);
    elseif ( length(answer(answer==1)) >= 1 )
       cl = find(ig == max(ig(answer==1)));
   else
       cl = find(ig==min(ig));
   end
end