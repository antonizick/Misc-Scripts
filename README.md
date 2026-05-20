# Google Scripts

Collection of Google Apps Scripts for automating Google Docs workflows.

## Scripts

### Table of Contents (`tableofcontents`)

Automatically generates a navigable table of contents for Google Documents using the tabs feature.

**What it does:**
- Adds a custom `Nx TOC` menu to Google Docs
- Finds a tab named `Table of Contents` or `TOC` and populates it with a hierarchical list of all document tabs
- Each entry is a clickable link that navigates directly to that tab
- Supports nested (child) tabs with proportional indentation
- Includes the document title as an underlined heading at the top

**How to use:**
1. Open the Google Doc in Google Apps Script editor (Extensions > Apps Script)
2. Paste the script content and deploy
3. Create a tab in the document named `Table of Contents` or `TOC`
4. Run `Nx TOC > Refresh Table of Contents` from the menu

## Adding New Scripts

Each script lives as a standalone file in this directory. Name the file after its function (no extension needed — these are Google Apps Script files, not local code).

## Installation

Scripts are copied into the Google Apps Script editor of the target document or add-on. They run in Google's sandbox and require appropriate OAuth scopes.
