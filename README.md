#  Citation cards

## ToDo
### Models
- citation
    - text, String
    - author, String
    - source, String
    - updatedAt, Date
    - isFavourite, Boolean
- tag
    - tag, String
    - color, String // using something like 'blue' or '#2020AA'; are we use only limited colors, or can provide palette for user
- citations_tags
    - citationId
    - tagId
        - unique key for citationId_tagId

### Three main screens from menu
- Citations list
    - Top bar with 'filter' and 'create' buttons on the right corner
        - filter - by tags and sorting
        - create - redirect to the screen with static cells for all needed to create a new citation
            - think, how to create a new tag or use existed
        - do we need the 'edit' button?
    - List of all citations, sorted be recently modified
        - on the top display one of favourites
        - by click on item copy the whole meaning data for share it by paste anywhere
- Favourites
    - the same like main, but only for marked
- Settings
    - switcher, is need to display on the top of main screen the one favourite citation, by default - true
    - choosing the tags from which the citations will display on the widgets, by default - all
    - light/dark/automatic mode
    - language
    - about info

- Bottom bar with buttons for these screens

Settings will be stored in UserDefaults.standard.settings

## Widgets
