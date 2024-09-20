<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="spdx" uri="http://spdx.org/rdf/terms#"/>
  <sch:ns prefix="owl" uri="http://www.w3.org/2002/07/owl#"/>
  <sch:ns prefix="adms" uri="http://www.w3.org/ns/adms#"/>
  <sch:ns prefix="locn" uri="http://www.w3.org/ns/locn#"/>
  <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <sch:ns prefix="foaf" uri="http://xmlns.com/foaf/0.1/"/>
  <sch:ns prefix="dct" uri="http://purl.org/dc/terms/"/>
  <sch:ns prefix="vcard" uri="http://www.w3.org/2006/vcard/ns#"/>
  <sch:ns prefix="dcat" uri="http://www.w3.org/ns/dcat#"/>
  <sch:ns prefix="schema" uri="http://schema.org/"/>
  <sch:ns prefix="rdf" uri="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
  <sch:ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
  <sch:ns prefix="xml" uri="http://www.w3.org/XML/1998/namespace"/>
  <sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
  <sch:ns prefix="dc" uri="http://purl.org/dc/elements/1.1/"/>
  <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
  <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="mdcat" uri="https://data.vlaanderen.be/ns/metadata-dcat#"/>
  <sch:ns prefix="geodcat" uri="http://data.europa.eu/930/"/>
  <sch:ns prefix="generiek" uri="https://data.vlaanderen.be/ns/generiek#"/>
  <sch:ns prefix="rdfs" uri="http://www.w3.org/2000/01/rdf-schema#"/>
  <sch:ns prefix="prov" uri="http://www.w3.org/ns/prov#"/>

  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">DCAT-AP Vlaanderen Cardinality check</sch:title>

  <sch:pattern abstract="true" id="CardinalityCheck">
    <sch:title>Cardinality of $element in $context</sch:title>
    <sch:rule context="$context">
      <sch:assert test="count($element) &gt;= $min and ('$max' = 'n' or count($element) &lt;= $max)">
        <sch:value-of select="'$context'"/>/<sch:value-of select="'$element'"/> should be of cardinality <sch:value-of select="'$min'"/>..<sch:value-of select="'$max'"/> but found <sch:value-of select="count($element)"/> nodes.</sch:assert>
      <sch:report test="count($element) &gt;= $min and ('$max' = 'n' or count($element) &lt;= $max)">
        <sch:value-of select="'$context'"/>/<sch:value-of select="'$element'"/> is of cardinality <sch:value-of select="'$min'"/>..<sch:value-of select="'$max'"/>. Found <sch:value-of select="count($element)"/> nodes.</sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:pattern is-a="CardinalityCheck" id="Catalog_accessRights">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:accessRights"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_created">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:created"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_identifier">
    <sch:param name="context" value="//dcat:Distribution"/>
    <sch:param name="element" value="dct:identifier"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_accessRights">
    <sch:param name="context" value="//dcat:Distribution"/>
    <sch:param name="element" value="dct:accessRights"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_identifier">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:identifier"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_publisher">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:publisher"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_contactPoint">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dcat:contactPoint"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_versionInfo">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="owl:versionInfo"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_landingspaginaVoorAuthenticatie">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="mdcat:landingspaginaVoorAuthenticatie"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_landingspaginaVoorStatusinformatie">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="mdcat:landingspaginaVoorStatusinformatie"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_landingspaginaVoorGebruiksinformatie">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="mdcat:landingspaginaVoorGebruiksinformatie"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_levensfase">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="mdcat:levensfase"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_ontwikkelingstoestand">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="mdcat:ontwikkelingstoestand"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_creator">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:creator"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_created">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:created"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_issued">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:issued"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_modified">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:modified"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_type">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:type"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>


  <!-- Overwrite DCAT-AP generic cardinalities -->
  <sch:pattern is-a="CardinalityCheck" id="Dataset_contactPoint">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dcat:contactPoint"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_publisher">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:publisher"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_identifier">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:identifier"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_accessRights">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:accessRights"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_accessURL">
    <sch:param name="context" value="//dcat:Distribution"/>
    <sch:param name="element" value="dcat:accessURL"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_rights">
    <sch:param name="context" value="//dcat:Distribution"/>
    <sch:param name="element" value="dct:rights"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_downloadURL">
    <sch:param name="context" value="//dcat:Distribution"/>
    <sch:param name="element" value="dcat:downloadURL"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_compressFormat">
    <sch:param name="context" value="//dcat:Distribution"/>
    <sch:param name="element" value="dcat:compressFormat"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_endpointURL">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dcat:endpointURL"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_endpointDescription">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dcat:endpointDescription"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_accessRights">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:accessRights"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
</sch:schema>
