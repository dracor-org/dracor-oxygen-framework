# DraCor Oxygen Framework

Framework for the Oxygen XML Editor providing support for editing TEI files for
the [DraCor project](https://dracor.org).

## Usage

This Framework can be added as an add-on to the Oxygen XML Editor as follows:

* Under "Options" > "Preferences" > "Add-ons" add the URL
  https://dracor-org.github.io/dracor-oxygen-framework/updateSite.xml to the
  *Add-on Update Site URLs*.
* "DraCor" should now appear among the installable add-ons under "Help" >
  "Install new add-ons"


## Development setup

If you want to add features to the framework or fix bugs, instead of using a
released version, you can add the add-on from a local working directory:

* Clone the repo.
* Open your Oxygen XML Editor and add the folder as a framework location:
  * English version: "Options" > "Preferences" > "Document Type Association" >
    "Locations" > "Additional framework directories" > "Add"
  * German version: "Optionen" > "Einstellungen" > "Dokumenttypen-Zuordnung" >
    "Orte" > "Zusätzliche Framework-Verzeichnisse" > "Hinzufügen"
* "DraCor" should show up as a framework, deactivate all others and activate it.
