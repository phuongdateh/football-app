# Football App
### Overview
Welcome to the Football App, a simple iOS application designed to provide users with information about football matches, teams, and highlights. This app follows the MVVM design pattern, uses UIKit and Combine for functional reactive programming, and builds the entire project's UI programmatically. Core Data integration ensures offline access to matches and teams, and the app conforms to the API Design Guidelines and Swift Style Guide.

### Functional
* Display All Team
* Select a team to view detailed information.
* View a list of previous and upcoming matches.
* Watch highlights of a previous match.

## Technical Stack
* UIKit: Building the UI programmatically.
* Combine: Utilizing functional reactive programming.
* Core Data: Storing matches and teams for offline access.
  
## Project Structure
* Following MVVM architechture
* Repositories: Where get all data from remote/server or local database
* Service: Where implement some special logic of the application
* ViewModels: Where implement bussiness logic and communication with view layer as well

## Coding
* Conform to API Design Guidelines (https://bit.ly/3ZqnUXO).
* Conform to Swift Style Guide (https://bit.ly/3YicMuO).

## API Endpoints
* Get Teams: https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams
* Get Matches: https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams/matches
* Unit Testing: **Coverage 65%**


## Getting Started
1. Clone the repository.
2. Open the Xcode football-app.xcodeproj
3. Build and run the project.

## Approach to Solving:

1. Identify the Problem:
* Start by reproducing the issue and understanding when and how the synchronization fails.
* Check for any inconsistencies between the local CoreData store and the remote data source (perhaps a backend server).

2. Data Model and Relationships:
* Ensure that the CoreData data model is set up correctly with proper relationships and constraints.
* Review how the data model aligns with the requirements of the MVVM architecture.

3. Concurrency and Threading:
* CoreData operates on its own managed object context (MOC) queue. Ensure that you are handling concurrency and threading correctly.
* Check if any CoreData operations are being performed on the main thread, which might cause UI freezes.
  
4. Update Notification Handling:
Verify that the MVVM architecture is handling CoreData update notifications properly. The ViewModel should react to changes in the model and update the View accordingly.
5. Synchronization Logic:
* Examine the synchronization logic between devices. Ensure that data is being properly fetched, updated, and saved.
* Check if there are any conflicts arising from simultaneous updates on different devices.
6. Unit Testing:
* Write unit tests to cover CoreData operations, especially those related to synchronization.
* Use breakpoints and debugging tools to step through the code and inspect variables during the synchronization process.

## What I Learned:
1. Concurrency Management: Understand the intricacies of managing concurrency in CoreData, especially when dealing with multiple devices and synchronization.

2. Testing Strategies: The importance of comprehensive unit testing, especially for critical components like CoreData operations. This not only aids in catching bugs early but also serves as a safety net during future changes.

3. Data Flow in MVVM: A deeper understanding of how data flows between the Model, ViewModel, and View in the MVVM architecture, and how to handle updates seamlessly.

4. Logging and Debugging: The effectiveness of extensive logging and using debugging tools to trace and identify complex issues in a distributed system.

## GIFs
| Home Page | Videos Highlights | Filter | 
| :---:   | :---: | :---: | 
| ![](https://github.com/phuongdateh/football-app/blob/master/1gif.gif) | ![](https://github.com/phuongdateh/football-app/blob/master/2gif.gif) | ![](https://github.com/phuongdateh/football-app/blob/master/3.gif) |


