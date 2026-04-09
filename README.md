# MultiBankTrading

Real-Time Stock Price Tracker (iOS)

1. Overview
A real-time stock price tracking iOS application that displays live price updates for multiple stock symbols using WebSocket. The app supports sorting, detailed symbol view, search, watchlist selection and connection state management.

2. Features
    
    2.1 Live price updates for 30+ stock symbols
    
    2.2 Real-time data using WebSocket
    
    2.3 Sorting by Price and Price Change
    
    2.4 Symbol detail screen with live updates
    
    2.5 Start/Stop price feed control
    
    2.6 Connection status indicator (Connected / Disconnected)
    
    2.7 Search the stocks by name and token id
    
    2.8 Selection of watchlist from multiple watchlist 

3. Architecture
    
    3.1 The app follows MVVM (Model-View-ViewModel) architecture to ensure scalability and maintainability.
    
    3.2 Clear separation of concerns between UI and business logic
    
    3.3 ViewModels handle data transformation and state management
    
    3.4 Reusable components for better modularity
    
    3.5 Coordinator class used for navigation

4. Networking
    
    4.1 Implemented using URLSessionWebSocketTask
    
    4.2 WebSocket endpoint: wss://ws.postman-echo.com/raw
    
    4.3 Random stock price updates are generated and sent via WebSocket
    
    4.4 Echoed responses are used to update UI in real-time

5. Data Flow
    
    5.1 WebSocket sends and receives price updates
    
    5.2 Data is processed in the ViewModel
    
    5.3 UI is updated via binding/state updates
    
    5.4 Changes are reflected across both list and detail screens

6. Tech Stack
    
    6.1 Swift
    
    6.2 UIKit
    
    6.3 URLSessionWebSocketTask
    
    6.4 MVVM Architecture

7. How to Run
    
    7.1 Clone the repository
    
    7.2 Open the project in Xcode
    
    7.3 Build and run on simulator or device

8. Demo
    8.1 For demo added a screen record in project files, 
    link - https://github.com/vijendra1192/MultiBankTrading/blob/main/Simulator%20Screen%20Recording%20-%20iPhone%2016e%20-%202026-04-08%20at%2019.38.21.mov

9. Assumptions & Improvements
    
    9.1 Prices are randomly generated for demonstration purposes Can be extended to integrate real stock market APIs
    
    9.2 Improve unit test coverage for production readiness Add caching and offline support
    
    9.3 Enhance UI/UX with animations and accessibility support
    
    9.4 Extend unit test coverage across multiple components to ensure reliability and maintainability.
    
    9.5 Add theme support (Light/Dark mode) to enhance user experience
    
    9.6 Add loading and empty states for better user feedback.
    
    9.7 Add logging and monitoring for debugging and analytics.

10. Notes
    
    10.1 Focused on clean architecture and real-time data handling
    
    10.2 Designed to be scalable and production-ready
    
11. Unit test case
    
    11.1 WatchlistFiltering
    
    11.2 MockWatchlistSocket
    
    11.3 MockWatchlistViewModelDelegate
    
    11.4 WatchlistViewModelTests
