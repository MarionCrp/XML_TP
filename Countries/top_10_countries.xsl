<xsl:stylesheet
  version="1.0"
  xmlns:r="my:countries"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svg="http://www.w3.org/2000/svg">
  <xsl:decimal-format name="big-number-format" decimal-separator=',' grouping-separator='.' />
  <xsl:output method="xml" />
  <xsl:variable name="width" select="50" />
  <xsl:variable name="height" select="700" />

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
            </ul>
          </div>
          <div class="col-sm-8 col-lg-9 col-xs-8">
            <svg width="100%" height="{$height}">
              <line x1="0" y1="{$height div 2}" x2="{(10 * $width)*1.2}" y2="{$height div 2}" style="stroke:rgb(0,0,0);stroke-width:2" />
              <xsl:apply-templates selet="r:country" mode="graph">
                <xsl:sort select="@population" order="descending" data-type="number" />
              </xsl:apply-templates>
            </svg>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="r:country" mode="graph">
    <xsl:if test="not(position() > 10)">
      <rect x="{$width*1.1 * position() - $width}" y="{($height div 2) - (@population div 5000000) }" width="{$width}" height="{ @population div 5000000}" style="fill:rgb(255,0,0);stroke-width:1;stroke:rgb(0,0,0)" />
      <text x="{($height div 2)*0.1}" y="{position() * - ($width*1.1) + ($width div 2)}" transform="rotate(90)" ><xsl:value-of select="format-number(@population, '###.###', 'big-number-format')"/></text>
      <text x="{($height div 2)*1.1}" y="{position() * -($width*1.1) + ($width div 2)}" transform="rotate(90)" ><xsl:value-of select="@name" /></text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>


<!-- xslproc recette2html.xsl gateau_aux_carottes.xml > resultat.html -->
