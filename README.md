# Air-Transit-Model
What tradeoffs did you make in choosing your representation? What else did you try that didn’t work as well?
- One of the tradeoffs that we made in choosing our representation was deciding which things we wanted to enforce as part of our design and signals and which parts we wanted to enforce with predicates that we could turn off or test with. One thing in particular was enforcing that there were no crashes artificially rather than naturally with like a concurrent registration system. This is mainly a way to limit the scope of our project and also to just filter out cases that are less interesting but which could still happen like (two planes simply drives onto a runway at the same time and crashes). By doing so however we ended up having to use other predicates to catch some of the more interesting crash cases like a phane running out of fuel etc...

What assumptions did you make about scope? What are the limits of your model?
- We were mainly interested in the logistics of Air Transit and ensuring "safety" under these conditions, so we wanted a model that would be complex enough to capture the entire process of the Air Transit System but not be too focused on the granularity. Thus our model is limited to modeling the planes as they fly between airports and as they leave and enter the runway. 

Did your goals change at all from your proposal? Did you realize anything you planned was unrealistic, or that anything you thought was unrealistic was doable?
- At the very beginning of our project our scale was a lot smaller, with the goal being just to model a single runway in a single airport where planes fly into a black box and come back and our goals was just to model crashing. But as we went on, we discovered that we were actually able to model more complex and moving parts than we initially thought and our model expanded from there. That said, due to the limitations of time/scope we still had to artificially constrain our model and were only able to identify some problems rather than model a solution, which was a reach goal. 

How should we understand an instance of your model and what your custom visualization shows?
-  The custom visualization has a variable called see_specific_state where you can look at the different time states of temporal forge and it shows where each of the planes are in an Airport and where they are flying to at each state. You can specify a specific number to see a specific state or if you set it to -1 it will just show every state! 

