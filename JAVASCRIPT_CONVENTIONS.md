# Codebase Naming Conventions and Best Practices

Welcome to our project! This README outlines the conventions and best practices we follow to ensure our code is clean, consistent, and easy to maintain. Adherence to these guidelines is crucial for collaboration and the long-term health of the codebase.

**IMPORTANT:**

Conventions apply to our `javascript/typescript` software only. Different conventions exist for other languages.

## Table of Contents

- [General Principles](#general-principles)
- [Front-End Conventions](#front-end-conventions)
  - [Cascading Style Sheets](#cascading-style-sheets)
- [Library Conventions](#libraries-conventions)
- [Back-End Conventions](#back-end-conventions)
- [Helpers Conventions](#helpers-conventions)
- [General](#general)
- [File Names & Structures](#file-names--structures)
- [Best Coding Practices](#best-coding-practices)
- [TSDoc Guide](#tsdoc-guide)

## General Principles

- **Clarity and Consistency**: Clear, consistent names aid in understanding and maintaining the code.
- **Descriptive Names**: Names should be intuitive and describe the entity's functionality.
- **Established Patterns**: Follow patterns for ease of integration and maintenance.

## Front-End Conventions

- **UI Components**: `PascalCase` for both filenames and class names (e.g., `UserProfile.tsx`).
- **React Hooks**: Prefixed with `use` and `camelCase` (e.g., `useAuth.ts`).

### Cascading Style Sheets

- **CSS Classes**: Use `kebab-case` for names. Example: `primary-button`.
- **Be semantic**: Name classes based on their purpose rather than their appearance, e.g., ``.btn-danger`` over ``.red-button``.
- **BEM (Block Element Modifier)**: A common methodology where the class is named following a `block__element--modifier` format, e.g., `.button__icon--small`

## Libraries Conventions

- **Classes, Types, and Enums**: Use `PascalCase`. Example: `LinkedList`, `UserType`.

## Back-End Conventions

- **Controllers**: `PascalCase` with `Controller` suffix; `kebab-case` for filenames (e.g., `user.controller.ts`).
- **Services**: `PascalCase` with `Service` suffix (e.g., `UserService`).
- **Middleware**: `PascalCase` with `Middleware` suffix (e.g., `AuthMiddleware`).

## Helpers Conventions

- **Helpers/Utilities**: `verbNoun` format in `camelCase` for functions and filenames (e.g., `formatDate.ts`).

## General

- **Interfaces**: Prefix with `I` and use `PascalCase`. Example: `IUser`.
- **Enums**: Use `PascalCase` in singular form. Example: `UserRole`.
- **Constants**: Use `UPPER_SNAKE_CASE`. Example: `DEFAULT_USER_ROLE`.
- **Environment Variables**: Use `UPPER_SNAKE_CASE`. Example: `API_BASE_URL`.
- **Assets/Images/Icons**: Name with `kebab-case`. Example: `logo-icon.svg`.
- **Test Filenames**: Match the tested file's filename with `.test.ts` (e.g., `dateHelpers.test.ts`).
- **Documentation**: Use TSDoc for clarity.

## File Names & Structures

- **File Names**: use the same convention as the default export (e.g. for a class `UserProfile` use `UserProfile.tsx` or for a function `transformUser()` use `userFunction.ts`).
- **File Names for Helpers**: Name the file based on the general functionality or category of the helpers. Use `camelCase`. For example, if the file contains various string manipulation functions, you could name it `stringHelpers.ts` or `authHelpers.ts`.
- **Folders**: Use kebab-case for general folders. Example: `user-profile`.
- **Group by Feature**: Organize files in feature-specific folders. For instance, all user-related entities such as `UserList`, `UserProfile`, and `UserEdit` can be within a `users` directory.
- **Folder Size**: If a folder has more than `10` files then generally, try to group some tother into sub-directories.
- **Avoid Redundancy**: Don't repeat folder names in the file name, e.g., if you have a `user/` folder, you don't need `user/user-list.component.ts`; just `list.component.ts` is clearer.

## Best Coding Practices

- **DRY Principle**: Avoid code duplication.
- **SOLID Principles**: Maintainable, understandable, and flexible OOP design.
- **Single Responsibility**: One function, one purpose.
- **Pure Functions**: Aim for no side effects.
- **TSDoc**: For all public interfaces, classes, functions, and methods.
- **Linting**: Try ensure as many coding conventions and styles are enforced with our linters. This is defined in the files `.prettierrc.json`, `tsconfig.json` and `.eslintrc.json`. By downloading the suggested `VSCode` extensions (specified in `.vscode/extensions.json`) your code will be automatically formatted to these rules.
- **Testing**: Ensure unit tests cover all business logic adequately. Currently we do **not** do UI automated testing.
- **Refactoring**: Regularly refactor to improve performance and readability.
- **Dependencies**: Keep track of any dependencies the helper functions have and make sure they are kept up to date.

For more information:

- [DRY Principle](https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design)
- [SOLID Principles](https://www.digitalocean.com/community/tutorials/what-is-dry-development)

## TSDoc Guide

- **When to Add**: On public interfaces, classes, functions, methods.
- **Minimum Include**: Description, parameters, return type.
- **Example**:

  ```typescript
  /**
   * Calculates the sum of two numbers.
   * @param {number} a - The first number.
   * @param {number} [b] - The second number (optional).
   * @returns {number} The sum of the two numbers.
   */
  function add(a: number, b?: number): number {
      return a + b ?? 0;
  }
