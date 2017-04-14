<?php
$get_country_name = "";
  if(isset($_GET["country_name"]) && !empty($_GET["country_name"])){
    $get_country_name = ucwords(str_replace("-", " ", htmlspecialchars($_GET["country_name"])));
  }
$srcxml = new DOMDocument();
$srcxml->load("countries.xml");
$srcxsl = new DOMDocument();

$xslt= new XSLTProcessor();

if($get_country_name == ""){
  $srcxsl->load('index_country.xsl');
} else {
  $srcxsl->load('show_element.xsl');
  $xslt->setParameter('','country_name', $get_country_name);
}

$xslt->importStyleSheet($srcxsl);
$result = $xslt->transformToXML($srcxml);

echo $result;

?>
