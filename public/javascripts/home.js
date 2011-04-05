$(document).ready(function(){
  $(".sector").hover(
    function(){
      var sector_name = this.id;
      $("#current_state img").attr('src','/images/static_charts/nl_2010_mix_' + sector_name + '.png');
      $(this).addClass('active');
    },
    function(){
      $("#current_state img").attr('src','/images/static_charts/nl_2010_mix_total.png');
      $(this).removeClass('active');
    }
  );
});