 (function($){
$(document).ready(function() {
  $( "#hiperbutton" ).click(function() {
$("#upphoto").finecrop({
    viewHeight: 950,
    cropWidth: 1280,
    cropHeight: 580,
    cropInput: 'inputImage',
    cropOutput: 'poi_cropimg',
    zoomValue: 50
});
});
});
 })(jQuery);