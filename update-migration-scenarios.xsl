<?xml version="1.0" encoding="UTF-8"?>
<!--
  Rewrite the "Schema migration ###: …" transformation scenarios inside
  dracor/dracor.framework based on the migration stylesheets found in a
  given directory. Existing scenarios with that name prefix are dropped;
  fresh ones are generated in numerical filename order.

  Invocation (see ./build):
    saxon -s:dracor/dracor.framework \
          -xsl:bin/update-migration-scenarios.xsl \
          migrations-dir=file:///absolute/path/to/dracor/xsl/migrations/

  The scenario name is composed of the numeric prefix of the migration
  filename (e.g. "003" from "003-xml-lang.xsl") and the first non-empty
  line of the first XML comment in the stylesheet.
-->
<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs">

  <!-- Absolute file:// URI of the directory holding the migration
       stylesheets. Trailing slash required. -->
  <xsl:param name="migrations-dir" as="xs:string" required="yes"/>

  <!-- Reference embedded in the framework file, resolved by Oxygen at
       run time via its ${framework} macro. -->
  <xsl:param name="migrations-ref" as="xs:string"
             select="'${framework}/xsl/migrations/'"/>

  <xsl:output method="xml" indent="no" omit-xml-declaration="no"/>
  <xsl:preserve-space elements="*"/>

  <xsl:variable name="prefix" as="xs:string" select="'Schema migration '"/>

  <xsl:variable name="NL" as="xs:string" select="'&#10;'"/>
  <xsl:variable name="T6" as="xs:string"
                select="'&#9;&#9;&#9;&#9;&#9;&#9;'"/>
  <xsl:variable name="T7" as="xs:string" select="concat($T6, '&#9;')"/>
  <xsl:variable name="T8" as="xs:string" select="concat($T7, '&#9;')"/>
  <xsl:variable name="T9" as="xs:string" select="concat($T8, '&#9;')"/>
  <xsl:variable name="T10" as="xs:string" select="concat($T9, '&#9;')"/>
  <xsl:variable name="T11" as="xs:string" select="concat($T10, '&#9;')"/>
  <xsl:variable name="T12" as="xs:string" select="concat($T11, '&#9;')"/>
  <xsl:variable name="T13" as="xs:string" select="concat($T12, '&#9;')"/>

  <xsl:variable name="migrations" as="xs:string*">
    <xsl:perform-sort
      select="uri-collection(
                concat($migrations-dir, '?select=*.xsl;recurse=no'))">
      <xsl:sort select="."/>
    </xsl:perform-sort>
  </xsl:variable>

  <!-- Identity default: copy nodes as-is, preserving whitespace. -->
  <xsl:mode on-no-match="shallow-copy"/>

  <!-- Drop any existing "Schema migration …" scenarios plus their
       surrounding whitespace, and also drop the whitespace-only text
       node that used to indent </scenario-array>. Then append fresh
       scenarios and emit a canonical closing indent. This keeps the
       transform idempotent. -->
  <xsl:template match="scenario-array">
    <xsl:copy>
      <xsl:apply-templates select="node()[
        not(self::scenario
            and starts-with(field[@name='name']/String, $prefix))
        and not(self::text()
                and normalize-space(.) = ''
                and (preceding-sibling::*[1]
                       [self::scenario
                        and starts-with(field[@name='name']/String,
                                        $prefix)]
                     or following-sibling::*[1]
                          [self::scenario
                           and starts-with(field[@name='name']/String,
                                           $prefix)]
                     or not(following-sibling::node())))]"/>
      <xsl:for-each select="$migrations">
        <xsl:call-template name="migration-scenario">
          <xsl:with-param name="uri" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:value-of select="concat($NL, $T6)"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="migration-scenario">
    <xsl:param name="uri" as="xs:string"/>

    <xsl:variable name="filename" as="xs:string"
                  select="tokenize($uri, '/')[last()]"/>

    <xsl:variable name="number" as="xs:string">
      <xsl:analyze-string select="$filename" regex="^(\d+)">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:variable name="description" as="xs:string">
      <xsl:variable name="comment" as="comment()?"
                    select="doc($uri)/comment()[1]"/>
      <xsl:variable name="lines" as="xs:string*"
                    select="for $l in tokenize(string($comment), '\n')
                            return normalize-space($l)"/>
      <xsl:value-of select="($lines[. != ''], $filename)[1]"/>
    </xsl:variable>

    <xsl:variable name="name" as="xs:string"
                  select="concat($prefix, $number, ': ', $description)"/>

    <xsl:value-of select="concat($NL, $T7)"/>
    <scenario>
      <xsl:call-template name="saxon-advanced-options"/>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'name'"/>
        <xsl:with-param name="v" select="$name"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'baseURL'"/>
        <xsl:with-param name="v" select="''"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'footerURL'"/>
        <xsl:with-param name="v" select="''"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'fOPMethod'"/>
        <xsl:with-param name="v" select="'pdf'"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'fOProcessorName'"/>
        <xsl:with-param name="v" select="'Apache FOP'"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'headerURL'"/>
        <xsl:with-param name="v" select="''"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'inputXSLURL'"/>
        <xsl:with-param name="v"
                        select="concat($migrations-ref, $filename)"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'inputXMLURL'"/>
        <xsl:with-param name="v" select="'${currentFileURL}'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'defaultScenario'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'isFOPPerforming'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'type'"/>
        <xsl:with-param name="v" select="'XSL'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'saveAs'"/>
        <xsl:with-param name="v" select="'true'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'openInBrowser'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'outputResource'"/>
        <xsl:with-param name="v" select="'${cf}'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'openOtherLocationInBrowser'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-null">
        <xsl:with-param name="n" select="'locationToOpenInBrowserURL'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'openInEditor'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'showInHTMLPane'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'showInXMLPane'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'showInSVGPane'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'showInResultSetPane'"/>
        <xsl:with-param name="v" select="'false'"/>
      </xsl:call-template>
      <xsl:call-template name="field-bool">
        <xsl:with-param name="n" select="'useXSLTInput'"/>
        <xsl:with-param name="v" select="'true'"/>
      </xsl:call-template>
      <xsl:value-of select="concat($NL, $T8)"/>
      <field name="xsltParams">
        <xsl:value-of select="concat($NL, $T9)"/>
        <list/>
        <xsl:value-of select="concat($NL, $T8)"/>
      </field>
      <xsl:value-of select="concat($NL, $T8)"/>
      <field name="cascadingStylesheets">
        <xsl:value-of select="concat($NL, $T9)"/>
        <String-array/>
        <xsl:value-of select="concat($NL, $T8)"/>
      </field>
      <xsl:call-template name="field-string">
        <xsl:with-param name="n" select="'xslTransformer'"/>
        <xsl:with-param name="v" select="'Saxon-PE'"/>
      </xsl:call-template>
      <xsl:value-of select="concat($NL, $T8)"/>
      <field name="extensionURLs">
        <xsl:value-of select="concat($NL, $T9)"/>
        <String-array/>
        <xsl:value-of select="concat($NL, $T8)"/>
      </field>
      <xsl:value-of select="concat($NL, $T7)"/>
    </scenario>
  </xsl:template>

  <xsl:template name="field-string">
    <xsl:param name="n" as="xs:string"/>
    <xsl:param name="v" as="xs:string"/>
    <xsl:value-of select="concat($NL, $T8)"/>
    <field name="{$n}">
      <xsl:value-of select="concat($NL, $T9)"/>
      <xsl:choose>
        <xsl:when test="$v = ''">
          <String/>
        </xsl:when>
        <xsl:otherwise>
          <String>
            <xsl:value-of select="$v"/>
          </String>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat($NL, $T8)"/>
    </field>
  </xsl:template>

  <xsl:template name="field-bool">
    <xsl:param name="n" as="xs:string"/>
    <xsl:param name="v" as="xs:string"/>
    <xsl:value-of select="concat($NL, $T8)"/>
    <field name="{$n}">
      <xsl:value-of select="concat($NL, $T9)"/>
      <Boolean>
        <xsl:value-of select="$v"/>
      </Boolean>
      <xsl:value-of select="concat($NL, $T8)"/>
    </field>
  </xsl:template>

  <xsl:template name="field-null">
    <xsl:param name="n" as="xs:string"/>
    <xsl:value-of select="concat($NL, $T8)"/>
    <field name="{$n}">
      <xsl:value-of select="concat($NL, $T9)"/>
      <null/>
      <xsl:value-of select="concat($NL, $T8)"/>
    </field>
  </xsl:template>

  <!-- Emit the scenario's advancedOptionsMap with Saxon-PE settings.
       Notably expandAttributeDefaults=false, which disables the RelaxNG
       DTD-compatibility a:defaultValue expansion that Oxygen otherwise
       injects into the input tree before Saxon sees it (and which
       would leak schema-declared attribute defaults like full="yes",
       status="draft", part="N" into the migration output). All other
       fields carry Oxygen's usual scenario defaults. -->
  <xsl:template name="saxon-advanced-options">
    <xsl:value-of select="concat($NL, $T8)"/>
    <field name="advancedOptionsMap">
      <xsl:value-of select="concat($NL, $T9)"/>
      <serializableOrderedMap>
        <xsl:value-of select="concat($NL, $T10)"/>
        <entry>
          <xsl:value-of select="concat($NL, $T11)"/>
          <String>Saxon-PE</String>
          <xsl:value-of select="concat($NL, $T11)"/>
          <xsltSaxonBAdvancedOptions>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'allowCallsOnExtensionFunctions'"/>
              <xsl:with-param name="v" select="'true'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'registerSaxonCEExtensions'"/>
              <xsl:with-param name="v" select="'true'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'enableAssertions'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'allowSyntaxExtensions'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'showVersionWarnings'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'dtdSourceValidation'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'dtdSourceValidationRecover'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'lineNumbering'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-null">
              <xsl:with-param name="n" select="'initialMode'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-null">
              <xsl:with-param name="n" select="'initialTemplate'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'traceXPathExpression'"/>
              <xsl:with-param name="v" select="'true'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'expandAttributeDefaults'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-string">
              <xsl:with-param name="n" select="'stripWS'"/>
              <xsl:with-param name="v" select="'saxon.strip.ws.none'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'optimizationEnabled'"/>
              <xsl:with-param name="v" select="'true'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'useConfigFile'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-null">
              <xsl:with-param name="n" select="'configSystemID'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-string">
              <xsl:with-param name="n" select="'initializer'"/>
              <xsl:with-param name="v" select="''"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-null">
              <xsl:with-param name="n" select="'profilingOutputFile'"/>
            </xsl:call-template>
            <xsl:call-template name="saxon-opt-bool">
              <xsl:with-param name="n" select="'isProfilingEnabled'"/>
              <xsl:with-param name="v" select="'false'"/>
            </xsl:call-template>
            <xsl:value-of select="concat($NL, $T11)"/>
          </xsltSaxonBAdvancedOptions>
          <xsl:value-of select="concat($NL, $T10)"/>
        </entry>
        <xsl:value-of select="concat($NL, $T9)"/>
      </serializableOrderedMap>
      <xsl:value-of select="concat($NL, $T8)"/>
    </field>
  </xsl:template>

  <xsl:template name="saxon-opt-bool">
    <xsl:param name="n" as="xs:string"/>
    <xsl:param name="v" as="xs:string"/>
    <xsl:value-of select="concat($NL, $T12)"/>
    <field name="{$n}">
      <xsl:value-of select="concat($NL, $T13)"/>
      <Boolean>
        <xsl:value-of select="$v"/>
      </Boolean>
      <xsl:value-of select="concat($NL, $T12)"/>
    </field>
  </xsl:template>

  <xsl:template name="saxon-opt-string">
    <xsl:param name="n" as="xs:string"/>
    <xsl:param name="v" as="xs:string"/>
    <xsl:value-of select="concat($NL, $T12)"/>
    <field name="{$n}">
      <xsl:value-of select="concat($NL, $T13)"/>
      <xsl:choose>
        <xsl:when test="$v = ''">
          <String/>
        </xsl:when>
        <xsl:otherwise>
          <String>
            <xsl:value-of select="$v"/>
          </String>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat($NL, $T12)"/>
    </field>
  </xsl:template>

  <xsl:template name="saxon-opt-null">
    <xsl:param name="n" as="xs:string"/>
    <xsl:value-of select="concat($NL, $T12)"/>
    <field name="{$n}">
      <xsl:value-of select="concat($NL, $T13)"/>
      <null/>
      <xsl:value-of select="concat($NL, $T12)"/>
    </field>
  </xsl:template>

</xsl:stylesheet>
