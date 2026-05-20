# Google Scripts

A collection of Google Apps Scripts for automating and enhancing Google Workspace documents.

## Purpose

This repository contains custom Google Apps Scripts designed to extend and automate functionality in Google Docs. These scripts are built to solve specific automation challenges and improve document workflows.

## Scripts

### Table of Contents Generator (`tableofcontents`)

**Purpose:** Automatically generate and refresh a table of contents in Google Docs with support for hierarchical tab navigation.

**Features:**
- Creates a clickable table of contents with direct links to each document tab
- Supports nested tab hierarchies with visual indentation
- Automatically finds and populates a designated TOC tab
- Refreshes on demand via custom menu command
- Handles both "Table of Contents" and "TOC" tab name variants (case-insensitive)

**Usage:**
1. In your Google Doc, create a new tab and name it either "Table of Contents" or "TOC"
2. Open the Apps Script editor (Extensions → Apps Script)
3. Paste the `tableofcontents` script code
4. Save and run the `onOpen()` function
5. Reload your document
6. Use the **Nx TOC** menu → **Refresh Table of Contents** to generate or update the TOC

**How It Works:**
- Creates a bulleted list of all tabs with direct links
- Applies proper indentation for nested tab structure
- Displays document title as a heading above the TOC
- Separates TOC from document body with a horizontal rule

## Getting Started

1. Copy a script from this repository
2. Open your target Google Doc
3. Go to **Extensions → Apps Script**
4. Paste the script code into the editor
5. Save and authorize the script
6. Reload your Google Doc to activate the custom menu

## Adding New Scripts

To add a new script to this collection:
1. Create a new file with a descriptive name
2. Add the Google Apps Script code
3. Update this README with the script's purpose and usage instructions
4. Commit to this repository

## Requirements

- Google Docs document
- Google account with Apps Script access
- Appropriate permissions to modify the document

## Notes

- All scripts are designed to be pasted directly into Google Apps Script editors
- Scripts require explicit user authorization when first run
- Custom menus appear after script execution and document reload
