# where_is_my_bus

### What does this do?
 - Collects locations from different users. Processes the data and displays the probable location of the vehicle.
    - The location data is only sent to the server if the user is in a moving vehicle.
        - Detecection of moving vehicle is done by checking the speed of the user.
    - The data processing is done on device. 
        - Only an userId is displayed when location data is passed around. Ensuring privacy.

### Challenges
- Grouping algorithm to group the locations of different users.
- Algorithm to check if the user location is within the college premises.
    - Uses ray casting algorithm to check.
- Converting grouped locations to user readable fromat. (eg: 23.434, 74.3234 as "Near the college gate")


### Bug fixes done. 
- Synchronization error.
    - Earlier users who opened the app at different times whould update the location data at different times. This caused the location data to be out of sync. ie. even if the users are in the same vehicle, the location data would show they are at different locations. 
    - fix -> set the function to update every 5th second from epoch time. This ensures that the location data is updated at the same time for all users.
- Android 14 restrictions
    - spent a ton of time figuring out how to set up loacation permissions for andriod 14
  
### Known issues 
- The location data is not accurate. 
    - The location data is not accurate. Gps may give positive speed even when the user is stationary. This causes the location data to be updated even when the user is stationary.
     == Solved == 
        Set location.speedAccuracy != 1.5. 1.5 is the default value if a speedAccuracy can't be determined. The logic here is that if it good enough to find the speedAccuracy then the speed must be fairly accurate.
- Sync issue in Database
    - Due to network issues the data may be older. This usually occurs in multiples of UPDATE_INTERVAL. ie. 2 seconds(currently).
    == SOLUTION ==
        ~ Need not implement, as we are migrating to own server from supabase. ~ 
        while grouping take time into consideration as well
            IF diff in time between two points is less than K sec 
                THEN while grouping the points be more lenient. 
                    for example if the MIN_DISTANCE_POINTS should be less than 10 normally. But 
                    if there are points that 2s apart check for 10 + 2 * AVG_SPEED. 
- The network might upload out of order for the same user.
    - So only update if newer data's datetime is newer than present one.


### Things to improve  
- Implement semaphore based location tracking.
    - Should have N nubmer of semaphors. N = # of Buses
        - Keep a table of who has access to semaphore.
            - If a user with semaphore access uploads data, his location is broadcast.
            - Semaphore uses a timeout based release mechanism. 
                - If user hasn't uploaded in while the semaphore is released and someone else can capture it and broadcast their location.
                    - Show a golden glow for users who are selected.
        - How to give access? 
            - Go through semaphore table
                - IF empty:
                    just assign current user a semaphore.
                - ELSE IF atleast one row vacant:
                    check the distance betweeen all the users in the table and current user. 
                        IF distance >= MIN_DIST_TO_BE_DISTINCT
                            allocate a semaphore to that user.
                - ELSE if no seat vacant:
                    discard request
- When list is pulled down do reload of location data.
