package gamejolt;

class GameJoltInfo
{
    /**
     * Variable to change which state to go to by hitting ESCAPE or the CONTINUE buttons.
     */
    public static var changeState:MusicBeatState = new MainMenuState();
    /**
    * Inline variable to change the font for the GameJolt API elements.
    * @param font You can change the font by doing **Paths.font([Name of your font file])** or by listing your file path.
    * If *null*, will default to the normal font.
    */
    public static var font:String = null; /* Example: Paths.font("vcr.ttf"); */
    /**
    * Inline variable to change the font for the notifications made by Firubii.
    * 
    * Don't make it a NULL variable. Worst mistake of my life.
    */
    public static var fontPath:String = "assets/fonts/FSEX300.ttf";
    /**
    * Image to show for notifications. Leave NULL for no image, it's all good :)
    * 
    * Example: Paths.getLibraryPath("images/stepmania-icon.png")
    */
    public static var imagePath:String = null; 

    /* Other things that shouldn't be messed with are below this line! */

    /**
    * GameJolt + FNF version.
    */
    public static var version:String = "1.1";
}