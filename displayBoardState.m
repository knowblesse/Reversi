function displayBoardState(B, possiblePositions)
board = B.BoardState;

numX = size(board,1); % height of the board. in original reversi, it's 8.
numY = size(board,2); % width of the board. in original reversi, it's 8.

if nargin == 1
    possiblePositions = [0,0];
end

for x = 1 : numX
    for y = 1 : numY
        if board(x,y) == 1
            fprintf('¡Ü ');
        elseif board(x,y) == -1
            fprintf('¡Û ');
        else
            flag = true;
            for i = 1 : size(possiblePositions,1)
                if possiblePositions(i,:) == [x,y]
                    fprintf('£ª ');
                    flag = false;
                end
            end
            if flag
                %fprintf('¡¡ ');
                fprintf('¡à ');
            end
        end
    end
    fprintf('\n');
end
fprintf('\n\n\n');
end

