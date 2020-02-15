#include <a_star.h>
#include <maze.h>

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


public:

    // constructor from coordinates
    Position(int _x, int _y) : Point(_x, _y) {}

    // constructor from base ecn::Point
    Position(ecn::Point p) : Point(p.x, p.y) {}

    // constructor for line-based motions
    Position(int _x, int _y, int _distance) : Point(_x, _y, _distance) {}

    static Point starting;
    static Point ending;

    int distToParent() //const Point &_child)
    {
        // in line-based motion, the distance is not 1 anymore

        return distance;//_child.distance;
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

    //going through the corridor to childrens
    std::vector<PositionPtr> children()
    {
        // this method should return  all positions reachable from this one
        std::vector<PositionPtr> generated;

        //Moving down
        if(Position::maze.isFree(x, y+1)){
            int j=0;
            while(!Position::maze.isFree(x-1, y+1+j) && !Position::maze.isFree(x+1, y+1+j)&& Position::maze.isFree(x, y+2+j)
                  && !terminalNodes(x, y))
                j++;
            distance = j+1;
            generated.push_back(std::make_unique<Position>(x, y+1+j, distance));
        }

        //Moving up
        if(Position::maze.isFree(x, y-1)){
            int j=0;
            while(  !Position::maze.isFree(x-1, y-1-j) && !Position::maze.isFree(x+1, y-1-j)&& Position::maze.isFree(x, y-2-j)
                    && !terminalNodes(x, y))
                j++;
            distance = j+1;
            generated.push_back(std::make_unique<Position>(x, y-1-j, distance));
        }

        //Moving right
        if(Position::maze.isFree(x+1, y)){
            int j=0;
            while( !Position::maze.isFree(x+1+j, y-1) && !Position::maze.isFree(x+1+j, y+1)&& Position::maze.isFree(x+2+j, y)
                   && !terminalNodes(x, y))
                j++;
            distance = j+1;
            generated.push_back(std::make_unique<Position>(x+1+j, y, distance));
        }

        //Moving left
        if(Position::maze.isFree(x-1, y)){
            int j=0;
            while( !Position::maze.isFree(x-1-j, y-1) && !Position::maze.isFree(x-1-j, y+1)&& Position::maze.isFree(x-2-j, y)
                   && !terminalNodes(x, y))
                j++;
            distance = j+1;
            generated.push_back(std::make_unique<Position>(x-1-j, y, distance));
        }

        if(terminalNodes(x, y))
            generated.push_back(std::make_unique<Position>(x, y, distance));

    return generated;
    }
};



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
