# Starshippers

How to build this iOS app:
- On a Mac, run the App Store app.
- In the Mac OS App Store app, do a search for Xcode (it’s free) and download and install it.
- Open Xcode, and select Open from the File menu.
- Browse to the Starshippers/Starshippers.xcodeproj file and open it.
- After the project is open, select a device from the iOS Simulator list at the top of the Xcode window (next to “Starshippers >”). For example, iPhone 6s.
- Press the Run button at the top left of the Xcode window.

Notes:
- I put tags on some of the commits showing how much time had passed since starting the project. For example, commit 30bbe6 (“2Hrs”) was the two-hour marker.
- I added a couple commits after 2:20 and 2:30 just because these things were quick once the main app was working (pulling API data and displaying it).

Next Steps:
- I added a “coming soon” image as a placeholder for where I wanted to do a programmatic Google image search for “Star Wars <starship_name>” (where starship_name is the name of the specific ship) and display the first resulting image.
- Adding price filtering and sorting should be very quick to do because they build on name search filtering (“2Hrs30Min” tag, commit 9ccda91).
- Get ALL starship results: I’m currently only showing the first page. To show the rest, I would get the additional pages from the API as the user scrolls to the end of the result list, or maybe preload all pages so filtering and sorting can be done completely client side.
- Show a scrollable list of pilot names on the starship detail screen.
- Add all remaining starship fields to the starship detail screen.
