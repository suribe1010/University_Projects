
//int main() {
  //  return 0;
//}

#include <a_star.h>
#include <maze.h>
#warning SOMETIMES IT EXISTS AN ERROR WHEN PRINTING THE MAZE. WITH SOME MAZES, FEW POINTS OF THE PATH REMAINS WHITE

using namespace std;
using namespace ecn;


// a node is a x-y position, we move from 1 each time
class Position : public Point
{
    typedef std::unique_ptr<Position> PositionPtr;
private:
    const int height=Position::maze.height();
    const int width=Position::maze.width();
    const int size = height*width;
    int w[2];

    //vector<tuple <int,int, int> > possibleMovs;



public:
    // constructor from coordinates
    Position(int _x, int _y) : Point(_x, _y) {}

    // constructor from base ecn::Point
    Position(ecn::Point p) : Point(p.x, p.y) {}

    // constructor for line-based motions
    Position(int _x, int _y, int _distance) : Point(_x, _y, _distance) {}

    std::vector <Point> corners;
    static Point starting;
    static Point ending;

    int distToParent()
    {
        // in line-based motion, the distance is not 1 anymore

        return distance;
    }

    //counting the number of walls so that to define de node: dead-end, intersection or corridor
    int TypeOfNode (Point point)
    {

        int numberWalls=0;

        vector<pair <int,int> > moves =
        {
            {point.x -1, point.y},
            {point.x +1, point.y},
            {point.x, point.y-1},
            {point.x, point.y+1},
        };


        for(int i=0; i<4; i++)
        {
            if(!Position::maze.isFree(moves[i].first, moves[i].second))
            {
                numberWalls = numberWalls + 1;//counter
            }
        }
        return numberWalls;
    }

    //say if there exists a corridor checking 3 conditions:
    // 2 are because there should exits 2 walls
    //the third one is checking that the next node to move is free
    bool isCorridor (Point point, int direction)
    {
        bool corridor;
        switch (direction)
        {
            case 0: //going left
            {
                if(!maze.isFree(point.x, point.y +1) && !maze.isFree(point.x, point.y -1) && maze.isFree(point.x, point.y))
                    corridor = true;
                else
                    corridor = false;
                break;
            }
            case 1: //going right
            {
                if(!maze.isFree(point.x, point.y +1) && !maze.isFree(point.x, point.y -1) && maze.isFree(point.x, point.y))
                    corridor = true;
                else
                    corridor = false;
                break;
            }
             case 2: //going up
             {
                if(!maze.isFree(point.x-1 , point.y ) && !maze.isFree(point.x+1, point.y) && maze.isFree(point.x, point.y))
                    corridor = true;
                else
                    corridor = false;
                break;
            }
            case 3: //going down
            {
                if(!maze.isFree(point.x-1 , point.y ) && !maze.isFree(point.x+1, point.y) && maze.isFree(point.x, point.y))
                    corridor = true;
                else
                    corridor = false;
                break;
            }
        }
        return corridor;
    }

    //change of direction in a corner so that we can continue in the corridor
    int newdirection (Point point, int previousdirection)
    {
        int direction;
        vector<bool > moves =
        {
            {maze.isFree(point.x -1, point.y)},
            {maze.isFree(point.x +1, point.y)},
            {maze.isFree(point.x , point.y-1)},
            {maze.isFree(point.x, point.y+1)},
        };
        moves[previousdirection] = false;
        std::vector<bool>::iterator it;
        it = std::find(moves.begin(), moves.end(), true);

        return it - moves.begin();


    }

    //computing distance of the corridor knowing the coordinates of the children and the parent.
    void distanceCorridor ()
    {
        distance = 0;

        while (corners.size()>1)
        {
            int distX=0, distY=0;
            if (corners[0].x != corners[1].x)
                  distX = abs (corners[1].x - corners[0].x);
            else
                  distY = abs (corners[1].y - corners[0].y);
            distance = distance+  distX + distY;
            corners.erase(corners.begin());
        }
        corners.clear();
    }

