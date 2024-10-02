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
    - Converting grouped locations to user readable fromat. (eg: 23.434, 74.3234 as "Near the college gate")


### Bug fixes done. 
    - Synchronization error.
        - Earlier users who opened the app at different times whould update the location data at different times. This caused the location data to be out of sync. ie. even if the users are in the same vehicle, the location data would show they are at different locations. 
        ~ fix -> set the function to update every 5th second from epoch time. This ensures that the location data is updated at the same time for all users.
    