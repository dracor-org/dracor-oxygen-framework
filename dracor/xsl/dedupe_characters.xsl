<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <xsl:template match="@*|*|processing-instruction()|comment()|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|*|processing-instruction()|comment()|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:person[@sameAs]">
        <xsl:comment>Something needs to be done here</xsl:comment>
    </xsl:template>
    
    <xsl:template match="tei:sp">
        <xsl:variable name="character_id" select="substring-after(@who,'#')"/>
        <!-- <xsl:value-of select="$character_id"/> -->
        <!-- Get the person element -->
        <xsl:choose>
            
            <!-- Change the who attribute if there is an person element with a sameAs attribute that indicates this is a doublette -->
            <xsl:when test="./ancestor::tei:TEI//tei:person[@xml:id eq $character_id][@sameAs]">
                <xsl:comment>This was changed:</xsl:comment>
                <xsl:copy>
                    <xsl:attribute name="who" select="./ancestor::tei:TEI//tei:person[@xml:id eq $character_id]/@sameAs"/>
                    <!-- keep arbitraty attributes -->
                    <xsl:copy-of select="@*[./name() !='who']"/>
                    <xsl:copy-of select="*"/>
                </xsl:copy>
               
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>