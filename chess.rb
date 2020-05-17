class ChessBoard
    attr_reader :board, :move_coordinates
    attr_accessor :knight_pos, :visited_spaces, :moves, :visited_nodes, :pathing

    def initialize()
        create_board
        @move_coordinates = {
            one: [2, 1],
            two: [2, -1],
            three: [-2, 1],
            four: [-2, -1],
            five: [1, 2],
            six: [1, -2],
            seven: [-1, 2],
            eight: [-1, -2]
        }
        #track visited spaces in an array in order to check if the knight has visited the destination space.
        @visited_spaces = []

        #track nodes in order to climb back up from the destination node and print the trajectory.
        @visited_nodes = []

        #storage queue for breadth-first tree generation.
        @queue = []
        @moves = 0

        #array to store trajectory.
        @pathing = []
    end

    #Creates a chess board to be used as a check for move legality
    def create_board
        @board = []
        0.upto(7) {|i|
            0.upto(7) {|j|
                @board << [i,j]
            }
        }
        return @board
    end

    #initialize the knight's moves and check visited spaces against destination space.
    def knight_moves(start, destination, queue = @queue)
        if (start == destination)
            p "Input a different start and destination please."
        else
            @visited_spaces = []
            @visited_nodes = []
            queue << Space.new(start, nil)
            until @visited_spaces.include?(destination) do
                generate_spaces(@queue)
            end
            if @visited_spaces.include?(destination)
                @visited_nodes.each do |node|
                    if (node.x == destination[0] && node.y == destination[1])
                        while node.previous_space do
                            @pathing.unshift([node.x, node.y])
                            node = node.previous_space
                            @moves += 1
                        end
                        @pathing.unshift([node.x, node.y])
                    end
                end
                puts "Knight reaches #{destination} in #{moves} moves:"
                p @pathing
            end
        end
    end

    #generates legal spaces for the knight to visit from its current position.
    def generate_spaces(arr)
        @move_coordinates.each {|key, value|
            space_x = value[0] + arr[0].x
            space_y = value[1] + arr[0].y
            space_new = Space.new([space_x, space_y], arr[0]) if @board.include?([space_x, space_y])
            arr << space_new if space_new
            @visited_nodes << space_new if space_new
            @visited_spaces << [space_x, space_y] if space_new
        }
        arr.shift
        return @visited_spaces
    end
end

class Space
    attr_reader :x, :y, :previous_space
    def initialize(arr, previous_space)
        @x = arr[0]
        @y = arr[1]
        @previous_space = previous_space
    end
end

chess = ChessBoard.new
chess.knight_moves([0,0], [7,7])