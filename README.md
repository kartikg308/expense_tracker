# Expense Tracker

A app for recording and keeping up to date with your personal finances

The architecture and code structure of the provided solution follow a common pattern used in Flutter apps, known as the Provider pattern, along with a simple MVC (Model-View-Controller) approach. Here is the breakdown of each and every component:

 1. Model:

- Expense: This class represents the model of an expense. It contains properties such as `id`, `description`, `amount`, `dateTime`, etc. It also includes methods for serializing and deserializing JSON data.

 2. View:

- HomePage: This is the main screen of the application. It displays summary, list of expenses and provides options for sorting and deleting expenses. It also includes buttons for adding new expenses.

 3. Controller / Provider:

- ExpenseProvider: This class acts as a centralized state management solution for the application. It provides data (list of expenses) to the UI and contains methods to manipulate that data (add, update, delete expenses). It uses the `SharedPreferences` package to persist data locally.
  
 Architectural Pattern:
The provided solution follows the Provider pattern, which is a state management solution widely used in Flutter apps. In this pattern:

- The `ExpenseProvider` class holds the application's state (list of expenses).
- The `HomePage` widget consumes the state provided by `ExpenseProvider` using the `Provider.of` method.
- Changes to the state are propagated to the UI automatically using the `notifyListeners` method when the state changes.

 Code Structure:

- main.dart: This file contains the main entry point of the application (`main` function) and configures the app's main components such as MaterialApp and Provider.
- expense.dart: This file contains the Expense model class.
- expense_provider.dart: This file contains the ExpenseProvider class, responsible for managing the state of expenses.
- home_page.dart: This file contains the HomePage widget, representing the main screen of the application.
  
 Code Flow:

1. The app starts by instantiating `ExpenseProvider` in the main function and providing it as a parameter to `ChangeNotifierProvider`.
2. When `HomePage` is rendered, it uses `Provider.of<ExpenseProvider>` to access the list of expenses provided by `ExpenseProvider`.
3. The user interacts with the UI, such as adding, updating, or deleting expenses.
4. These interactions trigger methods in `ExpenseProvider` to manipulate the list of expenses.
5. When the list of expenses changes, `ExpenseProvider` notifies its listeners (HomePage) using `notifyListeners`.
6. HomePage rebuilds based on the updated list of expenses, reflecting the changes in the UI.

 Summary:

- The architecture follows a simple MVC pattern with the Provider pattern for state management.
- Data flow is unidirectional: from the `ExpenseProvider` to the UI.
- Separation of concerns is maintained with clear responsibilities assigned to each component.
- The code structure is modular and follows Flutter's recommended project structure.

This architecture provides a scalable and maintainable foundation for the application, allowing for easy expansion and modification as the app grows.

## Getting Started

Clone the repository to your local machine.
Navigate to the project directory in the terminal.
Install dependencies using flutter pub get.
Run the app using flutter run.
