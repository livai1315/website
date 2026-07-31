// menu mobile
document.querySelectorAll('.burger').forEach(function(b){
  b.addEventListener('click',function(){
    var ouvert=document.body.classList.toggle('menu-ouvert');
    b.textContent=ouvert?'✕':'☰';
    b.setAttribute('aria-expanded',ouvert);
  });
});
document.querySelectorAll('.links a').forEach(function(a){
  a.addEventListener('click',function(){
    document.body.classList.remove('menu-ouvert');
    var b=document.querySelector('.burger');
    if(b){b.textContent='☰';b.setAttribute('aria-expanded','false');}
  });
});
// header : s'efface en descendant, revient en remontant
(function(){
  var hd=document.getElementById('hd');if(!hd)return;
  var py=window.scrollY;
  addEventListener('scroll',function(){
    var y=window.scrollY;
    if(!document.body.classList.contains('menu-ouvert')){
      hd.classList.toggle('cache',y>py&&y>320);
    }
    py=y;
  },{passive:true});
})();
// fermeture au clavier
addEventListener('keydown',function(e){
  if(e.key==='Escape'&&document.body.classList.contains('menu-ouvert')){
    document.body.classList.remove('menu-ouvert');
    var b=document.querySelector('.burger');
    if(b){b.textContent='☰';b.setAttribute('aria-expanded','false');b.focus();}
  }
});
