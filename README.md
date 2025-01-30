# noteapp

A new Flutter project.

# Note App with Firebase - Documentation

## **App Functionality Overview**
The Note-Taking App allows users to create, edit, delete, and view notes. The app integrates Firebase Authentication for user login and uses Firestore as the database for storing user notes. The state management is done using the Provider package, following the MVVM architecture.

---

## **Firebase Setup**

### **1. Authentication**
- The app uses **Firebase Authentication** for secure user login and signup.

### **2. Database Storage**
- The app uses **Firebase Database** to save the notes made by a user.
- The notes are added based on the user id in collection 'users' which has a collection of 'notes', where these notes are saved.


## **Firestore Rules**
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // This rule allows anyone with your Firestore database reference to view, edit,
    // and delete all data in your Firestore database. It is useful for getting
    // started, but it is configured to expire after 30 days because it
    // leaves your app open to attackers. At that time, all client
    // requests to your Firestore database will be denied.
    //
    // Make sure to write security rules for your app before that time, or else
    // all client requests to your Firestore database will be denied until you Update
    // your rules
    match /{document=} {
      allow read, write: if request.time < timestamp.date(2025, 2, 28);
    }
  }
}

---

## **App Features**

### **1. Authentication**
- The app uses **Firebase Authentication** for secure user login and signup.
- Firebase methods for authentication are handled in the ViewModel layer.
- Login and signup screens validate user input before proceeding.

### **2. CRUD Operations**
- **Create:** Users can create new notes with titles and content.
- **Read:** Notes are fetched from Firestore and displayed in a scrollable list.
- **Update:** Users can modify note titles and content.
- **Delete:** Notes can be permanently removed.
- Notes are stored under the authenticated user's UID in Firestore.

### **3. State Management**
- **Provider** is used to manage authentication state and the list of notes.
- ViewModels handle business logic and notify UI components about state changes.

---

## **Conclusion**
This project demonstrates how to build a simple-functional note-taking app with Firebase integration. The use of Provider for state management and MVVM architecture ensures a clean and maintainable code structure.

