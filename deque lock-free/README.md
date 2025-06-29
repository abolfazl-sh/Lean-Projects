# Lock-Free Deque Implementation

A lock-free double-ended queue (deque) implementation with formal verification using Veil.

## Components

### Rust Implementation
- **`lock_free_deque.rs`**: Multi-threaded lock-free deque implementation using atomic operations
- Thread-safe operations with `AtomicUsize` for head/tail pointers
- Memory ordering for proper synchronization
- Comprehensive test suite including concurrent producer-consumer scenarios

### Lean/Veil Verification
- **`Deque lockFree/LockFreeDequeVerification.lean`**: Formal specification and verification using Veil
- Abstract model of deque behavior
- Safety properties and invariants for lock-free guarantees
- Bounded model checking for verification

## Features

- **Lock-free operations**: No mutexes or locks required
- **Multi-threaded safe**: Concurrent push/pop operations
- **Formally verified**: Veil specification ensures correctness
- **Ring buffer**: Efficient memory usage with wraparound
- **Atomic operations**: Thread-safe using Rust's atomic primitives

## Usage

### Rust Implementation
```rust
use std::sync::Arc;

let deque = LockFreeDeque::with_capacity(100);
deque.push_back(42)?;
let value = deque.pop_front();
```

### Running Tests
```bash
cargo test
```

### Veil Verification
```bash
lake build
```

## Author
abolfazlsh (abolfazlph6@gmail.com)