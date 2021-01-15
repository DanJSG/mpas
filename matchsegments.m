%MATCHEDSEGMENTS Function to fit some data to a set number of samples
%                points which last a certain duration.
% Stretches or shrinks data with a set duration to have a different number
% of sample points.
function[matchedValues] = matchsegments(originalData, matchLength, duration)
    
    % Setup the time domain
    matchedTimeDomain = linspace(0, duration, length(originalData));
    
    % Determine the length of each sample in time
    segmentLength = matchedTimeDomain(end) / matchLength;
    
    % Initialise value for storing output
    matchedValues = zeros(matchLength, 1);
    
    % Loop over each sample in output
    for n=1:matchLength
        
        % Get the original data's value that falls within the time segment
        value = originalData(matchedTimeDomain <= n * segmentLength & matchedTimeDomain >= (n - 1) * segmentLength);
        
        % If multiple values are found, calculate the mean
        if length(value) > 1
            value = mean(value);
        % If no values are found, then use the previous values
        elseif length(value) < 1 && n > 1
            value = matchedValues(n - 1);
        end

        % Update the current sample for the output
        matchedValues(n) = value;
    end
    
end