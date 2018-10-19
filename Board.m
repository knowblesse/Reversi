classdef Board < handle
    properties
        BoardState
        isPlayer1Turn
        BoardValue = 0;
    end
    methods
        function obj = Board(BoardState, isPlayer1Turn, BoardValue)
            if nargin > 0
                obj.BoardState = BoardState;
                obj.isPlayer1Turn = isPlayer1Turn;
                obj.BoardValue = BoardValue;
            else
                obj.Initialize();
            end
                
        end
        function Initialize(obj)
            obj.BoardState = zeros(8,8);
            obj.BoardState(4,4) = 1;
            obj.BoardState(5,5) = 1;
            obj.BoardState(4,5) = -1;
            obj.BoardState(5,4) = -1;
            
            obj.isPlayer1Turn = true;
            
            obj.BoardValue = 0;
        end
    end
end
            