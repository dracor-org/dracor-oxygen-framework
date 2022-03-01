<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output encoding="UTF-8" indent="yes"/>
    
    <!-- 
        Populate particDesc based on @who attributes on <sp> elements
        Author: Ingo Börner (ingo.boerner@uni-potsdam.de)
    -->
    
    <!-- 
        Fallback "Identity Transform":
        If no other rule is in place, keep everything as is:
    -->
    
    <xsl:template match="@*|*|processing-instruction()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- root -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:particDesc">
        <!-- get all @who attribute values -->
        <xsl:variable name="characters">
            <xsl:value-of select="distinct-values(ancestor::tei:TEI//tei:sp/@who/string())"/>
        </xsl:variable>
        <particDesc xmlns="http://www.tei-c.org/ns/1.0">
            <listPerson>
                <xsl:for-each select="tokenize($characters,' ')">
                    <person xml:id="{substring-after(.,'#')}" sex="">
                        <name>
                            <xsl:comment>Add character label</xsl:comment>
                        </name>
                    </person>
                </xsl:for-each>
            </listPerson>
        </particDesc>
    </xsl:template>
    
</xsl:stylesheet>