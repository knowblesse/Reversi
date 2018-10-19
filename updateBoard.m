function out = updateBoard(Board_, Move)

%% Init.
turn = Board_.isPlayer1Turn; % true if P1's turn
board = Board_.BoardState;

numX = size(board,1); % height of the board. in original reversi, it's 8.
numY = size(board,2); % width of the board. in original reversi, it's 8.

x = Move(1);
y = Move(2);

nrow = max(1,x-1):min(size(board,1),x+1); % nearby rows
ncol = max(1,y-1):min(size(board,2),y+1); % nearby columns

%% check nearby positions
% valid move should have opponant's stone in any of 8 nearby
% positions
for nx = nrow
    for ny = ncol
        if board(nx, ny) == 0 % no stone
            continue;
        elseif and(x==nx, y==ny) % current location
            continue;
        elseif board(nx,ny) == 1 + (-2*turn) % other players stone found
            % Check whether my stone exist at the end of the
            % opponant's stone line.
            continueSearch = true;
            multiplier = 2;
            newX = [];
            newY = [];
            while continueSearch
                newX = [newX, x + multiplier * (nx - x)];
                newY = [newY, y + multiplier * (ny - y)];
                if or(newX(end)<1, numX<newX(end)) % end of the board => my stone not found
                    continueSearch = false;
                elseif or(newY(end)<1, numY<newY(end)) % end of the board => my stone not found
                    continueSearch = false;
                elseif board(newX(end), newY(end)) == 0 % no stone => my stone not found
                    continueSearch = false;
                elseif board(newX(end), newY(end)) == -1 + (2*turn) % my stone found
                    % change opponant stone into my stone
                    board(nx, ny) = -1 + (2*turn); 
                    for i = 1 : multiplier - 2
                        board(newX(i), newY(i)) = -1 + (2*turn);
                    end
                    continueSearch = false;
                else % opponant's stone found => continue
                    multiplier = multiplier + 1;
                end
            end
        end
    end
end
board(x,y) = -1 + (2*turn);
out = Board();
out.BoardState = board;
out.isPlayer1Turn = not(turn);
end