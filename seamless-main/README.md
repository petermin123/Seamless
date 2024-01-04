# Seamless 🏥💉


## Overview
The Duke Transplant Center is looking for an easy-to-use app that helps decide the proper path for hepatitis B vaccinations for solid organ transplant patients. The focus of the app is creating a user-friendly interface that guides the clinician through a series of questions and information to decide on the best course of action for vaccinations before an organ transplant.


## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributors](#contributors)
- [Acknowledgements](#acknowledgements)
- [Note](#note)


## <a name="features"></a> Features
- **CSV Parser**
    * **File Interpretation:** Parses CSV files to extract questions and vaccination details.
    * **Survey Generation:** Dynamically creates surveys based on CSV input, including questions and vaccine options.

- **Basic Survey Structure**
    * **Flowchart Compliance:** Ensures survey logic strictly follows a predefined flowchart for logical progression.
    * **Conditional Logic:** Incorporates branched questioning and tailored experiences based on user responses.
    * **User Interface Design:** Offers a clear and intuitive interface for easy navigation through the survey.

- **Persistent Storage (Firebase)**
    * **Database Operations:** Manages surveys and user ratings with a robust database supporting CRUD operations.
    * **Data Synchronization:** Keeps data synchronized across devices and sessions for up-to-date survey information.

- **QR Code Scanner**
    * **Code Generation:** Generates custom QR codes for each survey to simplify sharing and distribution.
    * **Scanning Functionality:** Allows QR code scanning to instantly access associated surveys.

- **Note (Pencil Kit)**
    * **Handwriting Recognition:** Supports notes using Apple Pencil or finger input for flexible annotation.
    * **Note Management:** Enables reading, saving, and organizing in-app notes for easy future access.
    * **Drawing Tools:** Provides a range of tools for detailed note-taking and annotations within Pencil Kit.

- **Enhanced Features**
    * **Onboarding View:** Includes a guide for first-time users to navigate the app effectively.
    * **Notifications:** Sends immediate alerts upon survey completion.
    * **Rating System:** Allows users to give structured and unstructured feedback on their experience.
    * **Statistical Analysis:** Performs analytical evaluations on feedback scores received.
    * **iPad Rotation Support:** Support rotation on iPad applications.


## <a name="installation"></a> Installation
1. Clone the repository
```
# if using SSH
git clone git@gitlab.oit.duke.edu:kits/ECE-564-01-F23/projects/seamless.git

# if using HTTPS
git clone https://gitlab.oit.duke.edu/kits/ECE-564-01-F23/projects/seamless.git
```
2. Open the `.xcodeproj` file in XCode to access the project workspace.
3. Install all necessary dependencies and await the completion of the project build process.
4. Execute the project using your preferred simulator or connected device in XCode.
5. Enjoy the app!


## <a name="usage"></a> Usage
Follow these steps to get started:

### Application Initiation
1. **Application Activation:** Initiate the application post-installation, either on a simulator or a physical device. Upon activation, the CSV Parser automatically configures the survey structure.
2. **Onboarding Overview:** New users are presented with an Onboarding view, offering guidance on application usage.

### Survey Engagement
3. **Survey Creation:** Select the `Start Survey` option on the homepage. Complete the survey according to your specific circumstances. A notification will be issued upon survey completion.
4. **Experience Rating:** Utilize the `Rating` feature to evaluate your overall experience, providing both a rating and optional feedback, followed by uploading the result.
5. **QR Code Production:** Employ the QR code generation tool to create a survey-specific QR code, preserving it for future usage.

### Operating on Existing Surveys
6. **Survey List Access:** Via the `List existing surveys` button on the homepage, view all surveys stored in Cloud FireStore. Enable survey search functionality with magnification feature through the search bar. Adjust sorting asynchronously to locate your most recent survey efficiently, or access the scanner view in the top right corner to scan a saved QR code.
7. **Survey Annotation Editing:** Amend survey notations using the drawing tools for enhanced detail and clarity. Once finalized, save and upload your annotations to Firebase Storage.

### Additional Functionalities
8. **Help Guide:** Access comprehensive assistance by selecting the `Help` button. Review the instructions.
9. **Statistical Analysis:** The application features interactive pie/donut charts for analyzing ratings. The top comments provide deeper insights into the analytical data. You may click on the top comments, or slide left/right to change the background color for the charts.


## <a name="contributors"></a> Contributors
- Yang Li
- Honggang Min
- Xinyi Xie


## <a name="acknowledgements"></a> Acknowledgements

This project makes use of several third-party APIs and resources. We extend our gratitude to the creators and maintainers of these resources for their valuable contributions to the community.

### Project Guidance
Duke University ECE 564 Course Staff
- Richard Telford
- Rishi Ravula
- Chen Dong

### Model
- **CSVParser:** Special thanks to Professor Telford for creating the basic CSVParser template, modified in our project.
- **FireStore:** Utilization of the Cloud FireStore API was guided by the official [Firebase Firestore Quickstart Documentation](https://firebase.google.com/docs/firestore/quickstart).
- **FirebaseStorage:** The Firebase Storage API usage was informed by the [Firebase Storage Tutorial](https://firebase.google.com/docs/storage/ios/start).
- **SaveImage:** Instructions on saving images to the user’s photo library were learned from the "Instafilter SwiftUI Tutorial 7/12" by [Hacking with Swift on YouTube](https://www.youtube.com/watch?v=q-eQWNsutjY).

### View
- **OnboardingView:** The OnBoarding Screen Animation in SwiftUI 3.0 was adapted from the tutorial on [YouTube](https://www.youtube.com/watch?v=rCgbJf5SWQE&t=54s).
- **OffsetPageTabView:** The walkthrough page UI and animated indicators were inspired by the "SwiftUI 3.0 Walkthrough Page UI" tutorial on [YouTube](https://www.youtube.com/watch?v=cY-Feaqkbng).
- **QRCodeView:** The QR Code Generator feature was developed using the "SwiftUI Tutorial - QR Code Generator" by [Hacking with Swift on YouTube](https://www.youtube.com/watch?v=HD_Fobpwt4M).
- **ScannerView:** Our QR Code Scanner App feature was inspired by the tutorial on [YouTube](https://www.youtube.com/watch?v=QHouskATQ5U) and the [CodeScanner GitHub Repository](https://github.com/twostraws/CodeScanner).
- **EditNoteView:** The implementation of Pencil Kit in SwiftUI was guided by the "SwiftUI Drawing App Using Pencil Kit" tutorial on [YouTube](https://www.youtube.com/watch?v=LR-ttBoa89M&t=144s) and Apple Official PencilKit Sample Project.
- **RatingView:** The dynamic emoji ratings and animations were inspired by the "Next-Level SwiftUI" tutorial available on [YouTube](https://www.youtube.com/watch?v=QFVMd3fMDfA).
- **SingleStatView:** Inspiration for the interactive pie/donut charts in SwiftUI came from the "SwiftUI Interactive Charts" tutorial from WWDC 2023, available on [YouTube](https://www.youtube.com/watch?v=nu74-aRobSs&t=261s).


We appreciate the efforts of these educators and developers in sharing their knowledge and resources, which have been invaluable in the development of this project.

For comprehensive technical details, kindly consult the documentation included within the project files. Should you have targeted inquiries or require further clarification, please do not hesitate to contact any of the project contributors. :smile:

## <a name="note"></a> Note
- Professor Telford allows us to ignore the warning "[Ignoring duplicate libraries: '-lc++', '-lsqlite3', '-lz'](https://stackoverflow.com/questions/77164140/ld-warning-ignoring-duplicate-libraries-lgcc-after-the-recent-update-of-xc)" and all running-time errors.
- Please use iPhone 15 Pro simulator for testing purposes.
