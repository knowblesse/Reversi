%% SelfPlay
% Expand BoardStates with self play.

%% Constants
% numGame : number of selfplay games to do.
% discounting : discounting factor for backward value update
% goRandom : if true, all moves are randomly selected. if false, next move
% is selected by softmax function.
% rewardValueRatio : (immediate reward * rewardValueRatio) + 
% (value updated from BoardStates * (1-rewardValueRatio) ) is used as score
% vaule to feed in the softmax function
numGame = 1000;
discounting = 0.9;
goRandom = false;
updateBoardStates = true;
rewardValueRatio = 0.3;
inverseTemperature = 0.5;

%% Initialize BoardStates
if ~exist('BoardStates','var')
    BoardStates = cell(60,1);
    for i = 1 : 60
        BoardStates{i} = cell(numGame,1);
        for j = 1 : numGame
            BoardStates{i}{j,1} = zeros(8, 8);
            BoardStates{i}{j,2} = 0;
            BoardStates{i}{j,3} = 0;
        end
    end
end

%% Play Games
Games = cell(numGame,1);
winner = zeros(numGame,1);
for g = 1 : numGame
    if rem(g,100) == 0
        fprintf('Playing... %d\n', g);
    end
    %% Initialize the Board
    B = Board();
    B.Initialize();
    Moves = {B};
    noPossibleMoveInARow = 0; % if >=2, P1 and P2 has no place to play. => end of the game
    while noPossibleMoveInARow < 2
        %% Search Possible Moves
        [possiblePositions] = findPossibleMoves(B);
        numPossMove = size(possiblePositions,1);
        if numPossMove == 0 % No Possible Moves
            noPossibleMoveInARow = noPossibleMoveInARow + 1;
            B.isPlayer1Turn = not(B.isPlayer1Turn);
            continue
        else
           %% Select Move
            noPossibleMoveInARow = 0;
            if goRandom % Next move is randomly selected
                selectedMoveIndex = randi(numPossMove);
            else % Next move is selected based on softmax function
               %% RL parameters
                % reward : immediate board score after the move
                % value : expected game result from BoardStates
                rewardMoves = zeros(numPossMove,1);
                valueMoves = zeros(numPossMove,1);

               %% Check all possible moves
                for m = 1 : numPossMove
                    tempB = updateBoard(B, possiblePositions(m,:));
                    tempb = tempB.BoardState;
                  %% Calculate reward
                    rewardMoves(m) = sum(sum(tempb));
                  %% Calculate value
                    stateFound = false;
                    i = 1;
                    currentStageNumber = sum(sum(tempb == 0)) + 1;
                    while and(BoardStates{currentStageNumber}{i,3} ~=0, ~stateFound)
                        if tempb == BoardStates{currentStageNumber}{i,1}
                            valueMoves(m) = BoardStates{currentStageNumber}{i,2} / BoardStates{currentStageNumber}{i,3};
                            stateFound = true;
                        end
                        i = i + 1;
                    end
                end
              %% Evaluate score
                % scoreMoves : total score from the reward and value
                scoreMoves = rewardMoves*rewardValueRatio + valueMoves*(1-rewardValueRatio); 
              %% Select Move
                if B.isPlayer1Turn
                    selectedMoveIndex = softmaxSel(scoreMoves, inverseTemperature);
                else
                    selectedMoveIndex = softmaxSel(scoreMoves * (-1), inverseTemperature);
                end
            end
          %% Update the board 
            newB = updateBoard(B, possiblePositions(selectedMoveIndex, :));
            Moves = [Moves, {newB}];
            B = newB;
        end
    end
    if updateBoardStates
        %% update table
        for m = numel(Moves) : -1 : 2
            board = Moves{m}.BoardState;
            newState = true;
            b = 1;
            currentStageNumber = sum(sum(board == 0))+1;
            while and(BoardStates{currentStageNumber}{b,3} ~= 0, newState)
                if BoardStates{currentStageNumber}{b,1} == board
                    BoardStates{currentStageNumber}{b,2} = ...
                        BoardStates{currentStageNumber}{b,2} + ...
                        sum(sum(B.BoardState))*discounting^(numel(Moves)-m);
                    BoardStates{currentStageNumber}{b,3} = ...
                        BoardStates{currentStageNumber}{b,3} + 1;
                    newState = false;
                end
                b = b + 1;
            end
            if newState
                BoardStates{currentStageNumber}{b,1} = board;
                BoardStates{currentStageNumber}{b,2} = sum(sum(B.BoardState))*discounting^(numel(Moves)-m);
                BoardStates{currentStageNumber}{b,3} = 1;
            end
        end
    end
    if sum(sum(B.BoardState))>0
        winner(g,1) = 1;
    else
        winner(g,2) = 2;
    end
end