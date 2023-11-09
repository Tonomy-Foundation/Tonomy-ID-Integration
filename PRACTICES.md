# JavaScript Best Practices

This document outlines the best practices for writing JavaScript code. Each practice is demonstrated with a "do" and "don't" example to show the preferred conventions and common pitfalls to avoid.

## Table of Contents

### Javascript best practices

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
- [Code Splitting](#code-splitting)
- [Linting and Formatting](#linting-and-formatting)
- [Testing](#testing)
- [Comments and Documentation](#comments-and-documentation)
- [Refactoring](#refactoring)
- [Security Practices](#security-practices)
- [Performance Optimization](#performance-optimization)

### Typescript Best Practices

- [Explicit Return Type](#explicit-return-types)
- [Interface over Type Alias](#interface-over-type-alias)
- [Use Utility Types](#use-utility-types)
- [Non-null Assertion Operator](#non-null-assertion-operator)

## Async/Await

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

## Object Property Access

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

## Array Iteration

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

## Asynchronous Iteration

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
function processArray(array) {
  array.forEach(async (item) => {
    await processItem(item);
  });
}
```

## Variable Declarations

**Do:**

```javascript
const name = 'Alice'; // for variables that won't change.
let score = 5; // for variables that may change.
```

**Don't:**

```javascript
var name = 'Alice'; // 'var' is function-scoped and can lead to confusion.
Template Literals
```

**Do:**

```javascript
const greeting = `Hello, ${name}!`;
```

**Don't:**

```javascript
const greeting = 'Hello, ' + name + '!';
Destructuring Assignment
```

**Do:**

```javascript
const { name, age } = person;
```

**Don't:**

```javascript
const name = person.name;
const age = person.age;
```

## Template Literals

**Do:**

```javascript
const greeting = `Hello, ${name}!`;
```

**Don't:**

```javascript
const greeting = 'Hello, ' + name + '!';
```

## Destructuring Assignment

**Do:**

```javascript
const { name, age } = person;
```

**Don't:**

```javascript
const name = person.name;
const age = person.age;
```

## Spread and Rest Operators

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

## Arrow Functions

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

## Modules

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

## Default Parameters

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

## Error Handling

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

## Pure Functions

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

## Callback Hell

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

## Input Validation

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

## Code Splitting

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

## Linting and Formatting

**Do:**

```javascript
// Use ESLint and Prettier in your project for consistent coding styles
// Configure them according to your coding style preferences
```

**Don't:**

```javascript
// Write code without any linting or formatting tools, leading to inconsistent styles
```

## Testing

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

## Comments and Documentation

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

## Refactoring

**Do:**

```javascript
// Regularly revisit and refactor your code to improve clarity and efficiency
```

**Don't:**

```javascript
// Leave old, unused, or inefficient code in the codebase without attempting to improve it
```

## Security Practices

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

## Performance Optimization

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

## Explicit Return Types

**Do:**

Declare return types explicitly for functions to improve readability and prevent unintended return values.

```typescript
function add(a: number, b: number): number {
  return a + b;
}
```

**Don't:**

```typescript
function add(a: number, b: number) {
  return a + b;
}
```

## Interface over Type Alias

**Do:**

Prefer interfaces over type aliases when declaring object shapes. Interfaces can be extended and merged, offering more flexibility.

```typescript
interface User {
  name: string;
  age: number;
}
```

**Don't:**

```typescript
type User = {
  name: string;
  age: number;
};
```

## Use Utility Types

**Do:**

Leverage TypeScript’s utility types like `Partial<T>`, `Readonly<T>`, `Record<K, T>`, etc., to create types based on transformations of other types.

```typescript
function updateProfile(user: Partial<User>) {
  // ...
}
```

**Don't:**

```typescript
function updateProfile(user: { name?: string; age?: number }) {
  // ...
}
```

## Non-null Assertion Operator

**Do:**

Use non-null assertion operators (!) sparingly, and only when you are certain that a value will not be null or undefined.

```typescript
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

## Conclusion

Remember, these are guidelines, not rules. There may be exceptions based on specific scenarios, but strive to follow these practices to write clean, efficient, and maintainable JavaScript code.

You can add more sections as required, following the same "Do/Don't" format to provide clear guidance to your team. Each section should demonstrate a single best practice with succinct and self-explanatory code examples.
