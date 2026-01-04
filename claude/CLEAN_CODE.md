## Core Philosophy
Code is clean if it can be understood easily by everyone on the team. Optimize for readability, changeability, and maintainability.

## General Rules
1. Follow standard conventions — Use language idioms and project patterns consistently
2. Keep it simple — Reduce complexity; simpler is always better
3. Boy Scout Rule — Leave the code cleaner than you found it
4. Find root cause — Don't patch symptoms; fix underlying problems

## Naming
* Choose descriptive, unambiguous names
* Use pronounceable, searchable names
* Replace magic numbers with named constants
* Avoid encodings, prefixes, or type info in names

## Functions
* Keep them small (ideally < 20 lines)
* Extract till you drop — If you have to scroll, the function is too long
* Do one thing — single responsibility
* Command-Query Separation — Functions should either do something or answer something, not both
* Use descriptive names that reveal intent
* Prefer fewer arguments (0-2 ideal, 3 max)
* Avoid output arguments — Return values instead of modifying arguments
* No side effects — do only what the name suggests
* No flag arguments — split into separate methods

## Comments
* Explain yourself in code, not comments
* Good comments: intent, clarification, warnings
* Bad comments: redundant, noise, commented-out code
* Delete rather than comment out dead code

## Formatting
* Separate concepts vertically
* Related code should be vertically dense
* Declare variables close to usage
* Place dependent functions close together
* Keep lines short (< 120 chars)
* Consistent indentation — never break it

## Objects & Data Structures
* Hide internal structure — encapsulate
* Keep classes small with few instance variables
* Single responsibility per class
* Data/Object Anti-Symmetry — Objects hide data and expose behavior; data structures expose data and have no behavior
* Avoid hybrids — Don't mix objects and data structures
* Prefer polymorphism over if/else or switch/case
* Follow Law of Demeter — only talk to direct dependencies

## Error Handling
* Use exceptions, not return codes
* Provide context with exceptions
* Don't return or pass `null`
* Define exception classes by caller's needs — wrap third-party APIs
* Don't ignore caught exceptions — handle or propagate
* Fail fast, fail clearly

## Boundaries
* Wrap third-party code — isolate external dependencies
* Use Adapter pattern for external APIs
* Write learning tests for third-party libraries
* Keep boundary interfaces narrow and well-defined

## Tests
* One assert per test (or one concept)
* Tests must be readable
* Tests must be fast, independent, repeatable
* Follow F.I.R.S.T. principles

## Code Smells to Avoid
| Smell | Description |
| :--- | :--- |
| Rigidity | Small changes cascade into many modifications |
| Fragility | Code breaks in unexpected places |
| Immobility | Hard to reuse components elsewhere |
| Needless Complexity | Over-engineering for unlikely futures |
| Needless Repetition | Copy-paste instead of abstraction |
| Opacity | Hard to understand intent |

## Design Principles
* DRY — Don't Repeat Yourself
* SOLID — Single responsibility, Open-closed, Liskov substitution, Interface segregation, Dependency inversion
* Tell, Don't Ask — Tell objects what to do, don't ask for their state and decide for them
* Prefer composition over inheritance
* Dependency Injection — Inject dependencies, don't hardcode them
* Keep configurable data at high levels
* Separate multi-threading code from business logic

## When Refactoring
1. Ensure tests pass before and after
2. Make small, incremental changes
3. Refactor one thing at a time
4. Commit frequently