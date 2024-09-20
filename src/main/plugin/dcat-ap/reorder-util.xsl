<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:variable name="dcatSchema" select="document('./schema/dcat.xsd')"/>

  <xsl:template name="dcat-reorder-elements" match="rdf:RDF">
    <xsl:param name="rdfRoot" as="node()"/>
    <xsl:apply-templates mode="reorder" select="$rdfRoot//rdf:RDF"/>
  </xsl:template>

  <xsl:template mode="reorder" match="dcat:Catalog|dcat:CatalogRecord|dcat:Dataset|dcat:Distribution|dcat:DataService">
    <xsl:variable name="typeName" select="concat(local-name(), '_type')"/>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@rdf:about"/>
      <xsl:variable name="catalog" select="."/>
      <xsl:for-each select="$dcatSchema//xs:complexType[@name = $typeName]//xs:extension[@base = 'rdf:Resource']//xs:element">
        <xsl:variable name="elementName">
          <xsl:call-template name="to-element-name">
            <xsl:with-param name="xsElement" select="."/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:apply-templates mode="reorder" select="$catalog/*[name() = $elementName]"/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="reorder" match="rdf:RDF">
    <xsl:copy copy-namespaces="yes">
      <xsl:apply-templates mode="reorder" select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="reorder" match="*|@*|text()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates mode="reorder" select="*|@*|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="to-element-name">
    <xsl:param name="xsElement" as="node()"/>
    <xsl:choose>
      <xsl:when test="normalize-space($xsElement/@name) != ''">
        <xsl:value-of select="concat('dcat:', normalize-space($xsElement/@name))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($xsElement/@ref)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
