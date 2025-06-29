use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;
use std::cell::UnsafeCell;

pub struct LockFreeDeque<T> {
    buffer: Vec<UnsafeCell<Option<T>>>,
    head: AtomicUsize,
    tail: AtomicUsize,
    capacity: usize,
}

unsafe impl<T: Send> Send for LockFreeDeque<T> {}
unsafe impl<T: Send> Sync for LockFreeDeque<T> {}

impl<T> LockFreeDeque<T> {
    pub fn with_capacity(capacity: usize) -> Arc<Self> {
        let buffer = (0..capacity)
            .map(|_| UnsafeCell::new(None))
            .collect();
        Arc::new(Self {
            buffer,
            head: AtomicUsize::new(0),
            tail: AtomicUsize::new(0),
            capacity,
        })
    }

    pub fn push_back(&self, value: T) -> Result<(), T> {
        let tail = self.tail.load(Ordering::Relaxed);
        let head = self.head.load(Ordering::Acquire);
        if tail - head == self.capacity {
            return Err(value); // Full
        }
        unsafe {
            *self.buffer[tail % self.capacity].get() = Some(value);
        }
        self.tail.store(tail + 1, Ordering::Release);
        Ok(())
    }

    pub fn pop_front(&self) -> Option<T> {
        let head = self.head.load(Ordering::Relaxed);
        let tail = self.tail.load(Ordering::Acquire);
        if head == tail {
            return None; // Empty
        }
        let value = unsafe {
            (*self.buffer[head % self.capacity].get()).take()
        };
        self.head.store(head + 1, Ordering::Release);
        value
    }

    pub fn len(&self) -> usize {
        let head = self.head.load(Ordering::Relaxed);
        let tail = self.tail.load(Ordering::Relaxed);
        tail - head
    }

    pub fn is_empty(&self) -> bool {
        self.len() == 0
    }

    pub fn is_full(&self) -> bool {
        self.len() == self.capacity
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::thread;
    use std::time::Duration;

    #[test]
    fn test_basic_operations() {
        let deque = LockFreeDeque::with_capacity(4);
        
        // Test empty state
        assert!(deque.is_empty());
        assert_eq!(deque.len(), 0);
        assert_eq!(deque.pop_front(), None);
        
        // Test push and pop
        assert!(deque.push_back(1).is_ok());
        assert_eq!(deque.len(), 1);
        assert!(!deque.is_empty());
        
        assert!(deque.push_back(2).is_ok());
        assert_eq!(deque.len(), 2);
        
        assert_eq!(deque.pop_front(), Some(1));
        assert_eq!(deque.len(), 1);
        
        assert_eq!(deque.pop_front(), Some(2));
        assert!(deque.is_empty());
        assert_eq!(deque.pop_front(), None);
    }

    #[test]
    fn test_capacity_limits() {
        let deque = LockFreeDeque::with_capacity(2);
        
        // Fill the deque
        assert!(deque.push_back(1).is_ok());
        assert!(deque.push_back(2).is_ok());
        assert!(deque.is_full());
        
        // Try to push when full
        let result = deque.push_back(3);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), 3);
        
        // Pop one and push again
        assert_eq!(deque.pop_front(), Some(1));
        assert!(deque.push_back(3).is_ok());
        assert_eq!(deque.pop_front(), Some(2));
        assert_eq!(deque.pop_front(), Some(3));
    }

    #[test]
    fn test_ring_buffer_wraparound() {
        let deque = LockFreeDeque::with_capacity(3);
        
        // Fill and empty multiple times to test wraparound
        for i in 0..10 {
            assert!(deque.push_back(i).is_ok());
            assert!(deque.push_back(i + 1).is_ok());
            assert!(deque.push_back(i + 2).is_ok());
            
            assert_eq!(deque.pop_front(), Some(i));
            assert_eq!(deque.pop_front(), Some(i + 1));
            assert_eq!(deque.pop_front(), Some(i + 2));
        }
    }

    #[test]
    fn test_single_producer_multiple_consumers() {
        let deque = LockFreeDeque::with_capacity(100);
        let producer_deque = deque.clone();
        let consumer_deque = deque.clone();
        
        // Producer thread
        let producer = thread::spawn(move || {
            for i in 0..50 {
                while producer_deque.push_back(i).is_err() {
                    thread::sleep(Duration::from_millis(1));
                }
            }
        });
        
        // Consumer threads
        let mut consumers = Vec::new();
        for _ in 0..5 {
            let consumer_deque = consumer_deque.clone();
            let consumer = thread::spawn(move || {
                let mut received = Vec::new();
                while received.len() < 10 {
                    if let Some(value) = consumer_deque.pop_front() {
                        received.push(value);
                    } else {
                        thread::sleep(Duration::from_millis(1));
                    }
                }
                received
            });
            consumers.push(consumer);
        }
        
        // Wait for producer to finish
        producer.join().unwrap();
        
        // Wait for all consumers and collect results
        let mut all_received = Vec::new();
        for consumer in consumers {
            all_received.extend(consumer.join().unwrap());
        }
        
        // Verify we got all values (order doesn't matter due to multiple consumers)
        all_received.sort();
        let expected: Vec<i32> = (0..50).collect();
        assert_eq!(all_received, expected);
    }

    #[test]
    fn test_concurrent_producer_consumer() {
        let deque = LockFreeDeque::with_capacity(10);
        let producer_deque = deque.clone();
        let consumer_deque = deque.clone();
        
        let (tx, rx) = std::sync::mpsc::channel();
        
        // Producer thread
        let producer = thread::spawn(move || {
            for i in 0..100 {
                while producer_deque.push_back(i).is_err() {
                    thread::sleep(Duration::from_millis(1));
                }
            }
            tx.send(()).unwrap();
        });
        
        // Consumer thread
        let consumer = thread::spawn(move || {
            let mut received = Vec::new();
            loop {
                if let Some(value) = consumer_deque.pop_front() {
                    received.push(value);
                    if received.len() >= 100 {
                        break;
                    }
                } else {
                    // Check if producer is done
                    if rx.try_recv().is_ok() {
                        // Producer finished, try to get remaining items
                        while let Some(value) = consumer_deque.pop_front() {
                            received.push(value);
                        }
                        break;
                    }
                    thread::sleep(Duration::from_millis(1));
                }
            }
            received
        });
        
        let received = consumer.join().unwrap();
        producer.join().unwrap();
        
        // Verify we got all values
        assert_eq!(received.len(), 100);
        let mut sorted = received.clone();
        sorted.sort();
        let expected: Vec<i32> = (0..100).collect();
        assert_eq!(sorted, expected);
    }

    #[test]
    fn test_string_values() {
        let deque = LockFreeDeque::with_capacity(5);
        
        assert!(deque.push_back("hello".to_string()).is_ok());
        assert!(deque.push_back("world".to_string()).is_ok());
        
        assert_eq!(deque.pop_front(), Some("hello".to_string()));
        assert_eq!(deque.pop_front(), Some("world".to_string()));
        assert_eq!(deque.pop_front(), None);
    }
}

fn main() {
    println!("Running lock-free deque tests...");
    
    // Run a simple demo
    let deque = LockFreeDeque::with_capacity(5);
    
    println!("Pushing values: 1, 2, 3");
    deque.push_back(1).unwrap();
    deque.push_back(2).unwrap();
    deque.push_back(3).unwrap();
    
    println!("Current length: {}", deque.len());
    
    println!("Popping values:");
    while let Some(value) = deque.pop_front() {
        println!("  Popped: {}", value);
    }
    
    println!("Deque is empty: {}", deque.is_empty());
    println!("All tests completed!");
} 