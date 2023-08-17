// Igualar altura de contenidos en portada de master, con control de tamaño de ventana
(function() {
	if (document.querySelector(".claves-master .information-detail__body__section") && document.querySelector(".master-en-breve")) {
		changeContentHeightMasters();
		window.addEventListener("resize", changeContentHeightMasters);
	}
})();

function changeContentHeightMasters() {
	if (matchMedia('only screen and (min-width: 992px)').matches) {
		if (document.querySelector(".claves-master .information-detail__body__section").offsetHeight > document.querySelector(".master-en-breve").offsetHeight) {
			document.querySelector(".master-en-breve").style.height = document.querySelector(".claves-master .information-detail__body__section").offsetHeight + "px";
		} else {
			document.querySelector(".claves-master .information-detail__body__section").style.height = document.querySelector(".master-en-breve").offsetHeight + "px";
		}
	} else {
		if(document.querySelector(".claves-master .information-detail__body__section").style.height) {
			document.querySelector(".claves-master .information-detail__body__section").style.height = null;
		} else if(document.querySelector(".master-en-breve").style.height) {
			document.querySelector(".master-en-breve").style.height = null
		}
	}
}