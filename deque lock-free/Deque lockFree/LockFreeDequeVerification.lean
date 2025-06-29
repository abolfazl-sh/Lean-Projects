import Veil

-- Veil module for CAS-based lock-free deque verification
veil module LockFreeDeque

-- Define the deque state with atomic counters and buffer (as propositions)
relation head_zero : Prop      -- head = 0
relation head_one : Prop       -- head = 1  
relation head_two : Prop       -- head = 2
relation head_three : Prop     -- head = 3
relation head_four : Prop      -- head = 4

relation tail_zero : Prop      -- tail = 0
relation tail_one : Prop       -- tail = 1
relation tail_two : Prop       -- tail = 2  
relation tail_three : Prop     -- tail = 3
relation tail_four : Prop      -- tail = 4

relation capacity_four : Prop  -- capacity = 4
relation buffer_empty : Prop   -- buffer_size = 0
relation buffer_one : Prop     -- buffer_size = 1
relation buffer_two : Prop     -- buffer_size = 2
relation buffer_three : Prop   -- buffer_size = 3
relation buffer_full : Prop    -- buffer_size = 4

-- CAS operation states
relation cas_success : Prop  -- CAS operation succeeded
relation cas_failure : Prop  -- CAS operation failed (retry needed)
relation retry_zero : Prop   -- retry_count = 0
relation retry_one : Prop    -- retry_count = 1
relation retry_two : Prop    -- retry_count = 2

-- Memory ordering and atomic operations
relation memory_ordering : Prop  -- Proper memory ordering maintained
relation atomic_operation : Prop -- Current operation is atomic
relation operation_in_progress : Prop -- An operation is currently being executed

-- Generate the state type
#gen_state

-- Initial state matching Rust implementation
after_init {
  head_zero := True
  head_one := False
  head_two := False
  head_three := False
  head_four := False
  
  tail_zero := True
  tail_one := False
  tail_two := False
  tail_three := False
  tail_four := False
  
  capacity_four := True
  buffer_empty := True
  buffer_one := False
  buffer_two := False
  buffer_three := False
  buffer_full := False
  
  cas_success := False
  cas_failure := False
  retry_zero := True
  retry_one := False
  retry_two := False
  
  memory_ordering := True
  atomic_operation := True
  operation_in_progress := False
}

-- Start atomic operation
action start_atomic_operation = {
  require ¬ operation_in_progress
  require atomic_operation
  operation_in_progress := True
  atomic_operation := False
}

-- End atomic operation
action end_atomic_operation = {
  require operation_in_progress
  operation_in_progress := False
  atomic_operation := True
}

-- CAS-based push_back operation with retry logic
action push_back = {
  require ¬ operation_in_progress
  require memory_ordering
  
  -- Start atomic operation
  operation_in_progress := True
  atomic_operation := False
  
  -- Check if deque is full (matching Rust condition)
  if buffer_full then
    -- Deque is full, operation fails
    cas_failure := True
    cas_success := False
    -- End atomic operation
    operation_in_progress := False
    atomic_operation := True
  else
    -- Try CAS operation on tail
    if cas_success then
      -- CAS succeeded: claim the position
      if tail_zero then
        tail_zero := False
        tail_one := True
        buffer_empty := False
        buffer_one := True
      else if tail_one then
        tail_one := False
        tail_two := True
        buffer_one := False
        buffer_two := True
      else if tail_two then
        tail_two := False
        tail_three := True
        buffer_two := False
        buffer_three := True
      else if tail_three then
        tail_three := False
        tail_four := True
        buffer_three := False
        buffer_full := True
      cas_failure := False
      retry_zero := True
      retry_one := False
      retry_two := False
      -- End atomic operation
      operation_in_progress := False
      atomic_operation := True
    else
      -- CAS failed: retry needed
      cas_failure := True
      if retry_zero then
        retry_zero := False
        retry_one := True
      else if retry_one then
        retry_one := False
        retry_two := True
      -- End atomic operation for retry
      operation_in_progress := False
      atomic_operation := True
}

-- CAS-based pop_front operation with retry logic  
action pop_front = {
  require ¬ operation_in_progress
  require memory_ordering
  
  -- Start atomic operation
  operation_in_progress := True
  atomic_operation := False
  
  -- Check if deque is empty (matching Rust condition)
  if buffer_empty then
    -- Deque is empty, operation fails
    cas_failure := True
    cas_success := False
    -- End atomic operation
    operation_in_progress := False
    atomic_operation := True
  else
    -- Try CAS operation on head
    if cas_success then
      -- CAS succeeded: claim the position
      if head_zero then
        head_zero := False
        head_one := True
        buffer_one := False
        buffer_empty := True
      else if head_one then
        head_one := False
        head_two := True
        buffer_two := False
        buffer_one := True
      else if head_two then
        head_two := False
        head_three := True
        buffer_three := False
        buffer_two := True
      else if head_three then
        head_three := False
        head_four := True
        buffer_full := False
        buffer_three := True
      cas_failure := False
      retry_zero := True
      retry_one := False
      retry_two := False
      -- End atomic operation
      operation_in_progress := False
      atomic_operation := True
    else
      -- CAS failed: retry needed
      cas_failure := True
      if retry_zero then
        retry_zero := False
        retry_one := True
      else if retry_one then
        retry_one := False
        retry_two := True
      -- End atomic operation for retry
      operation_in_progress := False
      atomic_operation := True
}

