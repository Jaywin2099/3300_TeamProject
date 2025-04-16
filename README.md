# 3300_TeamProject

This is the home repository for our SLU CSCI 3300 class's team agile project.

### The Swifties

We are currently developing an AR fact-of-the-day IOS app that also scans and reports information on whatever you'd like using image recognition.

### Design Links
- <a href="https://docs.google.com/document/d/17iHpNunVMzO-UT2wNKKZXIwQba7SwDKSYSnAKIRmWPw/edit?usp=sharing">Proposal</a>
- <a href="https://docs.google.com/document/d/12_2QKN3l9uep0tp9M55jegU8vaK22-mDRxQ1XigxPTc/edit?usp=sharing">High Level Design Document</a>

## Quickstart Guide
> You will need a Mac with XCode and an iPhone to complete the Quickstart Guide

1. Clone the repository
```bash
  git clone https://github.com/Jaywin2099/3300_TeamProject.git
```

2. Sign in as a devloper
    1. Open xcode and navigate to the SwiftLearning Project.
    2. Navigate to the SwiftLearning Project Build (not the SwiftLearning directory)
    3. Under Targets select SwiftLearning
    4. Navigate to Signing and Capabilites in the toolbar
    5. Under Signing select or create your own personal account (not team! do not pay to create an account!) and ensure the box for Automatically manage signing is checked

3. Setup your config file
    1. Open xcode and navigate to the SwiftLearning Project
    2. Navigate to SwiftLearning Project Build > Targets > SwiftLearning > Build Settings and in the filter search bar enter DEVELOPMENT_TEAM
    3. In the Development Team field click on \<Name\> (Personal Team) and select Other
    4. Copy/Save the digits that appear and click out (anywhere outside of the pop-up box)
    5. In the root directory create a config file and in the menu bar navigate to File > New > File from Template and under Other select Configuration Settings File, and name it AllBuilds
    6. Then inside your AllBuilds.xcconfig file write the following and save
    ```C++
      BUNDLE_ID = <YOUR_FIRST_NAME>.SwiftLearning
      DEVELOPMENT_TEAM_ID = <YOUR_DEVELOPMENT_TEAM_NUMBER>
      /*
        - You don't need to put your first name for the BUNDLE_ID, just put something
          that doesn't make XCode say "bundle_id already registered to ..." or some bs like that
        - YOUR_DEVELOPMENT_TEAM_NUMBER is the saved number from step 4
      */
    ```
    > *If you ever edit your sign-in like in step 2 in the Quickstart Guide you will need to discard the change or update the config/build settings accordingly.*

4. Edit your build settings
    1. Navigate to SwiftLearning Project Build > Info > Configurations
    2. Under both Debug and Release for the SwiftLearning Project (not target) change None to AllBuilds.xcconfig
    4. Navigate to SwiftLearning Project Build > Targets > SwiftLearning > Build Settings (ensure All and combined are selected directly below Build Settings)
    5. In the filter search bar enter PRODUCT_BUNDLE_IDENTIFIER
    6. Under Packaging find PRODUCT_BUNDLE_IDENTIFIER and click the empty line next to it, replacing it with $(BUNDLE_ID)
    7. You should now see  \<Name\> (Personal Team) - $(DEVELOPMENT_TEAM_ID where the empty line was
    8. In the filter search bar enter DEVELOPMENT_TEAM
    9. Under Signing find DEVELOPMENT_TEAM and click the empty line next to it, replacing it with $(DEVELOPMENT_TEAM_ID)
    10. You should now see your BUNDLE_ID where the empty line was

    > *You might have uncommited changes at this point. Those MUST be discarded before pushing anything else.*

5. Set Up Firebase
    1. Go to https://firebase.google.com/ and ensure you're signed into the Swifties gmail account
    2. In the top right of the navbar click _Go To Console_
    3. Click the SwiftLearning project
    4. Click _+ Add App_ button underneath the SwiftLearning Project Overview
    5. Select _Apple/IOS_ from the list of platforms
    6. Enter your bundle_id, set your app nickname to be SwiftLearning-\<YOUR_FIRST_NAME_HERE\> and click _Register App_ (ignore App Store ID)
    7. Download the GoogleService-Info.plist file and put it within the SwiftLearning directory (same location as AppDelegate)
    8. Ignore everything else and click through
  
   > *XCode may say you have staged changes to commit at this point (in reference to your .plist file). UNSTAGE THESE CHANGES IMMEDIATELY!!! OTHERWISE THE API KEY WILL BE UPLOADED TO GITHUB*

6. Get your gemini API key
    1. Go to <a href='https://aistudio.google.com/apikey'>https://aistudio.google.com/apikey</a>
    2. You may have to log in
    3. Hit the `Create API key` button
    
8. Create a Config.swift file
    1. In the Swiftlearning directory right click and create a new file from templete
    2. Name the file `Config.swift`
    3. inside the file paste the following:
   ```
   struct env {
      static let GEMINI_API_KEY = "YOUR_API_KEY"
   }
   ```
    4. Then just replace `YOUR_API_KEY` with the api key you created in the previous step
      
9. Set up your phone for Developer Mode
    1. In your iPhone Settings navigate to Privacy & Security > Developer Mode, switch your phone to Developer Mode and restart it
    2. Connect your iPhone to your Mac via. usb/usb-c
    3. In your iPhone Settings navigate to VPN & Device Management and under DEVELOPER APP click your apple_id associated with your development team and trust Swift Learning

10. Starting the app
    1. Click the play/run button to the left of SwiftLearning
    2. Allow camera access on your phone when the app opens automatically and you're good to go!

