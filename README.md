# 🛠️ GitHub Project Bulk Import via CLI + CSV

This script automates the creation of GitHub Project items from a structured CSV file. It uses the [GitHub CLI](https://cli.github.com/) (`gh`) to create and populate project items dynamically based on fields like `Feature`, `Role`, and `Estimate`.

---

## 📋 CSV Format (Just an example)

The CSV file should follow this format:

```csv
Module,Feature,Task,Role,Hours
Auth,Login,Design login UI layout,Frontend,4
Auth,Login,Implement login form & validation,Frontend,4
Auth,Login,Develop login API endpoint,Backend,6
Auth,Login,Integrate Keycloak authentication,Backend,6
````

* **Module**: Logical grouping (optional for now)
* **Feature**: Populates the `Feature` field in the project
* **Task**: Title of the project item
* **Role**: Populates the `Role` field
* **Hours**: Populates the `Estimate` field as a number

---

## 🚀 Usage

### 1. Prerequisites

* Install [GitHub CLI](https://cli.github.com/)
* Authenticate using `gh auth login`
* Make sure you have access to the GitHub project and it’s a **Project (Beta)** (aka Projects v2)

### 2. Run the Script

Make the script executable and run it:

```bash
chmod +x csv2ghproj.sh
./csv2ghproj.sh <CSV_FILE_PATH> <OWNER> <PROJECT_ID>
```

The script:

* Dynamically fetches field IDs from the GitHub project
* Creates draft items with titles from your CSV
* Populates `Feature`, `Role`, and `Estimate` fields for each item

---

## 🧩 Extending

You can easily extend the script to support:

* Setting **Status** (single-select field)
* Assigning reviewers
* Linking pull requests or milestones
* Parsing additional CSV columns like `Start Date` or `Epic`

---

## 🛡️ License

MIT License. Do as you wish.

---

## 🙌 Contributions

Pull requests welcome! If you improve the script or make it more robust, feel free to open a PR.

