<xsl:stylesheet
  version="1.0"
  xmlns:r="my:countries"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svg="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="big-number-format" decimal-separator=',' grouping-separator='.' />
  <xsl:output method="xml" />
  <xsl:variable name="width" select="50" />
  <xsl:variable name="height" select="200" />

  <xsl:template match="r:countries">
    <html>
      <head>
        <title>Le top 10 des pays les plus peuplés</title>
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" />
        <link rel="stylesheet" type="text/css" href="countries.css" />
      </head>
      <body>
        <h1> Le top 10 des pays les plus peuplés </h1>
        <div class="row">
          <div class="col-sm-4 col-lg-3 col-xs-4">
            <ul class="nav nav-pills nav-stacked">
              <li role="top_ten" class="">
                <a href="part_1.php">
                  Retour tout pays
                </a>
              </li>
              <xsl:for-each select="r:country">
                <xsl:sort select="@population" order="descending" data-type="number" />
                <xsl:if test="not(position() > 10)">
                  <xsl:apply-templates select="." mode="menu" />
                </xsl:if>
              </xsl:for-each>
            </ul>
          </div>
          <div class="col-sm-8 col-lg-9 col-xs-8">
            <xsl:for-each select="r:country">
              <xsl:sort select="@population" order="descending" data-type="number" />
              <xsl:if test="not(position() > 10)">
                <xsl:apply-templates select="." mode="panel" />
              </xsl:if>
            </xsl:for-each>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="r:country" mode="menu">
    <li role="presentation" class="">
      <a>
        <xsl:attribute name="href">
          #<xsl:value-of select="generate-id()"/>
        </xsl:attribute>
        <xsl:value-of select="@name" />
        </a>
      </li>
  </xsl:template>

  <xsl:template match="r:country" mode="panel">
    <div id="{generate-id()}" class="panel panel-primary">
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
        </table>
      </div>
      <div class="panel-footer">
        <a href="#">Revenir en haut !</a>
      </div>
    </div>
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
    <svg:text x="{$width*1.1 * position() - ($width*1.5 div 2)}" y="{(($height div 2) - r:population * 100 div ../@population) - 10 }"><xsl:value-of select="format-number(r:population * 100 div ../@population,'0.##')" />%</svg:text>
    <svg:rect x="{$width*1.1 * position() - $width}" y="{($height div 2) - r:population * 100 div ../@population }" width="{$width}" height="{r:population * 100 div ../@population }px" style="fill:rgb(255,0,0);stroke-width:1;stroke:rgb(0,0,0)" />
    <svg:text x="{($height div 2)*1.1}" y="{position() * -($width*1.1) + ($width div 2)}" transform="rotate(90)" ><xsl:value-of select="r:name" /></svg:text>
  </xsl:template>

  <xsl:template match="r:population">
    <xsl:value-of select="format-number(text(), '###.###', 'big-number-format')" /> habitants
    ( <xsl:value-of select="format-number(text()*100 div ancestor::r:country/@population, '0.##')" />%)
  </xsl:template>

  <xsl:template match="r:language">
    <div class="progress-bar progress-bar" role="progressbar" aria-valuenow="{@percentage}" aria-valuemin="0" aria-valuemax="100" style="width: {@percentage}%">
      <span class=""><xsl:apply-templates select="text()" /> -   <xsl:apply-templates select="@percentage" />%</span>
    </div>
  </xsl:template>

</xsl:stylesheet>


<!-- xslproc recette2html.xsl gateau_aux_carottes.xml > resultat.html -->
