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
        <title>Les Pays</title>
        <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" />
        <link rel="stylesheet" type="text/css" href="countries.css" />
      </head>
      <body>
        <h1> Les Pays </h1>
        <div class="row">
          <div class="col-sm-4 col-lg-3 col-xs-4">
            <ul class="nav nav-pills nav-stacked">
              <xsl:apply-templates select="r:country" mode="menu" />
            </ul>
          </div>
          <div class="col-sm-8 col-lg-9 col-xs-8">
            <xsl:apply-templates select="r:country" mode="panel" />
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
          <div class="progress">
            <xsl:apply-templates select="r:language" />
            <!-- <xsl:if test="sum(r:language/@percentage) < 100"> -->
            <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="{100 - sum(r:language/@percentage)}" aria-valuemin="0" aria-valuemax="100" style="width: {100 - sum(r:language/@percentage)}%">
              <span class=""> + <xsl:value-of select="100 - sum(r:language/@percentage)" />%</span>
            </div>
            <!-- </xsl:if> -->
          </div>
          <hr/>
        </xsl:if>

        <xsl:if test="r:city">
          <svg:svg width="{count(r:city) * $width + count(r:city) * 60}" height="{$height}">
            <xsl:apply-templates select="r:city" mode="graph" />
            <svg:line x1="0" y1="{$height div 2}" x2="{(count(r:city) * $width)*1.2}" y2="{$height div 2}" style="stroke:rgb(0,0,0);stroke-width:2" />
          </svg:svg>
          <xsl:apply-templates select="r:city" >
            <xsl:sort select="r:name" order="ascending" />
          </xsl:apply-templates>
        </xsl:if>
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
    <svg:rect x="{$width*1.1 * position() - $width}" y="{($height div 2) - r:population * 100 div ../@population }" width="{$width}" height="{r:population * 100 div ../@population }px" style="fill:rgb(255,0,0);stroke-width:1;stroke:rgb(0,0,0)" />
    <svg:text x="{($height div 2)*1.1}" y="{position() * -($width*1.1) + ($width div 2)}" transform="rotate(90)" ><xsl:value-of select="r:name" /></svg:text>
    <svg:text x="{($height)*1.1}" y="{position() * -($width*1.1) + ($width div 2)}" transform="rotate(90)" ><xsl:value-of select="r:name" /></svg:text>
  </xsl:template>

  <xsl:template match="r:population">
    <xsl:value-of select="format-number(text(), '###.###', 'big-number-format')" /> habitants
    ( <xsl:value-of select="format-number(text()*100 div ancestor::r:country/@population, '#,##%')" />)
  </xsl:template>

  <xsl:template match="r:language">
    <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="{@percentage}" aria-valuemin="0" aria-valuemax="100" style="width: {@percentage}%">
      <span class=""><xsl:apply-templates select="text()" /> -   <xsl:apply-templates select="@percentage" />%</span>
    </div>
  </xsl:template>

</xsl:stylesheet>


<!-- xslproc recette2html.xsl gateau_aux_carottes.xml > resultat.html -->


<!-- <xsl:sort select="count(r:city)" order="ascending" data-type="number" -->