    //case in which we are in the ending or starting point
    bool terminalNodes (int x, int y)
    {
        if (x == ending.x && y == ending.y)
            return true;
        else
        {
            if (x == starting.x && y == starting.y)
                return true;
            else return false;
        }
    }

    //going through the corridor and changing of direction to find the corners and childrens
    std::vector<PositionPtr> children()
    {
        // this method should return  all positions reachable from this one
        std::vector<PositionPtr> generated;

        vector<pair <int,int> > moves =
        {
            {x -1, y},
            {x +1, y},
            {x, y-1},
            {x, y+1},
        };

        for (int i=0; i<4; i++)
        {
            if(maze.isFree(moves[i].first, moves[i].second))
            {
                Point actual, point;
                actual.x = x;
                actual.y = y;

                corners.push_back(actual);

                point.x =  moves[i].first;
                point.y = moves[i].second;

                int direction;
                direction=i;
                    //MOVING LEFT ::::: 0
                    //MOVING RIGHT :::: 1
                    //MOVING UP ::::::: 2
                    //MOVING DOWN:::::: 3

                while(1)
                {
                    switch (direction)
                    {
                    case 0: //going left
                    {
                        while(maze.isFree(point.x - 1, point.y) && isCorridor(point, direction)
                              && !terminalNodes(point.x, point.y))
                            point.x --;
                        break;
                    }


                    case 1: //going right
                    {
                        while(maze.isFree(point.x + 1, point.y) && isCorridor(point, direction)
                              && !terminalNodes(point.x, point.y))
                             point.x ++;
                        break;
                    }

                    case 2:  //going up
                    {
                        while(maze.isFree(point.x, point.y - 1) && isCorridor(point, direction)
                              && !terminalNodes(point.x, point.y))
                            point.y --;
                        break;
                    }

                    case 3: //going down
                    {
                        while(maze.isFree(point.x, point.y - 1) && isCorridor(point, direction)
                              && !terminalNodes(point.x, point.y))
                             point.y ++;
                        break;
                    }
                    }

                    int numberWalls;
                    numberWalls= TypeOfNode(point);
                    if(terminalNodes(point.x, point.y))
                    {
                        corners.push_back(point);
                        distanceCorridor();
                        generated.push_back(std::make_unique<Position>(point.x, point.y, distance));
                        break;
                    }

                    if (numberWalls == 2 )
                    {
                        int previousdirection;
                        corners.push_back(point);
                        switch (direction)
                        {
                            case 0 : //going left
                                previousdirection = 1;
                            break;
                            case 1 : //going right
                                previousdirection = 0;
                            break;
                            case 2 : //going up
                                previousdirection = 3;
                            break;
                            case 3 : //going down
                                previousdirection = 2;
                            break;
                        }
                        direction = newdirection(point, previousdirection);
                        switch (direction)
                        {
                            case 0 : //going left
                                point.x -=1;
                            break;
                            case 1 : //going right
                                point.x += 1;
                            break;
                            case 2 : //going up
                                point.y -= 1;
                            break;
                            case 3 : //going down
                                point.y += 1;
                            break;
                        }
                        continue;
                    } else //dead-end or intersection
                    {
                        corners.push_back(point);
                        distanceCorridor();
                        generated.push_back(std::make_unique<Position>(point.x, point.y, distance));
                        break;
                    }

                }
            }

        }

    return generated;
    } //method
}; //Class


Point Position::starting(0,0);
Point Position::ending(0,0);

int main( int argc, char **argv )
{
    // load file
    std::string filename = "maze.png";
    if(argc == 2)
        filename = std::string(argv[1]);

    // let Point know about this maze
    Position::maze.load(filename);

    // initial and goal positions as Position's
    Position start = Position::maze.start(),
             goal = Position::maze.end();
    Position::starting = start;
    Position::ending = goal;

    // call A* algorithm
    ecn::Astar(start, goal);

    // save final image
    Position::maze.saveSolution("cell");
    cv::waitKey(0);

}

