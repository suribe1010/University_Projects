//Code by Jacek Wieczorek

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <iostream>
#include <maze.h>
#include <point.h>

using namespace std;
using namespace ecn;

//CALL THROUGH TERMINAL -->
//LOCATION IN TERMINAL FILE: BUILD
//CALL ./generator 11 13 20
//        width height percentage


typedef struct
{
    int x, y; //Node position - little waste of memory, but it allows faster generation
    void *parent; //Pointer to parent node
    char c; //Character to be displayed
    char dirs; //Directions that still haven't been explored
} Node;

Node *nodes; //Nodes array
int width, height, percentage; //Maze dimensions

Maze *maze; // WE CREATE A MAZE ARRAY


int init( ) //initialises maze
{

    maze = new Maze(height, width); //WE ALLOCATE MEMORY

    int i, j;
    Node *n;

    //Allocate memory for maze //memory we need
    nodes = (Node*)calloc( width * height, sizeof( Node ) );//nº of elements: W*H
                                                            //size of each element. integer:4
                                                            //creates space for num*size) bytes

    if ( nodes == NULL ) return 1;

    //Setup crucial nodes
    for ( i = 0; i < width; i++ )
    {
        for ( j = 0; j < height; j++ )
        {
            n = nodes + i + j * width;
            if ( i * j % 2 ) //here for example, in (1,1) we should have wall. But
                             //sometimes we dont have. Don't forget about the part that erases walls in this code.
            {
                n->x = i;
                n->y = j;
                n->dirs = 15; //Assume that all directions can be explored (4 youngest bits set)
                n->c = ' ';
            }
            else n->c = '#'; //Add walls between nodes

        }
    }
    return 0;
}

Node *link( Node *n )
{
    //Connects node to random neighbor (if possible) and returns
    //address of next node that should be visited

    int x, y;
    char dir;
    Node *dest;

    //Nothing can be done if null pointer is given - return
    if ( n == NULL ) return NULL;

    //While there are directions still unexplored
    while ( n->dirs )
    {
        //Randomly pick one direction
        dir = ( 1 << ( rand( ) % 4 ) );

        //If it has already been explored - try again
        if ( ~n->dirs & dir ) continue;

        //Mark direction as explored
        n->dirs &= ~dir;

        //Depending on chosen direction
        switch ( dir )
        {
            //Check if it's possible to go right
            case 1:
                if ( n->x + 2 < width )
                {
                    x = n->x + 2;
                    y = n->y;
                }
                else continue;
                break;

            //Check if it's possible to go down
            case 2:
                if ( n->y + 2 < height )
                {
                    x = n->x;
                    y = n->y + 2;
                }
                else continue;
                break;

            //Check if it's possible to go left
            case 4:
                if ( n->x - 2 >= 0 )
                {
                    x = n->x - 2;
                    y = n->y;
                }
                else continue;
                break;

            //Check if it's possible to go up
            case 8:
                if ( n->y - 2 >= 0 )
                {
                    x = n->x;
                    y = n->y - 2;
                }
                else continue;
                break;
        }

        //Get destination node into pointer (makes things a tiny bit faster)
        dest = nodes + x + y * width;

        //Make sure that destination node is not a wall
        if ( dest->c == ' ' )
        {
            //If destination is a linked node already - abort
            if ( dest->parent != NULL ) continue;

            //Otherwise, adopt node
            dest->parent = n;

            //Remove wall between nodes
            nodes[n->x + ( x - n->x ) / 2 + ( n->y + ( y - n->y ) / 2 ) * width].c = ' ';


            //Return address of the child node
            return dest;
        }
    }

    //If nothing more can be done here - return parent's address
    return (Node*)n->parent;
}

void draw( )
{
    int i, j;

    //Outputs maze to terminal - nothing special
    for ( i = 0; i < height; i++ )
    {
        for ( j = 0; j < width; j++ )
        {

            printf( "%c", nodes[j + i * width].c );

            //WE WANT TO DIG, TO MAKE SPACES INTO THE COLOUR WHITE
            if(nodes[j + i*width].c == ' ')
                maze->dig(j,i);

        }
        printf( "\n" );
    }
}


//REMOVING WALLS. PERCENTAGE SHOULD BE INTRODUCED AS A NUMBER BETWEEN 0-100.
//IF WE HAVE A HUGE MAZE(TENDS TO INFINITE), THE PERCENTAGE OF WALLS REMOVED WOULD BE EXACTLY THE PERCENTAGE INTRODUCED BY THE USER.
//WE DONT WANT TO REMOVE WALLS IN THE MAZE'S BORDERS
void erase(int percentage)
{

    srand(time(NULL));
    for (int k = 1; k < height-1; k++)
    {
        for (int l = 1; l < width-1; l++)
        {
            int num = random()%100;

            if (num < percentage )
            {
                if (nodes[k*width+l].c == '#')
                {
                    nodes[k*width+l].c = ' ';
                }
            }
        }
    }


}


int main( int argc, char **argv )
{
    Node *start, *last;


    //Check argument count
    if ( argc < 4 ) //3 ARGUMENTS: NAME, WIDTH, HEIGHT AND PERCENTAGE
    {
        fprintf( stderr, "%s: please specify maze dimensions!\n", argv[0] );
        exit( 1 );
    }

    // this is done to transform string to integer. first element in the argv[0] is the name of the project
    //width = atoi(argv[1]);
    //height = atoi(argv[2]);

    //Read maze dimensions from command line arguments
    if ( sscanf( argv[1], "%d", &width ) + sscanf( argv[2], "%d", &height ) < 2 )
    {
        fprintf( stderr, "%s: invalid maze size value!\n", argv[0] );
        exit( 1 );
    }

    //READ THE PERCENTAGE FROM COMMAND LINE ARGUMENTS
    sscanf(argv[3], "%d", &percentage); //%d: ONLY USEFUL FOR INTEGER
                                   // %g: WITH FLOATS




    //Allow only odd dimensions
    if ( !( width % 2 ) || !( height % 2 ) )
    {
        fprintf( stderr, "%s: dimensions must be odd!\n", argv[0] );
        exit( 1 );
    }

    //Do not allow negative dimensions
    if ( width <= 0 || height <= 0 )
    {
        fprintf( stderr, "%s: dimensions must be greater than 0!\n", argv[0] );
        exit( 1 );
    }

    //Seed random generator
    srand( time( NULL ) );

    //Initialize maze
    if ( init( ) )
    {
        fprintf( stderr, "%s: out of memory!\n", argv[0] );
        exit( 1 );
    }

    //Setup start node
    start = nodes + 1 + width;
    start->parent = start;
    last = start;

    //CALL ERASE TO REMOVE WALLS RANDOMLY
    erase(percentage);


    //Connect nodes until start node is reached and can't be left
    while ( ( last = link( last ) ) != start );
    draw( );

    //SAVE THE MAZE SO THAT IT CREATES AN IMAGE IM
    maze->save();
}



