function [numCells, combinedString] = combineUserCommands(cellArray)
    % Initialize variables
    numCells = numel(cellArray);
    combinedString = '';

    % Loop through each cell in the cell array
    for i = 1:numCells
        % Append the string in the current cell followed by "\n" to the combined string
        combinedString = [combinedString, cellArray{i}, '\n'];
    end
end