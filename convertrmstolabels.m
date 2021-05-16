% CONVERTRMSTOLABELS Function to convert a set of RMS dynamic values to
%                    their corresponding dynamic labels.
% Converts RMS dynamic values to musical dynamic labels, ranging from pp to
% ff. The RMS ranges are as follow:
%            RMS < 0.0549 = "pp"
%   0.0548 < RMS < 0.0718 = "p"
%   0.0717 < RMS < 0.1026 = "mp"
%   0.1027 < RMS < 0.1524 = "mf"
%   0.1523 < RMS < 0.2184 = "f"
%   0.2184 < RMS < 0.2997 = "ff"
% Input arguments:
%   rmsDynamics - the RMS dynamic values to convert to labels
function[dynamics, dynamicLabelIndices] = convertrmstolabels(rmsDynamics)
    
    % The RMS values and dynamics labels, in the same order for indexing
    rmsDynamicRanges = [0.0549, 0.0718, 0.1026, 0.1524, 0.2184, 0.2997];
    dynamicLabels = ["pp", "p", "mp", "mf", "f", "ff"]';
    
    % Initialise array for storing the dynamics labels
    dynamicLabelIndices = zeros(length(rmsDynamics), 1);
    
    % Loop over each RMS dynamics value 
    for n=1:length(rmsDynamics)

        % Get the current RMS value
        currentRmsValue = rmsDynamics(n);

        % Initialise index to -1 for error checking
        dynamicLabelIndex = -1;
        
        % Loop through the dynamic range
        for m=1:length(rmsDynamicRanges) -  1
            % Check if the current RMS value falls within two of the
            % concurrent values in the dynamic ranges
            if currentRmsValue >= rmsDynamicRanges(m) && currentRmsValue < rmsDynamicRanges(m + 1)
                % If it does, store the index and break
                dynamicLabelIndex = m;
                break;
            end
            
            % Catch the edge cases where the RMS value is smaller than the
            % minimum or greater than the maximum
            if currentRmsValue < rmsDynamicRanges(1)
                dynamicLabelIndex = 1;
            elseif currentRmsValue > rmsDynamicRanges(end)
                dynamicLabelIndex = length(rmsDynamicRanges);
            end

        end
        
        % Store the current dynamic index
        dynamicLabelIndices(n) = dynamicLabelIndex;

    end
    
    % Conver the dynamics indices to labels using the lookup table
    dynamics = dynamicLabels(dynamicLabelIndices);
    
end