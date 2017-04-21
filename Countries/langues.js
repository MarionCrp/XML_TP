window.onload=function()   {
  <!-- on récupère le svg des langues pour chaque pays -->
  var languages_bars = document.getElementsByClassName("language_bar");

  <!-- pour chaque pays on va modifier la position du x pour les mettre à la bonne place -->
  for(var i=0; i < languages_bars.length; i++) {
    var languages = languages_bars[i].querySelectorAll('rect.language_rect');
    var languages_title = languages_bars[i].querySelectorAll('text.title');
    var languages_percent = languages_bars[i].querySelectorAll('text.percent');

    <!--  Initialisation de la première langue -->
    <!--  WIDTH -->
    var first_width = parseInt(languages[0].getAttribute("width"));

    <!--  TITLE - X -->
    languages_title[0].setAttribute("x", (first_width) / 2);

    <!--  PERCENT - X -->
    languages_percent[0].setAttribute("x", (first_width) / 2);

    <!--  COULEUR LANGUE -->
    languages[0].setAttribute("fill", "rgb(" + 75 + ",0,0)");

    <!--  pour une meilleure visibilité on met le pourcentage en blanc si la couleur est trop foncée -->
    if(parseInt(languages[0].getAttribute("width")) >= 400){
      languages_percent[0].setAttribute("fill", "white");
    }

    <!--  pour chaque langue on leur attribut les valeurs correspondantes -->
    for(var j=0; j < languages.length; j++) {
      var current_rect = languages[j];
      var current_title = languages_title[j];
      var current_percent = languages_percent[j];

      <!-- La première langue étant initialisée, on traite les autres langues -->
      if(j > 0){
        var previous_rect = languages[j-1];
        var previous_x = parseInt(previous_rect.getAttribute("x"));
        var previous_width = parseInt(previous_rect.getAttribute("width"));

        <!-- positionnement du rectangle de la langue -->
        current_rect.setAttribute("x", previous_x + (previous_width));

        <!-- gestion des couleurs -->
        current_rect.setAttribute("fill", "rgba(153,0,0," + parseInt(current_rect.getAttribute("width")) / 250 + ")");
        if(parseInt(current_rect.getAttribute("width")) >= 350){
          current_percent.setAttribute("fill", "white");
        }

        <!-- positionnement du nom du pays et du pourcentage associé -->
        var middle_rect_x = parseInt(current_rect.getAttribute("x")) + parseInt(current_rect.getAttribute("width") / 2)
        current_title.setAttribute("x", middle_rect_x - 20);
        current_percent.setAttribute("x",  middle_rect_x - 10);
      }
    }
  }
}
