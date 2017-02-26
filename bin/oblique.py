#!/usr/bin/env python
import random

strategies = """
Faced with a choice, do both things.
Make an exhaustive list of everything you might do next.
Try to make the problem worse to understand how you might make it better.
Do nothing for as long as possible.
Break a big thing up into smaller pieces.
Remember that models don't necessarily correspond with reality.
Generate alternative solutions and pick the best.
Can you make this program do one thing instead of two?
Is this abstraction delivering enough benefit?
Are you solving the right problem?
Are you solving the problem you have or the problem you'd like to have?
Can you automate this?
If it doesn't work, it doesn't matter how fast it doesn't work.
Are you clear about what you are trying to build?
Do you even know what you're talking about?
Could the documentation be wrong?
Does the code actually do what the comments say it should?
Is this premature optimization?
Write a plan then throw it away.
Is this what the customer wants or is it what he needs?
Can you build something to help you understand the problem?
Before software can be reusable it first has to be usable.
Does this need a program or could I use another tool?
First, solve the problem. Then, write the code.
Simplicity is prerequisite for reliability.
Easy things hould be easy; hard things should be possible.
The most effective debugging tool is still careful thought, coupled with judiciously placed print statements.
Deleted code is debugged code.
Are you getting confused by the complexities of your own making?
Don't worry about what anybody else is doing.
Programs must be written for people to read, and only incidentally for machines to execute.
The key to performance is elegance, not battalions of special cases.
Watch out for off-by-one bugs where loops are used.
If there are two or more ways to do something, and one of those ways can result in a catastrophe, then someone will do it.
Make some time and space to learn some new skills.
If you have four groups working on a compiler, you'll get a four-pass compiler.
Resist the temptation to fix it by hand. Make sure the fix is permanent.
Can you use brute force for now and find a fancy algorithm later?
Is it broken by design?
A twin-engine aeroplane has twice as many engine problems as a single engine aeroplane.
Imagine a day in the life of a user of your software.
Go to the library. Sit quietly and think.
Can you find an analogy or metaphor to explore this problem?
KISS: Keep It Short and Simple.  Keep It Simple Stupid!
When did it last work? what has changed?
What's the worse thing that could happen next?
What would be the implications of ignoring this problem and doing nothing about it for the time being?
The simplest explanation is most likely the correct one.
What would a layman or somebody with less experience do?
Shouting and swearing won't help. Clear, rational thinking almost certainly will.
Be quiet! Stop talking and think!
Can you get more information from the customer? Real data? A crash dump? Configuration settings? Virtual machine image?
Is it time to upgrade your computer?
Is there a test or simulation that you could run overnight to give you more information tomorrow?
Is this code really necessary?
Can I simplify the problem somehow?
Only change one thing at a time. Try to predict what will happen with each change.
Find a code sample.
Stop guessing and look at the facts.
Are you fooling yourself?
Could you build a textualizer utility to help manage your data files?
Write some more unit tests.
Have you switched it off and back on again?
Keep a written log of every little thing you change and any results.
Is there a better algorithm? Consult the computer science literature.
Idly thumb through The Gang of Four Design Patterns book.
Idly thumb through The Art of Computer Science by Donald Knuth.
Designing the right data structure is often more important than designing the right code.
How could you go about formally proving this code to be correct?
Is this code part of a design pattern? What's its name?
Get away from your desk. Take a journey on public transport: a train, bus or plane.
Strum your guitar.
Be alone for a while. Make some time and space to really think.
If you are thinking and not writing you only think you are thinking.
Collect together all the information, pictures, scribbles and diagrams. Make a scrapbook or pin them to the wall.
Tidy up your work area.
Are you looking in the right place?
Is this a symptom or a root cause?
Take a break; Read a poem.
Take a break; Look at a painting.
Try recreating this program section from scratch.
What would this code look like in another programming language?
Try to write a small, reproducible code sample with just the salient parts and all other complexity removed.
Is this a numerical problem? Think about rounding, division by zero, overflow and floating point errors.
Are you using the correct configuration settings?
Is this a versioning problem? Check the versions of your operating system, tools and libraries.
Is there a video about this? Look on YouTube or Channel 9.
Is there a standards approach to this?
If you had time to refactor this code, what would you change?
Can you pair program it?
How did they do it without computers?
Don't assume that the bug was caused by somebody else.
Is there somebody you could call upon for assistance?
Build expertise in your project's domain. Talk to expert users. Read industry papers, academic reports, brochures etc.
Buy a book on the subject.
Take a smoke break, even if you don't actually smoke. (Smokers always know what's going on).
Walk a lap around the car park.
Make a cup of tea or coffee.
Don't invent another data format.
Go outside and get some fresh air.
Take a break; go for a run or do some cardiovascular exercise.
Stand in front of a big blank whiteboard with a pen. Start writing.
Draw a picture of the problem with coloured pens.
Try to reproduce the problem on a different computer or different hardware.
What's the simplest thing that could possibly work?
Explain the problem to a co-worker.
Think about what is going on at the lowest layers. What is hitting RAM? What is being sent on the wire?
Try using a different web browser.
Try it on a different network. 3G, Starbucks WIFI or home broadband.
Work in a coffee shop or cafe for a while.
Work from home for a day.
Lie on the sofa with your laptop.
Read the error message slowly, carefully and deliberately. What does it actually say?
Go and sit next to a user of your software.
Can you add code that will provide more information about the problem?
Comment out all the exception and error handlers and try again.
Look hard at any loops. Under what circumstances can they terminate?
Check the types of all the variables in the problematic code.
Rollback or undo the last change.
Does turning OFF any compiler optimizations or debugging tools change the problem?
Write down a clear statement of the problem on paper.
What would Donald Knuth do?
What would Steve Jobs have done?
What would Paul Graham do?
What is the worst thing you could do next?
Can you find some similar code in an open source project and study it?
Go and talk to somebody who isn't a programmer.
Switch off your monitor and sit at your desk quietly for a while.
Shut your eyes for five minutes.
Take a break. Go and get something to eat.
Ignore the problem and work on something else for a while.
Ask a question on Stack Overflow.
Ponder the Telegraph Crossword.
Post the problem on a forum or news group.
Google it.
Can you reuse an old idea or code from an earlier project?
Go home and sleep on it. Things will look different tomorrow.
Can you do this job without writing any more code?
Try to imagine what the world would look like if you had already solved the problem.
Are you using the right tools for the job?
Do your names and abstractions correspond with the real world? Is your code model driven?
Just because other people think it's a bug doesn't mean it's really a bug.
Perform the calculation or task manually with a calculator, pencil and paper.
Consider the possibility of side effects.
Is there an existing library or component that you could use?
Have a long soak in a hot bath.
Are there any log files that might give you more information?
Are there any compiler flags or runtime switches that you could configure to give you more information?
If you are the only person fixing a problem, then people will just have to wait until you're done.
What can you do to contain a problem so that things can't get any worse?
Keep calm and breathe. 
Every problem has a perfectly reasonable explanation.
Can you use a tool to watch what's happening? A debugger, protocol analyzer or trace listener for example.
Be wary of Not Invented Here syndrome.
Can you adapt something that you already have?
Read the documentation properly. Read it again.
Can you build a simulator to help reproduce the problem conditions?
Imagine you had unlimitted time, budget, memory and compute power. What would you do?
Don't trust a bug report until you've seen the problem with your own eyes.
Solve the easiest possible problem in the dumbest possible way.
Write a test for it.
Is there a better name for this thing?
Can we move work between query time (when we need the answer) and ingest time (when we see the data that eventually informs the answer)?
Is it easier in a relational data store? A KV Store? A column store? A document store? A graph store?
Can performance be improved by batching many small updates?
Can clarity be improved by transforming a single update to more smaller updates?
Can we more profitably apply a functional or declarative or imperative paradigm to the existing design?
Can we profitably apply a change from synchronous to asynchronous, or vice versa?
Can we profitably apply an inversion of control, moving logic between many individual call sites, a static central definition, and a reflectively defined description of the work to be done?
Is it faster with highly mutable or easier with completely immutable data structures?
Is it easier on the client side or the server side?
List the transitive closure of fields in a data model. Regroup them to make the most sense for your application. Do you have the same data model?
Is it better to estimate it quickly or compute it slowly?
What semantics do you need? Should it be ordered? Transactional? Blocking?
Can you do it with a regex? Do you need to bite the bullet and make a real parser? Can you avoid parsing by using a standardized format? (A few to get you started: s-expressions/XML/protobuf/JSON/yaml/msgpack/capn/avro/edn.)
What is the schema for this data? Is the schema holding you back?
Draw a state diagram according to the spec.
Draw a state diagram according to the data.
Draw a data flow ( )
Draw a timeline ( )
How would you do it in Haskell? C? Javascript?
Instead of doing something, emit an object.
Instead of emitting an object, do something.
Store all of it.
Truncate the old stuff.
Write the API you wish existed.
Make an ugly version where all the things work.
Make a gorgeous version that doesn't do anything.
Can you codegen the boilerplate?
Enumerate all the cases.
What happens if you do it all offline / precompute everything? What happens if you recompute every time? Can you cache it?
Can you build an audit log?
Think like a tree: ignore the book-keeping details and find the cleanest representation.
Think like a stack: zoom in to the book-keeping details and ignore the structure.
Replace your implementation with an implementation that computes how much work the real implementation does for that problem.
What is the steady state?
"""

print(random.choice(strategies.split('\n')))
