# Lemon Todo

* Add quadrant processing
* Add colour detection? (not really necessary at this point)
* Add the ability to detect the full insect
    * Approach 1: Detect all the parts. If they're all visible and positioned correctly to each other, bingo.
    * Approach 2: Machine learning babyyyyy

Math approach 1: perpendicular lines

1. Draw the approximate linear line that goes (mostly) through abdomen, thorax and head
2. Make sure the abdomen, thorax and head appear in that order
3. Draw the approximate linear line that goes (mostly) through left wing, thorax, right wing
4. Make sure the wings and thorax appear in that order
5. Check if the lines are somewhat close to being perpendicular
6. Check all points are positioned correctly relative to each other (so if a line is drawn from green to red, abdomen should be to the left of it and head should be to the right of it)
7. If everything passes, it's complete (I could also calculate a insect-confidence score based on how close all these variables are)

Math approach 2: crosses

1. Develop some sort of algorithm that detects if all points are in some sort of approximate cross shape

Machine learning model approach:

1. Take lots of pictures of the insect in full
2. Take lots of pictures of the insect broken apart (and don't annotate them)
3. Train
4. Cross my fingers