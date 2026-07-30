# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository is an [Oxygen XML Editor](https://www.oxygenxml.com/) framework (add-on) for editing DraCor TEI files. It is not a codebase in the traditional sense — there is no build system, tests, package manager, or lint tooling. Distribution happens via GitHub Releases; users install by pointing Oxygen at `updateSite.xml`.

## Repository layout

- [dracor/](dracor/) — the framework itself; this whole directory is what gets zipped and shipped
  - [dracor.framework](dracor/dracor.framework) — Oxygen's serialized configuration (the "central nervous system"). Defines document type associations, CSS layer names, XSLT transformation scenarios, Schematron/schema associations, and toolbar/menu actions. Edited via the Oxygen UI, not by hand.
  - [dracor/schemas/schema.rng](dracor/schemas/schema.rng) — RelaxNG schema generated from the DraCor ODD (currently DraCor 1.5.1 / TEI P5 4.11.0). Do not hand-edit; regenerate from the upstream ODD when bumping schema versions.
  - [dracor/catalog.xml](dracor/catalog.xml) — XML catalog rewriting `https://dracor.org/` URIs to the local `schemas/` directory so `<?xml-model href="https://dracor.org/schema.rng"?>` resolves locally.
  - [dracor/css/](dracor/css/) — multiple author-mode stylesheets. Each is registered as a named layer in `dracor.framework` (e.g. "Editing view", "Linking", "Structure", "NeoLatDraCor …") and toggled by the user in Oxygen's Author view.
  - [dracor/xsl/](dracor/xsl/) — transformation scenarios referenced from `dracor.framework` (e.g. `generate_particDesc_from_who.xsl`, `dedupe_characters.xsl`, `camena-tei_2_dracor-simple-tei.xsl`).
  - [dracor/templates/](dracor/templates/) — "New file" templates offered in Oxygen; the DraCor drama template sets `type="dracor"` on the root `<TEI>`.
- [updateSite.xml](updateSite.xml) — Oxygen add-on descriptor. The `<xt:location>` URL and `<xt:version>` must be bumped in lock-step on each release.
- [.github/workflows/release.yml](.github/workflows/release.yml) — on GitHub Release publish, zips `dracor/` as `dracor-oxygen-framework-<tag>.zip` and uploads it as a release asset; separately publishes `updateSite.xml` to GitHub Pages so users can subscribe to updates.

## Document type detection

`dracor.framework` associates DraCor with files matching any of these rules (see also [README.md](README.md)):

- root `<TEI>` with `@type="dracor"`
- file path matches `*/*dracor/tei/*` (e.g. `engdracor/tei/foo.xml`)
- root element is `<dracorCorpus>` (for `corpus.xml` catalog files)

When editing detection rules, update all three places consistently: the framework file, the README, and any templates.

## Release process

1. Update `<xt:version>` and the download URL tag in [updateSite.xml](updateSite.xml).
2. Commit with a version-bump message (see `git log` — recent style: bare version like `1.1.1`).
3. Tag and publish a GitHub Release with the matching tag; the workflow builds the zip and updates Pages.

## Working conventions

- Don't hand-edit `dracor.framework` unless the change is small and structurally obvious — Oxygen owns this file's format. Prefer opening the framework in Oxygen and using its UI.
- Prefer editing existing CSS layers over adding new ones; each new layer must also be registered in `dracor.framework`.
- For local development, users add the repo root as an "Additional framework directory" in Oxygen (see [README.md](README.md)); no build step is needed — changes to CSS/XSL/schema are picked up on reload.
