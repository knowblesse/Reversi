%%
B = Board();
B.Initialize();
Moves = {B};
noPossMoveInARow = 0;

myturn = false;
%%
while noPossMoveInARow < 2
    [possiblePositions] = findPossibleMoves(B);
    displayBoardState(B,possiblePositions);
    numPossMove = size(possiblePositions,1);
    if numPossMove == 0
        noPossMoveInARow = noPossMoveInARow + 1;
        B.isPlayer1Turn = not(B.isPlayer1Turn);
        fprintf('No move to do : %d\n', noPossMoveInARow);
        myturn = not(myturn);
    else
        if myturn
            numbers = 1 : numPossMove;
            disp([numbers',possiblePositions]);
            selMove = input('Move?');
            myturn = false;
        else
            myturn = true;
            noPossMoveInARow = 0;
            movesScore = zeros(numPossMove,1);
            for m = 1 : numPossMove
                tempB = updateBoard(B, possiblePositions(m,:));
                tempb = tempB.BoardState;
                for i = 1 : size(BoardStates{sum(sum(tempb == 0)) + 1},1)
                    if tempb == BoardStates{sum(sum(tempb == 0)) + 1}{i,1}
                        movesScore(m) = BoardStates{sum(sum(tempb == 0)) + 1}{i,2} / BoardStates{sum(sum(tempb == 0)) + 1}{i,3};
                        break;
                    end
                end
            end

            [~, selMove] = max(movesScore);
            if any(movesScore ~= 0)
                disp('solution found!');
            end
        end
        newB = updateBoard(B, possiblePositions(selMove, :));
        Moves = [Moves, {newB}];
        B = newB;
    end
    displayBoardState(B);
    pause(2);
    clc;
end