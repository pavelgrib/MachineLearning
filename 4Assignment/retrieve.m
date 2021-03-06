function [bestCase ] = retrieve( cbr,newCase )
%%RETRIEVE CBR step of extracting the case most similar to newCase
% we look at the noOfBestAUs most frequently occuring active AUs in the meanVec
% for each cluster and take the distance between newCase and that 
    retrieveAllBestCases = 0;
    similarity = cbr.similarityMeasure;
%     arrays = cell(1, noOfClasses);
%     listClasses= [];

    %checking each cluster in the CBR
    dist = zeros(cbr.numBases, 1);
    for i=1:cbr.numBases
        dist(i) = similarity( newCase, cbr.base{i}.meanVec );
    end
    
    % indices of all the clusters to check
	clusters = find(dist == min(dist));
    bestCases = CaseStr.empty;
    bestCases(1) = cbr.base{clusters(1)}.vector(1);
    minDist = similarity( bestCases(1), newCase );
    for j=1:length(clusters)
        clusterCases = cbr.base{clusters(j)}.vector;
        for k=1:length(clusterCases)
            tempDist = similarity( clusterCases(k), newCase );
            if tempDist < minDist
                bestCases = CaseStr.empty;
                bestCases(1) = clusterCases(k);
                minDist = tempDist;
            elseif tempDist == minDist
                bestCases(end+1) = clusterCases(k);
            end
        end
    end
    
    % at this stage, we have candidates for best case;  if there is ambiguity,
    % we first check which one has been retrieved most often, then we pick
    % randomly by selecting the one encountered first
    maxRetrieved = bestCases(1).timesRetrieved;
    bestCase = bestCases(1);
    idxOfBest = 1;
    for m=1:length(bestCases)
        if ( bestCases(m).timesRetrieved > maxRetrieved )
            bestCase = bestCases(m);
            idxOfBest = m;
        end
    end
    
    
    % updating the retrieved count for the best cases and one more for best case
    if retrieveAllBestCases
        for p=1:length(bestCases)
            slnIdx = bestCases(p).solution;
            % cbr.base{slnIdx}.vector(bestCases(p).cbrIndex)
            cbr.base{slnIdx}.vector(bestCases(p).cbrIndex).retrieved();
        end
    end
    cbr.base{bestCase.solution}.vector(idxOfBest).retrieved();
    
    % looking through all active AUs to determine which cases should be considered
    % we do this so we don't have to consider all cases in the case base
        
%         if nextFlag
%             listClasses(i) = length(intersect(arrays{i},newCase.activeAU));
%         end

% 	listClasses = [];
% 
% 	%find the maximum common AUs to check that index
%     if(isempty(listClasses))
%         maxInd = 1:cbr.numBases;
%     else
%         maxInd = listClasses;
%     end
%     %maxInd = find(listClasses == max(listClasses));
%     
%     maxSim.diff = 0;
%     maxSim.same = -1;
%     maxSim.timesRetrieved = 0;
%     bestCase = CaseStr;
%     indexBestCase = -1;
%     for i=1:size(maxInd,2)
%         %Look inside each class
%         for j=1:length(cbr{maxInd(i)}.vector)
%            
%             sim = d(cbr{maxInd(i)}.vector(j),newCase);
%             
%              %Initialize if first time
%             if(maxSim.same == -1 )
%                 maxSim = sim;
%                  bestCase = cbr{maxInd(i)}.vector(j);
%                  indexBestCase = j;
%             end
%             
%             if(maxSim.same > sim.same)
%                 maxSim = sim;
%                 bestCase = cbr{maxInd(i)}.vector(j);
%                 indexBestCase = j;
%             elseif (maxSim.same == sim.same)
%                 if(maxSim.diff > sim.diff)
%                      maxSim = sim;
%                      bestCase = cbr{maxInd(i)}.vector(j);
%                      indexBestCase = j;
%                 elseif(maxSim.diff == sim.diff)
%                      if(maxSim.timesRetrieved < sim.timesRetrieved)
%                         maxSim = sim;
%                         bestCase = cbr{maxInd(i)}.vector(j);
%                         indexBestCase = j;
%                      end
%                 end
%             end
%         end
%     end
%     cbr.base{bestCase.solution}.vector(indexBestCase).retrieved();
end

