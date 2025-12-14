# MASTER CONTENT GENERATOR - Creates all missing chapters
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  NullSector Content Generator v2.0" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

# Standard header template
function Get-StandardHeader($title, $breadcrumb, $chapterNum, $activeNav) {
    return @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title - NullSector</title>
    <link rel="icon" type="image/svg+xml" href="logo.svg">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #000; color: #fff; line-height: 1.7; }
        .header { position: fixed; top: 0; left: 0; right: 0; background: rgba(0,0,0,0.95); backdrop-filter: blur(10px); border-bottom: 1px solid #222; z-index: 1000; padding: 1rem 2rem; }
        .header-content { max-width: 1400px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
        .brand { display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: #fff; font-weight: 700; font-size: 1.25rem; }
        .brand img { width: 36px; height: 36px; }
        .nav { display: flex; gap: 2rem; align-items: center; }
        .nav a { color: #888; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .nav a:hover, .nav a.active { color: #fff; }
        .content { padding: 7rem 2rem 4rem; max-width: 1200px; margin: 0 auto; }
        h1 { font-size: 3rem; font-weight: 800; margin-bottom: 1rem; }
        h2 { font-size: 2rem; font-weight: 700; margin: 3rem 0 1.5rem; }
        h3 { font-size: 1.5rem; font-weight: 600; margin: 2rem 0 1rem; }
        p { color: #888; margin-bottom: 1.5rem; font-size: 1.05rem; line-height: 1.8; }
        code { font-family: 'JetBrains Mono', monospace; background: #111; padding: 0.2rem 0.5rem; border-radius: 4px; color: #fff; font-size: 0.9em; }
        pre { background: #111; border: 1px solid #222; border-radius: 8px; padding: 1.5rem; margin: 1.5rem 0; overflow-x: auto; }
        .example-box { background: #111; border: 1px solid #222; border-radius: 12px; padding: 2rem; margin: 2rem 0; }
        .metaphor-box { background: #111; border-left: 4px solid #fff; padding: 2rem; margin: 2rem 0; border-radius: 8px; }
        ul, ol { margin: 1rem 0 1.5rem 2rem; color: #888; }
        li { margin-bottom: 0.75rem; }
        strong { color: #fff; }
        .breadcrumb { background: #111; border: 1px solid #222; padding: 0.75rem 1.5rem; border-radius: 8px; display: inline-flex; gap: 0.5rem; margin-bottom: 2rem; }
        .breadcrumb a { color: #fff; text-decoration: none; }
        .chapter-num { display: inline-block; width: 60px; height: 60px; line-height: 60px; text-align: center; background: #111; border: 2px solid #222; border-radius: 12px; font-size: 1.5rem; font-weight: 800; margin-bottom: 1.5rem; }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <a href="index.html" class="brand">
                <img src="logo.svg" alt="NullSector">
                <span>NullSector</span>
            </a>
            <nav class="nav">
                <a href="roadmap-hacking.html"$( if ($activeNav -eq 'hacking') {' class="active"'} )>Hacking</a>
                <a href="roadmap-programming.html"$( if ($activeNav -eq 'programming') {' class="active"'} )>Programming</a>
                <a href="null-terminal.html"$( if ($activeNav -eq 'terminal') {' class="active"'} )>Null Terminal</a>
                <a href="faq.html"$( if ($activeNav -eq 'faq') {' class="active"'} )>FAQ</a>
                <a href="https://discord.gg/Tz9Y3wea32" target="_blank">Discord</a>
            </nav>
        </div>
    </header>
    <div class="content">
        <div class="breadcrumb">
            <a href="$breadcrumb">$( if ($activeNav -eq 'programming') {'Programming Roadmap'} else {'Hacking Roadmap'} )</a> <span>/</span> <span>Chapter $chapterNum</span>
        </div>
        <div class="chapter-num">$chapterNum</div>
"@
}

Write-Host "`n[1/7] Creating programming-ch02.html (Data Structures)..." -ForegroundColor Yellow

$ch02 = Get-StandardHeader "Ch02: Data Structures" "roadmap-programming.html" "02" "programming"
$ch02 += @'
        <h1>Data Structures: Organizing Your Data</h1>
        <p style="font-size: 1.2rem; color: #fff; margin-bottom: 3rem;">Lists, dictionaries, tuples, and sets explained for absolute beginners</p>

        <div class="metaphor-box">
            <strong>The Big Picture:</strong> In Chapter 1, you learned about variables—boxes that hold single values. But what if you need to store 100 values? 1000? You can't create 1000 separate variables! Data structures are like different types of containers: shelves for lists, filing cabinets for dictionaries, sealed boxes for tuples.
        </div>

        <h2>Section 1: Lists — Ordered Collections</h2>
        
        <h3>What is a List?</h3>
        <p>A list is an ordered collection of items. Think of it like a shopping list where order matters and you can add/remove items.</p>

        <div class="example-box">
            <h4>Creating Lists:</h4>
            <pre><code>fruits = ["apple", "banana", "cherry"]
numbers = [1, 2, 3, 4, 5]
mixed = [42, "hello", True, 3.14]  # Can mix types!
empty = []</code></pre>
        </div>

        <h3>Accessing List Items</h3>
        <div class="metaphor-box">
            <strong>Index Metaphor:</strong> Think of a list like apartment numbers. The first item is #0, second is #1, etc. Python counts from 0 because programmers are weird like that. You can also count backwards: -1 is the last item, -2 is second-to-last.
        </div>

        <div class="example-box">
            <pre><code>fruits = ["apple", "banana", "cherry", "date"]

print(fruits[0])    # "apple" (first)
print(fruits[1])    # "banana"
print(fruits[-1])   # "date" (last)
print(fruits[-2])   # "cherry" (second-to-last)</code></pre>
        </div>

        <h3>Modifying Lists</h3>
        <div class="example-box">
            <pre><code>fruits = ["apple", "banana"]

# Add to end
fruits.append("cherry")        # ["apple", "banana", "cherry"]

# Insert at position
fruits.insert(1, "blueberry")  # ["apple", "blueberry", "banana", "cherry"]

# Remove item
fruits.remove("banana")         # ["apple", "blueberry", "cherry"]

# Remove by index
del fruits[0]                   # ["blueberry", "cherry"]

# Change item
fruits[0] = "strawberry"        # ["strawberry", "cherry"]</code></pre>
        </div>

        <h3>List Operations</h3>
        <div class="example-box">
            <pre><code>numbers = [1, 2, 3]

len(numbers)        # 3 (length)
numbers + [4, 5]    # [1, 2, 3, 4, 5] (concatenate)
numbers * 2         # [1, 2, 3, 1, 2, 3] (repeat)
3 in numbers        # True (check membership)
numbers.sort()      # Sort in place
numbers.reverse()   # Reverse in place</code></pre>
        </div>

        <h2>Section 2: Dictionaries — Key-Value Pairs</h2>

        <h3>What is a Dictionary?</h3>
        <div class="metaphor-box">
            <strong>The Phone Book Analogy:</strong> A dictionary is like a phone book. You look up a name (key) to find a phone number (value). Unlike lists where you access items by position (0, 1, 2...), dictionaries use meaningful keys like "name", "age", "email".
        </div>

        <div class="example-box">
            <h4>Creating Dictionaries:</h4>
            <pre><code>person = {
    "name": "Alice",
    "age": 25,
    "city": "New York"
}

# Access by key
print(person["name"])    # "Alice"
print(person["age"])     # 25

# Add new key-value pair
person["email"] = "alice@example.com"

# Change value
person["age"] = 26

# Delete key
del person["city"]</code></pre>
        </div>

        <h3>Dictionary Methods</h3>
        <div class="example-box">
            <pre><code>person = {"name": "Bob", "age": 30}

person.keys()       # ["name", "age"]
person.values()     # ["Bob", 30]
person.items()      # [("name", "Bob"), ("age", 30)]

# Safe access (won't crash if key missing)
person.get("email", "N/A")    # "N/A" (default)</code></pre>
        </div>

        <h2>Section 3: Tuples — Immutable Lists</h2>

        <h3>What is a Tuple?</h3>
        <div class="metaphor-box">
            <strong>The Sealed Package Metaphor:</strong> A tuple is like a sealed package. Once you create it, you CAN'T change it. No adding, removing, or modifying items. Use tuples when data shouldn't change (coordinates, RGB colors, database records).
        </div>

        <div class="example-box">
            <pre><code># Create tuples with parentheses
coordinates = (10, 20)
rgb = (255, 0, 128)
person = ("Alice", 25, "New York")

# Access like lists
print(coordinates[0])    # 10
print(rgb[1])            # 0

# This would cause ERROR (tuples are immutable):
# coordinates[0] = 15  # ❌ Can't modify!</code></pre>
        </div>

        <h2>Section 4: Sets — Unique Collections</h2>

        <h3>What is a Set?</h3>
        <div class="metaphor-box">
            <strong>The VIP Club Metaphor:</strong> A set is like a VIP club—each person can only be in the club once. No duplicates allowed. Also, order doesn't matter (unlike lists). Perfect for finding unique items or checking membership super fast.
        </div>

        <div class="example-box">
            <pre><code># Create sets with curly braces
numbers = {1, 2, 3, 4, 5}
colors = {"red", "green", "blue"}

# Duplicates automatically removed
numbers = {1, 2, 2, 3, 3, 3}  # Becomes {1, 2, 3}

# Set operations
set1 = {1, 2, 3}
set2 = {3, 4, 5}

set1.union(set2)         # {1, 2, 3, 4, 5}
set1.intersection(set2)  # {3}
set1.difference(set2)    # {1, 2}

# Add/remove
numbers.add(6)
numbers.remove(3)</code></pre>
        </div>

        <h2>Practice Challenges</h2>

        <div class="example-box">
            <h4>Challenge 1: Shopping List Manager</h4>
            <p>Create a program that:</p>
            <ol>
                <li>Starts with an empty list</li>
                <li>Asks the user to add 5 items</li>
                <li>Prints the list</li>
                <li>Asks which item to remove</li>
                <li>Prints the updated list</li>
            </ol>
        </div>

        <div class="example-box">
            <h4>Challenge 2: Student Database</h4>
            <p>Create a dictionary for 3 students with keys: name, age, grade, subjects (list)</p>
            <p>Then print each student's information formatted nicely</p>
        </div>

        <h2>Key Takeaways</h2>
        <ul>
            <li><strong>Lists</strong> []: Ordered, changeable, allow duplicates. Use for sequences.</li>
            <li><strong>Dictionaries</strong> {}: Key-value pairs. Use for labeled data.</li>
            <li><strong>Tuples</strong> (): Ordered, unchangeable. Use for fixed data.</li>
            <li><strong>Sets</strong> {}: Unordered, unique items only. Use for membership checks.</li>
        </ul>

        <div style="margin-top: 4rem; padding: 2rem; background: #111; border-radius: 12px; text-align: center;">
            <a href="programming-ch03.html" style="display: inline-block; padding: 1rem 2rem; background: #fff; color: #000; text-decoration: none; border-radius: 8px; font-weight: 700;">Continue to Chapter 03 →</a>
        </div>
    </div>
</body>
</html>
'@

$ch02 | Out-File -FilePath "programming-ch02.html" -Encoding UTF8
Write-Host "  ✓ programming-ch02.html created!" -ForegroundColor Green

Write-Host "`n[2/7] Creating programming-ch03.html (Control Flow)..." -ForegroundColor Yellow

$ch03 = Get-StandardHeader "Ch03: Control Flow" "roadmap-programming.html" "03" "programming"
$ch03 += @'
        <h1>Control Flow & Functions: Making Decisions & Reusing Code</h1>
        <p style="font-size: 1.2rem; color: #fff; margin-bottom: 3rem;">if/else, loops, and functions explained simply</p>

        <h2>Section 1: if Statements — Making Decisions</h2>

        <div class="metaphor-box">
            <strong>The Bouncer Analogy:</strong> An if statement is like a bouncer at a club. "IF you're 21+, you can enter. ELSE, go home." Your code checks a condition and takes different actions based on whether it's True or False.
        </div>

        <div class="example-box">
            <pre><code>age = int(input("Enter your age: "))

if age >= 18:
    print("You are an adult")
else:
    print("You are a minor")</code></pre>
        </div>

        <h3>elif — Multiple Conditions</h3>
        <div class="example-box">
            <pre><code>score = 85

if score >= 90:
    print("Grade: A")
elif score >= 80:
    print("Grade: B")
elif score >= 70:
    print("Grade: C")
else:
    print("Grade: F")</code></pre>
        </div>

        <h2>Section 2: Loops — Repeating Actions</h2>

        <h3>for Loops — Iterate Over Sequences</h3>
        <div class="metaphor-box">
            <strong>The Assembly Line:</strong> A for loop is like an assembly line worker. Give them a list of items, and they'll process each one the same way.
        </div>

        <div class="example-box">
            <pre><code># Loop through list
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)

# Loop through range
for i in range(5):  # 0, 1, 2, 3, 4
    print(i)

# Loop through string
for letter in "hello":
    print(letter)</code></pre>
        </div>

        <h3>while Loops — Repeat Until Condition</h3>
        <div class="example-box">
            <pre><code>count = 0
while count < 5:
    print(count)
    count += 1  # Same as: count = count + 1</code></pre>
        </div>

        <h2>Section 3: Functions — Reusable Code Blocks</h2>

        <div class="metaphor-box">
            <strong>The Recipe Analogy:</strong> A function is like a recipe. Write it once, use it many times. You give it ingredients (parameters), it follows steps, returns a result.
        </div>

        <div class="example-box">
            <h4>Defining Functions:</h4>
            <pre><code>def greet(name):
    return "Hello, " + name + "!"

# Call the function
message = greet("Alice")
print(message)  # "Hello, Alice!"</code></pre>
        </div>

        <h3>Function with Multiple Parameters</h3>
        <div class="example-box">
            <pre><code>def add_numbers(a, b):
    return a + b

result = add_numbers(5, 3)  # 8
print(result)</code></pre>
        </div>

        <h3>Default Parameters</h3>
        <div class="example-box">
            <pre><code>def greet(name, greeting="Hello"):
    return greeting + ", " + name

print(greet("Alice"))              # "Hello, Alice"
print(greet("Bob", "Hi"))          # "Hi, Bob"</code></pre>
        </div>

        <h2>Practice Challenges</h2>

        <div class="example-box">
            <h4>Challenge 1: Number Guessing Game</h4>
            <p>Create a game where:</p>
            <ol>
                <li>Computer picks random number 1-100</li>
                <li>User guesses</li>
                <li>Program says "higher" or "lower"</li>
                <li>Repeat until correct</li>
            </ol>
        </div>

        <div class="example-box">
            <h4>Challenge 2: Calculator Function</h4>
            <p>Write a calculator function that takes two numbers and an operator (+, -, *, /) and returns the result</p>
        </div>

        <div style="margin-top: 4rem; padding: 2rem; background: #111; border-radius: 12px; text-align: center;">
            <a href="programming-ch04.html" style="display: inline-block; padding: 1rem 2rem; background: #fff; color: #000; text-decoration: none; border-radius: 8px; font-weight: 700;">Continue to Chapter 04 →</a>
        </div>
    </div>
</body>
</html>
'@

$ch03 | Out-File -FilePath "programming-ch03.html" -Encoding UTF8
Write-Host "  ✓ programming-ch03.html created!" -ForegroundColor Green

Write-Host "`n[3/7] Creating programming-ch04.html (OOP Basics)..." -ForegroundColor Yellow

$ch04 = Get-StandardHeader "Ch04: Object-Oriented Programming" "roadmap-programming.html" "04" "programming"
$ch04 += @'
        <h1>Object-Oriented Programming: Organizing Code with Classes</h1>
        <p style="font-size: 1.2rem; color: #fff; margin-bottom: 3rem;">Classes and objects explained for absolute beginners</p>

        <h2>Section 1: What is OOP?</h2>

        <div class="metaphor-box">
            <strong>The Blueprint Analogy:</strong> A class is like a blueprint for a house. The blueprint (class) describes what a house should have (rooms, doors, windows), but it's not a house itself. When you BUILD a house from the blueprint, that's an object (instance).
        </div>

        <h3>Your First Class</h3>
        <div class="example-box">
            <pre><code>class Dog:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def bark(self):
        return f"{self.name} says Woof!"

# Create objects
dog1 = Dog("Buddy", 3)
dog2 = Dog("Max", 5)

print(dog1.name)    # "Buddy"
print(dog1.bark())  # "Buddy says Woof!"
print(dog2.age)     # 5</code></pre>
        </div>

        <h3>Understanding self</h3>
        <div class="metaphor-box">
            <strong>The Mirror Metaphor:</strong> <code>self</code> is how an object refers to itself. When <code>dog1.bark()</code> runs, <code>self</code> means "me, dog1". When <code>dog2.bark()</code> runs, <code>self</code> means "me, dog2". It's like looking in a mirror—each object sees itself.
        </div>

        <h2>Section 2: Attributes and Methods</h2>

        <div class="example-box">
            <pre><code>class Person:
    def __init__(self, name, age):
        self.name = name        # Attribute
        self.age = age          # Attribute
    
    def introduce(self):        # Method
        return f"Hi, I'm {self.name}, {self.age} years old"
    
    def have_birthday(self):
        self.age += 1
        return f"Happy birthday! Now {self.age}"

person = Person("Alice", 25)
print(person.introduce())      # "Hi, I'm Alice, 25 years old"
print(person.have_birthday())  # "Happy birthday! Now 26"</code></pre>
        </div>

        <h2>Section 3: Inheritance — Reusing Classes</h2>

        <div class="metaphor-box">
            <strong>The Family Tree:</strong> Inheritance is like a family tree. A child class inherits traits from a parent class but can add its own unique features. A "Vehicle" class might have speed and fuel. A "Car" class inherits those but adds doors and trunk.
        </div>

        <div class="example-box">
            <pre><code>class Animal:
    def __init__(self, name):
        self.name = name
    
    def speak(self):
        return "Some sound"

class Dog(Animal):  # Dog inherits from Animal
    def speak(self):
        return "Woof!"

class Cat(Animal):  # Cat inherits from Animal
    def speak(self):
        return "Meow!"

dog = Dog("Buddy")
cat = Cat("Whiskers")

print(dog.name)     # "Buddy" (inherited)
print(dog.speak())  # "Woof!" (overridden)
print(cat.speak())  # "Meow!" (overridden)</code></pre>
        </div>

        <h2>Practice Challenges</h2>

        <div class="example-box">
            <h4>Challenge 1: Bank Account Class</h4>
            <p>Create a BankAccount class with:</p>
            <ul>
                <li>Attributes: owner, balance</li>
                <li>Methods: deposit(), withdraw(), check_balance()</li>
            </ul>
        </div>

        <div class="example-box">
            <h4>Challenge 2: Student Management System</h4>
            <p>Create a Student class with name, age, grades (list). Add methods to:</p>
            <ul>
                <li>Add a grade</li>
                <li>Calculate average</li>
                <li>Print student info</li>
            </ul>
        </div>

        <h2>Key Takeaways</h2>
        <ul>
            <li><strong>Class</strong>: Blueprint for creating objects</li>
            <li><strong>Object</strong>: Instance of a class</li>
            <li><strong>__init__</strong>: Constructor, runs when object is created</li>
            <li><strong>self</strong>: Refers to the object itself</li>
            <li><strong>Inheritance</strong>: Child classes inherit from parent classes</li>
        </ul>

        <div style="margin-top: 4rem; padding: 2rem; background: #111; border-radius: 12px; text-align: center;">
            <p style="color: #fff; margin-bottom: 1rem;">Congratulations! You've completed the fundamentals!</p>
            <a href="roadmap-programming.html" style="display: inline-block; padding: 1rem 2rem; background: #fff; color: #000; text-decoration: none; border-radius: 8px; font-weight: 700;">Back to Roadmap</a>
        </div>
    </div>
</body>
</html>
'@

$ch04 | Out-File -FilePath "programming-ch04.html" -Encoding UTF8
Write-Host "  ✓ programming-ch04.html created!" -ForegroundColor Green

Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  All programming chapters created!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

# Count total lines
$totalLines = 0
1..4 | ForEach-Object {
    $lines = (Get-Content "programming-ch0$_.html" | Measure-Object -Line).Lines
    $totalLines += $lines
    Write-Host "  programming-ch0$_.html: $lines lines" -ForegroundColor White
}
Write-Host "`n  Total: $totalLines lines of content created!" -ForegroundColor Cyan
