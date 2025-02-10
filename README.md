#  Citation cards
## Overview
iOS application for store a great, smart, motivatation citations and coping cards.
Use the widgets to always have the one on your phone screen.
![Home screen](https://pm-lab.s3.eu-central-1.amazonaws.com/CitationCards/HomeScreen.png "Home screen")
![Widget](https://pm-lab.s3.eu-central-1.amazonaws.com/CitationCards/Widget.png "Widget")

## Description
### Models
- citation
    - text, String
    - author, String?
    - source, String?
    - createdAt, Date
    - updatedAt, Date
    - isFavourite, Boolean
    - archivedAt, Date? - if not NULL, it's archived
- tag
    - tag, String
    - color, String // using something like 'blue' or '#2020AA'; are we use only limited colors, or can provide palette for user

### Three main screens from menu
- Citations list
    - Top bar with 'sort' and 'create' buttons on the right corner
        - create - redirect to the screen with static cells for all needed to create a new citation
            - think, how to create a new tag or use existed
            - try to get simplify the adding of new citation (field in the bottom of screen; after click on 'Save' redirect to "create screen")
    - Yet one toolbar with:
        - 'Only favourites' button
    - List of all citations, sorted be recently modified
        - by click on item copy the whole meaning data for share it by paste anywhere; display faded message "Copied in clipboard!"
        - do not delete citations immediately - archive it
- Tags
    - Top bar with:
        - 'Edit', on tap shows the alarm screen with list of tags
            - on tap the delete icon it asking should remove only tag and save the citations with it or remove tag with citations
    - Under top bar - field for creating a new tag; + button for choosing one of 10 colors
    - List with all existed tags
        - on tap on the tag, select it and display all citations with this tag
        - long tap - edit tag and choose other color
- More
    - access to archived citations - another screen, with rightward swipe to recover, and leftward - to delete
    - export citations: txt, csv
    - widget settings
        - time interval for update
        - choosing the tags from which the citations will display on the widgets, by default - all
        - only favourites
    - about info

- Bottom bar with buttons for these screens

Settings stored in UserDefaults.standard.settings
