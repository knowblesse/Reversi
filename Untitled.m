%% Constants
numGame = 3000;
discounting = 0.9;

BoardStates = cell(60,1);
for i = 1 : 60
    BoardStates{i} = cell(numGame,1);
    for j = 1 : numGame
        BoardStates{i}{j,1} = zeros(64, 64);
        BoardStates{i}{j,2} = 0;
        BoardStates{i}{j,3} = 0;
    end
end

%% Repeat
Games = cell(numGame,1);
for g = 1 : numGame
    if rem(g,500) == 0
        disp(g);
    end
    B = Board();
    B.Initialize();
    Moves = {B};
    noPossMoveInARow = 0;
    while noPossMoveInARow < 2
        %disp(numel(Moves));
        %displayBoardState(B);
        %pause(1);
        [possiblePositions] = findPossibleMoves(B);
        numPossMove = size(possiblePositions,1);
        if numPossMove == 0
            noPossMoveInARow = noPossMoveInARow + 1;
            B.isPlayer1Turn = not(B.isPlayer1Turn);
            continue
        else
            noPossMoveInARow = 0;
            selMove = randi(numPossMove);
            newB = updateBoard(B, possiblePositions(selMove, :));
            Moves = [Moves, {newB}];
            B = newB;
        end
    end
    
    %% update table
    for m = numel(Moves) : -1 : 2
        board = Moves{m}.BoardState;
        newState = true;
        b = 1;
        while and(BoardStates{sum(sum(board == 0))+1}{b,3} ~= 0, newState)
            if BoardStates{sum(sum(board == 0))+1}{b,1} == board
                BoardStates{sum(sum(board == 0))+1}{b,2} = ...
                    BoardStates{sum(sum(board == 0))+1}{b,2} + ...
                    sum(sum(B.BoardState))*discounting^(numel(Moves)-m);
                BoardStates{sum(sum(board == 0))+1}{b,3} = ...
                    BoardStates{sum(sum(board == 0))+1}{b,3} + 1;
                newState = false;
            end
            b = b + 1;
        end
        if newState
            BoardStates{sum(sum(board == 0))+1}{b,1} = board;
            BoardStates{sum(sum(board == 0))+1}{b,2} = sum(sum(B.BoardState))*discounting^(numel(Moves)-m);
            BoardStates{sum(sum(board == 0))+1}{b,3} = 1;
        end
    end     
end