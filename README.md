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

Feel free to explore the codebase and documentation to understand the architecture and implementation details.

## GIFs
| Home Page | Videos Highlights |
| :---:   | :---: | 
| ![](https://github.com/phuongdateh/football-app/blob/master/1gif.gif) | ![](https://github.com/phuongdateh/football-app/blob/master/2gif.gif) | 


