<?php
$get_country_name = "";
  if(isset($_GET["country_name"]) && !empty($_GET["country_name"])){
    $get_country_name = ucwords(str_replace("-", " ", htmlspecialchars($_GET["country_name"])));
  }

  $srcxml = new DOMDocument();
  $srcxml->load("countries.xml");
  $srcxsl = new DOMDocument();
  $srcxsl->load('show_element.xsl');

  $xslt= new XSLTProcessor();

  $xslt->setParameter('','country_name', $get_country_name);
  $xslt->importStyleSheet($srcxsl);
  $result = $xslt->transformToXML($srcxml);

  // $srcxml->getElementsByTagName("country");


  echo $result;
 ?>
