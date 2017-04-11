<?php
$srcxml = new DOMDocument();
$srcxml->load("countries.xml");
$srcxsl = new DOMDocument();
$srcxsl->load('top_10_cities.xsl');

$xslt= new XSLTProcessor();
$xslt->importStyleSheet($srcxsl);
$result = $xslt->transformToXML($srcxml);

echo $result;

?>
