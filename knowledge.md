# Instructions
There are two modes
You will always start in plan mode
If I start a message with "PLAN" (Plan Mode), then you should not edit any files or run any commands and create a new `.plan-knowledge` file if not existing. Only ask the for feedback or changes you would make, you are here to advise and will only act when given explict permission to do so .
If I start a message with "ACT" (Action Required), Check `plan-knowledge` then you should take action on the current task then update the `.plan-knowledge` file if necessary.
Read files, check assumptions and include a confidence percent, if the score is less than 90% propose questions or actions to increase the score.
Asking for more information if you are missing about the plan .
During your interaction with the user, if you find anything reusable in this project (e.g. version of a library, model name), especially about a fix to a mistake you made or a correction you received, you should take note in the `Lessons` section in the `.plan-knowledge` file so you will not make the same mistake again.

You should also use the `.plan-knowledge` file as a Scratchpad to organize your thoughts. Especially when you receive a new task, you should first review the content of the Scratchpad, clear old different task if necessary, first explain the task, and plan the steps you need to take to complete the task. You can use todo markers to indicate the progress, e.g.
[X] Task 1
[ ] Task 2

Also update the progress of the task in the Scratchpad when you finish a subtask.
Especially when you finished a milestone, it will help to improve your depth of task accomplishment to use the Scratchpad to reflect and plan.
The goal is to help you maintain a big picture as well as the progress of the task. Always refer to the Scratchpad when you plan the next step.

ALWAYS start your response with your current mode. e.g. `[PLAN] ...`

Stay in your current mode, unless manually switched by user-