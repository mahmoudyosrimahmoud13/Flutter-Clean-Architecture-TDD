# Flutter Clean Architecture & TDD: Number Trivia

A professional implementation of the **Clean Architecture** patterns and **Test-Driven Development (TDD)** principles based on the ResoCoder curriculum. 

This project demonstrates how to build a highly decoupled, maintainable, and 100% testable Flutter application by following strict architectural boundaries.

## 🏛 Architecture Overview

The project is structured into three distinct layers, following the **Dependency Rule** where dependencies point inwards toward the Domain layer.

### 1. Domain Layer (The Core)
* **Entities:** Pure Dart classes representing the business objects (`NumberTrivia`).
* **Use Cases:** Application-specific business rules that coordinate data flow.
* **Repositories:** Abstract interfaces defining the data contracts.
* **Characteristics:** Completely independent of frameworks, UI, and external data sources.

### 2. Data Layer (The Implementation)
* **Repositories Implementation:** Logic that decides between remote and local data fetching.
* **Models:** Data Transfer Objects (DTOs) with JSON serialization logic (extending Entities).
* **Data Sources:** Low-level operations for API calls (Remote) and local persistence (Local).

### 3. Presentation Layer (The UI)
* **State Management:** BLoC (Business Logic Component) pattern.
* **UI:** Clean, modular widgets that depend only on the BLoC state.

---

## 🧪 Engineering Standards

### Test-Driven Development (TDD)
This project follows a strict **Red-Green-Refactor** workflow:
* **Unit Testing:** Logic testing for UseCases and Entities using `mocktail`.
* **State Testing:** Verification of BLoC state transitions.
* **Widget Testing:** UI verification in isolation.

### 2026 Modernization
While the foundational concepts are based on established patterns, this implementation is fully modernized:
* **Sound Null Safety:** Full implementation of Dart 3.x non-nullable types.
* **Mocktail:** Leveraging modern mocking techniques that don't require code generation.
* **Dartz:** Functional programming (Either type) for clean error handling.

---

## 📂 Project Structure

```text
lib/
 ├── core/              # Shared logic (Failures, UseCase interfaces)
 └── features/
      └── number_trivia/
           ├── domain/  # Entities, Use Cases, Repositories
           ├── data/    # Models, Data Sources
           └── pres/    # BLoC and UI