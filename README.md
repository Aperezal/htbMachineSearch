# HTB Machine Finder (htbmachine-finder)

This Bash script is a terminal sidekick for Hack The Box. 
Quickly look up any HTB machine's IP, difficulty, OS, and even the YouTube writeup link, all without leaving the shell!

## Features

* **Quick Machine Search:** Find all properties of a machine using its **name** (`-m`).
* **IP Lookup:** Reverse-lookup the machine **name** from a known **IP address** (`-i`).
* **Filter by Difficulty:** List all machines associated with a specific **difficulty** (`-d`).
* **Filter by OS:** List all machines running a specific **Operating System** (Linux/Windows) (`-o`).
* **Combined Filter:** Search for machines based on both **OS and Difficulty** (`-o` and `-d`).
* **YouTube Writeup Link:** Instantly retrieve the **YouTube resolution link** for a given machine (`-y`).
* **Data Management:** Automatically **download and update** the required machine data file (`-u`).
* **Colored Output:** Uses custom color definitions for clean, readable output in the terminal.

## Prerequisites

* A Linux environment (tested with Bash).
* The following tools installed:
    * `curl`: For downloading the data file.
    * `js-beautify`: For formatting the downloaded JavaScript file.
    * `sponge`: (Often part of `moreutils`) For modifying the file in place.
    * `md5sum`: For checking file integrity and updates.
    * `awk`, `grep`, `tr`, `sed`: Standard Linux utilities.
    * `bat`: (Optional, but used in the script for formatted output) A cat clone with syntax highlighting.

## Usage

Run the script with the `-h` flag to view the help panel:

```bash
./htbmachine-finder.sh -h
```


| Flag | Argument | Description |
| :--- | :--- | :--- |
| **`-u`** | N/A | **Update** the necessary `bundle.js` data file. **(Run this first!)** |
| **`-m`** | `[Machine Name]` | Search for a machine by its **name**. |
| **`-i`** | `[IP Address]` | Search for a machine by its **IP address**. |
| **`-d`** | `[Difficulty]` | Search for machines by **difficulty** (e.g., `Easy`, `Medium`, `Hard`). |
| **`-o`** | `[OS]` | Search for machines by **Operating System** (e.g., `Linux`, `Windows`). |
| **`-y`** | `[Machine Name]` | Get the **YouTube resolution link** for a machine. |
| **`-h`** | N/A | Display the **help panel**. |


1.  **Update the data file:**
    ```bash
    ./htbmachines.sh -u
    ```
2.  **Search for machine properties by name (e.g., 'Legacy'):**
    ```bash
    ./htbmachines.sh -m Legacy
    ```    
3.  **Find the name of the machine with IP 10.10.10.4:**
    ```bash
    ./htbmachines.sh -i 10.10.10.4
    ```
4.  **List all machines with 'Hard' difficulty:**
    ```bash
    ./htbmachines.sh -d Hard
    ```
5.  **List all Windows machines:**
    ```bash
    ./htbmachines.sh -o Windows
    ```
6.  **List all Easy Linux machines (Combined Search):**
    ```bash
    ./htbmachines.sh -d Easy -o Linux
    ```






