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
    5. Under Signing select or create your account for a team and ensure the box for Automatically manage signing is checked

3. Setup your config file
    1. Open xcode and navigate to the SwiftLearning Project
    4. Navigate to SwiftLearning Project Build > Targets > SwiftLearning > Build Settings and in the filter search bar enter DEVELOPMENT_TEAM
    5. In the Development Team field click on \<Name\> (\<Team Type\>) and select Other
    6. Copy/Save the digits that appear and replace them with $(DEVELOPMENT_TEAM)
    7. In the root directory create a config file and in the menu bar navigate to File > New > File from Template and under Other select Configuration Settings File, then name it Config
    8. Then inside your Config.xcconfig file write the following and save
    ```C++
      DEVELOPMENT_TEAM = <YOUR_DEVELOPMENT_TEAM_NUMBER>
      // YOUR_DEVELOPMENT_TEAM_NUMBER is the saved number from step 6
    ```
    > *If you ever edit your sign-in like in step 2 in the Quickstart Guide you will need to discard the change or update the config/build settings accordingly.*

4. Set up your phone for Developer Mode
    1. In your iPhone Settings navigate to Privacy & Security > Developer Mode, switch your phone to Developer Mode and restart it
    2. Connect your iPhone to your Mac via. usb/usb-c
    3. In your iPhone Settings navigate to VPN & Device Management and under DEVELOPER APP click your apple_id associated with your development team and trust Swift Learning

5. Starting the app
    1. Click the play/run button to the left of SwiftLearning
    2. Allow camera access on your phone when the app opens automatically and you're good to go!

