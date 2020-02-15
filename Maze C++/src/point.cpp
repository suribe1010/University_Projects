#include <point.h>
#include <maze.h>

using std::min;
using std::max;

namespace ecn
{

Maze Point::maze;

//checking if we reached the parent
bool childrenisParent(Point point,  const Point parent)
{
    if(point.x == parent.x && point.y == parent.y)
        return true;
    else
        return false;
}

//change of direction in a corner so that we can continue in the corridor
int newdirection (Point point, int previousdirection)
    {
        int direction;
        std::vector<bool > moves =
        {
            {Point::maze.isFree(point.x -1, point.y)},
            {Point::maze.isFree(point.x +1, point.y)},
            {Point::maze.isFree(point.x , point.y-1)},
            {Point::maze.isFree(point.x, point.y+1)},
        };
        moves[previousdirection] = false;
        std::vector<bool>::iterator it;
        it = std::find(moves.begin(), moves.end(), true);

        return it - moves.begin();
    }

//gives the number of walls around the actual node
int TypeOfNode (Point point)
{
    int numberWalls=0;
    std::vector<std::pair <int,int> > moves =
    {
        {point.x -1, point.y},
        {point.x +1, point.y},
        {point.x, point.y-1},
        {point.x, point.y+1},
    };


    for(int i=0; i<4; i++)
    {
        if(!Point::maze.isFree(moves[i].first, moves[i].second))
            numberWalls = numberWalls + 1;//counter
    }
    return numberWalls;
}

//say if there exists a corridor checking 3 conditions:
// 2 are because there should exits 2 walls
//the third one is checking that the next node to move is free
bool isCorridor (Point &point, int &direction)
{
    bool corridor;
    switch (direction)
    {
        case 0: //going left
        {
            if(!Point::maze.isFree(point.x, point.y +1) && !Point::maze.isFree(point.x, point.y -1) && Point::maze.isFree(point.x, point.y))
                corridor = true;
            else
                corridor = false;
            break;
        }
        case 1: //going right
        {
            if(!Point::maze.isFree(point.x, point.y +1) && !Point::maze.isFree(point.x, point.y -1) && Point::maze.isFree(point.x, point.y))
                corridor = true;
            else
                corridor = false;
            break;
        }
         case 2: //going up
         {
            if(!Point::maze.isFree(point.x-1 , point.y ) && !Point::maze.isFree(point.x+1, point.y) && Point::maze.isFree(point.x, point.y))
                corridor = true;
            else
                corridor = false;
            break;
        }
        case 3: //going down
        {
            if(!Point::maze.isFree(point.x-1 , point.y ) && !Point::maze.isFree(point.x+1, point.y) && Point::maze.isFree(point.x, point.y))
                corridor = true;
            else
                corridor = false;
            break;
        }
    }
    return corridor;
}

//computing the parents and pushing them back to a vector with the corners
void parents(std::pair<int,int> moves,int& d, const Point &parent, std::vector<Point> &corners)
{
    Point point (moves.first, moves.second);
    int direction = d;
    while (true)
    {

        switch (direction)
        {
        case 0: //going left

            while(Point::maze.isFree(point.x - 1, point.y) && isCorridor(point, direction) && !childrenisParent(point, parent))
                point.x --;
            break;
        case 1: //going right

            while(Point::maze.isFree(point.x + 1, point.y) && isCorridor(point, direction) && !childrenisParent(point, parent))
                point.x ++;
            break;
        case 2: //going up

            while(Point::maze.isFree(point.x, point.y - 1) && isCorridor(point, direction) && !childrenisParent(point, parent))
                point.y --;
            break;
        case 3: //going down

            while(Point::maze.isFree(point.x, point.y + 1) && isCorridor(point, direction) && !childrenisParent(point, parent))
                point.y ++;
            break;
        }

        if(childrenisParent(point, parent))
        {
            corners.push_back(point);
            return;
        }
        int NumberWalls = TypeOfNode(point);
        NumberWalls = TypeOfNode(point);
        if(NumberWalls != 2) //no corner
            return;
        corners.push_back(point);

        int previousdirection;
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
                direction = newdirection (point, previousdirection); //change of direction

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
    }
}

// final print
// maze deals with the color, just tell the points
void Point::print(const Point &parent)
{
    std::vector<Point> corners; //points which are corners, children and parents

    std::vector<std::pair<int,int>> moves =
    {
        {x-1,y},
        {x+1,y},
        {x,y-1},
        {x,y+1},
    };

    for(int i = 0; i<moves.size(); i++)
    {
        if(Point::maze.isFree(moves[i].first, moves[i].second) &&
                corners.empty())
        {   parents(moves[i], i, parent, corners);

            if(!corners.empty())
            {
                if(!childrenisParent(corners[corners.size()-1], parent))
                     corners.clear();

            }
        }
    }
    Point children (x, y);
    std::reverse(corners.begin(), corners.end()); //just to have the parent at first
    corners.push_back(children);//actual children

    while(corners.size() -1) {

        int x_incr(0), y_incr(0);

        if(corners[1].x - corners[0].x)
            x_incr = corners[1].x - corners[0].x > 0 ? 1 : -1;
        else
            y_incr = corners[1].y - corners[0].y > 0 ? 1 : -1;

        int k = 1;
        while(corners[0].x + k*x_incr != corners[1].x || corners[0].y + k*y_incr != corners[1].y)
        {
            maze.passThrough(corners[0].x + k*x_incr,
                             corners[0].y + k*y_incr);
            k++;
        }
        maze.passThrough(corners[1].x,corners[1].y);
        corners.erase(corners.begin()); //erasing first parent
    }

}

void Point::start()
{
    maze.write(x, y);
}

// online print, color depends on closed / open set
void Point::show(bool closed, const Point & parent)
{
    const int b = closed?255:0, r = closed?0:255;
    if(x != parent.x)
        for(int i = min(x, parent.x); i <= max(x, parent.x);++i)
            maze.write(i, y, r, 0, b, false);
    else
        for(int j = min(y, parent.y); j <= max(y, parent.y);++j)
            maze.write(x, j, r, 0, b, false);
    maze.write(x, y, r, 0, b);
}

}
