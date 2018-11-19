Starting up PikSpeech
After downloading the project to run the app, ensure to go into the terminal with the appropriate path and provide the command:
pod install
This will allow all the pods to be installed for the app to function correctly.
Finally when running the app, ensure that one is using an iPad since we have constrained the app to work on only these types of
models.
To ensure that the UI is working at its best, the recommended device is an iPad Pro (10.5-inch) since the UI constraints still have issues
with other models.
#####################################################################################################################
Register into PikSpeech
On start up of the app, you will be provided a screen that allows you to register for the account or to sign in to an already registered one.
Specifically for registering, one needs to provide a valid email and a non trivial password (a password like “password” is non trivial
enough).
*Note that if the email is currently not valid or if the password is too trivial, there will be no indication that you have made a
mistake. This is so due to time constraints of implementing these features*
Upon registering, there will be no need to verify the email for ease of use of testing or time constraints of implementing this feature.
#####################################################################################################################
Sign into PikSpeech
We have already provided a test account for the debugging of the app which we have provided for you:
User: CMPT275Group11Test@gmail.com
Password: password
If you have already registered an account, you can already use the account you have made.. but again we have provided a test email for
you.
*Note that if the email is not valid or the password is not correct, there will be no indication that you have made a mistake. This
is due to time constraints of implementing these features*
Notes on the Sign in/ Register View
In terms of user experience, using the keyboard will overshadow the text field that one is writing towards. This is expected as we have
not taken into account the issue.
#####################################################################################################################
Main Activity View

In this view, you will be presented by the activity that the user will most often use. As previously promised in Version 1, we can do Tile-
to-Sentence and Sentence-to-Speech when choosing the

appropriate categories and tiles. No functionality has been changed other that the customizability of the app which is to be described in
the later section of the README file
#####################################################################################################################
Parental Settings Features
Shown below are features that have not yet been implemented. One can expect that entering these views leads to nothing important.
-Add Favourites
-Delete
Shown below are features that has been implemented. Due to time constraints, not each feature is in its final version and is yet to
change in the final version
Camera Roll
Entering into the Camera Roll View will give a prototype of the view. There will be an option to Upload from the Camera Roll,
choose for a particular category to place the Tile, and an option to place a name on the Tile.
Note that the User Experience will not be optimal upon using this especially with the use of a model that was not recommended.
Also note that if a picture was not uploaded from the Camera Roll or if a name was not
placed on the Tile, there will no indication that you have made a mistake. This is due to time constraints of implementing these
features.
Upon successful uploading, there will be no indication that it has uploaded successfully due to time constraints of implementing
these features. To verify at this current version, one must go back to the Main View and
go to the category the Tile was placed in to see the update.
Drawing
Entering into the Drawing View will show an almost finished version of this feature. At the top are options to tap on the Reset,
Settings, and Share. At the bottom left are color presets that the user can use, and majority
of the view is drawing.

To draw, one can use the touch screen and draw which should be intuitive.
To choose a highly customized color, opacity, and brush size, go into the settings to do so.
To finally save the image, one needs to go to the Share option, and choose the Save Image option.
Doing so will save the image onto the camera roll. However since there is no direct feedback that there was a successful save,
one needs to either go into their Camera Roll to check or to go back to the Camera Roll Feature
and upload the image through there. Once you have gone through the Camera Roll Feature, you can verify the upload using
the same steps.
Colours/ Sizes
Colours and sizes are customizable with the given presets. As we have not yet given much thought into the User Experience,
what is in the view is still its prototype.
The first row corresponds to the color customization.
The second row corresponds to the amount of tiles per row.
*Note that if the user has tapped onto a preset, there will be no indication that the user’s customization has changed.
This is due to time constraints of implementing these features*
Logout
Upon tapping the Logout, the user will be logged out of their account automatically.
Back to Main
Upon tapping the Back to Main, the user will be sent back to the Main View where the user can use the app once more.
#####################################################################################################################
Final Notes
Upon the use of the app, the app might spawn minor bugs due to its dependence on Firebase. This could be due to its connection, the
device being used, or Firebase going down for maintenance.
