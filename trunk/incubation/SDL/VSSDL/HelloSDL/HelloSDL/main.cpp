#include "SDL.h"
#include "SDL_image.h"

int main(int argc, char **argv)
{
    printf("\nHello SDL User!\n");

	/* initialize SDL */
    if (SDL_Init(SDL_INIT_EVERYTHING) < 0) {
        fprintf( stderr, "Video initialization failed: %s\n",
            SDL_GetError( ) );
        SDL_Quit( );
    }

    SDL_Surface *screen = SDL_SetVideoMode(800, 600, 16, SDL_SWSURFACE);

    SDL_Surface *bg;
    bg = IMG_Load(".\\resources\\daughterroom.png");

    SDL_Surface *image;
    image = IMG_Load(".\\resources\\after.png");

    if (!image) {
        fprintf( stderr, "Loading image failed: %s\n",
        SDL_GetError( ) );
        SDL_Quit( );
    }

    SDL_Rect dstrect;

    dstrect.x = 0;
    dstrect.y = 0;
    SDL_BlitSurface(bg, NULL, screen, &dstrect);
    dstrect.x = 200;
    dstrect.y = 200;
    SDL_BlitSurface(image, NULL, screen, &dstrect);

    SDL_Flip(screen);


	// Main loop
	SDL_Event event;
    while(1) {
        // Check for messages
        if (SDL_PollEvent(&event)) {
            // Check for the quit message
            if (event.type == SDL_QUIT) break;
        }
        // Game loop will go here...
    }

    SDL_FreeSurface(image);
    SDL_FreeSurface(screen);

    SDL_Quit( );

    return 0;
}