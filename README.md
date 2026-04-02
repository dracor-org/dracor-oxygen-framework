# DraCor Oxygen Framework

Framework for the Oxygen XML Editor providing support for editing TEI files for
the [DraCor project](https://dracor.org).

## Usage

This framework can be added as an add-on to the Oxygen XML Editor as follows:

- Under "Options" > "Preferences" > "Add-ons" add the URL
  https://dracor-org.github.io/dracor-oxygen-framework/updateSite.xml to the
  _Add-on Update Site URLs_.
- "DraCor" should now appear among the installable add-ons under "Help" >
  "Install new add-ons"

Once installed, the framework detects DraCor TEI files and uses the DraCor
schema and customizations when one of the following conditions applies:

- the root TEI element has a `type` attribute with the value "dracor"
- the file path matches the pattern `*/*dracor/tei/*`, i.e. the file is located
  in a `tei` directory inside a directory with a name ending in "dracor" (e.g.
  "engdracor").
- the root element is `dracorCorpus` for corpus.xml files

## Development setup

If you want to add features to the framework or fix bugs, instead of using a
released version, you can add the add-on from a local working directory:

- Clone the repo.
- Open your Oxygen XML Editor and add the folder as a framework location:
  - English version: "Options" > "Preferences" > "Document Type Association" >
    "Locations" > "Additional framework directories" > "Add"
  - German version: "Optionen" > "Einstellungen" > "Dokumenttypen-Zuordnung" >
    "Orte" > "Zusätzliche Framework-Verzeichnisse" > "Hinzufügen"
- "DraCor" should show up as a framework, deactivate all others and activate it.
