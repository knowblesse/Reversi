function [possiblePositions] = findPossibleMoves(Board)
% find all Possible Moves from the Board State

%% Init.
turn = Board.isPlayer1Turn; % true if P1's turn
board = Board.BoardState;

numX = size(board,1); % height of the board. in original reversi, it's 8.
numY = size(board,2); % width of the board. in original reversi, it's 8.

possiblePositions = zeros(0,2); % empty array for all possible moves

%% Check every board position
for x = 1: numX
    for y = 1: numY
        if board(x,y) ~= 0 % skip if the position is already occupied
            continue;
        else 
           %% if the position is empty, check all nearby 8 positions for opponant stone
            
            % 1  2  3
            % 4  O  5
            % 6  7  8
            
            nrow = max(1,x-1):min(size(board,1),x+1); % nearby rows
            ncol = max(1,y-1):min(size(board,2),y+1); % nearby columns

           %% check nearby positions
            % valid move should have opponant's stone in any of 8 nearby
            % positions
            flag_possible = false;
            for nx = nrow
                for ny = ncol
                    if flag_possible % already possible direction is found.
                        continue;
                    elseif board(nx, ny) == 0 % no stone
                        continue;
                    elseif and(x==nx, y==ny) % current location
                        continue;
                    elseif board(nx,ny) == 1 + (-2*turn) % other players stone found
                        % Check whether my stone exist at the end of the
                        % opponant's stone line.
                        continueSearch = true;
                        multiplier = 2;
                        while continueSearch
                            newX = x + multiplier * (nx - x);
                            newY = y + multiplier * (ny - y);
                            if or(newX<1, numX<newX) % end of the board => my stone not found
                                continueSearch = false;
                            elseif or(newY<1, numY<newY) % end of the board => my stone not found
                                continueSearch = false;
                            elseif board(newX, newY) == 0 % no stone => my stone not found
                                continueSearch = false;
                            elseif board(newX, newY) == -1 + (2*turn) % my stone found
                                possiblePositions = [possiblePositions;[x, y]];
                                flag_possible = true;
                                continueSearch = false;
                            else % opponant's stone found => continue
                                multiplier = multiplier + 1;
                            end
                        end  
                    end
                end
            end
        end
    end
end