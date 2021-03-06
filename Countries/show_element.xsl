<xsl:stylesheet
  version="1.0"
  xmlns:r="my:countries"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svg="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="big-number-format" decimal-separator=',' grouping-separator='.' />
  <xsl:output method="html" />
  <xsl:variable name="width" select="50" />
  <xsl:variable name="height" select="200" />

  <xsl:template match="r:countries">
    <html>
      <head>
        <title><xsl:value-of select="$country_name" /> - Détails</title>
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" />
        <link rel="stylesheet" type="text/css" href="countries.css" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
      </head>
      <body>
        <xsl:if test="count(r:country[@name= $country_name]) >= 1" >
          <h1><xsl:value-of select="count(r:country[@name= $country_name])" /> résultat
            <xsl:if test="count(r:country[@name= $country_name]) > 1" >s</xsl:if>
            pour "<xsl:value-of select="$country_name" />"
          </h1>
        </xsl:if>
        <xsl:if test="count(r:country[@name= $country_name]) = 0" >
          <h1> Aucun résultat ne correspond à votre recherche</h1>
        </xsl:if>
        <div class="row">
          <div class="col-sm-4 col-lg-3 col-xs-4">
            <ul class="nav nav-pills nav-stacked">
              <li role="top_ten" class="">
                <a href="part_1.php">
                  Retour tout pays
                </a>
              </li>
            </ul>
          </div>
          <div class="col-sm-8 col-lg-9 col-xs-8">
            <xsl:if test="count(r:country[@name= $country_name]) >= 1" >
              <xsl:apply-templates select="r:country" mode="panel" />
            </xsl:if>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="r:country" mode="panel">
    <xsl:if test="$country_name = @name or r:city/r:name[.=$country_name]" >
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><xsl:value-of select="@name" /></h3>
        </div>
        <div class="panel-body">
          <table>
            <tr>
              <td>
                <span class="glyphicon glyphicon-user" aria-hidden="true">
                </span>
              </td>
              <td>
                <xsl:value-of select="format-number(@population, '###.###', 'big-number-format')" /> </td>
              <td> habitants </td>
            </tr>
            <tr>
              <td>
                <span class="glyphicon glyphicon-globe" aria-hidden="true">
                </span>
              </td>
              <td> <xsl:value-of select="format-number(@area, '###.###', 'big-number-format')" /></td>
              <td> km² </td>
            </tr>
          </table>
          <hr/>
          <xsl:if test="r:language">
            <h3> Langues parlées </h3>
            <svg width="1100" height="100">
              <xsl:apply-templates select="r:language" mode="rect">
                <xsl:sort select="@percentage" order="ascending" />
              </xsl:apply-templates>
              <xsl:apply-templates select="r:language" mode="text">
                <xsl:sort select="@percentage" order="ascending" />
              </xsl:apply-templates>
              <xsl:if test="sum(r:language/@percentage) &lt; 100">
                <rect x="{sum(r:language/@percentage)*10}" y="20" width="{1000 - sum(r:language/@percentage)*10}" height="40" fill="rgb({255 - (count(r:language) * 50)},0,0)" stroke="white" />
                <text x="{sum(r:language/@percentage)*10+10}" y="10" fill="black"> Autres</text>
                <text x="{sum(r:language/@percentage)*10+10}" y="45" fill="black"><xsl:value-of select="100 - sum(r:language/@percentage)" />% </text>
              </xsl:if>
            </svg>
            <hr/>
          </xsl:if>

          <xsl:if test="r:city">
            <svg width="{count(r:city) * $width + count(r:city) * 60}" height="{$height}">
              <xsl:apply-templates select="r:city" mode="graph">
                <xsl:sort select="r:population" order="descending" />
              </xsl:apply-templates>
              <line x1="0" y1="{$height div 2}" x2="{(count(r:city) * $width)*1.2}" y2="{$height div 2}" style="stroke:rgb(0,0,0);stroke-width:2" />
            </svg>
            <xsl:apply-templates select="r:city" >
              <xsl:sort select="r:name" order="ascending" />
            </xsl:apply-templates>
          </xsl:if>
        </div>
    </div>
  </xsl:if>
  </xsl:template>
  <xsl:template match="r:city">
    <div id="{generate-id()}" class="panel panel-info">
      <div class="panel-heading">
        <h3 class="panel-title"><xsl:apply-templates select="r:name"/></h3>
      </div>
      <div class="panel-body">
        <table>
          <tr>
            <td>
              <span class="glyphicon glyphicon-user" aria-hidden="true">
              </span>
            </td>
            <td>
              <xsl:apply-templates select="r:population" />
            </td>
          </tr>
        </table>
        <xsl:apply-templates select="r:city" />
      </div>
    </div>
  </xsl:template>

  <xsl:template match="r:city" mode="graph">
    <text x="{$width*1.1 * position() - ($width*1.5 div 2)}" y="{(($height div 2) - r:population * 100 div ../@population) - 10 }"><xsl:value-of select="format-number(r:population * 100 div ../@population,'0.##')" />%</text>
    <rect x="{$width*1.1 * position() - $width}" y="{($height div 2) - r:population * 100 div ../@population }" width="{$width}" height="{r:population * 100 div ../@population }px" style="fill:rgb(255,0,0);stroke-width:1;stroke:rgb(0,0,0)" />
    <text x="{($height div 2)*1.1}" y="{position() * -($width*1.1) + ($width div 2)}" transform="rotate(90)" ><xsl:value-of select="r:name" /></text>
  </xsl:template>

  <xsl:template match="r:population">
    <xsl:value-of select="format-number(text(), '###.###', 'big-number-format')" /> habitants
    ( <xsl:value-of select="format-number(text()*100 div ancestor::r:country/@population, '0.##')" />%)
  </xsl:template>

  <xsl:template match="r:language" mode="rect">
    <rect x="{sum(preceding-sibling::*//@percentage)*10}" y="20" width="{@percentage*10}" height="40" fill="rgb({255 - (count(preceding-sibling::*) * 50)},0,0)" stroke="white" />
  </xsl:template>

  <xsl:template match="r:language" mode="text">
    <xsl:if test="position() mod 2=0">
      <text x="{(sum(preceding-sibling::*//@percentage)*10 + (@percentage*10 div 2))*0.93}" y="10" fill="black"><xsl:apply-templates /></text>
    </xsl:if>
    <xsl:if test="not(position() mod 2=0)">
      <text x="{(sum(preceding-sibling::*//@percentage)*10 + (@percentage*10 div 2))*0.93}" y="80" fill="black"><xsl:apply-templates /></text>
    </xsl:if>
    <text x="{(sum(preceding-sibling::*//@percentage)*10 + (@percentage*10 div 2)) - 10}" position="absolute" y="45" fill="black"><xsl:value-of select="@percentage" />% </text>
  </xsl:template>

</xsl:stylesheet>


<!-- xslproc recette2html.xsl gateau_aux_carottes.xml > resultat.html -->
