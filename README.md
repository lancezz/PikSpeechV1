# Starting up PikSpeech

To run the app, first download the project. Then, go into the terminal and navigate to the path with the source code, and provide the command:
 *pod install*
   This will allow all the pods to be installed for the app to function correctly.
   
Finally when running the app, ensure that you are using an iPad, since we have constrained the app to work on only these devices. To ensure that the UI is working at its best, the recommended device is an iPad Pro (10.5-inch) since the UI constraints still have issues with other models.

# Register into PikSpeech

On start up of the app, you will be provided a screen that allows you to register an account or sign in to an already registered one. Specifically for registering, one needs to provide a valid email and a non trivial password (a password like “password” is non trivial enough). If the email is currently not valid or if the password is too trivial, ***there will be no indication that you have made a mistake***. This is due to time constraints of implementing these features. Upon registering, there will be ***no need to verify the email*** for ease of use of testing or time constraints of implementing this feature.

# Sign into PikSpeech
If you have already registered an account, you can sign in with that. Otherwise, you can use the credentials below. 
* **User**: CMPT275Group11Test@gmail.com
* **Password**: testing

* **Note:** If the email is not valid or the password is not correct, there will be no indication that you have made a mistake. This is due to time constraints of implementing these features. In terms of user experience, using the keyboard will overshadow the text field that you are writing on. This is expected, as we have not taken into account the issue.*

# Main Activity View

In this view, you will see the activity that the user will most often use. As previously promised in Version 1, we can do Tile-to-Sentence and Sentence-to-Speech when choosing the appropriate categories and tiles. No functionality has been changed other that the customizability of the app which is to be described in the later section of the README file.

## Parental Settings Features

Shown below are features that have been implemented. Due to time constraints, not all features are finished, but this will change for the better in the final version.

### Camera Roll
Entering into the Camera Roll View will give a prototype of the view. There will be an option to Upload from the Camera Roll, choose for a particular category to place the Tile, and an option to place a name on the Tile.
Upon successful uploading, there will be ***no indication that it has uploaded successfully*** due to time constraints of implementing these features. Our app currently does not account for duplicate entries of a newly tile with the same text of one that already exists for that given user instead it replaces it with the newer version of the tile. To verify at this current version, one must go back to the Main View and go to the category the Tile was placed in to see the update.

* **Note:** The User Experience will not be optimal upon using this especially with the use of a model that was not recommended. Also note that if a picture was not uploaded from the Camera Roll or if a name was not placed on the Tile, there will no indication that you have made a mistake. This is due to time constraints of implementing these features.*

### Drawing
Entering into the Drawing View will show an almost finished version of this feature. At the top are options to tap on the Reset, Settings, and Share. At the bottom left are color presets that the user can use, and majority of the view is drawing.
To draw, one can use the touch screen and draw which should be intuitive. Our app offers high customizibility color, opacity, and brush size, go into the settings to do so. In order save the image, one needs to go to the Share option, and choose the Save Image option this will save the image onto the camera roll. However, since there is ***no direct feedback that there was a successful save***,one needs to either go into their Camera Roll to check or to go back to the Camera Roll Feature
and upload the image through there. Once you have gone through the Camera Roll Feature, you can verify the upload using
the same steps.

### Colours/ Sizes
Colours and sizes are customizable with the given presets. What is in the view is still its prototype. The first row corresponds to the color customization. The second row corresponds to the amount of tiles per row.
* **Note:** If the user has tapped onto a preset, there will be no indication that the user’s customization has changed.
This is due to time constraints of implementing these features.*

### Logout
Upon tapping the Logout, the user will be logged out of their account automatically.

### Back to Main
Upon tapping the Back to Main, the user will be sent back to the Main View where the user can use the app once more.

# Final Notes
Upon the use of the app, the app might spawn minor bugs due to its dependence on Firebase. This could be due to its connection, the device being used, or Firebase going down for maintenance.
Shown below are features that have not yet been implemented. One can expect that entering these views leads to nothing important.
* Add Favourites
* Delete

