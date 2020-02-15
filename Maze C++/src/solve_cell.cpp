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


    int distToParent()
    {
        // in cell-based motion, the distance to the parent is always 1
        return 1;
    }
    //we can only move in 4 directions. i think like this is more simple that with a for loop because we have few lines of code
    std::vector<PositionPtr> children()
    {
        // this method should return  all positions reachable from this one
        std::vector<PositionPtr> generated;

    if(Position::maze.isFree(x, y-1))
        generated.push_back(std::make_unique<Position>(x, y-1));

    if(Position::maze.isFree(x, y+1))
        generated.push_back(std::make_unique<Position>(x, y+1));

    if(Position::maze.isFree(x+1, y))
        generated.push_back(std::make_unique<Position>(x+1, y));

    if(Position::maze.isFree(x-1, y))
        generated.push_back(std::make_unique<Position>(x-1, y));


    return generated;
    }
};



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

    // call A* algorithm
    ecn::Astar(start, goal);

    // save final image
    Position::maze.saveSolution("cell");
    cv::waitKey(0);

}