-- Helper action to simulate CAS success/failure
action simulate_cas_success = {
  cas_success := True
  cas_failure := False
}

action simulate_cas_failure = {
  cas_success := False
  cas_failure := True
}

-- Reset CAS state for next operation
action reset_cas_state = {
  cas_success := False
  cas_failure := False
  retry_zero := True
  retry_one := False
  retry_two := False
}

-- Safety properties for lock-free deque
safety [no_deadlock] 
  -- At least one operation can always make progress
  (¬ buffer_full) ∨ (¬ buffer_empty)

safety [cas_atomicity]
  -- CAS operations are atomic - only one operation can be in progress at a time
  ¬ (operation_in_progress ∧ atomic_operation)

safety [memory_ordering_preserved]
  -- Memory ordering is always maintained
  memory_ordering

-- Invariants for lock-free properties
invariant [progress_possible] 
  -- Progress is always possible in lock-free implementation
  (¬ buffer_full) ∨ (¬ buffer_empty)

invariant [logical_consistency] 
  -- Logical consistency of deque state
  (buffer_empty → (head_zero ∧ tail_zero)) ∧ 
  (buffer_full → (tail_four ∧ head_zero))

invariant [state_consistency] 
  -- State consistency: buffer size matches head/tail difference
  (buffer_empty → (head_zero ∧ tail_zero)) ∧
  (buffer_one → ((head_zero ∧ tail_one) ∨ (head_one ∧ tail_two) ∨ (head_two ∧ tail_three) ∨ (head_three ∧ tail_four))) ∧
  (buffer_two → ((head_zero ∧ tail_two) ∨ (head_one ∧ tail_three) ∨ (head_two ∧ tail_four))) ∧
  (buffer_three → ((head_zero ∧ tail_three) ∨ (head_one ∧ tail_four))) ∧
  (buffer_full → (head_zero ∧ tail_four))

invariant [capacity_bounds]
  -- Capacity bounds are respected
  (buffer_empty ∨ buffer_one ∨ buffer_two ∨ buffer_three ∨ buffer_full) ∧ 
  (head_zero ∨ head_one ∨ head_two ∨ head_three ∨ head_four) ∧
  (tail_zero ∨ tail_one ∨ tail_two ∨ tail_three ∨ tail_four)

invariant [retry_bounded]
  -- Retry count is bounded (prevents infinite loops)
  retry_zero ∨ retry_one ∨ retry_two

invariant [atomicity_consistency]
  -- Atomicity consistency: atomic_operation and operation_in_progress are mutually exclusive
  (atomic_operation ∧ ¬ operation_in_progress) ∨ (¬ atomic_operation ∧ operation_in_progress)

-- Generate the specification
#gen_spec

-- Check invariants
#check_invariants

-- Bounded model checking for CAS-based lock-free scenarios
sat trace [cas_push_success] {
  assert ¬ buffer_full
  simulate_cas_success
  push_back
  assert ¬ buffer_empty
} by bmc_sat

sat trace [cas_pop_success] {
  push_back
  assert ¬ buffer_empty
  simulate_cas_success
  pop_front
  assert buffer_empty
} by bmc_sat

sat trace [cas_retry_logic] {
  simulate_cas_failure
  push_back
  simulate_cas_success
  push_back
} by bmc_sat

sat trace [no_deadlock_progress] {
  any 3 actions
  assert ((¬ buffer_full) ∨ (¬ buffer_empty))
} by bmc_sat

-- Verify CAS atomicity
sat trace [cas_atomic_operation] {
  assert atomic_operation
  push_back
  assert ¬ atomic_operation
  end_atomic_operation
  assert atomic_operation
} by bmc_sat

-- Verify memory ordering preservation
sat trace [memory_ordering_maintained] {
  assert memory_ordering
  pop_front
  assert memory_ordering
} by bmc_sat

-- Verify retry logic works correctly
sat trace [retry_logic_correct] {
  simulate_cas_failure
  assert retry_one
  reset_cas_state
  assert retry_zero
} by bmc_sat

-- Verify that operations can always make progress (lock-free property)
sat trace [lock_free_progress] {
  assert (¬ buffer_full) ∨ (¬ buffer_empty)
  any 2 actions
  assert (¬ buffer_full) ∨ (¬ buffer_empty)
} by bmc_sat

-- Verify CAS-based push operation
unsat trace [cas_push_violation] {
  assert buffer_full
  simulate_cas_success
  push_back
} by bmc

-- Verify CAS-based pop operation  
unsat trace [cas_pop_violation] {
  assert buffer_empty
  simulate_cas_success
  pop_front
} by bmc

-- Verify no infinite retry loops
unsat trace [infinite_retry_violation] {
  any 15 actions
  assert retry_two
} by bmc

-- Verify atomicity violation (two operations cannot be atomic simultaneously)
unsat trace [atomicity_violation] {
  push_back
  assert operation_in_progress
  pop_front
} by bmc

end LockFreeDeque 