#include "SDL.h"
#include "SDL_image.h"


SDL_Surface* processSurface(SDL_Surface *surface, float alpha);


int charX = 200;
int charY = 200;

int main(int argc, char **argv)
{
    printf("\nHello SDL User!\n");

	/* initialize SDL */
    if (SDL_Init(SDL_INIT_EVERYTHING) < 0) {
        fprintf( stderr, "Video initialization failed: %s\n",
            SDL_GetError( ) );
        SDL_Quit( );
    }

    SDL_Surface *screen = SDL_SetVideoMode(800, 600, 32, SDL_DOUBLEBUF|SDL_HWSURFACE|SDL_ANYFORMAT);

    SDL_Surface *bg;
    bg = IMG_Load(".\\resources\\daughterroom.png");

    SDL_Surface *image;
    image = IMG_Load(".\\resources\\after.png");
    
    if (!image) {
        fprintf( stderr, "Loading image failed: %s\n",
        SDL_GetError( ) );
        SDL_Quit( );
    }

    //SDL_SetColorKey(image, SDL_SRCCOLORKEY | SDL_RLEACCEL, SDL_MapRGB(image->format, 255, 255, 255));
    

    SDL_Rect dstrect;

	// Main loop
	SDL_Event event;

    float alpha = 1.0f;
    while(1) {
        // Check for messages
        if (SDL_PollEvent(&event)) {
            // Check for the quit message
            if (event.type == SDL_QUIT) break;
            else if (event.type == SDL_MOUSEMOTION) {
                //printf("%d, %d\n", event.button.x, event.button.y);
                charX = event.motion.x;
                alpha = 1.0f;
            }
        }
        // Game loop will go here...

        //processSurface(image);

        SDL_FillRect(screen , NULL , 0xFFFFFF);
        dstrect.x = 0;
        dstrect.y = 0;
        SDL_BlitSurface(bg, NULL, screen, &dstrect);
        dstrect.x = charX - image->w/2;
        dstrect.y = charY;
        //SDL_SetAlpha(image, SDL_RLEACCEL | SDL_SRCALPHA, 255);
        SDL_BlitSurface(processSurface(image, alpha), NULL, screen, &dstrect);

        SDL_Flip(screen);

        if (alpha > 0.10) ;//alpha -= 0.05;
        else alpha = 1;

        
        //printf("%f\n", alpha);
    }

    SDL_FreeSurface(image);
    SDL_FreeSurface(screen);

    SDL_Quit( );

    return 0;
}


SDL_Surface* processSurface(SDL_Surface *surface, float alpha)
{
    SDL_Surface *newSurface = SDL_CreateRGBSurface(SDL_SWSURFACE, surface->w, 
        surface->h, surface->format->BitsPerPixel, surface->format->Rmask,
        surface->format->Gmask, surface->format->Bmask, surface->format->Amask); 

    Uint32 *raw_pixels, *dest_pixels;
    
    //If the surface must be locked
    if( SDL_MUSTLOCK( surface ) )
    {
        //Lock the surface
        SDL_LockSurface( surface );
    }

    if( SDL_MUSTLOCK( newSurface ) )
    {
        //Lock the surface
        SDL_LockSurface( newSurface );
    }
    
    raw_pixels = (Uint32 *) surface->pixels;
    dest_pixels = (Uint32 *) newSurface->pixels;
    //Go through columns
    for( int x = 0; x < surface->w; x++)
    {
        //Go through rows
        for( int y = 0; y < surface->h; y++)
        {
            int offset = (surface->pitch * y / 4 + x);
            dest_pixels[offset] = ((Uint32)((surface->format->Amask & raw_pixels[offset]) * alpha) & surface->format->Amask)
                + (raw_pixels[offset] & ~surface->format->Amask);
        }
    }
    //Unlock surface
    if( SDL_MUSTLOCK( surface ) )
    {
        SDL_UnlockSurface( surface );
    }

    if( SDL_MUSTLOCK( newSurface ) )
    {
        SDL_UnlockSurface( newSurface );
    }
    return newSurface;
}