<?xml version="1.0" encoding="utf-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">{$loc/strings/schematron.title}</sch:title>
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

  <sch:title xmlns="http://www.w3.org/2001/XMLSchema">DCAT-AP Cardinality check</sch:title>

  <sch:pattern abstract="true" id="CardinalityCheck">
    <sch:title>Cardinality of $element in $context</sch:title>
    <sch:rule context="$context">
      <sch:assert test="count($element) &gt;= $min and ('$max' = 'n' or count($element) &lt;= $max)">
        <sch:value-of select="'$context'"/>/<sch:value-of select="'$element'"/> should be of cardinality <sch:value-of select="'$min'"/>..<sch:value-of select="'$max'"/> but found <sch:value-of select="count($element)"/> nodes.</sch:assert>
      <sch:report test="count($element) &gt;= $min and ('$max' = 'n' or count($element) &lt;= $max)">
        <sch:value-of select="'$context'"/>/<sch:value-of select="'$element'"/> is of cardinality <sch:value-of select="'$min'"/>..<sch:value-of select="'$max'"/>. Found <sch:value-of select="count($element)"/> nodes.</sch:report>
    </sch:rule>
  </sch:pattern>


  <sch:pattern is-a="CardinalityCheck" id="Catalog_title">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:title"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_description">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:description"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_publisher">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:publisher"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_record">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dcat:record"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_dataset">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dcat:dataset"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_service">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dcat:service"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_issued">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:issued"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_modified">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:modified"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_homepage">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="foaf:homepage"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_license">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:license"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_creator">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:creator"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_isPartOf">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:isPartOf"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Catalog_rights">
    <sch:param name="context" value="//dcat:Catalog"/>
    <sch:param name="element" value="dct:rights"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>

  <sch:pattern is-a="CardinalityCheck" id="CatalogRecord_primaryTopic">
    <sch:param name="context" value="dcat:CatalogRecord"/>
    <sch:param name="element" value="foaf:primaryTopic"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="CatalogRecord_modified">
    <sch:param name="context" value="dcat:CatalogRecord"/>
    <sch:param name="element" value="dct:modified"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="CatalogRecord_conformsTo">
    <sch:param name="context" value="dcat:CatalogRecord"/>
    <sch:param name="element" value="dct:conformsTo"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="CatalogRecord_status">
    <sch:param name="context" value="dcat:CatalogRecord"/>
    <sch:param name="element" value="adms:status"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="CatalogRecord_issued">
    <sch:param name="context" value="dcat:CatalogRecord"/>
    <sch:param name="element" value="dct:issued"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="CatalogRecord_source">
    <sch:param name="context" value="dcat:CatalogRecord"/>
    <sch:param name="element" value="dct:source"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_title">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:title"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_description">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:description"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_publisher">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:publisher"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_accrualPeriodicity">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:accrualPeriodicity"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_accessRights">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:accessRights"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_type">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:type"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_creator">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:creator"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_issued">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:issued"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_modified">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="dct:modified"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Dataset_versionInfo">
    <sch:param name="context" value="//dcat:Dataset"/>
    <sch:param name="element" value="owl:versionInfo"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_accessURL">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dcat:accessURL"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_license">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dct:license"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_format">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dct:format"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_status">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="adms:status"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_packageFormat">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dcat:packageFormat"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_mediaType">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dcat:mediaType"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_checksum">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="spdx:checksum"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_rights">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dct:rights"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_byteSize">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dcat:byteSize"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_issued">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dct:issued"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="Distribution_modified">
    <sch:param name="context" value="dcat:Distribution"/>
    <sch:param name="element" value="dct:modified"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_endpointURL">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dcat:endpointURL"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_title">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:title"/>
    <sch:param name="min" value="1"/>
    <sch:param name="max" value="n"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_accessRights">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:accessRights"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
  <sch:pattern is-a="CardinalityCheck" id="DataService_license">
    <sch:param name="context" value="//dcat:DataService"/>
    <sch:param name="element" value="dct:license"/>
    <sch:param name="min" value="0"/>
    <sch:param name="max" value="1"/>
  </sch:pattern>
</sch:schema>
