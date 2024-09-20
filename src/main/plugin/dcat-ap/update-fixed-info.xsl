<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:spdx="http://spdx.org/rdf/terms#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:adms="http://www.w3.org/ns/adms#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:schema="http://schema.org/"
                xmlns:locn="http://www.w3.org/ns/locn#"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
                xmlns:mdcat="https://data.vlaanderen.be/ns/metadata-dcat#"
                xmlns:gn-fn-dcat-ap="http://geonetwork-opensource.org/xsl/functions/profiles/dcat-ap"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                xmlns:uuid="java:java.util.UUID"
                extension-element-prefixes="saxon"
                version="2.0"
                exclude-result-prefixes="#all">

  <!-- Tell the XSL processor to output XML. -->
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:output name="default-serialize-mode" indent="no"
              omit-xml-declaration="yes"/>

  <!-- =================================================================   -->
  <xsl:include href="reorder-util.xsl"/>
  <xsl:include href="layout/utility-fn.xsl"/>
  <xsl:include href="layout/utility-tpl-multilingual.xsl"/>

  <xsl:variable name="serviceUrl" select="/root/env/siteURL"/>
  <xsl:variable name="env" select="/root/env"/>
  <xsl:variable name="iso2letterLanguageCode" select="lower-case(java:twoCharLangCode(/root/gui/language))"/>
  <xsl:variable name="resourcePrefix" select="$env/metadata/resourceIdentifierPrefix"/>

  <xsl:variable name="metadata"
                select="/root/rdf:RDF"/>

  <xsl:variable name="mainLanguage">
    <xsl:call-template name="get-dcat-ap-language"/>
  </xsl:variable>

  <xsl:variable name="locales">
    <xsl:call-template name="get-dcat-ap-other-languages"/>
  </xsl:variable>

  <xsl:variable name="isMultilingual"
                select="count($locales/*) > 1"/>

  <xsl:variable name="isLanguageSet"
                select="count($locales/*) >= 1"/>

  <xsl:variable name="editorConfig"
                select="document('layout/config-editor.xml')"/>

  <xsl:variable name="resourceType">
    <xsl:choose>
      <xsl:when test="/root/rdf:RDF/dcat:Catalog/dcat:dataset/dcat:Dataset">
        <xsl:value-of select="'datasets'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'services'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="profile">
    <xsl:variable name="std" select="string(/root/rdf:RDF/dcat:Catalog/dcat:record/dcat:CatalogRecord/dct:conformsTo/dct:Standard/@rdf:about)"/>
    <xsl:choose>
      <xsl:when test="starts-with($std, 'https://data.vlaanderen.be/doc/applicatieprofiel/metadata-dcat')">
        <xsl:value-of select="'metadata-dcat'"/>
      </xsl:when>
      <xsl:when test="starts-with($std, 'https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL')">
        <xsl:value-of select="'DCAT-AP-VL'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="uuidRegex" select="'([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}){1}'"/>
  <xsl:variable name="record" select="/root/rdf:RDF/dcat:Catalog/dcat:record/dcat:CatalogRecord"/>
  <xsl:variable name="resource" select="/root/rdf:RDF/dcat:Catalog/dcat:dataset/dcat:Dataset|
                                        /root/rdf:RDF/dcat:Catalog/dcat:service/dcat:DataService"/>

  <xsl:variable name="recordUUID" select="/root/env/uuid"/>
  <xsl:variable name="recordAbout" select="concat(/root/env/nodeURL, 'api/records/', $recordUUID)"/>

  <xsl:variable name="resourceUUID">
    <xsl:choose>
      <xsl:when test="count($resource/dct:identifier[matches(., concat('^', $uuidRegex, '$'))]) > 0">
        <xsl:value-of select="$resource/dct:identifier[matches(., concat('^', $uuidRegex, '$'))][1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="uuid:toString(uuid:randomUUID())"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="resourceAbout" select="concat(/root/env/nodeURL, 'resources/', $resourceType, '/', $resourceUUID)"/>

  <!-- Multilingual support -->
  <xsl:variable name="nonMultilingualElements"
                select="$editorConfig/editor/multilingualFields/exclude/name"/>


  <!-- Ignore element not in main language (they are handled in dcat2-translations-builder. -->
  <xsl:template match="*[
                          count(*) = 0
                          and not(name() = $nonMultilingualElements)
                          and $isLanguageSet
                          and @xml:lang != $mainLanguage]"
                        priority="100">
  </xsl:template>

  <!-- Expand element which may not contain xml:lang attribute
  eg. when clicking + -->
  <xsl:template match="*[
                          count(*) = 0
                          and not(name() = $nonMultilingualElements)
                          and $isLanguageSet
                         and (not(@xml:lang) or not(string(@xml:lang)))]"
                        priority="105">
    <xsl:variable name="name"
                  select="name()"/>
    <xsl:variable name="value"
                  select="."/>
    <xsl:for-each select="$locales/lang/@code">
      <xsl:element name="{$name}">
        <xsl:attribute name="xml:lang"
                       select="current()"/>
        <xsl:value-of select="if (current() = $mainLanguage)
                              then $value else ''"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*[
                          count(*) = 0
                          and not(name() = $nonMultilingualElements)
                          and $isLanguageSet
                         and @xml:lang = $mainLanguage]"
                priority="100">
    <!-- Then we copy translations of following siblings
    or create empty elements. -->
    <xsl:variable name="name"
                  select="name(.)"/>
    <xsl:variable name="excluded"
                  select="gn-fn-dcat-ap:isNotMultilingualField(., $editorConfig)"/>
    <xsl:variable name="isMultilingualElement"
                  select="$isMultilingual and $excluded = false()"/>

    <xsl:choose>
      <xsl:when test="$isMultilingualElement">
        <xsl:call-template name="rdf-translations-builder"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Copy existing translation
  and add empty elements for other languages -->
  <xsl:template name="rdf-translations-builder">
    <xsl:variable name="name"
                  select="name(.)"/>
    <xsl:variable name="value"
                  select="text()"/>

    <xsl:variable name="followingSiblings"
                  select="following-sibling::*[name() = $name]"/>

    <!-- Select element with same name and different xml:lang attribute
    until the next one with the main language. -->
    <xsl:variable name="currentGroup"
                  select="$followingSiblings[
                    count($followingSiblings/*[@xml:lang = $mainLanguage]) = 0
                    or position() &lt; $followingSiblings/*[@xml:lang = $mainLanguage]/position()]"/>

    <xsl:for-each select="$locales/lang/@code">
      <xsl:element name="{$name}">
        <xsl:attribute name="xml:lang"
                       select="current()"/>
        <xsl:value-of select="if (current() = $mainLanguage)
                              then $value else $currentGroup[@xml:lang = current()]"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>



  <xsl:template match="/root">
    <xsl:variable name="updated">
      <xsl:apply-templates select="//rdf:RDF"/>
    </xsl:variable>
    <xsl:call-template name="dcat-reorder-elements">
      <xsl:with-param name="rdfRoot" select="$updated"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@*|*[name(.)!= 'root']">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="rdf:RDF" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:call-template name="add-namespaces"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dcat:Catalog" priority="10">
    <dcat:Catalog>
      <xsl:attribute name="rdf:about">
        <xsl:value-of select="concat($resourcePrefix, '/catalogs/', $env/system/site/siteId)"/>
      </xsl:attribute>
      <dct:title xml:lang="{$mainLanguage}">
        <xsl:value-of select="concat('Open Data Catalogus van ', $env/system/site/organization)"/>
      </dct:title>
      <dct:description xml:lang="{$mainLanguage}">
        <xsl:value-of select="concat('Deze catalogus bevat datasets ontsloten door ', $env/system/site/organization)"/>
      </dct:description>
      <dct:identifier>
        <xsl:value-of select="$env/system/site/siteId"/>
      </dct:identifier>
      <dct:publisher>
        <!-- Organization in charge of the catalogue defined in the administration > system configuration -->
        <foaf:Agent rdf:about="{$resourcePrefix}/organizations/{encode-for-uri($env/system/site/organization)}">
          <foaf:name xml:lang="{$mainLanguage}">
            <xsl:value-of select="$env/system/site/organization"/>
          </foaf:name>
          <dct:type>
            <skos:Concept rdf:about="http://purl.org/adms/publishertype/LocalAuthority">
              <xsl:for-each select="$locales/lang/@code">
                <skos:prefLabel xml:lang="{.}">Lokaal bestuur</skos:prefLabel>
              </xsl:for-each>
              <skos:inScheme rdf:resource="http://purl.org/adms/publishertype/1.0"/>
            </skos:Concept>
          </dct:type>
        </foaf:Agent>
      </dct:publisher>
      <foaf:homepage>
        <foaf:Document>
          <xsl:if test="normalize-space($serviceUrl) != ''">
            <xsl:attribute name="rdf:about" select="$serviceUrl"/>
          </xsl:if>
          <foaf:name xml:lang="{$mainLanguage}"><xsl:value-of select="$env/system/site/name"/></foaf:name>
        </foaf:Document>
      </foaf:homepage>
      <dct:license>
        <dct:LicenseDocument rdf:about="https://data.vlaanderen.be/id/licentie/creative-commons-zero-verklaring/v1.0">
          <dct:type>
            <skos:Concept rdf:about="http://purl.org/adms/licencetype/PublicDomain">
              <xsl:for-each select="$locales/lang/@code">
                <skos:prefLabel xml:lang="{.}">Werk in het publiek domein</skos:prefLabel>
              </xsl:for-each>
              <skos:inScheme rdf:resource="http://purl.org/adms/licencetype/1.0"/>
            </skos:Concept>
          </dct:type>
          <dct:title xml:lang="{$mainLanguage}">Creative Commons Zero verklaring</dct:title>
          <dct:description xml:lang="{$mainLanguage}">De instantie doet afstand van haar intellectuele eigendomsrechten voor zover dit wettelijk mogelijk is. Hierdoor kan de gebruiker de data hergebruiken voor eender welk doel, zonder een verplichting op naamsvermelding. Deze is de welbekende CC0 licentie.</dct:description>
          <dct:identifier>https://data.vlaanderen.be/id/licentie/creative-commons-zero-verklaring/v1.0</dct:identifier>
        </dct:LicenseDocument>
      </dct:license>
      <dct:language>
        <skos:Concept rdf:about="http://publications.europa.eu/resource/authority/language/NLD">
          <rdf:type rdf:resource="http://purl.org/dc/terms/LinguisticSystem"/>
          <xsl:for-each select="$locales/lang/@code">
            <skos:prefLabel xml:lang="{.}">Nederlands</skos:prefLabel>
          </xsl:for-each>
          <skos:inScheme rdf:resource="http://publications.europa.eu/resource/authority/language"/>
        </skos:Concept>
      </dct:language>
      <dct:issued>
        <xsl:value-of select="'2019-09-01'"/>
      </dct:issued>
      <dct:modified>
        <xsl:value-of select="'2019-09-01'"/>
      </dct:modified>
      <xsl:for-each select="/root/gui/thesaurus/thesauri/thesaurus">
        <dcat:themeTaxonomy>
          <skos:ConceptScheme rdf:about="{$resourcePrefix}/registries/vocabularies/{key}">
            <dct:title xml:lang="{$iso2letterLanguageCode}">
              <xsl:value-of select="title"/>
            </dct:title>
            <foaf:isPrimaryTopicOf><xsl:value-of select="$serviceUrl"/>thesaurus.download?ref=<xsl:value-of
              select="key"/>
            </foaf:isPrimaryTopicOf>
          </skos:ConceptScheme>
        </dcat:themeTaxonomy>
      </xsl:for-each>
      <dcat:contactPoint>
        <vcard:Organization>
          <vcard:organization-name>
            <xsl:value-of select="$env/system/site/organization"/>
          </vcard:organization-name>
          <xsl:if test="normalize-space($env/system/site/organizationMail) != ''">
            <vcard:hasEmail rdf:resource="mailto:{normalize-space($env/system/site/organizationMail)}" />
          </xsl:if>
          <xsl:if test="normalize-space($env/system/site/organizationUrl) != ''">
            <vcard:hasURL rdf:resource="{normalize-space($env/system/site/organizationUrl)}" />
          </xsl:if>
        </vcard:Organization>
      </dcat:contactPoint>
      <xsl:choose>
        <xsl:when test="dcat:record/dcat:CatalogRecord">
          <xsl:apply-templates select="dcat:record"/>
        </xsl:when>
        <xsl:otherwise>
          <dcat:record>
            <dcat:CatalogRecord>
              <xsl:call-template name="handle-record-id"/>
              <dct:modified>
                <xsl:value-of select="format-dateTime(/root/env/changeDate, '[Y0001]-[M01]-[D01]')"/>
              </dct:modified>
            </dcat:CatalogRecord>
          </dcat:record>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="dcat:dataset|dcat:service"/>
    </dcat:Catalog>
  </xsl:template>

  <xsl:template match="dcat:CatalogRecord" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:call-template name="handle-record-id"/>

      <xsl:choose>
        <xsl:when test="/root/env/changeDate">
          <dct:modified>
            <xsl:value-of select="format-dateTime(/root/env/changeDate,'[Y0001]-[M01]-[D01]')"/>
          </dct:modified>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="dct:modified"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="dct:conformsTo"/>
      <xsl:apply-templates select="adms:status"/>
      <xsl:apply-templates select="dct:issued"/>
      <xsl:apply-templates select="dct:title"/>
      <xsl:apply-templates select="dct:description"/>
      <xsl:apply-templates select="dct:language"/>
      <xsl:apply-templates select="dct:source"/>
      <xsl:apply-templates select="adms:identifier"/>
      <xsl:apply-templates select="dct:rights"/>
    </xsl:copy>
  </xsl:template>

  <!-- Ensure Dataset element ordering -->
  <xsl:template match="dcat:Dataset" priority="10">
    <dcat:Dataset>
      <xsl:call-template name="handle-resource-id"/>
      <xsl:apply-templates select="dct:title"/>
      <xsl:apply-templates select="dct:description"/>
      <xsl:apply-templates select="dcat:contactPoint"/>
      <xsl:apply-templates select="dct:created"/>
      <xsl:apply-templates select="dct:issued"/>
      <xsl:apply-templates select="dct:modified"/>
      <xsl:apply-templates select="dct:publisher"/>
      <xsl:apply-templates select="dct:rightsHolder"/>
      <xsl:apply-templates select="dcat:keyword"/>
      <xsl:apply-templates select="mdcat:MAGDA-categorie"/>
      <xsl:call-template name="apply-statuut"/>
      <xsl:apply-templates select="dcat:theme"/>
      <xsl:apply-templates select="dct:accessRights"/>
      <xsl:apply-templates select="dct:conformsTo"/>
      <xsl:apply-templates select="foaf:page"/>
      <xsl:apply-templates select="dct:accrualPeriodicity"/>
      <xsl:apply-templates select="dct:hasVersion"/>
      <xsl:apply-templates select="dct:isVersionOf"/>
      <xsl:apply-templates select="dcat:landingPage"/>
      <xsl:apply-templates select="dct:language"/>
      <xsl:apply-templates select="adms:identifier"/>
      <xsl:apply-templates select="dct:provenance"/>
      <xsl:apply-templates select="dct:relation"/>
      <xsl:apply-templates select="dct:source"/>
      <xsl:apply-templates select="dct:spatial"/>
      <xsl:apply-templates select="dct:temporal"/>
      <xsl:apply-templates select="dct:type"/>
      <xsl:apply-templates select="owl:versionInfo"/>
      <xsl:apply-templates select="adms:versionNotes"/>
      <xsl:apply-templates select="dcat:extension"/>
      <xsl:apply-templates select="dcat:distribution"/>
      <xsl:apply-templates select="adms:sample"/>
      <xsl:apply-templates select="dcat:qualifiedRelation"/>
      <xsl:apply-templates select="dct:creator"/>
      <xsl:apply-templates select="dct:isReferencedBy"/>
      <xsl:apply-templates select="dct:rights"/>
    </dcat:Dataset>
  </xsl:template>

  <!-- Ensure DataService element ordering -->
  <xsl:template match="dcat:DataService" priority="10">
    <dcat:DataService>
      <xsl:call-template name="handle-resource-id"/>
      <xsl:apply-templates select="dct:title"/>
      <xsl:apply-templates select="dct:description"/>
      <xsl:apply-templates select="dct:publisher"/>
      <xsl:apply-templates select="dct:rightsHolder"/>
      <xsl:apply-templates select="dcat:endpointURL"/>
      <xsl:apply-templates select="dcat:endpointDescription"/>
      <xsl:apply-templates select="dcat:servesDataset"/>
      <xsl:apply-templates select="dcat:landingPage"/>
      <xsl:apply-templates select="dcat:contactPoint"/>
      <xsl:apply-templates select="dcat:keyword"/>
      <xsl:apply-templates select="dct:language"/>
      <xsl:apply-templates select="adms:identifier"/>
      <xsl:apply-templates select="owl:versionInfo"/>
      <xsl:apply-templates select="mdcat:landingspaginaVoorAuthenticatie"/>
      <xsl:apply-templates select="mdcat:landingspaginaVoorStatusinformatie"/>
      <xsl:apply-templates select="mdcat:landingspaginaVoorGebruiksinformatie"/>
      <xsl:apply-templates select="mdcat:levensfase"/>
      <xsl:apply-templates select="mdcat:ontwikkelingstoestand"/>
      <xsl:apply-templates select="dcat:qualifiedRelation"/>
      <xsl:apply-templates select="mdcat:MAGDA-categorie"/>
      <xsl:call-template name="apply-statuut"/>
      <xsl:apply-templates select="dcat:theme"/>
      <xsl:apply-templates select="dct:accessRights"/>
      <xsl:apply-templates select="dct:conformsTo"/>
      <xsl:apply-templates select="dct:creator"/>
      <xsl:apply-templates select="dct:isReferencedBy"/>
      <xsl:apply-templates select="dct:license"/>
      <xsl:apply-templates select="dct:created"/>
      <xsl:apply-templates select="dct:issued"/>
      <xsl:apply-templates select="dct:modified"/>
      <xsl:apply-templates select="dct:relation"/>
      <xsl:apply-templates select="dct:rights"/>
      <xsl:apply-templates select="dct:type"/>
    </dcat:DataService>
  </xsl:template>

  <!-- Ensure Distribution element ordering -->
  <xsl:template match="dcat:Distribution[name(..)='dcat:distribution']" priority="10">
    <dcat:Distribution>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="count(dct:identifier[normalize-space() != '']) = 0 or normalize-space(@rdf:about) = ''">
        <xsl:variable name="distroUUID" select="uuid:toString(uuid:randomUUID())"/>
        <xsl:if test="normalize-space(@rdf:about) = ''">
          <xsl:attribute name="rdf:about" select="concat(/root/env/nodeURL, 'resources/distributions/', $distroUUID)"/>
        </xsl:if>
        <xsl:if test="count(dct:identifier[normalize-space() != '']) = 0">
          <dct:identifier>
            <xsl:value-of select="$distroUUID"/>
          </dct:identifier>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="dct:identifier"/>
      <xsl:apply-templates select="dct:title"/>
      <xsl:apply-templates select="dct:description"/>
      <xsl:apply-templates select="dcat:accessURL"/>
      <xsl:apply-templates select="dcat:downloadURL"/>
      <xsl:apply-templates select="dct:issued"/>
      <xsl:apply-templates select="dct:modified"/>
      <xsl:apply-templates select="dct:format"/>
      <xsl:apply-templates select="dcat:mediaType"/>
      <xsl:apply-templates select="dct:language"/>
      <xsl:apply-templates select="dct:license"/>
      <xsl:apply-templates select="dct:rights"/>
      <xsl:apply-templates select="dcat:byteSize"/>
      <xsl:apply-templates select="spdx:checksum"/>
      <xsl:apply-templates select="foaf:page"/>
      <xsl:apply-templates select="dct:conformsTo"/>
      <xsl:apply-templates select="adms:status"/>
      <xsl:apply-templates select="dcat:accessService"/>
      <xsl:apply-templates select="dcat:compressFormat"/>
      <xsl:apply-templates select="dcat:packageFormat"/>
      <xsl:apply-templates select="dcat:spatialResolutionInMeters"/>
      <xsl:apply-templates select="dcat:temporalResolution"/>
      <xsl:apply-templates select="adms:identifier"/>
    </dcat:Distribution>
  </xsl:template>

  <!-- Remove empty concepts -->
  <xsl:template match="foaf:Agent/dct:type|mdcat:MAGDA-categorie|mdcat:statuut|dcat:theme|dct:accrualPeriodicity|
                       dct:language|dcat:Dataset/dct:type|dcat:DataService/dct:type|dct:format|dcat:mediaType|adms:status|
                       dct:LicenseDocument/dct:type|dct:accessRights|mdcat:levensfase|mdcat:ontwikkelingstoestand|
                       dcat:compressFormat|dcat:packageFormat" priority="10">
    <xsl:choose>
      <xsl:when test="count(skos:Concept) = 1">
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="skos:Concept"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates select="*"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Rename dct:subject -->
  <xsl:template match="dct:subject" priority="10">
    <xsl:if test="count(skos:Concept) = 1">
      <mdcat:statuut>
        <xsl:apply-templates select="skos:Concept"/>
      </mdcat:statuut>
    </xsl:if>
  </xsl:template>

  <!-- Fill concepts with resourceType -->
  <xsl:template match="skos:Concept" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="rdfType" select="gn-fn-dcat-ap:getRdfTypeByElementName(name(..), name(../..))"/>
      <xsl:if test="normalize-space($rdfType) != ''">
        <rdf:type rdf:resource="{$rdfType}"/>
      </xsl:if>
      <xsl:apply-templates select="*[not(name() = 'rdf:type')]"/>
    </xsl:copy>
  </xsl:template>

  <!-- Fix value for attribute -->
  <xsl:template match="rdf:Statement/rdf:object" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[name() != 'rdf:datatype']"/>
      <xsl:attribute name="rdf:datatype">xs:dateTime</xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <!-- Fix value for attribute -->
  <xsl:template match="dct:created|dct:issued|dct:modified|schema:startDate|schema:endDate" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[name() != 'rdf:datatype']"/>
      <xsl:attribute name="rdf:datatype">
        <xsl:if test="not(contains(lower-case(.),'t'))">http://www.w3.org/2001/XMLSchema#date</xsl:if>
        <xsl:if test="contains(lower-case(.),'t')">http://www.w3.org/2001/XMLSchema#dateTime</xsl:if>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <!-- Normalize bbox -->
  <xsl:template match="dct:Location" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <xsl:variable name="coverage">
        <xsl:choose>
          <xsl:when test="count(locn:geometry[ends-with(@rdf:datatype, '#wktLiteral')])>0">
            <xsl:value-of select="locn:geometry[ends-with(@rdf:datatype, '#wktLiteral')][1]"/>
          </xsl:when>
          <xsl:when test="count(locn:geometry[ends-with(@rdf:datatype, '#gmlLiteral')])>0">
            <xsl:value-of select="locn:geometry[ends-with(@rdf:datatype, '#gmlLiteral')][1]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="locn:geometry[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="n" select="substring-after($coverage, 'North ')"/>
      <xsl:if test="string-length($n)=0">
        <xsl:copy-of select="node()"/>
      </xsl:if>
      <xsl:if test="string-length($n)>0">
        <xsl:variable name="north" select="substring-before($n, ',')"/>
        <xsl:variable name="s" select="substring-after($coverage, 'South ')"/>
        <xsl:variable name="south" select="substring-before($s, ',')"/>
        <xsl:variable name="e" select="substring-after($coverage, 'East ')"/>
        <xsl:variable name="east" select="substring-before($e, ',')"/>
        <xsl:variable name="w" select="substring-after($coverage, 'West ')"/>
        <xsl:variable name="west" select="if (contains($w, '. ')) then substring-before($w, '. ') else $w"/>
        <xsl:variable name="isValid" select="number($west) and number($east) and number($south) and number($north)"/>
        <xsl:if test="$isValid">
          <xsl:variable name="wktLiteral" select="concat('POLYGON ((',$west,' ',$south,',',$west,' ',$north,',',$east,' ',$north,',', $east,' ', $south,',', $west,' ',$south,'))')"/>
          <xsl:variable name="gmlLiteral" select="concat('&lt;gml:Polygon&gt;&lt;gml:exterior&gt;&lt;gml:LinearRing&gt;&lt;gml:posList&gt;',$south,' ',$west,' ',$north,' ', $west, ' ', $north, ' ', $east, ' ', $south, ' ', $east,' ', $south, ' ', $west, '&lt;/gml:posList&gt;&lt;/gml:LinearRing&gt;&lt;/gml:exterior&gt;&lt;/gml:Polygon&gt;')"/>
          <xsl:element name="locn:geometry">
            <xsl:attribute name="rdf:datatype">http://www.opengis.net/ont/geosparql#wktLiteral</xsl:attribute>
            <xsl:value-of select="$wktLiteral"/>
          </xsl:element>
          <xsl:element name="locn:geometry">
            <xsl:attribute name="rdf:datatype">http://www.opengis.net/ont/geosparql#gmlLiteral</xsl:attribute>
            <xsl:value-of select="$gmlLiteral"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="not($isValid)">
          <xsl:element name="locn:geometry">
            <xsl:attribute name="rdf:datatype">http://www.opengis.net/ont/geosparql#wktLiteral</xsl:attribute>
          </xsl:element>
          <xsl:element name="locn:geometry">
            <xsl:attribute name="rdf:datatype">http://www.opengis.net/ont/geosparql#gmlLiteral</xsl:attribute>
          </xsl:element>
        </xsl:if>
        <xsl:apply-templates select="node()[name(.) != 'locn:geometry']"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- Remove all empty rdf:about to avoid invalid RDF syntax -->
  <xsl:template match="@rdf:about[normalize-space() = '']|@rdf:datatype[normalize-space() = '']"
                priority="10"/>

  <!-- Fix value for attribute -->
  <xsl:template match="spdx:checksumValue" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*[name() != 'rdf:datatype']"/>
      <xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#hexBinary</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <!-- Fix value for attribute -->
  <xsl:template match="spdx:algorithm" priority="10">
    <spdx:algorithm rdf:resource="http://spdx.org/rdf/terms#checksumAlgorithm_sha1"/>
  </xsl:template>

  <!-- Add "mailto:" prefix on mail adresses -->
  <xsl:template match="vcard:hasEmail[not(starts-with(@rdf:resource, 'mailto:')) and normalize-space(@rdf:resource) != '']" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="rdf:resource" select="concat('mailto:', @rdf:resource)"/>
    </xsl:copy>
  </xsl:template>

  <!-- Automatically set license identifier based on license URL -->
  <xsl:template match="dct:LicenseDocument" priority="10">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|*[name() != 'dct:identifier']"/>
      <xsl:element name="dct:identifier">
        <xsl:value-of select="@rdf:about"/>
      </xsl:element>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="dcat:CatalogRecord/dct:conformsTo/dct:Standard" priority="10">
    <xsl:choose>
      <xsl:when test="@rdf:about = (
        'https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL',
        'https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/',
        'https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/erkendestandaard/2019-10-03'
      )">
        <dct:Standard rdf:about="https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/erkendestandaard/2019-10-03">
          <dct:identifier>https://data.vlaanderen.be/doc/applicatieprofiel/DCAT-AP-VL/erkendestandaard/2019-10-03</dct:identifier>
          <dct:title>Dcat-ap-vl</dct:title>
          <dct:description xml:lang="{$mainLanguage}">Dit applicatieprofiel beschrijft Open Data Catalogi in Vlaanderen. DCAT-AP Vlaanderen (DCAT-AP VL) is een verdere specialisatie van DCAT-AP. De applicatie waarop dit profiel betrekking heeft is een Open Data Portaal in Vlaanderen. Open Data portalen zijn catalogussen van Open Data datasets. Ze hebben als belangrijkste doelstelling het vindbaar maken van data en hierdoor het hergebruik ervan te stimuleren. Open Data portalen vervullen een centrale rol in de overheidsopdracht om de toegankelijkheid tot overheidsinformatie te realiseren. Met dit applicatieprofiel bevorderen we de uniformiteit van de beschikbare informatie over datasets. Tevens vereenvoudigen we het aggregatie proces van meerdere Open Data Catalogi. Dit document bevat de verplichte elementen en bijkomende elementen waarover DCAT-AP Vlaanderen een uitspraak doet. Aanbevolen en optionele informatie waarvoor geen bijkomende afspraken in de context van DCAT-AP Vlaanderen zijn, zijn niet opgenomen in dit document. Hiervoor verwijzen we naar de DCAT-AP specificatie zelf.</dct:description>
          <owl:versionInfo>2.0</owl:versionInfo>
        </dct:Standard>
      </xsl:when>
      <xsl:when test="@rdf:about = (
        'https://data.vlaanderen.be/doc/applicatieprofiel/metadata-dcat',
        'https://data.vlaanderen.be/doc/applicatieprofiel/metadata-dcat/',
        'https://data.vlaanderen.be/doc/applicatieprofiel/metadata-dcat/erkendestandaard/2021-04-22'
      )">
        <dct:Standard rdf:about="https://data.vlaanderen.be/doc/applicatieprofiel/metadata-dcat/erkendestandaard/2021-04-22">
          <dct:identifier>https://data.vlaanderen.be/doc/applicatieprofiel/metadata-dcat/erkendestandaard/2021-04-22</dct:identifier>
          <dct:title>Metadata-dcat</dct:title>
          <dct:description xml:lang="{$mainLanguage}">Het applicatieprofiel “metadata dcat”. Dit is een applicatieprofiel gebaseerd op DCAT en richt zich op het verzamelen van informatie over generieke datasets, distributies en services die door een overheid beschikbaar gesteld worden. De datasets en services omvatten zowel publiek toegankelijke als afgeschermde data en diensten (ontwikkeld in en voor eender welk technisch perspectief). Het samenbrengen van al deze informatie in een catalogus laat toe om de vindbaarheid van deze datasets en services te verhogen. Dit applicatieprofiel is het generieke basisprofiel. Afgeleide profielen kunnen zeker aangemaakt worden voor specifieke domeinen of communities. Bijvoorbeeld is DCAT-AP-VL zo’n afgeleid applicatieprofiel, specifiek voor het Open data domein en bijhorende community.</dct:description>
          <owl:versionInfo>2.0</owl:versionInfo>
        </dct:Standard>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*"/>
          <xsl:if test="not(dct:identifier)">
            <dct:identifier>
              <xsl:value-of select="@rdf:about"/>
            </dct:identifier>
          </xsl:if>
          <xsl:apply-templates select="node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="dct:Standard[not(dct:identifier)]" priority="9">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*"/>
      <dct:identifier>
        <xsl:value-of select="@rdf:about"/>
      </dct:identifier>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="dcat:CatalogRecord/dct:conformsTo/dct:Standard/dct:title" priority="10">
    <dct:title>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="concat(upper-case(substring(., 1, 1)), lower-case(substring(., 2)))"/>
    </dct:title>
  </xsl:template>

  <!-- =================================================================  -->

  <xsl:template name="handle-record-id">
    <xsl:apply-templates select="@*[name() != 'rdf:about']"/>
    <xsl:attribute name="rdf:about" select="$recordAbout"/>
    <xsl:element name="dct:identifier">
      <xsl:value-of select="$recordUUID"/>
    </xsl:element>
    <xsl:element name="foaf:primaryTopic">
      <xsl:attribute name="rdf:resource" select="$resourceAbout"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="handle-resource-id">
    <xsl:apply-templates select="@*[name() != 'rdf:about']"/>
    <xsl:attribute name="rdf:about" select="$resourceAbout"/>
    <xsl:element name="dct:identifier">
      <xsl:value-of select="$resourceUUID"/>
    </xsl:element>
    <xsl:apply-templates select="dct:identifier[string() != $resourceUUID]"/>
  </xsl:template>

  <xsl:template name="apply-statuut">
    <xsl:choose>
      <xsl:when test="$profile != 'DCAT-AP-VL'">
        <xsl:apply-templates select="mdcat:statuut|dct:subject"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="name() = 'dcat:Dataset'">
            <mdcat:statuut>
              <skos:Concept rdf:about="https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden/VLOPENDATA">
                <xsl:for-each select="$locales/lang/@code">
                  <skos:prefLabel xml:lang="{.}">Vlaamse Open data</skos:prefLabel>
                </xsl:for-each>
                <skos:inScheme rdf:resource="https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden"/>
              </skos:Concept>
            </mdcat:statuut>
          </xsl:when>
          <xsl:otherwise>
            <mdcat:statuut>
              <skos:Concept rdf:about="https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden/VLOPENDATASERVICE">
                <xsl:for-each select="$locales/lang/@code">
                  <skos:prefLabel xml:lang="{.}">Vlaamse Open data Service</skos:prefLabel>
                </xsl:for-each>
                <skos:inScheme rdf:resource="https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden"/>
              </skos:Concept>
            </mdcat:statuut>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*[name() = ('mdcat:statuut', 'dct:subject') and not(skos:Concept/@rdf:about = (
          'https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden/VLOPENDATA',
          'https://metadata.vlaanderen.be/id/GDI-Vlaanderen-Trefwoorden/VLOPENDATASERVICE'
        ))]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="add-namespaces">
    <xsl:namespace name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
    <xsl:namespace name="skos" select="'http://www.w3.org/2004/02/skos/core#'"/>
    <xsl:namespace name="spdx" select="'http://spdx.org/rdf/terms#'"/>
    <xsl:namespace name="owl" select="'http://www.w3.org/2002/07/owl#'"/>
    <xsl:namespace name="adms" select="'http://www.w3.org/ns/adms#'"/>
    <xsl:namespace name="locn" select="'http://www.w3.org/ns/locn#'"/>
    <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
    <xsl:namespace name="foaf" select="'http://xmlns.com/foaf/0.1/'"/>
    <xsl:namespace name="dct" select="'http://purl.org/dc/terms/'"/>
    <xsl:namespace name="vcard" select="'http://www.w3.org/2006/vcard/ns#'"/>
    <xsl:namespace name="dcat" select="'http://www.w3.org/ns/dcat#'"/>
    <xsl:namespace name="schema" select="'http://schema.org/'"/>
    <xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'"/>
    <xsl:namespace name="mdcat" select="'https://data.vlaanderen.be/ns/metadata-dcat#'"/>
  </xsl:template>
</xsl:stylesheet>
