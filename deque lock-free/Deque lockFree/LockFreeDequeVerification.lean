import Veil

-- Veil module for lock-free deque verification
veil module LockFreeDeque

-- Define the deque state as simple boolean relations
relation is_full : Prop      -- Deque is full
relation is_empty : Prop     -- Deque is empty
relation can_push : Prop     -- Push operation can succeed
relation can_pop : Prop      -- Pop operation can succeed

-- Generate the state type
#gen_state

-- Initial state
after_init {
  is_full := False
  is_empty := True
  can_push := True
  can_pop := False
}

-- Push operation action
action push_back = {
  require can_push
  is_empty := False
  can_pop := True
  can_push := ¬ is_full
}

-- Pop operation action
action pop_front = {
  require can_pop
  can_pop := ¬ is_empty
  if is_full then
    is_full := False
    can_push := True
}

-- Safety property: No deadlock - at least one operation can always succeed
safety [no_deadlock] 
  can_push ∨ can_pop

-- Invariants for lock-free properties
invariant [progress_possible] 
  can_push ∨ can_pop

invariant [logical_consistency] 
  (is_empty → ¬ can_pop) ∧ (is_full → ¬ can_push)

invariant [state_consistency] 
  (can_push ∧ can_pop) ∨ (can_push ∧ ¬ can_pop) ∨ (¬ can_push ∧ can_pop)

-- Generate the specification
#gen_spec

-- Check invariants
#check_invariants

-- Bounded model checking for lock-free scenarios
sat trace [can_push_when_available] {
  assert can_push
  push_back
} by bmc_sat

sat trace [can_pop_when_available] {
  push_back
  assert can_pop
  pop_front
} by bmc_sat

sat trace [no_deadlock_progress] {
  any 2 actions
  assert (can_push ∨ can_pop)
} by bmc_sat

-- Verify that operations can always make progress
sat trace [push_progress] {
  assert can_push
  push_back
} by bmc_sat

sat trace [pop_progress] {
  push_back
  assert can_pop
  pop_front
} by bmc_sat

-- Verify lock-free property: at least one operation can always succeed
unsat trace [lock_free_violation] {
  any 3 actions
  assert (¬ can_push ∧ ¬ can_pop)
} by bmc

end LockFreeDeque 