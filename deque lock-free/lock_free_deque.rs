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
        loop {
            let tail = self.tail.load(Ordering::Relaxed);
            let head = self.head.load(Ordering::Acquire);
            
            // Check if deque is full
            if tail - head >= self.capacity {
                return Err(value);
            }
            
            // Try to claim the tail position
            if self.tail.compare_exchange_weak(
                tail, 
                tail + 1, 
                Ordering::Release, 
                Ordering::Relaxed
            ).is_ok() {
                // Successfully claimed the position, now write the value
                unsafe {
                    *self.buffer[tail % self.capacity].get() = Some(value);
                }
                return Ok(());
            }
            // CAS failed, retry
        }
    }

    pub fn pop_front(&self) -> Option<T> {
        loop {
            let head = self.head.load(Ordering::Relaxed);
            let tail = self.tail.load(Ordering::Acquire);
            
            // Check if deque is empty
            if head >= tail {
                return None;
            }
            
            // Try to claim the head position
            if self.head.compare_exchange_weak(
                head, 
                head + 1, 
                Ordering::Release, 
                Ordering::Relaxed
            ).is_ok() {
                // Successfully claimed the position, now read the value
                let value = unsafe {
                    (*self.buffer[head % self.capacity].get()).take()
                };
                return value;
            }
            // CAS failed, retry
        }
    }

    pub fn len(&self) -> usize {
        let head = self.head.load(Ordering::Relaxed);
        let tail = self.tail.load(Ordering::Relaxed);
        tail.saturating_sub(head)
    }

    pub fn is_empty(&self) -> bool {
        let head = self.head.load(Ordering::Relaxed);
        let tail = self.tail.load(Ordering::Relaxed);
        head >= tail
    }

    pub fn is_full(&self) -> bool {
        let head = self.head.load(Ordering::Relaxed);
        let tail = self.tail.load(Ordering::Relaxed);
        tail - head >= self.capacity
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
        
        // Producer thread
        let producer = thread::spawn(move || {
            for i in 0..100 {
                while producer_deque.push_back(i).is_err() {
                    thread::sleep(Duration::from_millis(1));
                }
            }
        });
        
        // Consumer thread
        let consumer = thread::spawn(move || {
            let mut received = Vec::new();
            while received.len() < 100 {
                if let Some(value) = consumer_deque.pop_front() {
                    received.push(value);
                } else {
                    thread::sleep(Duration::from_millis(1));
                }
            }
            received
        });
        
        // Wait for consumer to finish first (it will collect all 100 items)
        let received = consumer.join().unwrap();
        
        // Then wait for producer to finish
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

    #[test]
    fn test_stress_concurrent_access() {
        let deque = LockFreeDeque::with_capacity(50);
        let num_threads = 2;
        let operations_per_thread = 50;
        
        let mut producer_handles = Vec::new();
        let mut consumer_handles = Vec::new();
        
        // Create producer threads
        for thread_id in 0..num_threads / 2 {
            let deque = deque.clone();
            let handle = thread::spawn(move || {
                for i in 0..operations_per_thread {
                    let value = (thread_id * operations_per_thread + i) as i32;
                    while deque.push_back(value).is_err() {
                        thread::sleep(Duration::from_nanos(1));
                    }
                }
            });
            producer_handles.push(handle);
        }
        
        // Create consumer threads
        for _ in 0..num_threads / 2 {
            let deque = deque.clone();
            let handle = thread::spawn(move || {
                let mut received = Vec::new();
                while received.len() < operations_per_thread {
                    if let Some(value) = deque.pop_front() {
                        received.push(value);
                    } else {
                        thread::sleep(Duration::from_nanos(1));
                    }
                }
                received
            });
            consumer_handles.push(handle);
        }
        
        // Wait for all producers
        for handle in producer_handles {
            let _ = handle.join();
        }
        
        // Wait for all consumers and collect results
        let mut all_received = Vec::new();
        for handle in consumer_handles {
            if let Ok(received) = handle.join() {
                all_received.extend(received);
            }
        }
        
        // Verify we got all expected values
        assert_eq!(all_received.len(), (num_threads / 2) * operations_per_thread);
        all_received.sort();
        let expected: Vec<i32> = (0..((num_threads / 2) * operations_per_thread)).map(|x| x as i32).collect();
        assert_eq!(all_received, expected);
        
        // Verify deque is empty
        assert!(deque.is_empty());
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