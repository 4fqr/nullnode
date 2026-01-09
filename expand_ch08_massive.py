#!/usr/bin/env python3
"""
Massive expansion script for Programming Ch08.
Adds 800-1000 lines to each section to reach 15000+ total lines.
"""

# Section 5 State Management expansion (insert after line 6310)
section5_expansion = """
            <h3>Part 2: When Do You REALLY Need State Management?</h3>
            
            <p>Before reaching for Redux or Zustand, ask yourself these questions:</p>

            <div class="info-box">
                <h4>8 Signs You Need Global State Management</h4>
                <p><strong>1. Deep prop drilling:</strong> Passing props through 3+ components<br>
                <strong>2. Shared state:</strong> Multiple unrelated components need same data (user info, theme, cart)<br>
                <strong>3. Frequent updates:</strong> Data changes often and many components care<br>
                <strong>4. Complex state logic:</strong> State updates depend on previous state in non-trivial ways<br>
                <strong>5. State synchronization:</strong> Need to keep multiple pieces of UI in sync<br>
                <strong>6. Undo/redo:</strong> Need state history (time-travel debugging)<br>
                <strong>7. Server state caching:</strong> Want to avoid refetching same API data<br>
                <strong>8. Team collaboration:</strong> Predictable state updates help team coordination<br><br>
                <strong>If you answered YES to 2+ of these, consider state management!</strong></p>
            </div>

            <div class="metaphor-box">
                <h4>The Decision Tree</h4>
                <p><strong>1-2 components need data:</strong> Use local state (<code>useState</code>)<br><br>
                <strong>3-5 components, single feature:</strong> Lift state up to common parent<br><br>
                <strong>5-10 components, multiple features:</strong> Use Context API<br><br>
                <strong>10+ components, complex logic:</strong> Use Redux Toolkit or Zustand<br><br>
                <strong>Lots of server data:</strong> Use React Query + minimal client state<br><br>
                Don't overthink it! Start simple, refactor when you feel the pain.</p>
            </div>

            <h3>Part 3: Redux Toolkit - The Industry Standard</h3>
            
            <p>Redux is the most popular state management library for React. But "regular" Redux is verbose and complicated. <strong>Redux Toolkit (RTK)</strong> is the modern, official way to use Redux—much simpler!</p>

            <h4>Redux Mental Model</h4>
            
            <div class="metaphor-box">
                <h4>Redux as a Restaurant Kitchen</h4>
                <p><strong>Store:</strong> The entire kitchen—centralized place for all food/data<br>
                <strong>State:</strong> Current inventory (what's in the fridge right now)<br>
                <strong>Actions:</strong> Orders from customers ("Add burger", "Remove fries")<br>
                <strong>Reducers:</strong> Cooks who process orders and update inventory<br>
                <strong>Dispatch:</strong> Sending an order to the kitchen<br>
                <strong>Selectors:</strong> Looking at the inventory to see what's available<br><br>
                When you dispatch an action, a reducer processes it and updates the store. All components watching that data get notified!</p>
            </div>

            <h4>Installing Redux Toolkit</h4>
            
            <div class="code">npm install @reduxjs/toolkit react-redux

// Or with yarn:
yarn add @reduxjs/toolkit react-redux</div>

            <h4>Creating Your First Store</h4>
            
            <p>Let's build a counter app with Redux Toolkit to see all the pieces:</p>

            <div class="code">// src/store/store.js
import { configureStore } from '@reduxjs/toolkit';
import counterReducer from './counterSlice';

export const store = configureStore({
  reducer: {
    counter: counterReducer,
    // Add more slices here as your app grows
  },
});
</div>

            <div class="info-box">
                <h4>What's configureStore?</h4>
                <p><code>configureStore</code> sets up the Redux store with good defaults: Redux DevTools enabled, middleware included, and easier configuration. You just pass an object with your reducers!</p>
            </div>

            <h4>Creating a Slice (The RTK Way)</h4>
            
            <p>A "slice" is a piece of your state + the logic to update it. It's like one section of your kitchen:</p>

            <div class="code">// src/store/counterSlice.js
import { createSlice } from '@reduxjs/toolkit';

const counterSlice = createSlice({
  name: 'counter',  // Name for this slice
  initialState: {
    value: 0,       // Starting state
  },
  reducers: {
    // Each function here becomes an action!
    increment: (state) => {
      // In RTK, you can "mutate" state directly!
      // (Immer library handles immutability behind the scenes)
      state.value += 1;
    },
    decrement: (state) => {
      state.value -= 1;
    },
    incrementByAmount: (state, action) => {
      // action.payload contains the data you passed
      state.value += action.payload;
    },
    reset: (state) => {
      state.value = 0;
    },
  },
});

// Export actions (auto-generated!)
export const { increment, decrement, incrementByAmount, reset } = counterSlice.actions;

// Export reducer
export default counterSlice.reducer;
</div>

            <div class="warning-box">
                <h4>The "Mutable" Updates Magic</h4>
                <p>In regular Redux, you can't mutate state: <code>state.value += 1</code> is WRONG.<br><br>
                But Redux Toolkit uses Immer library, which lets you write "mutating" code that's actually safe! Under the hood, it creates a new state object. This makes Redux SO much easier to write!</p>
            </div>

            <h4>Connecting Redux to Your App</h4>
            
            <div class="code">// src/index.js or src/main.jsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import { Provider } from 'react-redux';
import { store } from './store/store';
import App from './App';

ReactDOM.createRoot(document.getElementById('root')).render(
  &lt;Provider store={store}&gt;
    &lt;App /&gt;
  &lt;/Provider&gt;
);
</div>

            <div class="info-box">
                <h4>The Provider Component</h4>
                <p><code>Provider</code> makes the Redux store available to ALL components in your app. Wrap your <code>&lt;App&gt;</code> with it at the top level. Now any component can access the store!</p>
            </div>

            <h4>Using Redux in Components</h4>
            
            <div class="code">// src/components/Counter.jsx
import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { increment, decrement, incrementByAmount, reset } from '../store/counterSlice';

function Counter() {
  // useSelector: Read data from store
  const count = useSelector((state) => state.counter.value);
  
  // useDispatch: Get the dispatch function to send actions
  const dispatch = useDispatch();
  
  return (
    &lt;div&gt;
      &lt;h2&gt;Count: {count}&lt;/h2&gt;
      
      &lt;button onClick={() => dispatch(increment())}&gt;
        + Increment
      &lt;/button&gt;
      
      &lt;button onClick={() => dispatch(decrement())}&gt;
        - Decrement
      &lt;/button&gt;
      
      &lt;button onClick={() => dispatch(incrementByAmount(5))}&gt;
        + Add 5
      &lt;/button&gt;
      
      &lt;button onClick={() => dispatch(reset())}&gt;
        Reset
      &lt;/button&gt;
    &lt;/div&gt;
  );
}

export default Counter;
</div>

            <div class="metaphor-box">
                <h4>How It Works</h4>
                <p><strong>useSelector:</strong> "Hey store, give me the counter value. If it changes, re-render me!"<br><br>
                <strong>useDispatch:</strong> "Give me the function to send orders to the kitchen."<br><br>
                <strong>dispatch(increment()):</strong> "Send an INCREMENT action to the store."<br><br>
                The reducer processes the action, updates state, and all components using that state re-render with the new value!</p>
            </div>

            <h3>Part 4: Building a Todo App with Redux</h3>
            
            <p>Let's build something more realistic: a todo app with add, toggle, delete, and filter:</p>

            <div class="code">// src/store/todosSlice.js
import { createSlice } from '@reduxjs/toolkit';

const todosSlice = createSlice({
  name: 'todos',
  initialState: {
    items: [],  // Array of todos
    filter: 'all',  // 'all', 'active', 'completed'
  },
  reducers: {
    addTodo: (state, action) => {
      state.items.push({
        id: Date.now(),
        text: action.payload,
        completed: false,
      });
    },
    toggleTodo: (state, action) => {
      const todo = state.items.find(t => t.id === action.payload);
      if (todo) {
        todo.completed = !todo.completed;
      }
    },
    deleteTodo: (state, action) => {
      state.items = state.items.filter(t => t.id !== action.payload);
    },
    setFilter: (state, action) => {
      state.filter = action.payload;  // 'all', 'active', 'completed'
    },
  },
});

export const { addTodo, toggleTodo, deleteTodo, setFilter } = todosSlice.actions;
export default todosSlice.reducer;
</div>

            <div class="code">// src/components/TodoApp.jsx
import React, { useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { addTodo, toggleTodo, deleteTodo, setFilter } from '../store/todosSlice';

function TodoApp() {
  const [input, setInput] = useState('');
  const dispatch = useDispatch();
  
  // Get todos and filter from store
  const todos = useSelector((state) => state.todos.items);
  const filter = useSelector((state) => state.todos.filter);
  
  // Filter todos based on current filter
  const filteredTodos = todos.filter(todo => {
    if (filter === 'active') return !todo.completed;
    if (filter === 'completed') return todo.completed;
    return true;  // 'all'
  });
  
  const handleAdd = () => {
    if (input.trim()) {
      dispatch(addTodo(input));
      setInput('');
    }
  };
  
  return (
    &lt;div&gt;
      &lt;h2&gt;Redux Todo App&lt;/h2&gt;
      
      {/* Input */}
      &lt;div&gt;
        &lt;input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && handleAdd()}
          placeholder="What needs to be done?"
        /&gt;
        &lt;button onClick={handleAdd}&gt;Add&lt;/button&gt;
      &lt;/div&gt;
      
      {/* Filters */}
      &lt;div&gt;
        &lt;button onClick={() => dispatch(setFilter('all'))}&gt;All&lt;/button&gt;
        &lt;button onClick={() => dispatch(setFilter('active'))}&gt;Active&lt;/button&gt;
        &lt;button onClick={() => dispatch(setFilter('completed'))}&gt;Completed&lt;/button&gt;
      &lt;/div&gt;
      
      {/* Todo List */}
      &lt;ul&gt;
        {filteredTodos.map(todo => (
          &lt;li key={todo.id}&gt;
            &lt;input
              type="checkbox"
              checked={todo.completed}
              onChange={() => dispatch(toggleTodo(todo.id))}
            /&gt;
            &lt;span style={{
              textDecoration: todo.completed ? 'line-through' : 'none'
            }}&gt;
              {todo.text}
            &lt;/span&gt;
            &lt;button onClick={() => dispatch(deleteTodo(todo.id))}&gt;
              Delete
            &lt;/button&gt;
          &lt;/li&gt;
        ))}
      &lt;/ul&gt;
      
      &lt;p&gt;{filteredTodos.length} items&lt;/p&gt;
    &lt;/div&gt;
  );
}

export default TodoApp;
</div>

            <div class="info-box">
                <h4>What Just Happened?</h4>
                <p>We created a full todo app with Redux! Key points:<br><br>
                <strong>1. Multiple state pieces:</strong> <code>items</code> array and <code>filter</code> string<br>
                <strong>2. Multiple actions:</strong> add, toggle, delete, filter<br>
                <strong>3. Derived state:</strong> <code>filteredTodos</code> computed from todos + filter<br>
                <strong>4. All state in store:</strong> Any component can access todos without prop drilling<br><br>
                This same pattern scales to apps with 100+ components!</p>
            </div>

"""

print("Expansion script created. This demonstrates the pattern for massive content injection.")
print("To fully expand Ch08 to 15000+ lines, similar expansions need to be added for:")
print("- Section 6: API Integration (add 800 lines)")
print("- Section 7: Real-Time Features (add 800 lines)")
print("- Section 8: Authentication (add 800 lines)")
print("- Section 9: File Uploads (add 800 lines)")
print("- Section 10: PWA Features (add 800 lines)")
print("- Section 11: Testing (add 800 lines)")
print("- Section 12: Deployment (add 500 lines)")
print("\nTotal additions needed: ~6000 lines")
print("Current file: ~7500 lines")
print("Target: 15000+ lines")
