# JavaScript Best Practices

This document outlines the best practices for writing JavaScript code. Each practice is demonstrated with a "do" and "don't" example to show the preferred conventions and common pitfalls to avoid.

## Table of Contents

- [Javascript Best Practices](#javascript-best-practices)
  - [Async/Await](#asyncawait)
  - [Object Property Access](#object-property-access)
  - [Array Iteration](#array-iteration)
  - [Asynchronous Iteration](#asynchronous-iteration)
  - [Variable Declarations](#variable-declarations)
  - [Template Literals](#template-literals)
  - [Destructuring Assignment](#destructuring-assignment)
  - [Spread and Rest Operators](#spread-and-rest-operators)
  - [Arrow Functions](#arrow-functions)
  - [Modules](#modules)
  - [Default Parameters](#default-parameters)
  - [Error Handling](#error-handling)
  - [Pure Functions](#pure-functions)
  - [Callback Hell](#callback-hell)
  - [Input Validation](#input-validation)
- [General Best Practices](#general-best-practices)
  - [Code Splitting](#code-splitting)
  - [Linting and Formatting](#linting-and-formatting)
  - [Testing](#testing)
  - [Comments and Documentation](#comments-and-documentation)
  - [Refactoring](#refactoring)
  - [Security Practices](#security-practices)
  - [Performance Optimization](#performance-optimization)
- [Typescript Best Practices](#typescript-best-practices)
  - [Explicit Return Type](#explicit-return-types)
  - [Interface over Type Alias](#interface-over-type-alias)
  - [Use Utility Types](#use-utility-types)
  - [Non-null Assertion Operator](#non-null-assertion-operator)
  - [Function Parameters as Options Object](#function-parameters-as-options-object)
- [DRY and SOLID Principles](#dry-and-solid-principles)
  - [DRY Principle](#dry-principle)
  - [Single Responsibility Principle (SRP)](#single-responsibility-principle-srp)
  - [Open/Closed Principle (OCP)](#openclosed-principle-ocp)
  - [Liskov Substitution Principle (LSP)](#liskov-substitution-principle-lsp)
  - [Interface Segregation Principle (ISP)](#interface-segregation-principle-isp)
  - [Dependency Inversion Principle (DIP)](#dependency-inversion-principle-dip)
- [Conclusion](#conclusion)

### Async/Await

**Do:**

```javascript
async function fetchData() {
  try {
    const response = await fetch('https://api.example.com/data');
    const data = await response.json();
    console.log(data);
  } catch (error) {
    console.error('Error fetching data:', error);
  }
}
```

**Don't:**

```javascript
function fetchData() {
  fetch('https://api.example.com/data')
    .then(response => response.json())
    .then(data => {
      console.log(data);
    })
    .catch(error => {
      console.error('Error fetching data:', error);
    });
}
```

### Object Property Access

**Do:**

```javascript
const person = { name: 'Alice', age: 25 };
console.log(person.name);
```

**Don't:**

```javascript
const person = { name: 'Alice', age: 25 };
console.log(person['name']);
```

### Array Iteration

**Do:**

```javascript
const numbers = [1, 2, 3, 4, 5];
const squares = numbers.map(number => number * number);
```

**Don't:**

```javascript
const numbers = [1, 2, 3, 4, 5];
const squares = [];
for (let i = 0; i < numbers.length; i++) {
  squares.push(numbers[i] * numbers[i]);
}
```

### Asynchronous Iteration

**Do:**

```javascript
async function processArray(array) {
  for (const item of array) {
    await processItem(item);
  }
}
```

**Do:**

With concurrent processing

```javascript
async function processArray(array) {
    await Promise.all(array.map(item) => await processItem(item))
}
```

**Don't:**

```javascript
async function processArray(array) {
  await array.forEach(async (item) => { // <-- This will immediately return
    await processItem(item);
  });
}
```

### Variable Declarations

**Do:**

```javascript
const name = 'Alice'; // for variables that won't change.
let score = 5; // for variables that may change.
```

**Don't:**

```javascript
var name = 'Alice'; // 'var' is function-scoped and can lead to confusion.
```

### Template Literals

**Do:**

```javascript
const greeting = `Hello, ${name}!`;
```

**Don't:**

```javascript
const greeting = 'Hello, ' + name + '!';
```

### Destructuring Assignment

**Do:**

```javascript
const { name, age } = person;
```

**Don't:**

```javascript
const name = person.name;
const age = person.age;
```

### Spread and Rest Operators

**Do:**

```javascript
const newArray = [...oldArray, newItem];
const { x, y, ...rest } = obj;
```

**Don't:**

```javascript
const newArray = oldArray.concat(newItem);
const x = obj.x, y = obj.y;
```

### Arrow Functions

**Do:**

```javascript
const add = (a, b) => a + b;
```

**Don't:**

```javascript
function add(a, b) {
  return a + b;
}
```

### Modules

**Do:**

```javascript
// es6 module syntax
import myFunction from './myModule';
```

**Don't:**

```javascript
// CommonJS syntax
const myFunction = require('./myModule');
```

### Default Parameters

**Do:**

```javascript
function greet(name = 'Guest') {
  console.log(`Hello, ${name}!`);
}
```

**Don't:**

```javascript
function greet(name) {
  name = name || 'Guest';
  console.log(`Hello, ${name}!`);
}
```

### Error Handling

**Do:**

```javascript
try {
  // code that may throw an error
} catch (error) {
  // error handling
}
```

**Don't:**

```javascript
// code that may throw an error
// No error handling
```

### Pure Functions

**Do:**

```javascript
function add(a, b) {
  return a + b;
}
```

**Don't:**

```javascript
let result;
function add(a, b) {
  result = a + b;
}
```

### Callback Hell

**Do:**

```javascript
async function asyncFlow() {
  const resultA = await asyncTaskA();
  const resultB = await asyncTaskB(resultA);
  return finalTask(resultB);
}
```

**Don't:**

```javascript
function callbackHell() {
  asyncTaskA(function(resultA) {
    asyncTaskB(resultA, function(resultB) {
      finalTask(resultB);
    });
  });
}
```

### Input Validation

**Do:**

```javascript
function processInput(input) {
  if (typeof input !== 'string') {
    throw new TypeError('Input must be a string');
  }
  // process input
}
```

**Don't:**

```javascript
function processInput(input) {
  // No validation, assuming input is always correct
  // process input
}
```

### Shallow Copy

**Do:**

```javascript
// Use the spread operator or `Object.assign` for creating a shallow copy of an object when nested objects are not a concern.
const original = { a: 1, b: 2 };
const shallowCopy = { ...original };
```

**Don't:**

```javascript
// Use a shallow copy if your object contains nested structures and you need a deep copy, as changes to nested data will affect the original.
const original = { a: 1, b: { c: 3 } };
const shallowCopy = { ...original };
shallowCopy.b.c = 4; // This will change original.b.c to 4 as well.
```

### Deep Copy

**Do:**

```javascript
// Use a utility function like JSON.parse(JSON.stringify(object)) for a quick deep copy when you don't have functions or circular references in your object.
const original = { a: 1, b: { c: 3 } };
const deepCopy = JSON.parse(JSON.stringify(original));
deepCopy.b.c = 4; // This will not affect original.b.c
```

**Don't:**

```javascript
// Rely on JSON.parse(JSON.stringify(object)) for deep copying objects containing functions, dates, undefined, or circular references, as it will not preserve those values.
const original = { a: 1, b: () => console.log("Not copied!"), c: new Date() };
const deepCopy = JSON.parse(JSON.stringify(original));
// deepCopy.b is undefined, and deepCopy.c is a string, not a Date object.
```

For complex objects, consider using a utility library like Lodash's `_.cloneDeep` method, or write a custom deep copy function that handles all edge cases specific to your needs.

## General Best Practices

### Code Splitting

**Do:**

```javascript
// Using dynamic imports for code splitting in a React application
const MyComponent = React.lazy(() => import('./MyComponent'));
```

**Don't:**

```javascript
// Loading everything in a single large bundle
import MyComponent from './MyComponent';
```

### Linting and Formatting

**Do:**

```javascript
// Use ESLint and Prettier in your project for consistent coding styles
// Configure them according to your coding style preferences
```

**Don't:**

```javascript
// Write code without any linting or formatting tools, leading to inconsistent styles
```

### Testing

**Do:**

```javascript
// Write unit tests for your functions
describe('add function', () => {
  it('adds two numbers', () => {
    expect(add(2, 3)).toBe(5);
  });
});
```

**Don't:**

```javascript
// No testing
function add(a, b) {
  return a + b;
}
```

### Comments and Documentation

**Do:**

```javascript
/**
 * Adds two numbers together.
 * @param {number} a The first number.
 * @param {number} b The second number.
 * @returns {number} The sum of the two numbers.
 */
function add(a, b) {
  return a + b;
}
```

**Don't:**

```javascript
// Adds two numbers
function add(a, b) {
  return a + b;
}
```

### Refactoring

**Do:**

```javascript
// Regularly revisit and refactor your code to improve clarity and efficiency
```

**Don't:**

```javascript
// Leave old, unused, or inefficient code in the codebase without attempting to improve it
```

### Security Practices

**Do:**

```javascript
// Use libraries like Helmet to protect your Express applications
const helmet = require('helmet');
app.use(helmet());
```

**Don't:**

```javascript
// Ignore security best practices
const express = require('express');
const app = express();
```

### Performance Optimization

**Do:**

```javascript
// Use efficient algorithms and data structures
const values = new Set([1, 2, 3]);
```

**Don't:**

```javascript
// Use inefficient methods that can lead to performance issues
const values = [1, 2, 3, 1, 2, 3].filter((value, index, self) => self.indexOf(value) === index);
```

## Typescript Best Practices

### Explicit Return Types

**Do:**

```typescript
// Declare return types explicitly for functions to improve readability and prevent unintended return values.
function add(a: number, b: number): number {
  return a + b;
}
```

**Don't:**

```typescript
//Omit return types, which can lead to less predictable code and reliance on type inference, which might not always work as expected.
function add(a: number, b: number) {
  return a + b;
}
```

### Interface over Type Alias

**Do:**

```typescript
// Prefer interfaces over type aliases when declaring object shapes. Interfaces can be extended and merged, offering more flexibility.
interface User {
  name: string;
  age: number;
}
```

**Don't:**

```typescript
// Use type aliases for object shapes unless you need a feature specific to type aliases, such as union or intersection types.
type User = {
  name: string;
  age: number;
};
```

### Use Utility Types

**Do:**

```typescript
// Leverage TypeScript’s utility types like `Partial<T>`, `Readonly<T>`, `Record<K, T>`, etc., to create types based on transformations of other types.
function updateProfile(user: Partial<User>) {
  // ...
}
```

**Don't:**

```typescript
// Manually recreate the functionality provided by utility types, leading to more verbose and less maintainable code.
function updateProfile(user: { name?: string; age?: number }) {
  // ...
}
```

### Non-null Assertion Operator

**Do:**

```typescript
// Use non-null assertion operators (!) sparingly, and only when you are certain that a value will not be null or undefined.
function initialize() {
  const el = document.getElementById('myId')!;
  // ...
}
```

**Don't:**

```typescript
function initialize() {
  const el = document.getElementById('myId')!; // Risky if 'myId' does not exist
  // ...
}
```

### Function Parameters as Options Object

**Do:**

```typescript
// Use an options object for functions with multiple optional parameters to improve readability and maintainability. Useful when a function has several parameters, especially if many of them are optional.

interface CreateUserOptions {
  name: string;
  email: string;
  password: string;
  age?: number;
  isAdmin?: boolean;
}

function createUser(options: CreateUserOptions): void {
  // Implementation...
}

// Usage
createUser({
  name: 'Alice',
  email: 'alice@example.com',
  password: 'securePass123',
  age: 42,
});
```

**Don't:**

```typescript
function createUser(name: string, email: string, password: string, age?: number, isAdmin?: boolean): void {
  // Implementation...
}

// Usage - It's unclear what the true parameter stands for.
createUser('Alice', 'alice@example.com', 'securePass123', 42, true);
```

## DRY and SOLID Principles

The DRY principle emphasizes the need to reduce the repetition of software patterns, replacing them with abstractions or using data normalization to avoid redundancy.

The SOLID principles are a set of guidelines for object-oriented programming that facilitate scalability and maintainability.

### DRY Principle

**Do:**

```javascript
// Encapsulate repeated logic into functions or classes.
function calculateArea(radius) {
  return Math.PI * radius * radius;
}

const areaOfCircle1 = calculateArea(10);
const areaOfCircle2 = calculateArea(20);
```

**Don't:**

```javascript
// Repeat the same logic in multiple places.
const areaOfCircle1 = Math.PI * 10 * 10;
const areaOfCircle2 = Math.PI * 20 * 20;
```

### Single Responsibility Principle (SRP)

**Do:**

```typescript
// Define classes or components with a single responsibility.
class UserAuthenticator {
  authenticateUser(user) {
    // Handle authentication
  }
}
```

**Don't:**

```typescript
// Create classes or components that handle multiple responsibilities.
class UserManager {
  authenticateUser(user) {
    // Handle authentication
  }

  updateUserDetails(user) {
    // Handle updating user details
  }

  deleteUser(user) {
    // Handle deleting a user
  }
}
```

## Open/Closed Principle (OCP)

**Do:**

```typescript
// Design modules, classes, functions to be open for extension but closed for modification.
class Shape {
  getArea() {}
}

class Rectangle extends Shape {
  constructor(public width: number, public height: number) {
    super();
  }

  getArea() {
    return this.width * this.height;
  }
}
```

**Don't:**

```typescript
// Modify existing classes when adding new functionality, which risks breaking existing code.
class Shape {
  getArea(shapeType) {
    if (shapeType === 'rectangle') {
      // Calculate area of rectangle
    }
    // Other shapes...
  }
}
```

## Liskov Substitution Principle (LSP)

**Do:**

```typescript
// Ensure that subclasses can be used interchangeably with their base class.
class Bird {
  fly() {
    // ...
  }
}

class Duck extends Bird {}
class Ostrich extends Bird {
  fly() {
    throw new Error("Can't fly!");
  }
}
```

**Don't:**

```typescript
// Write subclasses that cannot be used in place of their base class without altering the desired result.
class Bird {
  fly() {
    // ...
  }
}

class Duck extends Bird {}
class Ostrich extends Bird {} // Ostriches can't fly, so this violates LSP.
```

## Interface Segregation Principle (ISP)

**Do:**

```typescript
// Create specific interfaces that are tailored to the needs of the client.
interface Printable {
  print(): void;
}

class Book implements Printable {
  print() {
    // Print the book
  }
}
```

## Don't

```typescript
// Force a class to implement interfaces they don't use.
interface Worker {
  work(): void;
  eat(): void;
}

class Robot implements Worker {
  work() {
    // Perform work
  }

  eat() {
    // Robots don't eat, this method shouldn't exist!
  }
}
```

## Dependency Inversion Principle (DIP)

**Do:**

```typescript
// High-level modules should not depend on low-level modules. Both should depend on abstractions. Also, abstractions should not depend on details. Details should depend on abstractions.
interface Database {
  query();
}

class MySqlDatabase implements Database {
  query() {
    // Query logic
  }
}

class UserManager {
  database: Database;

  constructor(database: Database) {
    this.database = database;
  }

  findUser(userId) {
    return this.database.query(`SELECT * FROM users WHERE id = ${userId}`);
  }
}
```

**Don't:**

```typescript
// Hardcode dependencies on low-level modules.
class UserManager {
  findUser(userId) {
    return mySqlDatabase.query(`SELECT * FROM users WHERE id = ${userId}`);
  }
}

const mySqlDatabase = {
  query: (sql) => {
    // Query logic
  }
};
```

## Conclusion

Remember, these are guidelines, not rules. There may be exceptions based on specific scenarios, but strive to follow these practices to write clean, efficient, and maintainable JavaScript code.

You can add more sections as required, following the same "Do/Don't" format to provide clear guidance to your team. Each section should demonstrate a single best practice with succinct and self-explanatory code examples.
