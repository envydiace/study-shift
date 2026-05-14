# Project README

## Overview
This project is developed collaboratively, so please follow the Git workflow below before starting any implementation.

### git repo:
```bash
https://github.com/envydiace/study-shift
```

---

## Git Workflow

### 1. Pull the latest code from `main`
Before starting any task, make sure your local code is up to date.

```bash
git checkout main
git pull origin main
```

### 2. Create a new branch
After pulling the latest code from `main`, create a new branch for your task.

```bash
git checkout -b feature/your-feature-name
```

Example branch names:
- `feature/calendar-screen`
- `feature/shift-detail`
- `fix/date-picker-bug`

### 3. Implement your task
Make your code changes in your own branch.

Please do not work directly on `main`.

### 4. Commit your changes
After finishing your implementation, commit your code with a clear message.

```bash
git add .
git commit -m "Add your change here"
```

### 5. Push your branch
Push your branch to remote:

```bash
git push origin feature/your-feature-name
```

### 6. Create a Pull Request
After pushing your branch, create a Pull Request to merge your code into `main`.

Please make sure:
- your code builds successfully
- your changes are related only to your task
- your commit message is clear
- you do not include unnecessary files

## Summary
Workflow for each task:

1. Pull latest code from `main`
2. Create a new branch
3. Implement the task
4. Commit changes
5. Push branch
6. Create Pull Request to `main`

## Example Full Flow

```bash
git checkout main
git pull origin main
git checkout -b feature/calendar-screen

# do your implementation

git add .
git commit -m "Add calendar screen"
git push origin feature/calendar-screen
```

Then create a Pull Request from:
- `feature/calendar-screen` → `main`

## Source Folder Explanation

### Extensions
This folder contains extensions for existing Swift types.

For example, if we want to add extra functions or computed properties to types like `Date`, `String`, `Color`, or `View`, we put them here.

The purpose of this folder is to keep reusable small improvements separated from the main logic.

---

### Models
This folder contains the data models of the app.

Models are used to define the structure of the data that the app works with.

For example, if the app has data such as a shift, user, attendance record, or schedule item, the structure of that data should be placed here.

Models should mainly describe data, not handle screen logic.

---

### Repositories
This folder contains code responsible for accessing and managing data.

Repositories are used to separate data operations from the UI and ViewModels.

For example, if we need to fetch, save, update, or delete data from SwiftData or another data source, that logic should be placed here.

The ViewModel should call the Repository instead of directly handling all database logic.

---

### Services
This folder contains app logic that is not directly related to the UI.

Services are usually used for reusable business logic or app-level features.

For example, logic such as importing/exporting data, checking attendance, handling notifications, or processing files can be placed here.

Services can work together with Repositories when they need to read or save data.

---

### Utilities
This folder contains helper code used across the app.

Utilities are usually small reusable functions or helper classes.

For example, formatting dates, calculating values, converting data, or other common helper logic can be placed here.

This folder helps avoid repeating the same helper code in many places.

---

### ViewModels
This folder contains the state and logic for the screens.

A ViewModel prepares data for the View and handles user actions.

For example, when a user taps a button, selects a date, submits a form, or loads data for a screen, that logic should usually be handled in the ViewModel.

The ViewModel connects the View with Repositories or Services.

---

### Views
This folder contains the SwiftUI views of the app.

Views are responsible for displaying the UI and receiving user interaction.

A View should focus mainly on layout and presentation. Complex logic should be moved to the ViewModel, Service, or Repository when possible.
